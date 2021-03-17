function vectOut = diffVect(comat)
%diffVect generates vector Cx-y, which has N elements
%Notation described in 'Feature Definition and Algorithm.docx'

n = size(comat, 1);
vectOut = zeros(1, n);

i = 1;
for k = 0:n-1
    if k == 0
        vectOut(i) = sum(diag(comat, k));
    else
        vectOut(i) = sum(diag(comat, k)) + sum(diag(comat, -k));
    end
    i = i + 1;
end
