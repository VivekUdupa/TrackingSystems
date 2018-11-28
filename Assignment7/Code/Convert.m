function Num = Convert(Alpha, Num)
%Convert alphabetical sequence to numbers
    for i = 1:length(Alpha)
       if(Alpha(i) == 'A')
           Num(i) = 1;
       elseif(Alpha(i) == 'C')
           Num(i) = 2;
       elseif(Alpha(i) == 'G')
           Num(i) = 3;
       else
           Num(i) = 4;
       end
    end

end