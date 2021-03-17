function readQCWaxDensity

[fileName, pathName] = uigetfile('*.txt', 'Select the acquisition list file');
analysisVersion = 'Version6.6';
padSize = {'Small', 'Large'};

if fileName ~= 0
    fullFileName = [pathName, fileName];
    acqList = textread(fullFileName, '%u');
    numAcq = length(acqList);
    results = cell(numAcq, 12);
    
    orderedIdx = [11 8 5 10 7 4 9 6 3];
    
    for i = 1:numAcq
        acqID = acqList(i);
        SQLstatement = ['SELECT commonanalysis_id ', ...
                        'FROM commonanalysis ', ...
                        'WHERE commonanalysis_id = ', ...
                              '(SELECT MAX(commonanalysis_id) ', ...
                              'FROM commonanalysis ', ...
                              'WHERE version = ''', analysisVersion, ''' ', ...
                              'AND acquisition_id = ', num2str(acqID), ')'];
        entryRead = mxDatabase('mammo_cpmc', SQLstatement);
        
        if ~isempty(entryRead)
            comAnaID = entryRead{1};
            SQLstatement = ['SELECT date_acquisition ', ...
                            'FROM acquisition ', ...
                            'WHERE acquisition_id = ', num2str(acqID)];
            entryRead = mxDatabase('mammo_cpmc', SQLstatement);
            acqDate = str2num(strtrim(entryRead{1}));
            
            %retrieve the paddle size
            SQLstatement = ['select Columns ', ...
                            'from DICOMinfo ',...
                            'where DICOM_ID = ', ...
                            '(SELECT DICOM_ID ', ...
                            'FROM acquisition ', ...
                            'WHERE acquisition_id = ', num2str(acqID), ')'];
            entryRead = mxDatabase('mammo_cpmc', SQLstatement);
            imgCols = entryRead{1};
            if imgCols < 3000
                paddle = 1;
            else
                paddle = 2;
            end

            SQLstatement = ['SELECT * ', ...
                            'FROM QCWAXAnalysis ', ...
                            'WHERE commonanalysis_id = ', num2str(comAnaID)];
            entryRead = mxDatabase('mammo_cpmc', SQLstatement);
            results{i, 1} = acqID;
            results{i, 2} = acqDate;
            results{i, 3} = padSize{paddle};
            if ~isempty(entryRead)
                for j = 1:9
                    cellIdx = orderedIdx(j);
                    results{i, j+3} = entryRead{cellIdx};
                end
            end
        end
    end
end
results;