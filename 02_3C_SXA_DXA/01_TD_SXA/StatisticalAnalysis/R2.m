%R2
%Lionel HERVE
%5-20-04
%compute the paramater R2 after the multilple regression of A by B is done

function result=R2(A,B);

B=[ones(size(B,1),1) B];
X=(B'*B)^-1*B'*A;

figure;plot(A,B*X,'.');
result=1-sum((B*X-A).^2)/sum((A-mean(A)).^2);