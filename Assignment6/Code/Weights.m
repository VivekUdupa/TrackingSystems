function wtsUN = Weights(wtsPrev, XPrev,sensorRead, sigmaM, sigmaN)
%This function calculates the weights of the particles

    %Simplifications
    %Gaussian Const
    A = (1 / (sqrt(2*pi) * sigmaM)); 
    
    %Magnet 1 and 2 observation
    M1 = exp( -((XPrev - xm1  )^2) / (2 * (sigmaM^2) )); 
    M2 = exp( -((XPrev - xm2  )^2) / (2 * (sigmaM^2) ));
    
    
    %Observation Equation
    ytP =  (A * M1) + (A  * M2);
            
    %Simplification
    %Gaussian Const
    B = (1 / (sqrt(2*pi) * sigmaN));
    
    %ideal measurement vs actual measurement
    diff = ((ytP - sensorRead )^2);
    P = exp( - (diff / (2 *(sigmaN^2) )));
    
    %Probability 
    prob = ( B * P);
            
    %Unnormalized weights
    wtsUN = wtsPrev * prob;
end