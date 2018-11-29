function Best = Backtracking(Best, Prob)
%Finds the best probsbility
    
    init = 1;
    finalProb = Prob(4,:);
    size = length(finalProb);
    
    for i = size:-1:1
        if(finalProb(i) == 9)
            if(i == size)
                Best(i) = init; %If last prob is same, initialize
            else
                Best(i) = Best(i+1);
            end
        elseif(finalProb(i) == 0)
            Best(i) = 0; %Low
        else
            Best(i) = 1; %High
        end
    end

end