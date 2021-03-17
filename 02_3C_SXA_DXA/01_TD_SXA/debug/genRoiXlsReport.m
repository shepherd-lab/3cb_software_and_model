function genRoiXlsReport(roiInfo, info, append)
%save roiInfo in ROI.xls

global rootdir xlsLineNum

shtName = 'Sheet1';

%default: append = false
if nargin == 2
    append = false;
end

%Get the full path name of the file
fileName = 'KarlaFeatures.xls';
filePathName = [rootdir, 'debug\FeatureReport\', fileName];

%Get the number of lines used if append if true
%Clear the excel file content if append if false
if append
    xlsLineNum = getXlsLines(filePathName, 'sheetIndex', 1) + 1;
else
    if xlsLineNum == 1
        clearExcelFile(filePathName);
    end
end
lineNum = xlsLineNum;

%Writing results
if ~isempty(roiInfo)
    switch lower(roiInfo.regType)
        case 'square'
            %write table title
            if lineNum == 1
                tableTitle = {'Acquisition ID', 'ROI Type', ...
                              'Xmin', 'Xmax', 'Ymin', 'Ymax'};
                xlswrite(filePathName, tableTitle, shtName);
                lineNum = lineNum + 1;
            end

            %write contents
            tableEntry = cell(1, 6);
            tableEntry{1} = info.AcquisitionKey;
            tableEntry{2} = roiInfo.regType;
            tableEntry(3:6) = num2cell(roiInfo.regParam);
            xlswrite(filePathName, tableEntry, shtName, ['A', num2str(lineNum)]);
    end
else
    xlswrite(filePathName, info.AcquisitionKey, shtName, ['A', num2str(lineNum)]);
end