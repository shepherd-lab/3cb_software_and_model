function result=Windowfiltration2D(signal,windowsize)
%Lionel HERVE
%10-1-03


result=conv2(+signal,ones(windowsize),'same')/windowsize^2;
