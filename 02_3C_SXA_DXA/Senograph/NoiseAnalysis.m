%Noise Analysis
% ask the operator to draw 5 square in the phantom

global Extract f0

f2=figure;hold on;

for i=1:5
    figure (f0.handle);
    imagemenu('meanStandarddeviation');
    i2=1;
    Y=[];X=[];
    while min(size(Extract))>1
       flatsignal=reshape(Extract,1,prod(size(Extract)));
       X(i2)=4^(i2-1);
       Y(i2)=var(flatsignal)^0.5;
       Extract=undersamplingn(Extract,2); 
       i2=i2+1;
    end
    figure(f2);plot(log(X),log(Y));
end