function SXAStepRoiFit( )

[fName, pName] = uigetfile('*.txt', 'Select an acquisition list file');
if ~isequal(fName, 0)
    listIn = textread([pName, fName]);
    n = length(listIn);
    version = 'Version7.0.C4';
    roiThick = [1.2; 1.9; 2.6; 3.3; 4; 4.7; 5.4; 6.1; 6.8];
    xlsLine = 1;
    
    for i=1:n
        acqId = listIn(i);
        
        %Read kVp
        sql = ['SELECT kVp FROM acquisition ', ...
               'WHERE acquisition_id = ', num2str(acqId)];
        kVp = mxDatabase('mammo_cpmc', sql);
        
        %Read SXA roi values
        sql = ['SELECT * FROM SXAStepAnalysis ', ...
               'WHERE commonanalysis_id = ( ', ...
                    'SELECT MAX(commonanalysis_id) ', ...
                    'FROM commonanalysis ', ...
                    'WHERE acquisition_id = ', num2str(acqId), ' ', ...
                    'AND version LIKE ''%C4'')'];
        entryRead = mxDatabase('mammo_cpmc', sql);
        
        %Calculate best-fit
        if isempty(entryRead)
            roiVal = NaN*ones(1, 9);
            p = NaN*ones(1, 3);
            normr = NaN;
            chiSqr = NaN;
            rSqr = NaN;
        else
            roiVal = cell2mat(entryRead(5:13));
            roiVal = sort(roiVal)';
            [p, S] = polyfit(roiThick, roiVal, 2);
            normr = S.normr;
            chiSqr = sum((roiVal - p(1)*roiThick.^2 - p(2)*roiThick - p(3)).^2./ ...
                         (p(1)*roiThick.^2 + p(2)*roiThick + p(3)));
            rSqr = 1 - sum((roiVal - p(1)*roiThick.^2 - p(2)*roiThick - p(3)).^2)/ ...
                   sum((roiVal - mean(roiVal)).^2);
        end
        
        %Save results
        if i == 1
            entryWrite = {'acqId', 'kVp', 'ROI 1', 'ROI 2', 'ROI 3', 'ROI 4', ...
                          'ROI 5', 'ROI 6', 'ROI 7', 'ROI 8', 'ROI 9', ...
                          'p2', 'p1', 'p0', 'normRes', 'chiSqr', 'r-square'};
            xlswrite('SXAroiFit.xls', entryWrite, 'CPMC', ['A', num2str(xlsLine)]);
            xlsLine = xlsLine + 1;
        end

        entryWrite = {acqId};
        entryWrite(2) = kVp;
        entryWrite(3:11) = num2cell(roiVal);
        entryWrite(12:14) = num2cell(p);
        entryWrite(15:17) = {normr, chiSqr, rSqr};
        xlswrite('SXAroiFit.xls', entryWrite, 'CPMC', ['A', num2str(xlsLine)]);
        
        if mod(i, 50) == 0
            display(['i = ', num2str(i)])
        end
        
        xlsLine = xlsLine + 1;
    end
end