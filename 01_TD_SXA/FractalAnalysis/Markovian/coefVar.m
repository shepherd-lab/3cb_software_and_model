function result = coefVar(comat)
%coefVar computes Coefficient of Variation
%Notation described in 'Feature Definition and Algorithm.docx'

result = std(comat(:))/mean(comat(:));