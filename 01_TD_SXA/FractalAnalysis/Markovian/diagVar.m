function result = diagVar(comat)
%diagVar computes Diagonal Variance
%Notation described in 'Feature Definition and Algorithm.docx'

result = var(diag(comat));