function result = diagM(comat)
%diagM computes Diagonal Moment
%Notation described in 'Feature Definition and Algorithm.docx'

n = size(comat, 1);
result = 0;

for i = 1:n
    for j = 1:n
        result = result + sqrt(0.5 * abs(i-j) * comat(i, j));
    end
end