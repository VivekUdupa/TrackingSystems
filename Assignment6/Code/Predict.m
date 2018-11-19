function XState = Predict(XState, XPrev, sigmaA)
%This function calculates the State transit1on of the particles

            %Position
            XState(1,1) = XPrev(1,1) + XPrev(2,1) ;
            
            %Velocity
            if( XPrev(1,1) < -20)
                XState(2,1) = 2;
            
            elseif (XPrev(1,1) > 20)
                XState(2,1) = -2;
            
            elseif (XPrev(1,1) >= 0 && XPrev(1,1) <= 20 ) 
                XState(2,1) = XPrev(2,1) - abs(randn * sigmaA);
            
            elseif (XPrev(1,1) >= -20 && XPrev(1,1) < 0)
                XState(2,1) = XPrev(2,1) + abs(randn * sigmaA);
            end

end