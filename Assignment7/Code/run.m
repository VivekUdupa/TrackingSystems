function [Prob, Best] = run()%Main function to execute the Viterbi algorithm
clc
clear
    %% Initialization
    %Order     A    C    G     T
    H = log2( [0.2, 0.3, 0.3, 0.2] );
    L = log2( [0.3, 0.2, 0.2, 0.3] );

    
    %Initial probability
    poh = -1;
    pol = -1;
    
    %Transition probabilities
    phh = -1;
    pll = log2(0.6);
    phl = -1;
    plh = log2(0.4);
    
    %Input sequence
    
%     IS = ['G', 'G', 'C', 'A', 'C', 'T', 'G', 'A', 'A' ]; %Sequence 1
    IS = ['T', 'C', 'A', 'G', 'C', 'G', 'G', 'C', 'T' ]; %Sequence 2
    
    size = length(IS);
    
    ISn = zeros(1,size);
    
    %Probabilities row1 -> Ph ;row2 -> Pl ;row3 -> best prob
    Prob = zeros(4, size);
    Best = zeros(1, size);
    
    %Convert sequence to array
    ISn = Convert(IS, ISn);
        
    %% Execution
        
    %Calculating the forward Probabilities using Viterbi Algorithm
    Prob = Viterbi(Prob, poh, pol, plh, pll, phh, phl, H, L, ISn);
    
    %Backtracking
    Best = Backtracking(Best, Prob);
    
    disp("Best Probs: ");
    disp(Best)
        
    for i = 1:size
        if(Best(i) == 1)
            Ans(i) = 'L';
        else
            Ans(i) = 'H';
        end
    end
    
    disp(Ans);
    
    
    
disp("SUCCESS!!")
end