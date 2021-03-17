function [p, chiSqr, roiUsed] = SXAroiBestFit(roiThick, roiVal)
% This function determines the optimal fitting of roi attenuations vs. SXA
% step thicknesses. The best fit may use only a few ROI steps.
% 
% Refer to Song Note I, p.81.
global Info
num2str(Info.AcquisitionKey)
roiVal

numData = length(roiVal);
confLevel =  0.999; 
success = false;
iter = 1;

while ( ~success && iter < 5 )
    % The ROIs used in each iteration for fitting is outlined in lab notes
    switch iter
        case 1
            min = 1;
            max = numData;
        case 2
            min = 2;
            max = 6;
        case 3
            min = 1;
            max = 5;
        case 4
            min = 3;
            max = 6;
    end
    numData = max - min + 1;
    
    % Do the fitting
    [p, chiSqr] = sxaRoiFit(roiThick(min:max), roiVal(min:max));
    
    % Chi-square test to determine the best fitting
    if ( chiSqr <= chiSqrTableLookUp(confLevel, numData-3) )
        if ( iter == 2 )
            %For case 2, try to include most points for best fit
            %Add more left points
            while min > 1
                min = min - 1;
                numData = max - min + 1;
                [pNew, chiSqrNew] = sxaRoiFit(roiThick(min:max), roiVal(min:max));
                if ( chiSqrNew <= chiSqrTableLookUp(confLevel, numData-3) )
                    p = pNew;
                    chiSqr = chiSqrNew;
                else
                    min = min + 1;
                    break;
                end
            end

            %Add more right points
            while max < 9
                max = max + 1;
                numData = max - min + 1;
                [pNew, chiSqrNew] = sxaRoiFit(roiThick(min:max), roiVal(min:max));
                if ( chiSqrNew <= chiSqrTableLookUp(confLevel, numData - 3) )
                    p = pNew;
                    chiSqr = chiSqrNew;
                else
                    max = max - 1;
                    break;
                end
            end

            numData = max - min + 1;
        end
        success = true;
        roiUsed = [num2str(min), '_', num2str(max)];
    end
    
    iter = iter + 1;
end

if ( success == false )
    p = NaN;
    chiSqr = NaN;
    roiUsed = NaN;
end


%% 
function threshold = chiSqrTableLookUp(confLevel, df)
chiSqrTable = [NaN, 0.95, 0.99, 0.999;
               1, 3.84, 6.64, 10.83
               2, 5.99, 9.21, 13.82
               3, 7.82, 11.34, 16.27
               4, 9.49, 13.28, 18.47
               5, 11.07, 15.09, 20.52
               6, 12.59, 16.81, 22.46];
row = find(chiSqrTable(:, 1) == df);
col = find(chiSqrTable(1, :) == confLevel);

if ( ~isempty(row) && ~isempty(col) )
    threshold = chiSqrTable(row, col);
else
    threshold = chi2inv(confLevel, df);
end


%%
function [p, chiSqr] = sxaRoiFit(roiThick, roiVal)

p = polyfit(roiThick, roiVal, 2);
chiSqr = sum((roiVal - p(1)*roiThick.^2 - p(2)*roiThick - p(3)).^2./ ...
         abs(p(1)*roiThick.^2 + p(2)*roiThick + p(3)));
