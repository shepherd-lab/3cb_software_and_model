function numLines = getXlsLines(fileName, shtInfoType, shtInfo)
% Get the number of lines used in a sheets of an excel workbook.
% shtInfoType: 'sheetIndex' or 'sheetName'
% shtInfo:  number specifying the sheet index
%        or string specifying the sheet name

% Check whether the file exists
if ~exist(fileName, 'file')
    error([fileName ' does not exist !']);
else
    % Check whether it is an Excel file
    typ = xlsfinfo(fileName);
    if ~strcmp(typ,'Microsoft Excel Spreadsheet')
        error([fileName ' not an Excel sheet !']);
    end
end

% If fileName does not contain a "\" the name of the current path is added
% to fileName. The reason for this is that the full path is required for
% the command "excelObj.workbooks.Open(fileName)" to work properly.
if isempty(strfind(fileName,'\'))
    fileName = [cd '\' fileName];
end

% Check if sheet is specified
% If not, default sheet #1 is used
if nargin == 1
    shtInfoType = 'sheetIndex';
    shtInfo = 1;
elseif nargin == 3
    % Check if shtInfoType matches the keywords
    if ~(strcmpi(shtInfoType, 'sheetIndex') || ...
         strcmpi(shtInfoType, 'sheetName'))
        error(['The sheetInfoType must be ''sheetIndex'' ', ...
               'or ''sheetName''']);
    end
else
    error('Error! Check the number of input arguments.');
end

excelObj = actxserver('Excel.Application');
excelWorkbook = excelObj.workbooks.Open(fileName);
worksheets = excelObj.sheets;
numSheets = worksheets.Count;

if strcmpi(shtInfoType, 'sheetIndex')
    shtIdx = shtInfo;
else
    % Get names of all sheets
    shtNameAll = cell(1, numSheets);
    for s = 1 : numSheets
        % worksheets.Item(sheetIndex).UsedRange is the range of used cells.
        shtNameAll{s} = worksheets.Item(s).Name;
    end

    %locate the index of the sheet specified
    shtIdx = find(strcmp(shtNameAll, sheetName));
end

%return the number of lines
if isempty(shtIdx)
    excelWorkbook.Close(false);
    excelObj.Quit;
    excelObj.delete;
    error('No sheet is found with the name specified !');
else
    numLines = worksheets.Item(shtIdx).UsedRange.Rows.Count;
    excelWorkbook.Close(false);
    excelObj.Quit;
    excelObj.delete;
end
