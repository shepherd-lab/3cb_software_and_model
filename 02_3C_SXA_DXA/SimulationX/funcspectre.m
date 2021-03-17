function spectre=funcspectre(mAs,kVp,coef,energies)
%compute spectre
%author Lionel HERVE
%date 3-25-3

mask=(energies<=kVp);  %to prevent the negative value for E>kVp
degre=[ones(size(coef,1),1) 2*ones(size(coef,1),1) 3*ones(size(coef,1),1) 4*ones(size(coef,1),1)];
tempspectre=sum(((kVp*ones(size(degre))).^degre.*coef)');
spectre=mAs.*tempspectre.*mask;
