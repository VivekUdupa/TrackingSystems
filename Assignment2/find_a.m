function a = find_a(Data, initial_guess, Name)

    disp("Executing for ");
    disp(Name);

    %Find the unknown using iritative root finding method
    iti = 500; %Total number of itirations
    a = initial_guess; %initial guess
    
    x = Data(:,1);  %X co-ordiante values
    y = Data(:,2);  %Y co-ordinate points
    
    N = length(x); %Total number of data points
    
    for j = 1:iti
        F = 0;
        F_dash = 0;
        for i = 1:N
%             F = F + ( ( y(i) - log(a*x(i) ) ) / a ) ;
%             F_dash = F_dash + log( a*x(i) ) - ( y(i) + 1 );
              F = F + ( ( y(i) - log( a * x(i) ) ) / a  );
              F_dash = F_dash + ( ( log( a * x(i) ) - y(i) - 1 ) / ( a*a) );
        end
        an = a - (F / F_dash);
        if( abs(an - a) < 0.0001 )
            break;
        end
        a = an;
    end
    disp("Itirations taken");
    disp(j);


end