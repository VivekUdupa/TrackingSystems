
clc
clear all

%Import Data
Data = dlmread("2D-UWB-data.txt");

%Initialization
t = 1; %Time
noise_measure1 = 0.0001; %Measurement noise1
noise_measure2 = 0.001; %Measurement noise2

noise_dynamic1 = 0.0001; %Dynamic nosie1
noise_dynamic2 = 0.0001; %Dynamic nosie2

ST = [1 0 t 0 ; 0 1 0 t; 0 0 1 0; 0 0 0 1]; %State transition matrix
M = [1 0 0 0 ; 0 1 0 0]; %Observation matrix
X_tPrev = [Data(1,1) ; Data(1,2) ; 0 ; 0]; %State matrix
R = [noise_measure1 0.00001; 0.00001 noise_measure2 ]; %Co-Variance of Measurement noise
Q = [0 0 0 0; 0 0 0 0; 0 0 noise_dynamic1 0.00001; 0 0 0.00001 noise_dynamic2]; %Co-variance of Dynamic noise
k_t = zeros(4,2); %Kalman gain
I = [1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1]; %Identity matrix
S_tPrev = [1 0.1 0.1 0.1; 0.1 1 0.1 0.1; 0.1 0.1 1 0.1; 0.1 0.1 0.1 1]; %State Co-variance
predicted_Data = zeros(2, length(Data(:,1))); %Output
yt = Data'; %Observation variables

count = 0

%Kalman Filter Loop
 while(t < length(Data(:,1) ))
    
     X_tNext = ST * X_tPrev;
     
     S_tNext = (ST * S_tPrev * ST') + Q;  
    
     k_t = (S_tNext * M') / ( M * S_tNext * M' + R );
     
     X_pred = X_tNext + (k_t * (yt(:,t) - (M * X_tNext) ));
     
     S_pred = (I - (k_t * M) ) * S_tNext ; 
     
     predicted_Data(1,t) = X_pred(1,1); %Store for plotting
     predicted_Data(2,t) = X_pred(2,1); %Store for plotting

     X_tPrev = X_pred;
     S_tPrev = S_pred;
     
     t = t + 1 ;
     
 end %end of while
 
 %Plotting 
x = 1:length(Data(:,1));
 
figure(1)
plot(x,Data(:,2),"b-") ;
hold on
% plot(x,Data(:,2),"r-") ;
plot(x,predicted_Data(2,:), "r*");
hold off

