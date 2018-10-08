clc
clear
close all

%Read data from file
Data = dlmread("1D-data.txt");

%Initialization
t = 1; %Time
noise_measure = 0.1; %Measurement noise
noise_dynamic = 200; %Dynamic nosie

ST = [1 t ; 0 1]; %State transition matrix
M = [1 0; 0 0]; %Observation matrix
X_tPrev = [0 ; 0]; %State matrix
R = [noise_measure 0.1; 0.1 0.1 ]; %Co-Variance of Measurement noise
Q = [0 0 ; 0 noise_dynamic]; %Co-variance of Dynamic noise
k_t = [0 0; 0 0]; %Kalman gain
I = [1 0; 0 1]; %Identity matrix
S_tPrev = I; %State Co-variance
predicted_Data = zeros(1, length(Data)); %Output
yt = [Data' ; zeros(1, length(Data)) ]; %Observation variables



%Kalman Filter Loop
 while(t < length(Data) )
    
     X_tNext = ST * X_tPrev;
     
     S_tNext = (ST * S_tPrev * ST') + Q ; 
    
     k_t = (S_tNext * M') / ( M * S_tNext * M' + R ); 
     
     X_pred = X_tNext + (k_t * (yt(:,t) - (M * X_tNext) ));
     
     S_pred = (I - (k_t * M) ) * S_tNext ; 
     
     predicted_Data(t) = X_pred(1,1); %Store for plotting
     
     X_tPrev = X_pred;
     S_tPrev = S_pred;
     
     t = t + 1 ; 
     
 end %end of while
 
 %Plotting 
 
x = 0:length(Data)-1;

figure(1)
plot(x,Data,"o") ;
hold on
plot(x, predicted_Data, "+");
hold off
 
 



