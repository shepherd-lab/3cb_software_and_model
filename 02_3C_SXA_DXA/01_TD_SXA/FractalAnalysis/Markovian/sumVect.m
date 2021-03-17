function vectOut = sumVect(comat)
%sumVect generates vector Cx+y, which has 2N - 1 elements
%Notation described in 'Feature Definition and Algorithm.docx'

n = size(comat, 1);
comatFlip = fliplr(comat);
vectOut = zeros(1, 2*n-1);

i = 1;
for k = (n-1):-1:-(n-1)
    vectOut(i) = sum(diag(comatFlip, k));
    i = i + 1;
end