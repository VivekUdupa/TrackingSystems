clc 
clear

%Read the data set
T = dlmread("sin-data.txt");

%Actual position for reference
trueData = T(:,1);

%Sensor measurement data
mesData = T(:,2);

%Length of dataset
n = length(mesData);

%Plot the raw dataset
x = 1:n;

figure (1)
plot(x,mesData, "O")
hold on
plot(x, trueData)
hold off
xlabel("time samples");
ylabel("amplitude");
set(gca, "FontSize",26);
legend("Measurement data", "Actual position");

%Initialize variables

t = 1; %time

%Noises
mesNoise = 0.01;
dynNoise = 0.001;

% Initialize matrices 
%PArtial derivatives

Dfa = [0 0 0; 0 1 0; 0 0 0];

Dgx = [0 0 1];

Dgn = 1;

%Dynamic noise Co-variance
Q = [0 0 0; 0 dynNoise 0; 0 0 0];

%Measurement noise co-variance
R = mesNoise;

%Identity matrix (3x3)
I = eye(3) ;

%State Co-variance
S_t1_t1 = I;  

%State Matrix
X_t1_t1 = [0.001; 0.01; mesData(1,1)];

%Result array
result = zeros(1, n);

%DeltaT
delta = 0.001;

while(t <  n)
    
    %Predicting the next state
    X_t_t1 = [ (X_t1_t1(1,1) + (delta*(t-1) * X_t1_t1(2,1))) ;
                X_t1_t1(2,1);
                sin( X_t1_t1(1,1) * 0.1) ];
 
    Dfx = [1 delta*t 0; 0 1 0; 0.1*cos(0.1 * X_t_t1(1,1)) 0 0];
            
    %Predicting next state co-variance
    S_t_t1 = (Dfx * S_t1_t1 * Dfx') + (Dfa * Q * Dfa');
    
    %Measurement data
    Y_t = mesData(t);
    
    %Calculating kalman gain
    K_t = (S_t_t1 * Dgx') / ( (Dgx * S_t_t1 * Dgx') + (Dgn * R * Dgn') );
    
    %Update state
    X_t_t = X_t_t1 + (K_t * (Y_t - X_t_t1(3,1) ));
    
    %Update state co-variance
    S_t_t = (I - K_t * (Dgx)) * S_t_t1;
    
    %Update prev variables
    S_t1_t1 = S_t_t;
    X_t1_t1 = X_t_t;
    
    result(1,t) = X_t_t(3,1);
        
    %Incriment loop counter
    t = t  + 1;

end
x = 1:n;
close all

figure (2)
plot(x,mesData, "O")
hold on
plot(x, result(1,:)')
% hold on
plot(x, trueData)
hold off
xlabel("time samples");
ylabel("amplitude");
set(gca, "FontSize",26);
legend("Measurement data", "Filter Output", "True Position");





% %Ratios
% dynNoise = 0.1 mesNoise = 0.01
% dynNoise = 0.01 mesNoise = 0.001
% dynNoise = 0.001 mesNoise = 0.1