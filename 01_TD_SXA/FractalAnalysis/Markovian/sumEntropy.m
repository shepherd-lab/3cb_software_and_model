function result = sumEntropy(sumVec)
%sumEntropy computes Sum Entropy
%Notation described in 'Feature Definition and Algorithm.docx'

n = length(sumVec);
result = 0;

for i = 1:n
    if sumVec(i) ~= 0
        result = result + sumVec(i)*log(sumVec(i));
    end
end

result = -result;