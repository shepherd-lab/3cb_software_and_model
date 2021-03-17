function result = sumVar(sumVec, SE)
%sumVar computes Sum Variance
%Notation described in 'Feature Definition and Algorithm.docx'

n = length(sumVec);
result = 0;

for i = 1:n
    result = result + ((i+1) - SE)^2*sumVec(i);
end
