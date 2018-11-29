function Prob = Viterbi(Prob, poh, pol, plh, pll, phh, phl, H, L, Input)
%Viterbi algorithm to calculate the forward probabilities
    size = length(Input);
    
    for i = 1:size
        if( i == 1)
            Prob(1,i) = poh + H(Input(i));
            Prob(2,i) = pol + L(Input(i));

            if( Prob(1,i) == Prob(2,i) )
                Prob(3,i) = Prob(1,i);
                Prob(4,i) = 9; %Equal
            
            elseif(Prob(1,i) > Prob(2,i))
                Prob(4,i) = 0;
                Prob(3,i) = Prob(1,i); %High
            
            else
                Prob(4,i) = 1; %Low
                Prob(3,i) = Prob(2,i);
                
  
            end

        else
            Prob(1,i) = H(Input(i)) + max ( (Prob(1, i-1) + phh), (Prob(2, i-1) + plh) );
            Prob(2,i) = L(Input(i)) + max ( (Prob(1, i-1) + phl), (Prob(2, i-1) + pll) );

            if( (Prob(1,i) - Prob(2,i)) == 0 )
                Prob(3,i) = Prob(1,i); %Same
                Prob(4,i) = 9;
                
            elseif(  Prob(1,i) < Prob(2,i))
                Prob(3,i) = Prob(2,i);
                Prob(4,i) = 1; %Low

            else
                Prob(3,i) = Prob(1,i);
                Prob(4,i) = 0; %High

            end
                

        end
    end
end
   