function result = maxIntensProb(comat)
%maxIntensProb computes Maximum of Intensity Probability
%Notation described in 'Feature Definition and Algorithm.docx'

Cx = sum(comat, 2);
result = max(Cx);