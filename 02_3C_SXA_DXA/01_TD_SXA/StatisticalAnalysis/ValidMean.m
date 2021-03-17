%Valid mean
%take care of the Nan and the abnormal value of a list

function Result=ValidMean(table)
signal=reshape(table,1,prod(size(table)));
MEAN=nanmean(signal);
STD=nanstd(signal);

if STD>0
    signal=signal+real(i./((abs(signal-MEAN))<2*STD));   %put the point which are two far from the mean to NaN in order to exclude them from the next nanmean
end


Result=nanmean(signal);
