function popCalibTableForVer7(calibTable, anaVersion, machIdList)
%NOTE: This function must be run with Matlab 2008a or later

%This function reads tables 'MachineParametersGen3' and 'kTableGen3' to
%populate a calibration table with the results of a specified version
%example:
%popCalibTableForVer7('CalibrationTableC4', 'Version7.0.C4', [43, 44]);

if ~strcmp(calibTable(end-1:end), anaVersion(end-1:end))
    error('Calibration table to be populated must match the analysis version!');
end

n = length(machIdList);
for i = 1:n     %for each machine
    machId = machIdList(i);
    
    % load default th, rx and ry corrections
    SQLstatement = ['SELECT thicknessSmall_corr, rxSmall_corr, rySmall_corr, ', ...
                    'thicknessBig_corr, rxBig_corr, ryBig_corr ', ...
                    'FROM MachineParameters ', ...
                    'WHERE machine_id = ', num2str(machId)];
    entryRead = mxDatabase('mammo_cpmc', SQLstatement);
    corrSmall = entryRead(1:3);
    corrLarge = entryRead(4:6);
    
    %read all entries from MachineParametersGen3 on a machine
    SQLstatement = ['SELECT * FROM MachineParametersGen3 ', ...
                    'WHERE machine_id = ', num2str(machId), ' ', ...
                    'AND version = ''', anaVersion, ''''];
    entryRead = mxDatabase('mammo_cpmc', SQLstatement);
    
    %seperate small and large paddles
    [entrySmall entryLarge] = separateSmLg(entryRead);
    
    %clean each category of small and large paddles
    cleanSmall = cleanEntries(entrySmall, corrSmall);
    cleanLarge = cleanEntries(entryLarge, corrLarge);
    
    %add k values to the cleaned small and large categories
    writeSmall = addKvalues(cleanSmall);
    writeLarge = addKvalues(cleanLarge);
    
    %write the combined entries to the calibration table
    writeCalibTable(calibTable, writeSmall);
    writeCalibTable(calibTable, writeLarge);
end

%%
function [smallOut largeOut] = separateSmLg(entryIn)

padCol = 5;
[numRows numCols] = size(entryIn);

numSmall = 0;
numLarge = 0;
smallOut = cell(0, numCols);
largeOut = cell(0, numCols);
for row = 1:numRows
    if strcmpi(strtrim(entryIn{row, padCol}), 'Small')
        numSmall = numSmall + 1;
        smallOut(numSmall, :) = entryIn(row, :);
    else
        numLarge = numLarge + 1;
        largeOut(numLarge, :) = entryIn(row, :);
    end
end

%%
function entryOut = cleanEntries(entryIn, corrDefault)

if isempty(entryIn)    %return [] if entryIn is empty
    entryOut = [];
else
    [rows, cols] = size(entryIn);
    dateCol = 4;
%     kVpCol = cols;

%     %delete entries with kVp ~= 28
%     for i = rows:-1:1   %reverse order ensures delete won't affect other indexes
%         if (entryIn{i, kVpCol} ~= 28)
%             entryIn(i, :) = [];     %delete row i
%         end
%     end

    %order entiries by acquisition date
    entryOrdered = sortrows(entryIn, dateCol);

    %check multiple entries on each date
    rows = size(entryOrdered, 1);
    rowCurr = 1;
    rowNext = rowCurr + 1;
    rowEntryOut = 0;
    entryOut = cell(rows, cols-3);  %remove flag, kVp and version from entryIn

    if rows > 1
        %clean entries by combining calibrations on the same date
        while rowCurr <= rows
            while (rowNext <= rows && ...
                   strcmpi(entryOrdered(rowCurr, dateCol), entryOrdered(rowNext, dateCol)))
                rowNext = rowNext + 1;
            end

            %get the range of the same date
            rowFirst = rowCurr;
            rowLast = rowNext - 1;

            %generate an entry for identical date, adding corr if missing
            [newEntry newCorr] = genNewEntry(entryOrdered(rowFirst:rowLast, :), corrDefault);
            rowEntryOut = rowEntryOut + 1;
            entryOut(rowEntryOut, :) = newEntry;

            %update default correction
            corrDefault = newCorr;

            %move on to the next comparison
            rowCurr = rowNext;
            rowNext = rowCurr + 1;
        end
    else
        [entryOut newCorr] = genNewEntry(entryIn, corrDefault);
        rowEntryOut = 1;
    end

    %delete empty rows in entryOut
    entryOut(rowEntryOut+1:rows, :) = [];
end


%%
function [entryOut, corrOut] = genNewEntry(entryIn, corrIn)

[numEntry, cols] = size(entryIn);
acqIdCol = 2;
flagCol = cols - 2;

%order entries by flag and acqID, decreasing
if numEntry > 1
    entryOrdered = sortrows(entryIn, [-flagCol, -acqIdCol]);
else
    entryOrdered = entryIn;
end

if (entryOrdered{1, flagCol} ~= 0)   %exist a valid image
    entryOut = entryOrdered(1, 1:flagCol-1);
    corrOut = entryOrdered(1, flagCol-3:flagCol-1);
else
    entryOut = entryOrdered(1, 1:flagCol-1);
    entryOut(end-2:end) = corrIn;
    corrOut = corrIn;
end

%%
function entryOut = addKvalues(entryIn)

if isempty(entryIn)    %return [] if entryIn is empty
    entryOut = [];
else
    comIdCol = 3;
    kVpCol = 6;
    kStartCol = 8;      %starting column of k-values
    [numRows numCols] = size(entryIn);

    %read the first entry and determine size of entryOut
    comId = entryIn{1, comIdCol};
    SQLstatement = ['SELECT * FROM kTableGen3 ', ...
                    'WHERE commonanalysis_id = ', num2str(comId)];
    entryRead = mxDatabase('mammo_cpmc', SQLstatement);
    entryOut = cell(numRows, numCols+size(entryRead, 2)-6);
    entryOut(1, :) = [entryIn(1, :), entryRead([kVpCol, kStartCol:end])];

    %read in other entries
    for i = 2:numRows
        comId = entryIn{i, comIdCol};
        SQLstatement = ['SELECT * FROM kTableGen3 ', ...
                        'WHERE commonanalysis_id = ', num2str(comId)];
        entryRead = mxDatabase('mammo_cpmc', SQLstatement);
        entryOut(i, :) = [entryIn(i, :), entryRead([kVpCol, kStartCol:end])];
    end
end


%%
function writeCalibTable(calibTable, entryWrite)
%when writing entries to table, make sure there is only one calibration on
%each date

if ~isempty(entryWrite)     %no action if entryWrite is empty
    numEntry = size(entryWrite, 1);
    machIdCol = 1;
    acqIdCol = 2;
    dateCol = 4;
    padCol = 5;

    %get column names and number of columns of the table
    [a, colNames] = mxDatabase('mammo_cpmc', ...
                    ['SELECT * FROM ', calibTable], 1); 
    numCols = size(colNames, 2);

    for i = 1:numEntry
        %check duplicate entry by machine id, acquisition date and paddle size
        %This ensures only one set of calibration parameters in one day
        %also check by acquisition_id
        machId = entryWrite{i, machIdCol};
        dateVal = strtrim(entryWrite{i, dateCol});
        padVal = strtrim(entryWrite{i, padCol});
        acqId = entryWrite{i, acqIdCol};
    %     if ~ischar(checkVal)
    %         checkStr = num2str(checkVal);
    %     else
    %         checkStr = ['''', checkVal, ''''];
    %     end

        %check existance of dateVal and padVal in current table
        %or the acquisition_id is already existing
        SQLstatement = ['SELECT acquisition_id ', ...
                        'FROM ', calibTable, ' ', ...
                        'WHERE machine_id = ', num2str(machId), ' ', ...
                        'AND date_acquisition = ''', dateVal, ''' ', ...
                        'AND paddle_size = ''', padVal, ''' ', ...
                        'OR acquisition_id = ', num2str(acqId)];
        entryRead = mxDatabase('mammo_cpmc', SQLstatement);
        uniqueAcqId = unique(cell2mat(entryRead));
        
        %delete the entry if found
        if ~isempty(entryRead)
            for j = 1:length(uniqueAcqId)
%                 SQLstatement = ['DELETE FROM ', calibTable, ' ', ...
%                                 'WHERE machine_id = ', num2str(machId), ' ', ...
%                                 'AND date_acquisition = ''', dateVal, ''' ', ...
%                                 'AND paddle_size = ''', padVal, ''''];
                SQLstatement = ['DELETE FROM ', calibTable, ' ', ...
                                'WHERE acquisition_id = ', num2str(uniqueAcqId(j))];
                mxDatabase('mammo_cpmc', SQLstatement);
            end
        end

        %form the list of values to write
        numVal = min(numCols, size(entryWrite, 2));
        values = ['''', num2str(entryWrite{i, 1}), ''''];
        for j = 2:numVal
            values = [values, ', ''', num2str(entryWrite{i, j}),''''];
        end

        %add some empty fields if entryWrite is shorter than table fields
        while numVal < numCols
            values = [values, ', '''''];
            numVal = numVal + 1;
        end

        %Write the entry
        SQLstatement = ['INSERT INTO ', calibTable, ' ', ...
                        'VALUES(', values, ')'];
        mxDatabase('mammo_cpmc', SQLstatement);
    end
end

