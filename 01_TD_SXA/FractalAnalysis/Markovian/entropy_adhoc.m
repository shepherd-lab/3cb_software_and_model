function result = entropy(comat)
%entropy computes Entropy
%Notation described in 'Feature Definition and Algorithm.docx'
count = 0;
n = size(comat, 1);
result = 0;


%add since doesn't make sense to iterate assuming square
m = size(comat,2);

for i = 1:n
    for j = 1:m         
        if comat(i, j) ~= 0           
            result = result + comat(i, j)*log(comat(i, j));           
        end
    end
end

result = -result;