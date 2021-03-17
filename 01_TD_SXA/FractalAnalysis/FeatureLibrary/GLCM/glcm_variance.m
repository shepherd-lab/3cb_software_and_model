function output=glcm_variance(calcParam,inputParam)  %#ok<INUSD>
sx = 0; sy = 0;
Ng=calcParam.Ng;
for i = 1:Ng
    sx = sx + (i-calcParam.mx)^2*sum(calcParam.glcmroi_norm(i,:));
end
for j = 1:Ng
    sy = sy + (j-calcParam.my)^2*sum(calcParam.glcmroi_norm(:,j));
end
output = sqrt(sx^2+sy^2);
end
