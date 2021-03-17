function result = diffM(comat)
%diffM computes Difference Moment
%Notation described in 'Feature Definition and Algorithm.docx'

n = size(comat, 1);
result = 0;

for i = 1:n
    for j = 1:n
        result = result + (i-j)^2*comat(i, j);
    end
end
