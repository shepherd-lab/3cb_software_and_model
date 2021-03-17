function popCalibTableC1Kvalues

xlsFile = 'D:\users\sge\Data\Original K table_by sheet.xls';

for kVp = 24:35
    sheetName = num2str(kVp);
    kTable = xlsread(xlsFile, sheetName);
    [rows, cols] = size(kTable);
%     kList = zeros(1, rows*cols);
%     for j = 1:rows*cols
%         rowIdx = ceil(j/cols);
%         colIdx = j - (rowIdx-1)*cols;
%         kList(j) = kTable(rowIdx, colIdx);
%     end
%     kList;
    
    SQLstatement = ['UPDATE CalibrationTableC1 SET '];
    for j = 1:rows
        SQLstatement = [SQLstatement, ...
                        'thickness', num2str(j), '=', num2str(kTable(j, 1), '%11.9f'), ', ', ...
                        'klean', num2str(j), '=', num2str(kTable(j, 2), '%11.9f'), ', ', ...
                        'km', num2str(j), '=', num2str(kTable(j, 3), '%11.9f'), ', '];
    end
    SQLstatement = [SQLstatement(1:end-3), ' ', ...
                    'WHERE kVp = ', num2str(kVp)];
    mxDatabase('mammo_cpmc', SQLstatement);
end