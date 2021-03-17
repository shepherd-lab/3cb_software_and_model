function result = correlation(comat)
%correlation computes Correlation
%Notation described in 'Feature Definition and Algorithm.docx'

Cx = sum(comat, 2);
Cy = sum(comat, 1);
Mx = mean(Cx);
My = mean(Cy);
Sx = std(Cx);
Sy = std(Cy);

n = size(comat, 1);
result = 0;
for i = 1:n
    for j = 1:n
        result = result + i*j*comat(i, j) - Mx*My;
    end
end

result = result/(Sx*Sy);