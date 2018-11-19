function [wtsPrev, XPrev] = Update(wtsUN, XState)
%This function updates the previous weight and state values

wtsPrev = wtsUN;

%XPrev(1,i) = XState(1,i);
%XPrev(2,i) = XState(2,i);
XPrev = XState;

end