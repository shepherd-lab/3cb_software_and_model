function machineParams = getMachineParams(ImageInfo, Database, AnalysisInfo)

%This function returns the most appropriate machine parameters based on the
%image acquisition date
%acqDate (in the form of yyyymmdd, double)and machine_id needed from ImageInfo
%Database provides the name of database to query

machineID = ImageInfo.centerlistactivated;
acqDate = ImageInfo.acqDate;

SQLstatement = ['SELECT commonanalysis_id, date_acquisition, ', ...
                'validity_flag, paddle_size ', ...
                'FROM MachineParametersByDate ', ...
                'WHERE date_acquisition <= ', num2str(acqDate), ' ', ...
                'AND machine_id = ', num2str(machineID)];
entryRead = mxDatabase(Database.Name, SQLstatement);

numMat = zeros(size(entryRead, 1), 3);
numMat(:, 2) = str2num(cell2mat(entryRead(:, 2)));
numMat(:, [1 3]) = cell2mat(entryRead(:, [1 3]));
padSizeCell = strtrim(entryRead(:, 4));

%count # of small paddles
numTotal = size(numMat, 1);
padSizeBin = ones(numTotal, 1); %binary form of paddle size: 0 - Small, 1 - Large
numSmall = 0;
for i = 1:numTotal
    if strcmpi(padSizeCell{i}, 'Small')
        padSizeBin(i) = 0;
        numSmall = numSmall + 1;
    end
end
numLarge = numTotal - numSmall;

%divide small and large paddles into two matrices
dataSm = zeros(numSmall, 3);
idxSm = 0;
dataBg = zeros(numLarge, 3);
idxBg = 0;
for i = 1:numTotal
    if padSizeBin(i) == 0
        idxSm = idxSm + 1;
        dataSm(idxSm, :) = numMat(i, :);
    else
        idxBg = idxBg + 1;
        dataBg(idxBg, :) = numMat(i, :);
    end
end

%Sort the entries by date, then by validity flag, then by
%commonanalysis_id, decending
sortedSm = sortrows(dataSm, [-2, -3, -1]);
sortedBg = sortrows(dataBg, [-2, -3, -1]);

%determine the most recent comId and the most recent valid comId
[comIdMRSm, comIdValidSm] = getMostRecComId(sortedSm);
[comIdMRBg, comIdValidBg] = getMostRecComId(sortedBg);

%read machine parameters based on the comId's for both small and large
machineParamsSm = readMachParamByDate(comIdMRSm, comIdValidSm, Database, AnalysisInfo);
machineParamsBg = readMachParamByDate(comIdMRBg, comIdValidBg, Database, AnalysisInfo);

%combine small and large machine parameters
machineParams = combineParams(machineParamsSm, machineParamsBg);

%%
function [comIdMR, comIdValid] = getMostRecComId(sortedAry)

comIdMR = sortedAry(1, 1);
valIdx = find(sortedAry(:, 3), 1);  %find the first validity flag == 1
comIdValid = sortedAry(valIdx, 1);

%%
function params = readMachParamByDate(comIdMR, comIdValid, Database, AnalysisInfo)

if comIdMR == comIdValid
    SQLstatement = ['SELECT x0cm_diff, y0cm_diff, source_height, ', ...
                    'dark_counts, thickness_corr, rx_corr, ry_corr ', ...
                    'FROM MachineParametersByDate ' ...
                    'WHERE commonanalysis_id = ', num2str(comIdMR)];
    entryRead = mxDatabase(Database.Name, SQLstatement);
    params.x0_shift = entryRead{1}/AnalysisInfo.Filmresolution*10;
    params.y0_shift = entryRead{2}/AnalysisInfo.Filmresolution*10;
    params.source_height = entryRead{3};
    params.dark_counts = entryRead{4};
    params.thickness_corr = entryRead{5};
    params.rx_corr = entryRead{6};
    params.ry_corr = entryRead{7};
else
    SQLstatement = ['SELECT x0cm_diff, y0cm_diff, source_height, dark_counts ', ...
                    'FROM MachineParametersByDate ', ...
                    'WHERE commonanalysis_id = ', num2str(comIdMR)];
    entryRead = mxDatabase(Database.Name, SQLstatement);
    params.x0_shift = entryRead{1}/AnalysisInfo.Filmresolution*10;
    params.y0_shift = entryRead{2}/AnalysisInfo.Filmresolution*10;
    params.source_height = entryRead{3};
    params.dark_counts = entryRead{4};
    
    SQLstatement = ['SELECT thickness_corr, rx_corr, ry_corr ', ...
                    'FROM MachineParametersByDate ', ...
                    'WHERE commonanalysis_id = ', num2str(comIdValid)];
    entryRead = mxDatabase(Database.Name, SQLstatement);
    params.thickness_corr = entryRead{1};
    params.rx_corr = entryRead{2};
    params.ry_corr = entryRead{3};
end

%%
function params = combineParams(paramsSm, paramsBg)

params.x0_shift = (paramsSm.x0_shift + paramsBg.x0_shift)/2;
params.y0_shift = (paramsSm.y0_shift + paramsBg.y0_shift)/2;
params.source_height = (paramsSm.source_height + paramsBg.source_height)/2;
params.dark_counts = paramsSm.dark_counts;
params.thicknessSmall_corr = paramsSm.thickness_corr;
params.rxSmall_corr = paramsSm.rx_corr;
params.rySmall_corr = paramsSm.ry_corr;
params.thicknessBig_corr = paramsBg.thickness_corr;
params.rxBig_corr = paramsBg.rx_corr;
params.ryBig_corr = paramsBg.ry_corr;
params.linear_coef = 1;
