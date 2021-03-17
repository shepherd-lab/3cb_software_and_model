function [machParams, phanAtnu, SXAatnu, flag] = readPhantomResults(acqID)
%This function analyzes calibration and SXA phantom images and returns
%machine parameters.
%'machParams' contains all machine parameters
%machParams{1} = commonanalysis_id     machParams{2} = machine_id
%machParams{3} = date_acquisition      machParams{4} = paddle_size
%machParams{5} = x0cm_diff             machParams{6} = y0cm_diff
%machParams{7} = source_height         machParams{8} = bucky_distance
%machParams{9} = dark_counts           machParams{10} = thickness_corr
%machParams{11} = rx_corr              machParams{12} = ry_corr
%machParams{13} = validity_flag
%phanAtnu and SXAatnu contain the intensities of the GEN3 and SXA phantoms
%respectively
%'flag' indicates if analysis result is available

analysisVersion = 'Version6.6';
meanThick = [60.25, 59.5];  %in the order of [small paddle, large paddle]
stdThick = [0.5, 0.577];
meanForce = [81.2, 110.1];
stdForce = [2.23, 2.2];
padlThickness = 0.23;   %cm
%GEN3 phantom dimension data (from Song_note_I_page 7 to 10)
delta = 1;     %lower BB to bottom, unit: cm
dh = 4;        %vertical separation of each pair of BB's
w = 14.5618;    %distance btw outside surfaces of GEN3 phantom walls
bbCorr = 0.04953;    %BB_center to wall surface

%initialization
numBb = 14;
bbImgWld = zeros(numBb, 2);       %each row is (x, y) of a BB
phanAtnu = zeros(3, 3);      %row_index = height, col_index = density
SXAatnu = zeros(1, 9);

