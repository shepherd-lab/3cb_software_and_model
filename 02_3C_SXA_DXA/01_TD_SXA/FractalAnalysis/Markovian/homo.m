function result = homo(comat)
%homo computes Homogeneity
%Notation described in 'Feature Definition and Algorithm.docx'

n = size(comat, 1);
result = 0;

for i = 1:n
    for j = 1:n
        result = result + comat(i, j)/(1 + abs(i-j));
    end
end