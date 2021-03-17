function result = diffEntropy(diffVec)
%diffEntropy computes Difference Entropy
%Notation described in 'Feature Definition and Algorithm.docx'

n = length(diffVec);
result = 0;

for i = 1:n
    if diffVec(i) ~= 0
        result = result + diffVec(i)*log(diffVec(i));
    end
end

result = -result;
