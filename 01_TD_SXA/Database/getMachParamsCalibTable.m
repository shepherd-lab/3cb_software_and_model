function params = getMachParamsCalibTable(info, database, analysisInfo)

acqID = info.AcquisitionKey;
machineID = info.centerlistactivated;
acqDate = info.acqDate;
dbName = database.Name;
filmRes = analysisInfo.Filmresolution/10;   %cm/pixel

SQLstatement = ['SELECT Columns FROM DICOMinfo ', ...
                'WHERE DICOM_ID = ', ...
                    '(SELECT DICOM_ID FROM acquisition ', ...
                    'WHERE acquisition_id = ', num2str(acqID), ')'];
entryRead = mxDatabase(dbName, SQLstatement);
imageCol = entryRead{1};
if imageCol < 2700  %small paddle
    padSize = 'Small';
else
    padSize = 'Large';
end

SQLstatement = ['SELECT x0cm_diff, y0cm_diff, source_height, dark_counts, ', ...
                'thickness_corr, rx_corr, ry_corr, commonanalysis_id ', ...
                'FROM CalibrationTableC5 ', ...
                'WHERE paddle_size = ''', padSize, ''' ', ...
                'AND machine_id = ', num2str(machineID), ' ', ...
                    'AND date_acquisition = ', ...
                    '(SELECT MAX(date_acquisition) ', ...
                    'FROM CalibrationTableC5 ', ...
                    'WHERE date_acquisition <= ', num2str(acqDate), ' ', ...
                    'AND machine_id = ', num2str(machineID), ' ', ...
                    'AND paddle_size = ''', padSize, ''')'];
entryRead = mxDatabase(dbName, SQLstatement);

if ~isempty(entryRead)
    params.x0_shift = entryRead{1, 1}/filmRes;
    params.y0_shift = entryRead{1, 2}/filmRes;
    params.source_height = entryRead{1, 3};
    params.dark_counts = entryRead{1, 4};
    params.bucky_distance = entryRead{1, 5};
    params.rx_correction = entryRead{1, 6};
    params.ry_correction = entryRead{1, 7};
    params.linear_coef = 1;
    params.comId = entryRead{1, 8};
else
    error('No appropriate machine parameters were found!')
end