function output=glcm_homogeneity(calcParam,inputParam) %#ok<INUSD>
inv_diffmom = 0;
Ng=calcParam.Ng;
for i = 1:Ng
    for j = 1:Ng
        inv_diffmom  = inv_diffmom + calcParam.glcmroi_norm(i,j)/(1+(i-j)^2); %homogeneity
    end
end
output = inv_diffmom;
end
