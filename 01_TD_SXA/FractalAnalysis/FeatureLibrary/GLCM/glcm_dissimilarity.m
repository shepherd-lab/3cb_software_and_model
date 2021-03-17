function output=glcm_dissimilarity(calcParam,inputParam)  %#ok<INUSD>
dis = 0;
Ng=calcParam.Ng;
for i = 1:Ng
    for j = 1:Ng
        dis  = dis + calcParam.glcmroi_norm(i,j)*abs(i-j);
    end
end
output = dis;
end
