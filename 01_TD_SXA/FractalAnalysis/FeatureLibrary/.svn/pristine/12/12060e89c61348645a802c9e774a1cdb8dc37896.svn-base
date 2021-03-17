function output = laws(image, mask, filVer, filHor, mmt)
%This function calculate Laws features.
%filVer: vertical filter name (ie L5)
%filHor: horizontal filter name (ie E5)
%mmt: order of moment (ie 2nd 4th)

[imFiltered, mask] = applyLawsFilter(image, mask, filVer, filHor);

roiIdx = (mask ~= 0);
output = zeros(size(mmt));
for i = 1:length(mmt)
    mOrder = mmt(i);
    output(i) = moment(imFiltered(roiIdx), mOrder);
end