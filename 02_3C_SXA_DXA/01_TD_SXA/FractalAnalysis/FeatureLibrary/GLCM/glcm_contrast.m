function output=glcm_contrast(calcParam,inputParam) %#ok<INUSD>
output = calcParam.stats.Contrast;
end
%Labeled as contrast calculation in StructuralAnalysis but never returned.
%for i = 1:Ng
%    for j = 1:Ng
%        k_matr(i,j) = abs(i-j);
%    end
%end
%for k = 0:Ng-1
%    index = find(k_matr==k);
%    gcontr = gcontr + k^2*sum(glcmroi_norm(index));
%end
