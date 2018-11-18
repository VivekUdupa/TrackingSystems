clc;
close all

T = dlmread("magnets-data.txt");

actualPos = T(:,1);
actualVel = T(:,2);
sensorRead = T(:,3);


%Number of Particles
M = 10;

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

ytP = zeros(1,M);

%Resampling
Q = zeros(1,M);
T = zeros(1,M+1);

%Output
output = zeros(1,length(sensorRead));

for t = 1:length(sensorRead)
    
    for i = 1:M
            
            %State Transition
            XState(i) = XPrevState(i) + XPrevVel(i) * t;
            
            if( XPrevState(i) < -20)
                XVel(i) = 2;
            
            elseif (XPrevState(i) > 20)
                XVel(i) = -2;
            
            elseif (XPrevState(i) >= 0 && XPrevState(i) <= 20 ) 
                XVel(i) = XPrevVel(i) - abs(randn*0.0625^2);
            
            elseif (XPrevState(i) >= -20 && XPrevState(i) < 0)
                XVel(i) = XPrevVel(i) + abs(randn*0.0625^2);
            end
            
            XPrevState(i) = XState(i);
            XPrevVel(i) = XVel(i);
            
            %Update weight
            
            ytP(i) = (1 / (sqrt(2*pi) * 4))  * exp( -( XState(i) - xm1  )^2 / (2 * sigmaM^2) ) ...
                  + (1 / (sqrt(2*pi) * 4))  * exp( -( XState(i) - xm2  )^2 / (2 * sigmaM^2) ) ... 
                  + randn*0.003906^2;
            
            prob = (1 / (sqrt(2*pi) * 0.003906)) * exp ( - (ytP(i) - sensorRead(i) )^2 / (2 * (0.003906)^2 ));
            
            wtsUN(i) = wtsPrev(i) * prob;
            wtsPrev(i) = wtsUN(i);
            
    end
    
    %Normalize weights
    wtsSum = 0;
    Exp = 0;
    CV = 0;
    Index = zeros(1,M);
            
    for k = 1:M
        wtsSum = wtsSum + wtsUN(k) ;
    end
            
    for k = 1:M
        wts(k) = wtsUN(k) / wtsSum ;  
    end
            
    for k = 1:M
        %Expected Filter Output
        Exp = Exp +  wts(k) *  XState(k);
        
        %Coefficient of variation
        CV = CV + ((M * wts(k) - 1) ^ 2);
    end
    
    output(t) = Exp;
    CV = 1/M * CV;
            
    %Effective Sampling Size
    ESS = M / (1 + CV);
    
    %Resampling
        if( ESS < 0.5 * M )
                
                %Cumulative Weights Q
                Q(1) = wts(1); 
                for k = 2:M
                    Q(k) = Q(k-1) + wts(k); 
                end
                
                %Guesses
                for K = 1:M
                    T(k) = abs(rand(1));
                end
                T(k+1) = 1;
                
                %Sorting the Guesses
                T = sort(T);
                
                i = 1;
                j = 1;
                
                while( i <= M )
                
                    if( T(i) < Q(j) )
                        Index(i) = j;
                        i = i+1;
                    else
                        j = j+1;
                    end
                    
                end
                
                for i = 1:M
                    XState(i) = XState(Index(i));
                    XPrevState(i) = XState(i);
                    wts(i) = 1/M;
                    wtsPrev(i) = 1/M;
                end
                
        end
end

X = 0 : length(actualPos) - 1;
 
figure(1)
% plot(X,actualPos);
hold on
plot(X,output)
hold off
xlabel("Samples");
ylabel("Actual Position");
legend("Actual Position", "Filter Output");
% 
% figure(2)
% plot (X, sensorRead);
% xlabel("Samples");
% ylabel("Sensor Reading");
% 
% figure(3)

disp("SUCCESS!!!!!!!")