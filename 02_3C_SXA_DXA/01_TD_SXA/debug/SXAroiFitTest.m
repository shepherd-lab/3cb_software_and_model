function SXAroiFitTest( )

xlsLine = 2;
roiThick = [1.2; 1.9; 2.6; 3.3; 4; 4.7; 5.4; 6.1; 6.8];
testLevel = [0.95, 0.99, 0.999];
LOW = testLevel(1);
MED = testLevel(2);
HIGH = testLevel(3);

sheet = 'AVON';
data = xlsread('SXAroiFit.xls', sheet, ['A', num2str(xlsLine), ':', 'J', num2str(xlsLine)]);

% n = 3;
% normr = zeros(1, n);
% chiSqr = zeros(1, n);
% rSqr = zeros(1, n);

while ( ~isempty(data) )
    roiVal = data(2:end)';
    
    %Calculate best-fit
    numData = 9;
    chiSqr = Inf;
    iter = 1;
    results = cell(1, 11);
    while ( chiSqr > chiSqrTableLookUp(HIGH, numData-3) && iter < 5 )
        switch iter
            case 1
                min = 1;
                max = 9;
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
        
        [p, chiSqr] = sxaRoiFit(roiThick(min:max), roiVal(min:max));
        
        if ( iter == 1 )
            results{1} = chiSqr;
            if ( chiSqr <= chiSqrTableLookUp(HIGH, numData-3) )
                results{2} = 'Yes';
            else
                results{2} = 'No';
            end
        end
        
        if ( iter == 2 )
            results{3} = chiSqr;
            if ( chiSqr <= chiSqrTableLookUp(HIGH, numData-3) )
                results{4} = 'Yes';
                %Add more left points
                while min > 1
                    min = min - 1;
                    [pNew, chiSqrNew] = sxaRoiFit(roiThick(min:max), roiVal(min:max));
                    if ( chiSqrNew <= chiSqrTableLookUp(HIGH, numData-3) )
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
                    [pNew, chiSqrNew] = sxaRoiFit(roiThick(min:max), roiVal(min:max));
                    if ( chiSqrNew <= chiSqrTableLookUp(HIGH, numData - 3) )
                        p = pNew;
                        chiSqr = chiSqrNew;
                    else
                        max = max - 1;
                        break;
                    end
                end
                results{5} = [num2str(min), ' to ', num2str(max)];
                results{6} = chiSqr;
                results{7} = 'Yes';
            else
                results{4} = 'No';
            end
        end
        
        if ( iter == 3 )
            results{8} = chiSqr;
            if ( chiSqr <= chiSqrTableLookUp(HIGH, numData-3) )
                results{9} = 'Yes';
            else
                results{9} = 'No';
            end
        end
        
        if ( iter == 4 )
            results{10} = chiSqr;
            if ( chiSqr <= chiSqrTableLookUp(HIGH, numData-3) )
                results{11} = 'Yes';
            else
                results{11} = 'No';
            end
        end
        
        iter = iter + 1;
    end

    if xlsLine == 2
        entryWrite = {'acqId', 'ROI 1', 'ROI 2', 'ROI 3', 'ROI 4', ...
                      'ROI 5', 'ROI 6', 'ROI 7', 'ROI 8', 'ROI 9', ...
                      'chiSqrAll', 'success?', 'chiSqr 2-6', 'success?', ...
                      'x? - y?', 'chiSqr', 'success?', ...
                      'chiSqr 1-5', 'success?', 'chiSqr 3-6', 'success?'};
        xlswrite('roiFitTest.xls', entryWrite, sheet, 'A1');
    end

    entryWrite(1:10) = num2cell(data(1:10));
    entryWrite(11:21) = results;

    xlswrite('roiFitTest.xls', entryWrite, sheet, ['A', num2str(xlsLine)]);
    
    if mod(xlsLine, 200) == 0
        display(['xlsLine = ', num2str(xlsLine)])
    end

    xlsLine = xlsLine + 1;
    data = xlsread('SXAroiFit.xls', sheet, ['A', num2str(xlsLine), ':', 'J', num2str(xlsLine)]);
end


%%
function threshold = chiSqrTableLookUp(testLevel, df)
chiSqrTable = [NaN, 0.95, 0.99, 0.999;
               1, 3.84, 6.64, 10.83
               2, 5.99, 9.21, 13.82
               3, 7.82, 11.34, 16.27
               4, 9.49, 13.28, 18.47
               5, 11.07, 15.09, 20.52
               6, 12.59, 16.81, 22.46];
row = find(chiSqrTable(:, 1) == df);
col = find(chiSqrTable(1, :) == testLevel);

if ( ~isempty(row) && ~isempty(col) )
    threshold = chiSqrTable(row, col);
else
    threshold = chi2inv(testLevel, df);
end

%%
function [p, chiSqr] = sxaRoiFit(roiThick, roiVal)

p = polyfit(roiThick, roiVal, 2);
chiSqr = sum((roiVal - p(1)*roiThick.^2 - p(2)*roiThick - p(3)).^2./ ...
         abs(p(1)*roiThick.^2 + p(2)*roiThick + p(3)));
