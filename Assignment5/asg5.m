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

% figure (1)
% plot(x,mesData, "O")
% hold on
% plot(x, trueData)
% hold off
% xlabel("time samples");
% ylabel("amplitude");
% set(gca, "FontSize",26);
% legend("Measurement data", "Actual position");

%Initialize variables

t = 1; %time

%Noises
mesNoise = 0.1;
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
SPrev = I;  

%State Matrix
XPrev = [0.001; 0.01; mesData(1,1)];

%Result array
Output = zeros(1, n);

%DeltaT
delta = 0.001;

while(t <  n)
    
%     Predicting the next state
    XPredict = [ (XPrev(1,1) + (delta*(t-1) * XPrev(2,1))) ;
                XPrev(2,1);
                sin( XPrev(1,1) * 0.1) ];

    Dfx = [1 delta*t 0; 0 1 0; 0.1*cos(0.1 * XPredict(1,1)) 0 0];
            
    %Predicting next state co-variance
    SPredict = (Dfx * SPrev * Dfx') + (Dfa * Q * Dfa');
    
    %Measurement data
    Y_t = mesData(t);
    
    %Calculating kalman gain
    K_t = (SPredict * Dgx') / ( (Dgx * SPredict * Dgx') + (Dgn * R * Dgn') );
    
    %Update state
    XNext = XPredict + (K_t * (Y_t - XPredict(3,1) ));
    
    %Update state co-variance
    S_t_t = (I - K_t * (Dgx)) * SPredict;
    
    %Update prev variables
    SPrev = S_t_t;
    XPrev = XNext;
    
    Output(1,t) = XNext(3,1);
        
    %Incriment loop counter
    t = t  + 1;

end
x = 1:n;
% close all

figure (2)
plot(x,mesData, "kx", "LineWidth", 2)
hold on
plot(x, Output(1,:), "K", "Linewidth",2)
% hold on
plot(x, trueData, "k-.","Linewidth",2)
hold off
xlabel("Samples");
ylabel("Amplitude");
set(gca, "FontSize",26);
legend("Measurement data", "Filter Output", "True Position");
xticks([0:130:780])
axis([0 780 -2 2]);

% %Ratios
% dynNoise = 0.001 mesNoise = 1
% dynNoise = 0.001 mesNoise = 0.1
% dynNoise = 0.001 mesNoise = 0.003