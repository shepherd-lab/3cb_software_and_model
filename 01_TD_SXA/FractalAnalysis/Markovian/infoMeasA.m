function result = infoMeasA(comat, ETP)
%infoMeasA computes Information Measure A
%Notation described in 'Feature Definition and Algorithm.docx'

Cx = sum(comat, 2);
Cy = sum(comat, 1);

%Entropy of Cx
n = length(Cx);
HX = 0;
for i = 1:n
    if Cx(i) ~= 0
        HX = HX + Cx(i)*log(Cx(i));
    end
end
HX = -HX;

%Entropy of Cy
HY = 0;
for i = 1:n
    if Cy(i) ~= 0
        HY = HY + Cy(i)*log(Cy(i));
    end
end
HY = -HY;

%Entropy of comat and Cx, Cy
HXY = 0;
for i = 1:n
    for j = 1:n
        if comat(i, j)
            HXY = HXY + comat(i, j)*log(Cx(i)*Cy(j));
        end
    end
end
HXY = -HXY;

result = (ETP - HXY)/max(HX, HY);