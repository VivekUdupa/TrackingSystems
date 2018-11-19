function run()
    
    %% Importind Data
    %Read the entire dataset
    Table = dlmread("magnets-data.txt");

    %Seperate the table elements
    actualPos = Table(:,1);
    actualVel = Table(:,2);
    sensorRead = Table(:,3);
    
    %% Initialization   
        
    %Number of Sensor Reading
    Nsnsr = length(sensorRead);
    
    %Number of Particles
    M = 1000;
    
    %Magnet Positions
    xm1 = -10;
    xm2 =  10;
    
    %Standard deviation
    sigmaM = 4;
    sigmaA = 0.0625;
    sigmaN = 0.003906;
    
    %State Transition
    %1st row -> position | 2nd row -> velocity
    XState = zeros(2,M);
    XPrev = zeros(2,M);
    
    %Weights
    wts = ones(1,M) * 1/M;
    wtsPrev = ones(1,M) * 1/M;
    wtsUN = ones(1,M) * 1/M;
    
    %Measurement vector for each particle
    ytP = zeros(1,M);
    
    %Resampling
    %Cumulative Weights
    Q = zeros(1,M);
    %Random Guesses
    T = zeros(1,M+1);
    
    %Number of resampling 
    RSCount = 0;
    
    %Flag to track weight plot
    start = 0;
    
    %Plots start when resampling count is:
    luckyNum = 17;
    
    %Resample when particles go below RS percentage
    RS = 0.5;
    
    %Plotting
    
    %axis vector for weights plot
    axisW = [0 M 0 (1/M)*10];
    %axis vector for filter output
    axisF = [0 1109 -25 25];
    
    %Filter Output
    output = zeros(1,length(Nsnsr));
    
    %X-axis to plot filter output
    X1 = 1 : length(Nsnsr);
    %X-axis to plot weights
    X2 = 1 : M;
    
    %FontSize
    FS = 14;
    
    %% Predict-Update Loop
    
    %Loop for the entire sensor dataset
    for t = 1:Nsnsr

        %Loop for each particle
        for i = 1:M
            
            %State Transition Calculation
            XState(:,i) = Predict(XState(:,i), XPrev(:,i), sigmaA);
            
            %Calculate weight
            wtsUN(i) = Weights(wtsPrev(i), XPrev(1,i), sensorRead(t), sigmaM, sigmaN);

            
            %Update previous values
            [wtsPrev(i), XPrev(:,i)] = Update(wtsUN(i), XState(:,i));
            
        end %endi
        
        %Initialization for Normalizing weights and Resampling
        wtsSum = 0; %un-normalized cumulative weight 
        Exp = 0; %Expected filter Output
        CV = 0; %co-eff of variance
        Index = zeros(1,M); %Index of good particles
        
        %Normalize Weights
        wtsSum = cumsum(wtsUN);
        wts = wtsUN / wtsSum(M); 
        
        
        
        
        
        
        
    end %endt
    
    
    
    
    
    
    
    
    
    
    
end %Function