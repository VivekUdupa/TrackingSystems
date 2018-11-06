clc;
close all

T = dlmread("magnets-data.txt");

actualPos = T(:,1);
actualVel = T(:,2);
sensorRead = T(:,3);

X = 0 : length(actualPos) - 1;
 
% figure(1)
% plot(X,actualPos);
% xlabel("Samples");
% ylabel("Actual Position");
% 
% 
% figure(2)
% plot (X, sensorRead);
% xlabel("Samples");
% ylabel("Sensor Reading");

%Number of Particles
M = 500;

%Initialization

%Magnet Position
xm1 = -10;
xm2 = 10;

%S.D
sigmaM = 4;

%State Transition
XState = zeros(1,M);
XVel = zeros(1,M);

XPrevState = zeros(1,M);
XPrevVel = zeros(1,M);

%Weights
wts = ones(1,M) * 1/M;
wtsPrev = ones(1,M) * 1/M;
wtsUN = ones(1,M) * 1/M;

ytP = 0;

for t = 1:length(X)
    
    for i = 1:M
            
            %State Transition
            XState(i) = XPrevState(i) + XPrevVel(i) * t;
            
            if( XPrevState(i) < -20)
                XVel(i) = 2;
            
            elseif (XPrevState(i) > 20)
                XVel = -2;
            
            elseif (XPrevState(i) >= 0 && XPrevState(i) <= 20 ) 
                XVel = XPrevVel - abs(normrnd(0,0.0625));
            
            elseif (XPrevState(i) >= -20 && XPrevState(i) < 0)
                XVel = XPrevVel + abs(normrnd(0,0.0625));
            
            end
            
            %Update weight
            
            ytP = 1/ (sqrt(2*pi) * 4)  * exp( -( XState(i) - xm1  )^2 / 2 * sigmaM^2 ) ...
                  + 1/ (sqrt(2*pi) * 4)  * exp( -( XState(i) - xm2  )^2 / 2 * sigmaM^2 ) ... 
                  + normrnd(0,0.003906) ;
            
            prob = 1 / (sqrt(2*pi) * normrnd(0,0.003906)) * exp ( - (ytP - sensorRead(i) )^2 / 2 * normrnd(0,0.003906) );
            
            wtsUN(i) = wtsPrev(i) * prob;
            
    end
    
            %Normalize weights
            wtsSum = 0;
            
            for k = 1:M
                wtsSum = wtsSum + wtsUN(k); 
            end
            
            for k = 1:M
                wts(k) = wtsUN(k) / wtsSum ;  
            end
            
            
end

disp("SUCCESS!!!!!!!")