function Best = Backtracking(Best, Prob)
%Finds the best probsbility

    finalProb = Prob(3,:);
    size = length(finalProb);
    
    for i = size:-1:1
        if(finalProb(i) == 9)
            if(i == size)
                Best(i) = 1; %If last prob is same, initialize to Low
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