%retrieve the commonanalysis_id of the latest commonanalysis, where
%version == analysisVersion
SQLstatement = ['SELECT commonanalysis_id, ROI_xmin, ROI_ymin ', ...
                'FROM commonanalysis ', ...
                'WHERE commonanalysis_id = ', ...
                      '(SELECT MAX(commonanalysis_id) ', ...
                      'FROM commonanalysis ', ...
                      'WHERE version = ''', analysisVersion, ''' ', ...
                      'AND acquisition_id = ', num2str(acqID), ')'];
entryRead = mxDatabase('mammo_cpmc', SQLstatement);
if ~isempty(entryRead)
    comAnaID = entryRead{1};
    ROIx0 = entryRead{2};   %record the position of ROI region w.r.t.
    ROIy0 = entryRead{3};   %the film corner and will be used for thickCorr
    flag = 1;
else
    flag = 0;
end

%if analysis result exists, read and return
if flag == 1
    %read machine_id, date_acquisition from 'acquisition'
    %read resolution for the calculation of thickCorr
    SQLstatement = ['select machine_id, date_acquisition, resolution ',...
                    'from acquisition ',...
                    'where acquisition_id = ', num2str(acqID)];
	entryRead = mxDatabase('mammo_cpmc', SQLstatement);
    
    machineID = entryRead{1};
    dateAcq = strtrim(entryRead{2});
    pxToCm = entryRead{3}/10000;    %will be used for thickCorr
    
    %read the new world origin from 'QCWAXAanlysis'
    SQLstatement = ['SELECT QCWAXAnalysis_id, QCx0cm_diff, QCy0cm_diff ', ...
                    'FROM QCWAXAnalysis ', ...
                    'WHERE commonanalysis_id = ', num2str(comAnaID)];
	entryRead = mxDatabase('mammo_cpmc', SQLstatement);
    QCWAXAnaID = entryRead{1};
    QCx0 = entryRead{2};
    QCy0 = entryRead{3};
    
    
    %determine if image is valid by checking thickness and force
    %read thickness and force from 'acquisition'
    SQLstatement = ['SELECT Thickness, Force ', ...
                    'FROM acquisition ', ...
                    'WHERE acquisition_id = ', num2str(acqID)];
	entryRead = mxDatabase('mammo_cpmc', SQLstatement);
    thickness = entryRead{1};
    force = entryRead{2};
    %retrieve the paddle size
    SQLstatement = ['select Rows, Columns ', ...
                    'from DICOMinfo ',...
                    'where DICOM_ID = ', ...
                    '(SELECT DICOM_ID ', ...
                    'FROM acquisition ', ...
                    'WHERE acquisition_id = ', num2str(acqID), ')'];
    entryRead = mxDatabase('mammo_cpmc', SQLstatement);
    imgRows = entryRead{1};     %imgRows will be used for thickCorr
    imgCols = entryRead{2};
    if imgCols < 3000
        paddleSize = 1;
    else
        paddleSize = 2;
    end
    %check image validity
    if (thickness > meanThick(paddleSize) + 3*stdThick(paddleSize) || ...
        thickness < meanThick(paddleSize) - 3*stdThick(paddleSize) || ...
        force > meanForce(paddleSize) + 3*stdForce(paddleSize) || ...
        force < meanForce(paddleSize) - 3*stdForce(paddleSize))
        isImgValid = 0;
    else
        isImgValid = 1;
    end
    
    %read source_height, bucky_distance, dark_counts from
    %'MachineParameters', recalculate soure_height and bucky_distance
    SQLstatement = ['SELECT source_height, bucky_distance, dark_counts ', ...
                    'FROM MachineParameters ', ...
                    'WHERE machine_id = ', num2str(machineID)];
	entryRead = mxDatabase('mammo_cpmc', SQLstatement);
    sourceHeight = entryRead{1};    %initial value of source height in iteration
    buckyDistance = entryRead{2};   %initial value of bucky distance
    darkCounts = entryRead{3};
    %calculate BB positions in the world coordinate system (in cm)
    bbImgWld = getBbImgPos(acqID, comAnaID, pxToCm, imgRows, ROIx0, ROIy0, QCx0, QCy0);
    %get the BB positions in GEN3 phantom
    bbInPh = getBbPhPos('CPMC', numBb);
    %sourceHeight and buckyDistance are calculated by fitting
    [sourceHeight, buckyDistance] = findParams(sourceHeight, buckyDistance, bbInPh, bbImgWld);
    
    %for valid images, calculate thickCorr, rxCorr, ryCorr
    if isImgValid
        %thickCorr
        thickCorr = buckyDistance + padlThickness;
      
        %rxCorr & ryCorr
        SQLstatement = ['SELECT angle_rx, angle_ry ', ...
                        'FROM QCwaxSXAPhantomInfo ', ...
                        'WHERE QCWAXAnalysis_id = ', num2str(QCWAXAnaID)];
        entryRead = mxDatabase('mammo_cpmc', SQLstatement);
        rxCorr = entryRead{1};
        ryCorr = entryRead{2} - 5;
    end
    
    %return the machParams
    machParams{1} = comAnaID;
    machParams{2} = machineID;
    machParams{3} = dateAcq;
    paddleSizeTxt{1} = 'Small';
    paddleSizeTxt{2} = 'Large';
    machParams{4} = paddleSizeTxt{paddleSize};
    machParams{5} = QCx0;
    machParams{6} = QCy0;
    machParams{7} = sourceHeight;
    machParams{8} = buckyDistance;
    machParams{9} = darkCounts;
    if isImgValid
        machParams{10} = thickCorr;
        machParams{11} = rxCorr;
        machParams{12} = ryCorr;
    end
    machParams{13} = isImgValid;
    
    %read the phantom intensity data
    SQLstatement = ['SELECT ROI_WAXvalue9, ROI_WAXvalue6, ROI_WAXvalue3, ', ...
                           'ROI_WAXvalue8, ROI_WAXvalue5, ROI_WAXvalue2, ', ...
                           'ROI_WAXvalue7, ROI_WAXvalue4, ROI_WAXvalue1 ', ...
                    'FROM QCwaxSXAPhantomInfo ', ...
                    'WHERE QCWAXAnalysis_id = ', num2str(QCWAXAnaID)];
    entryRead = mxDatabase('mammo_cpmc', SQLstatement);
    for i = 1:3
        for j = 1:3
            phanAtnu(i, j) = entryRead{3*(i-1)+j};
        end
    end
    
    %read the SXA intensity data
    SQLstatement = ['SELECT '];
    for i = 1:8
        SQLstatement = [SQLstatement, 'ROI_value', num2str(i), ', '];
    end
    SQLstatement = [SQLstatement, 'ROI_value', num2str(i+1), ' ', ...
                   'FROM QCwaxSXAPhantomInfo ', ...
                   'WHERE QCWAXAnalysis_id = ', num2str(QCWAXAnaID)];
	entryRead = mxDatabase('mammo_cpmc', SQLstatement);
    for i = 1:9
        SXAatnu(1, i) = entryRead{i};
    end
    
else    %no commonanalysis_id found
    machParams = cell(1);

end