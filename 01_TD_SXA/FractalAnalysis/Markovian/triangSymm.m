function result = triangSymm(comat)
%triangSymm computes Triangular Symmetry
%Notation described in 'Feature Definition and Algorithm.docx'

n = size(comat, 1);
result = 0;

for i = 1:n
    for j = 1:n
        result = result + abs(comat(i, j) - comat(j, i));
    end
end