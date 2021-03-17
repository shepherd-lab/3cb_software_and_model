function result=Windowfiltration(signal,windowsize)
%Lionel HERVE
%10-1-03
%4-9-04 use conv2 with 'same' option

result=conv2(signal,ones(1,windowsize),'same')/windowsize;

