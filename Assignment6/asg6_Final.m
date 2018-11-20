clc;
clear
close all

Table = dlmread("magnets-data.txt");

actualPos = Table(:,1);
actualVel = Table(:,2);
sensorRead = Table(:,3);


%Number of Particles
M = 1000;

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

%For Weights Plotting
weightsBeforeReset = zeros(1,M);
weightsReset = zeros(1,M);

%Number of resampling 
ResampleCount = 0;

%Flag to track weight plot
start = 0;

%Plots start when resampling count is:
luckyNum = 10;

%Resample when particles go below RS percentage
RS = 0.5;

%Output
output = zeros(1,length(sensorRead));

%X-axis to plot filter output
X1 = 1 : length(sensorRead);
%X-axis to plot weights
X2 = 1 : M;

for t = 1:length(sensorRead)
    
    for i = 1:M
            
            %State Transition
            XState(i) = XPrevState(i) + XPrevVel(i) ;
            
            if( XPrevState(i) < -20)
                XVel(i) = 2;
            
            elseif (XPrevState(i) > 20)
                XVel(i) = -2;
            
            elseif (XPrevState(i) >= 0 && XPrevState(i) <= 20 ) 
                XVel(i) = XPrevVel(i) - abs(randn * 0.0625);
            
            elseif (XPrevState(i) >= -20 && XPrevState(i) < 0)
                XVel(i) = XPrevVel(i) + abs(randn * 0.0625);
            end
   
            %Update weight
            
            ytP(i) = (1 / (sqrt(2*pi) * sigmaM))  * exp( -((XPrevState(i) - xm1  )^2) / (2 * (sigmaM^2) )) + (1 / (sqrt(2*pi) * sigmaM))  * exp( -((XPrevState(i) - xm2  )^2) / (2 * (sigmaM^2) ));
            
            prob = ((1 / (sqrt(2*pi) * 0.003906)) * exp ( - ((ytP(i) - sensorRead(t) )^2) / (2 * (0.003906^2) )));
            
            wtsUN(i) = wtsPrev(i) * prob;
            wtsPrev(i) = wtsUN(i);

            XPrevState(i) = XState(i);
            XPrevVel(i) = XVel(i);
            
    end
    
    %Normalize weights
    %Initialization
    wtsSum = 0;
    Exp = 0;
    CV = 0;
    Index = zeros(1,M);
    
    %Find cumulative weight sum
    for k = 1:M
        wtsSum = wtsSum + wtsUN(k) ;
    end
    
    %Normalize weights
    for k = 1:M
        wts(k) = wtsUN(k) / wtsSum ;  
    end
     
    %Calculated Expected Filter Output and Co-eff of variation
    for k = 1:M
        %Expected Filter Output
        Exp = Exp +  (wts(k) *  XState(k));
        
        %Coefficient of variation
        CV = CV + (((M * wts(k)) - 1) ^ 2);
    end
    CV = 1/M * CV;
    
    %Store Expected filter output for plotting
    output(t) = Exp;
    
    %Effective Sampling Size
    ESS = M / (1 + CV);
    
    %Plot weights if flag is on
    if(start)
        figure(t)
        bar(X2, wts,'k')
        axis([-10 M+10 0 (1/M)*5])
        xlabel('Particle');
        ylabel('Weight');
        set(gca,'FontSize',24)
        fname = strcat('/Report/Figures/', num2str(t), '.eps');
%         saveas(figure(t),[pwd fname]);
        disp(strcat('iteration = ',num2str(t), ' ESS = ', num2str(ESS) ))

        
    end
    
    %Resampling
     if( ESS < RS * M )
        
        %Track the number of times Resampled 
        ResampleCount = ResampleCount + 1;
        
        %Check for lucky resampling number
        if(ResampleCount == luckyNum)
            start = 1;
        end
        
        %Cumulative Weights Q
        Q(1) = wts(1); 
        for k = 2:M
            Q(k) = Q(k-1) + wts(k); 
        end
                
        %Guesses
        T = rand(1,M);
        T(k+1) = 1;
                
        %Sorting the Guesses
        T = sort(T);
                
        i = 1;
        j = 1;
                
        while( i <= M )
            
            %Find good particle indices
            if( T(i) < Q(j) )
                Index(i) = j;
                i = i+1;
            else
                j = j+1;
            end
                    
        end
         
%         Replace Bad Particles with good particles
        for i = 1:M
            XState(i) = XState(Index(i));
            XPrevState(i) = XPrevState(Index(i));
            
            XVel(i) = XVel(Index(i));
            XPrevVel(i) = XPrevVel(Index(i)) ; 
            
            wts(i) = 1/M;
            wtsPrev(i) = 1/M;
            wtsUN(i) = 1/M;
        end
        
        %Plot resampled weights
        if(start)
            figure(t)
            bar(X2, wts, 'k');
            axis([-10 M+10 0 (1/M)*5]);
            set(gca,'FontSize',24);
            xlabel('Particle');
            ylabel('Weight');
            fname= strcat('/Report/Figures/', num2str(t), 'resampled.eps');
%             saveas(figure(t),[pwd fname]);
            disp(strcat('iteration = ',num2str(t), ' ESS = ', num2str(ESS) ))
        end
        
        %After 1 full cycle after last resample
        if(ResampleCount == luckyNum + 1)
           start = 0;
        end
                
     end

end

close all

figure(1) 
plot(X1,actualPos, 'kO','MarkerSize', 5);
hold on
plot(X1,output, 'k','LineWidth',2)
hold off
xlabel("Time Samples");
ylabel("Position");
legend("Actual Position", "Filter Output");
axis([0 1109 -25 25])
set(gca,'FontSize',24)



disp("SUCCESS!!!!!!!")