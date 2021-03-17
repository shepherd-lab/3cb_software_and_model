function result = maxCorCoef(comat)
%maxCorCoef computes Maximal Correlation Coefficient
%Notation described in 'Feature Definition and Algorithm.docx'

Cx = sum(comat, 2);
Cy = sum(comat, 1);
n = length(Cx);

Q = zeros(size(comat));
for i = 1:n
    for j = 1:n
        if Cx(i) ~= 0 && Cy(j) ~= 0
            for k = 1:n
                Q(i, j) = Q(i, j) + comat(i, k)*comat(j, k);
            end
            Q(i, j) = Q(i, j)/(Cx(i)*Cy(j));
        end
    end
end

eigVal = sort(eig(Q), 'descend');
result = eigVal(2);