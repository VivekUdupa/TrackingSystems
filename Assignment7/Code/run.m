%Main function to execute the Viterbi algorithm
    
    %% Initialization
    %Order A        C       G       T
%     H = [-2.322, -1.737, -1.737, -2.322];
%     L = [-1.737, -2.322, -2.322, -1.737];
    H = log2( [0.2, 0.3, 0.3, 0.2] );
    L = log2( [0.3, 0.2, 0.2, 0.3] );

    
    %Initial probability
    poh = -1;
    pol = -1;
    
    %Transition probabilities
    phh = -1;
%     pll = -0.737;
    pll = log2(0.6);
    phl = -1;
%     plh = -1.322;
    plh = log2(0.4);
    
    %Input sequence
    
%     IS = ['G', 'G', 'C', 'A', 'C', 'T', 'G', 'A', 'A' ];
    IS = ['T', 'C', 'A', 'G', 'C', 'G', 'G', 'C', 'T' ];
    
    size = length(IS);
    
    ISn = zeros(1,size);
    
    %Convert sequence to array
    for i = 1:length(IS)
       if(IS(i) == 'A')
           ISn(i) = 1;
       elseif(IS(i) == 'C')
           ISn(i) = 2;
       elseif(IS(i) == 'G')
           ISn(i) = 3;
       else
           ISn(i) = 4;
       end
    end
    
    %Probabilities row1 -> Ph ;row2 -> Pl ;row3 -> best prob
    Prob = zeros(3, size);
    Best = zeros(1, size);
    
    %% Main Loop
    for i = 1:size
        
        if( i == 1)
            Prob(1,i) = poh + H(ISn(i));
            Prob(2,i) = pol + L(ISn(i));

            if( Prob(1,i) > Prob(2,i) )
                Prob(3,i) = Prob(1,i);
                Best(i) = 0;
            else
                Prob(3,i) = Prob(2,i);
                Best(i) = 1;
            end
                
        else
            Prob(1,i) = H(ISn(i)) + max ( (Prob(1, i-1) + phh), (Prob(2, i-1) + plh) );
            Prob(2,i) = L(ISn(i)) + max ( (Prob(1, i-1) + phl), (Prob(2, i-1) + pll) );
          
            if( (Prob(1,i) - Prob(2,i)) == 0 )
                Prob(3,i) = Prob(1,i);
                Best(i) = Best(i-1);
            elseif(  Prob(1,i) < Prob(2,i))
                Prob(3,i) = Prob(2,i);
                Best(i) = 1;
            else
                Prob(3,i) = Prob(1,i);
                Best(i) = 0;
            end
            
        end
    end
    
    disp("Best Probs: ");
    disp(Best)
    
    
disp("SUCCESS!!")
