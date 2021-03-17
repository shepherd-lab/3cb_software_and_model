function result = angSecM(comat)
%angSecM computes Angular Second Moment

result = sum(sum(comat.^2));
