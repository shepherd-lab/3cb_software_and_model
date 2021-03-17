function DensityFitParams(analysis, info, machineParams, dbName)

global ok_continue Analysis Info 

%Save density corrections as a look up table
entryWrite{1} = num2str(info.centerlistactivated);      %machine_id
entryWrite{2} = num2str(info.AcquisitionKey);           %acquisition_id
entryWrite{3} = num2str(info.CommonAnalysisKey);        %commonanalysis_id
entryWrite{4} = num2str(info.FilmDate);                 %date_acquisition
entryWrite{5} = machineParams.padSize;                  %paddle_size
entryWrite{6} = info.Version;                           %version

colPt = 7;
thickVect = [2 4 6];
for h = 1:3     %3 thicknesses
    densCorrAtH = analysis.densCorrTable(:, :, h);
    for dens = 1:3  %3 densities
        entryWrite{colPt+9*(h-1)+3*(dens-1)} = num2str(thickVect(h));
        entryWrite{colPt+9*(h-1)+3*(dens-1)+1} = num2str(densCorrAtH(1, dens));
        entryWrite{colPt+9*(h-1)+3*(dens-1)+2} = num2str(densCorrAtH(2, dens));
    end
end

%write table by checking existance according to acquistion_id and version
writeTable(entryWrite, dbName, 'DensityCorrGen3', 1, [2, 6]);
entryWrite = {};

%Save density correction surface fit parameters
entryWrite{1} = num2str(info.centerlistactivated);      %machine_id
entryWrite{2} = num2str(info.AcquisitionKey);           %acquisition_id
entryWrite{3} = num2str(info.CommonAnalysisKey);        %commonanalysis_id
entryWrite{4} = num2str(info.FilmDate);                 %date_acquisition
entryWrite{5} = machineParams.padSize;                  %paddle_size
entryWrite{6} = info.Version;                           %version

colPt = 7;
numFitParams = length(analysis.densFitParam);
for i = 1:numFitParams
    entryWrite{colPt} = num2str(analysis.densFitParam(i));
    colPt = colPt + 1;
end
numFitAnaly = length(analysis.densFitAnalysis);
for i = 1:numFitAnaly
    entryWrite{colPt} = num2str(analysis.densFitAnalysis(i));
    colPt = colPt + 1;
end

%write table by checking existance according to acquistion_id and version
writeTable(entryWrite, dbName, 'DensityFitParams', 1, [2, 6]);
Message('Ok');ok_continue=true;

%%
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

