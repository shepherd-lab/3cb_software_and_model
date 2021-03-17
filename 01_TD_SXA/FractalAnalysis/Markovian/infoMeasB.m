function result = infoMeasB(comat, ETP)
%infoMeasB computes Information Measure B
%Notation described in 'Feature Definition and Algorithm.docx'

Cx = sum(comat, 2);
Cy = sum(comat, 1);
n = length(Cx);

%Entropy of Cx, Cy
HXY = 0;
for i = 1:n
    for j = 1:n
        if Cx(i) ~= 0 && Cy(j) ~= 0
            HXY = HXY + Cx(i)*Cy(j)*log(Cx(i)*Cy(j));
        end
    end
end
HXY = -HXY;

result = sqrt(1 - exp(-2*(HXY - ETP)));
