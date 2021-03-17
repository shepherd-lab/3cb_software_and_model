function result = prodM(comat)
%prodM computes Product Moment
%Notation described in 'Feature Definition and Algorithm.docx'

u = mean(comat(:));
n = size(comat, 1);
result = 0;

for i = 1:n
    for j = 1:n
        result = result + (i - u) * (j - u) * comat(i, j);
    end
end