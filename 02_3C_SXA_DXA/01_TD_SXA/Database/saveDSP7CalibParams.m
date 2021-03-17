function saveDSP7CalibParams()

global ok_continue Analysis Info  Database MachineParams
dbName = Database.Name;
% % % %Save machine parameters
% % % entryWrite{1} = num2str(info.centerlistactivated);      %machine_id
% % % entryWrite{2} = num2str(info.AcquisitionKey);           %acquisition_id
% % % entryWrite{3} = num2str(info.CommonAnalysisKey);        %commonanalysis_id
% % % entryWrite{4} = num2str(info.FilmDate);                 %date_acquisition
% % % entryWrite{5} = machineParams.padSize;                  %paddle_size
% % % entryWrite{6} = num2str(analysis.x0cm_diff);            %x0cm_diff
% % % entryWrite{7} = num2str(analysis.y0cm_diff);            %y0cm_diff
% % % entryWrite{8} = num2str(machineParams.source_height);   %source_height
% % % entryWrite{9} = num2str(machineParams.bucky_distance);  %bucky_distance
% % % entryWrite{10} = num2str(machineParams.dark_counts);    %dark_counts
% % % entryWrite{11} = num2str(machineParams.th_correction);  %thickness_corr
% % % entryWrite{12} = num2str(machineParams.rx_correction);  %rx_corr
% % % entryWrite{13} = num2str(machineParams.ry_correction);  %ry_corr
% % % entryWrite{14} = num2str(machineParams.valFlag);        %validity_flag
% % % entryWrite{15} = num2str(info.kVp);                     %kVp
% % % entryWrite{16} = info.Version;                          %version
% % % 
% % % %write table by checking existance according to acquistion_id and version
% % % writeTable(entryWrite, dbName, 'MachineParametersGen3', 1, [2, 16]);
% % % entryWrite = {};
% % % 
% % % %Save k values
entryWrite{1} = num2str(Info.centerlistactivated);      %machine_id
entryWrite{2} = num2str(Info.AcquisitionKey);           %acquisition_id
entryWrite{3} = num2str(Info.CommonAnalysisKey);        %commonanalysis_id
entryWrite{4} = num2str(Info.FilmDate);                 %date_acquisition
entryWrite{5} = MachineParams.padSize;                  %paddle_size
entryWrite{6} = num2str(Info.kVp);                      %kVp
entryWrite{7} = num2str(Info.Version);                  %version
entryWrite{8} = num2str(Info.mAs);  
entryWrite{9} = num2str(Analysis.a_offset);
entryWrite{10} = num2str(Analysis.b_slope);

%write table by checking existance according to acquistion_id and version
writeTable(entryWrite, dbName, 'abTableDSP7', 1, [2, 7]);

entryWrite{1} = num2str(Info.centerlistactivated);      %machine_id
entryWrite{2} = num2str(Info.AcquisitionKey);           %acquisition_id
entryWrite{3} = num2str(Info.CommonAnalysisKey);        %commonanalysis_id
entryWrite{4} = num2str(Info.FilmDate);                 %date_acquisition
entryWrite{5} = MachineParams.padSize;                  %paddle_size
entryWrite{6} = num2str(Info.kVp);                      %kVp
entryWrite{7} = num2str(Info.Version);                  %version
entryWrite{8} = num2str(Info.mAs);  
entryWrite{9} = num2str(Analysis.A2);
entryWrite{10} = num2str(Analysis.A1);
entryWrite{11} = num2str(Analysis.A0);


writeTable(entryWrite, dbName, 'DensityDSP7Corr', 1, [2, 7]);

Message('Ok');ok_continue=true;


%
%
function writeTable(entryWrite, dbName, tableName, dupCheck, colList)
%if dupCheck == 1, check existance of the entry to be written based on the
%columns specified by colList

%get column names and data type of columns of the table
[a, colNames] = mxDatabase(dbName, ['SELECT * FROM ', tableName], 1); 
numCols = size(colNames, 2);

%get the number of columns to be checked for duplicate prevention
nKeys = length(colList);

%check the existance of an entry by looking at specified columns
if dupCheck
    %initialization
    checkVal = cell(1, nKeys);      %values to be compared for existance
    checkStr = cell(1, nKeys);      %values converted to strings for SQL
    colCheck = cell(1, nKeys);      %columns to be checked
    
    for i = 1:nKeys
        %get the value for existance check
        checkVal{i} = entryWrite{colList(i)};
        if ~ischar(checkVal{i})
            checkStr{i} = num2str(checkVal{i});
        else
            checkStr{i} = ['''', checkVal{i}, ''''];
        end
        
        %get column names for existance check
        colCheck{i} = colNames{colList(i)};
    end
    
    %find existance of a certain entry by checkVal{}
    SQLstatement  = 'SELECT ';
    for i = 1:nKeys
        SQLstatement = [SQLstatement, colCheck{i}, ', '];
    end
    SQLstatement = [SQLstatement(1:end-2), ' ', ...
                    'FROM ', tableName, ' ', ...
                    'WHERE '];
    for i = 1:nKeys
        SQLstatement = [SQLstatement, colCheck{i}, ' = ', checkStr{i}, ' AND '];
    end
    SQLstatement = SQLstatement(1:end-5);
    entryRead = mxDatabase(dbName, SQLstatement);
    
    %delete the entry if found
    if ~isempty(entryRead)
        SQLstatement = ['DELETE FROM ', tableName, ' ', ...
                        'WHERE '];
        for i = 1:nKeys
            SQLstatement = [SQLstatement, colCheck{i}, ' = ', checkStr{i}, ' AND '];
        end
        SQLstatement = SQLstatement(1:end-5);
        mxDatabase(dbName, SQLstatement);
    end
end

%form the list of values to write
numVal = min(numCols, size(entryWrite, 2));     %number of values to write
values = ['''', cell2mat(entryWrite(1)), ''''];
for i = 2:numVal
    values = [values, ', ''', cell2mat(entryWrite(i)),''''];
end

%add some empty fields if entryWrite is shorter than table fields
while numVal < numCols
    values = [values, ', '''''];
    numVal = numVal + 1;
end

%Write the entry
SQLstatement = ['INSERT INTO ', tableName, ' ', ...
                'VALUES(', values, ')'];
mxDatabase(dbName, SQLstatement);
