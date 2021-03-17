function [densityRoiResults, densityRoiResultsCorr] = roi_QCWAX()
    
global ROI Analysis Info Image figuretodraw QCAnalysisData phleanref_vect Error

Error.SXAroiFitFailure = false;
Error.SXAroiFitWarning = false;

SXARoi = zeros(9, 2);     %the nine regions of SXA phantom
SXARoi(:, 1) = [1.2, 1.9, 2.6, 3.3, 4, 4.7, 5.4, 6.1, 6.8];   %thickness
indexOrder = [1, 7, 4, 2, 8, 5, 3, 9, 6];
SXARoi(:, 2) = Analysis.roi_values(indexOrder); %attenuation value

Gen3Roi = zeros(9, 3);    %the nine regions of Gen3 phantom
Gen3Roi(:, 1) = [6, 4, 2, 6, 4, 2, 6, 4, 2];      %thickness
Gen3Roi(:, 2) = [100, 100, 100, 50, 50, 50, 0, 0, 0];     %density

% flag.SXAphantomDisplay = false;
% tz = Analysis.params(4); 

if Info.DigitizerId == 3
    k = 1;
    m = 24;
elseif Info.DigitizerId == 4
    k = 150/140 ;
    m = 48;
elseif Info.DigitizerId == 5 || Info.DigitizerId == 6 || Info.DigitizerId == 7
    k = 150 / 200;
    m = 48 * 150 / 200;
end

% Commented out by Song, 08-04-10, because the rx and ry corrections are
% not always available due to the validity check of images
% So sign empty to all the global var to guarantee SaveInDatabase
% Analysis.midpoint = round(ROI.rows/2);
% if Info.DigitizerId > 3
%     if flag.small_paddle ==  true  %small paddle
%         X_angle = Analysis.rx - MachineParams.rx_correction;
%         Y_angle = Analysis.ry - MachineParams.ry_correction;
%     else
%      X_angle = Analysis.rx- MachineParams.rx_correction;
%      Y_angle = Analysis.ry - MachineParams.ry_correction;
%     end
%     thickness_ROI = thickness_ROIcreation(X_angle,Y_angle);
% else
%     X_angle = 0;
%     Y_angle = Analysis.AngleHoriz;
%     thickness_ROI = thickness_ROIcreation_film(X_angle,Y_angle);
% end
%         
% Analysis.thicknessDSP7 = tz -  MachineParams.bucky_distance;
% 
% if (~isnan(Analysis.y_1) | ~isnan(Analysis.x_1)) 
%     Analysis.thicknessWax1 = thickness_ROI(Analysis.y_1,Analysis.x_1); 
% else
%     Analysis.thicknessWax1 = [];
% end
% if (~isnan(Analysis.y_2) | ~isnan(Analysis.x_2)) 
%     Analysis.thicknessWax2 = thickness_ROI(Analysis.y_2,Analysis.x_2); 
% else
%     Analysis.thicknessWax2 = [];
% end
% if (~isnan(Analysis.y_3) | ~isnan(Analysis.x_3)) 
%     Analysis.thicknessWax3 = thickness_ROI(Analysis.y_3,Analysis.x_3); 
% else
%     Analysis.thicknessWax3 = [];
% end
% if (~isnan(Analysis.y_4) | ~isnan(Analysis.x_4)) 
%     Analysis.thicknessWax4 = thickness_ROI(Analysis.y_4,Analysis.x_4);
% else
%     Analysis.thicknessWax4 = [];
% end
% if (~isnan(Analysis.y_5) | ~isnan(Analysis.x_5)) 
%     Analysis.thicknessWax5 = thickness_ROI(Analysis.y_5,Analysis.x_5); 
% else
%     Analysis.thicknessWax5 = [];
% end
% if (~isnan(Analysis.y_6) | ~isnan(Analysis.x_6)) 
%     Analysis.thicknessWax6 = thickness_ROI(Analysis.y_6,Analysis.x_6); 
% else
%     Analysis.thicknessWax6 = [];
% end
Analysis.thicknessDSP7 = [];
Analysis.thicknessWax1 = [];
Analysis.thicknessWax2 = [];
Analysis.thicknessWax3 = [];
Analysis.thicknessWax4 = [];
Analysis.thicknessWax5 = [];
Analysis.thicknessWax6 = [];


xmax = round(Analysis.xmax);
ymax = round(Analysis.ymax);  
xmin = max(round(Analysis.xmin), 1);    %modified by Song 07-13-2010
ymin = round(Analysis.ymin);

ROI.xmin = round(xmin);
ROI.xmax = round(xmax);
ROI.ymin = round(ymin);
ROI.ymax = round(ymax);
if ROI.ymin < 0 %JW ROI.ymin in some cases negative
    ROI.ymin = 1;
end
ROI.rows = ymax - ymin + 1;
ROI.columns = xmax - xmin + 1;
ROI.image = Image.image(ROI.ymin:ROI.ymax, ROI.xmin:ROI.xmax);
Analysis.midpoint = round(ROI.rows/2);
QCAnalysisData.Draw.MainBox = [210, 1250] * k;
QCAnalysisData.Draw.Compartments = 9;
QCAnalysisData.Draw.BorderY = 75 * k;
QCAnalysisData.Draw.BorderX = 75 * k;

x1 = xmin + 230;
x2 = x1 + QCAnalysisData.Draw.MainBox(1);
y1 = ymin + m;
y2 = y1 + QCAnalysisData.Draw.MainBox(2);
QCAnalysisData.MainBox = plot(0,0,'g','linewidth',2);
for i = 1:9
    QCAnalysisData.Box(i) = plot(0,0,'g','linewidth',2);
end
figure(figuretodraw);
funcBox(ROI.xmin,ROI.ymin,ROI.xmin+ROI.columns,ROI.ymin+ROI.rows,'b',3); hold on;

% roi(9) = struct('xmin', {}, 'xmax', {}, 'ymin', {}, 'ymax', {}, 'rows', {}, ...
%           'columns', {}, 'density', {});

for i = 1:QCAnalysisData.Draw.Compartments
    j = i;
    l = 0;
    if ( j > 3 && j <= 6 )
        j = i - 3;
        l = 1;
    elseif j > 6
        j = i - 6;
        l = 2;
    end
    X1 = xmin + (ROI.columns/3)*(j-1) + QCAnalysisData.Draw.BorderX;
    X2 = xmin + (ROI.columns/3)*(j-1) + QCAnalysisData.Draw.BorderX + ...
        (ROI.columns-(QCAnalysisData.Draw.BorderX*6))/3;
    if i <= 4
        Y1 = ymin + (ROI.rows/3)*(l) + QCAnalysisData.Draw.BorderY;
        Y2 = ymin + (ROI.rows/3)*(l) + QCAnalysisData.Draw.BorderY + ...
            (ROI.rows-(QCAnalysisData.Draw.BorderY*6))/3;
    elseif i <= 7
        Y1 = ymin + (ROI.rows/3)*(l) + QCAnalysisData.Draw.BorderY;
        Y2 = ymin + (ROI.rows/3)*(l) + QCAnalysisData.Draw.BorderY + ...
            (ROI.rows-(QCAnalysisData.Draw.BorderY*6))/3;
    elseif i <= 9
        Y1 = ymin + (ROI.rows/3)*(l) + QCAnalysisData.Draw.BorderY;
        Y2 = ymin + (ROI.rows/3)*(l) + QCAnalysisData.Draw.BorderY + ...
            (ROI.rows-(QCAnalysisData.Draw.BorderY*6))/3;
    end

    %shiftX added by Song, 03/03/11
    %to make the compartments more centered in each step
    shiftX = 15;
    roi.xmin = floor(X1 + shiftX);
    roi.xmax = floor(X2 + shiftX);
    roi.ymin = floor(Y1);
    roi.ymax = floor(Y2);
    roi.rows = roi.ymax - roi.ymin + 1;
    roi.columns = roi.xmax - roi.xmin + 1;

    %draw a rectangle
    set(QCAnalysisData.Box(i),'xdata',[roi.xmin,roi.xmax,roi.xmax,roi.xmin,roi.xmin], ...
        'ydata',[roi.ymin,roi.ymin,roi.ymax,roi.ymax,roi.ymin]);
    hold on;
    
    Gen3Roi(i, 3) = mean(mean(Image.image(roi.ymin:roi.ymax, roi.xmin:roi.xmax)));
    Analysis.Step = 8;
%     if Info.DigitizerId >= 4
%         Analysis = Z4ComputeWAXPhantomDensity(roi,Image,Analysis,i);
%     else    
%         Analysis = funcComputePhantomDensity(roi,Image,Analysis);
%     end
%     DensityResults(1,i)=Analysis.DensityPercentage';
%     DensityResults(2,i)=mean(mean(Image.image(roi.ymin:roi.ymax,roi.xmin:roi.xmax)));
end

% %DSP scale based calculation
% %calculate kLean, km
% kTableDSP = calckValueDSP(SXARoi, Gen3Roi);
% Analysis.kTable = kTableDSP;
% %kTableDSP = Z4coef_tableSmall;
% %compute phantom density
% densityRoiResults = computeWAXPhanDensDSP(Gen3Roi, SXARoi, kTableDSP);

%WAX-water scale based calculation
[kTableWAX, SXAroiFit, SXAroiChiSqr, SXAroiUsed] = calckValueWAX(SXARoi, Gen3Roi);
if isnan(SXAroiFit)
    Error.DENSITY = true;
    Error.SXAroiFitFailure = true;
    error('No best-fit line was found on SXA ROI values!');
else
    if ( SXAroiUsed(end) - SXAroiUsed(1) < 5 )  %less than or equal to 5 roi used
        Error.SXAroiFitWarning = true;
    end

    densityRoiResults = computeWAXPhanDensWAX(Gen3Roi, SXAroiFit, kTableWAX);
    densCorrTable = calcDensCorr(densityRoiResults);
    densityRoiResultsCorr = correctWAXPhanDens(densityRoiResults, densCorrTable);

    %fit density correction surface
    %Model: z = p(1) + p(2)*y +p(3)*y^2 + p(4)*x*y + p(5)*x*y^2
    %where x = thickness, y = calculated density, z = true density
    [densFitParam, densFitAnalysis] = fitDensSurf(densCorrTable);

    Analysis.kTable = kTableWAX;
    Analysis.SXAroiFit = SXAroiFit;
    Analysis.SXAroiChiSqr = SXAroiChiSqr;
    Analysis.SXAroiUsed = SXAroiUsed;
    Analysis.densCorrTable = densCorrTable;
    Analysis.roi_DSP7values = densityRoiResults(2,:);   %this shouldn't be called DSP7 any more
                                                        %following this convention to
                                                        %guarantee SaveInDatabase
    Analysis.densFitParam = densFitParam;
    Analysis.densFitAnalysis = densFitAnalysis;

    phleanref_vect = SXARoi(:, 2);  %this is global, will be saved to 'QCwaxSAXPhanomInfo'

    % %New method of deriving Gen3 Phantom density
    % [kTableWAX, Gen3CoefOnH] = calcNewCoef(SXARoi, Gen3Roi);
    % %Analysis.newCoefTable = newCoefTable;
    % densityRoiResults = computeWAXPhanDensNew(Gen3Roi, SXARoi, kTableWAX, Gen3CoefOnH);
end


%% calculating k values on the DSP7 reference (obsolete)
% function kValueDSP = calckValueDSP(SXARoi, Gen3Roi)
% global refDSPtoWAX
% 
% sortedGen3Roi = sortrows(Gen3Roi, [1, 2]);
% SXAthick = SXARoi(:, 1);
% SXAatnu = SXARoi(:, 2);
% kValueDSP = zeros(3, 3);    %1st ~ 3rd col: h, kLean, km
% 
% SXAcoef = polyfit(SXAthick, SXAatnu, 2);
% for iterH = 1:3 %for each height of GEN3 phantom
%     H = sortedGen3Roi(iterH*3, 1);
%     dens = sortedGen3Roi(iterH*3-2:iterH*3, 2);
%     Gen3Atnu = sortedGen3Roi(iterH*3-2:iterH*3, 3);
%     Gen3Coef = polyfit(dens, Gen3Atnu, 2);
%     VD0 = Gen3Coef(1)*refDSPtoWAX^2 + Gen3Coef(2)*refDSPtoWAX + ...
%           Gen3Coef(3);
%     VD80 = Gen3Coef(1)*80^2 + Gen3Coef(2)*80 + Gen3Coef(3);
%     V80 = SXAcoef(1)*H^2 + SXAcoef(2)*H + SXAcoef(3);
%     kLean = VD80/V80;
%     m80 = kLean*(SXAcoef(1)*H + SXAcoef(2));
%     km = m80*H/(m80*H - VD80 + VD0);
%     
%     kValueDSP(iterH, :) = [H, kLean, km];
% end

%% calculating k valus on the WAX-water reference
function [kValueWAX, SXAcoef, SXAchiSqr, roiUsed] = calckValueWAX(SXARoi, Gen3Roi)

%thkSortedGen3Roi = sortrows(Gen3Roi, [1, 2]);
denSortedGen3Roi = sortrows(Gen3Roi, [2, 1]);
SXAthick = SXARoi(:, 1);
SXAatnu = SXARoi(:, 2);

thickForK = [0.6; SXAthick; 7.5; 8.0; 8.5; 9.0; 9.5; 10.0];
numH = length(thickForK);
kValueWAX = zeros(numH, 3);    %1st ~ 3rd col: h, kLean, km

Gen3CoefOnH = zeros(3, 3);  %row: density 0, 50, 100
                            %column: a, b, c in a*x^2+b*x+c
for i = 1:3 %For each density, fit for VD vs. H
    stepThick = denSortedGen3Roi(3*i-2:3*i, 1);
    Gen3Atnu = denSortedGen3Roi(3*i-2:3*i, 3);
    Gen3CoefOnH(i, :) = polyfit(stepThick, Gen3Atnu, 2);    
end

[SXAcoef, SXAchiSqr, roiUsed] = SXAroiBestFit(SXAthick, SXAatnu);

if ( ~isnan(SXAcoef) )
    dens = [0; 50; 100];
    Gen3AtnuAtH = zeros(3, 1);
    for iterH = 1:numH %for each thickness of SXA phantom
        H = thickForK(iterH, 1);
        for i = 1:3 %three densities
            Gen3AtnuAtH(i) = Gen3CoefOnH(i, 1)*H^2 + Gen3CoefOnH(i, 2)*H + Gen3CoefOnH(i, 3);
        end
        %get VD0 and VD80
        Gen3CoefOnDens = polyfit(dens, Gen3AtnuAtH, 1);
        VD0 = Gen3CoefOnDens(2);
        VD80 = Gen3CoefOnDens(1)*80 + Gen3CoefOnDens(2);
        %get V80 at H
        V80 = SXAcoef(1)*H^2 + SXAcoef(2)*H + SXAcoef(3);

        kLean = VD80/V80;
        m80 = kLean*(SXAcoef(1)*H + SXAcoef(2));
        km = m80*H/(m80*H - VD80 + VD0);

        kValueWAX(iterH, :) = [H, kLean, km];
    end
end

%% New method of calculating coef on WAX-water reference (obsolete)
% function [kValueWAX, Gen3CoefOnH] = calcNewCoef(SXARoi, Gen3Roi)
% 
% % thkSortedGen3Roi = sortrows(Gen3Roi, [1, 2]);
% denSortedGen3Roi = sortrows(Gen3Roi, [2, 1]);
% SXAthick = SXARoi(:, 1);
% SXAatnu = SXARoi(:, 2);
% numH = length(SXAthick);
% kValueWAX = zeros(numH, 2);    %1st col: h, 2nd col: kLean, 3rd: km
% 
% %quadratic fit Gen3 vs. H at each density
% Gen3CoefOnH = zeros(3, 3);  %row: density 0, 50, 100
%                             %column: a, b, c in a*x^2+b*x+c
% for i = 1:3 %For each density, fit for VD vs. H
%     stepThick = denSortedGen3Roi(3*i-2:3*i, 1);
%     Gen3Atnu = denSortedGen3Roi(3*i-2:3*i, 3);
%     Gen3CoefOnH(i, :) = polyfit(stepThick, Gen3Atnu, 2);    
% end
% 
% %calculate kLean & km
% SXAcoef = polyfit(SXAthick, SXAatnu, 2);
% dens = [0; 50; 100];
% Gen3AtnuAtH = zeros(3, 1);
% for iterH = 1:numH %for each thickness of SXA phantom
%     H = SXAthick(iterH, 1);
%     for i = 1:3
%         Gen3AtnuAtH(i) = Gen3CoefOnH(i, 1)*H^2 + Gen3CoefOnH(i, 2)*H + Gen3CoefOnH(i, 3);
%     end
%     %get VD0 and VD80
%     Gen3CoefOnDens = polyfit(dens, Gen3AtnuAtH, 2);
%     VD0 = Gen3CoefOnDens(3);
%     VD80 = Gen3CoefOnDens(1)*80^2 + Gen3CoefOnDens(2)*80 + Gen3CoefOnDens(3);
%     %get V80 at H
%     V80 = SXAcoef(1)*H^2 + SXAcoef(2)*H + SXAcoef(3);
% 
%     kLean = VD80/V80;
%     m80 = kLean*(2*SXAcoef(1)*H + SXAcoef(2));
%     km = m80*H/(m80*H - VD80 + VD0);
% 
%     kValueWAX(iterH, :) = [H, kLean, km];
% end

%% (obsolete)
% function density = computeWAXPhanDensDSP(Gen3Roi, SXARoi, kTable)
% 
% density = zeros(2, 9);  %row 1: density%, row 2: attenuation
% 
% %generate lean & fat ref curves
% [leanCurCoef, fatCurCoef] = computeLeanFatCurve(SXARoi, kTable);
% 
% for i = 1:9
%     H = Gen3Roi(i, 1);
%     atnuVal = Gen3Roi(i, 3);
%     lean_H = leanCurCoef(1)*H^2 + leanCurCoef(2)*H + leanCurCoef(3);
%     fat_H = fatCurCoef(1)*H^2 + fatCurCoef(2)*H + fatCurCoef(3);
%     density(1, i) = interp1([fat_H lean_H], [0 80], atnuVal, 'linear', 'extrap');
%     density(2, i) = atnuVal;
% end

%%
function density = computeWAXPhanDensWAX(Gen3Roi, SXAroiFit, kTable)

density = zeros(2, 9);  %row 1: density%, row 2: attenuation

%generate lean & fat ref curves
[leanCurCoef, fatCurCoef] = computeLeanFatCurve(SXAroiFit, kTable);

for i = 1:9
    H = Gen3Roi(i, 1);
    atnuVal = Gen3Roi(i, 3);
    lean_H = leanCurCoef(1)*H^2 + leanCurCoef(2)*H + leanCurCoef(3);
    fat_H = fatCurCoef(1)*H^2 + fatCurCoef(2)*H + fatCurCoef(3);
    density(1, i) = interp1([fat_H lean_H], [0 80], atnuVal, 'linear', 'extrap');
    density(2, i) = atnuVal;
end

% %for debug
% sortedGen3Roi = sortrows(Gen3Roi, [1, 2]);
% dens = [0; 50; 100];
% density50 = zeros(1, 3);
% density80 = zeros(1, 3);
% density100 =zeros(1, 3);
% for i = 1:3
%     H = sortedGen3Roi(3*i, 1);
%     ydata = sortedGen3Roi(3*i-2:3*i, 3);
%     fitCoef = polyfit(dens, ydata, 1);
%     VD50 = fitCoef(1)*50 + fitCoef(2);
%     VD80 = fitCoef(1)*80 + fitCoef(2);
%     VD100 = fitCoef(1)*100 + fitCoef(2);
%     lean_H = leanCurCoef(1)*H^2 + leanCurCoef(2)*H + leanCurCoef(3);
%     fat_H = fatCurCoef(1)*H^2 + fatCurCoef(2)*H + fatCurCoef(3);
%     density50(i) = interp1([fat_H lean_H], [0 80], VD50, 'linear', 'extrap');
%     density80(i) = interp1([fat_H lean_H], [0 80], VD80, 'linear', 'extrap');
%     density100(i) = interp1([fat_H lean_H], [0 80], VD100, 'linear', 'extrap');
% end
% %end for debug
% density50;

%% New method of calculating Gen3 densities (obsolete)
% function density = computeWAXPhanDensNew(Gen3Roi, SXARoi, kLean, Gen3CoefOnH)
% 
% density = zeros(2, 9);  %row 1: density%, row 2: attenuation
% 
% %generate lean & fat ref curves
% [leanCurCoef, fatCurCoef] = computeLeanFatCurveNew(SXARoi, kLean, Gen3CoefOnH);
% 
% for i = 1:9
%     H = Gen3Roi(i, 1);
%     atnuVal = Gen3Roi(i, 3);
%     lean_H = leanCurCoef(1)*H^2 + leanCurCoef(2)*H + leanCurCoef(3);
%     fat_H = fatCurCoef(1)*H^2 + fatCurCoef(2)*H + fatCurCoef(3);
%     density(1, i) = interp1([fat_H lean_H], [0 80], atnuVal, 'linear', 'extrap');
%     density(2, i) = atnuVal;
% end

%%
function densCorrTable = calcDensCorr(densityRoiResults)

densCalced = zeros(3, 3);   %row: fixed thickness, density from 0 to 100
                            %col: fixed density, thickness from 2 to 6
orderedIdx = [9 6 3 8 5 2 7 4 1];
for i = 1:3
    for j = 1:3
        densCalced(i, j) = densityRoiResults(1, orderedIdx(3*(i-1)+j));
    end
end

densExpted = [0 50 100];

densCorrTable = zeros(2, 3, 3); %row 1: calculated density
                                %row 2: density correction
                                %pages: differences in thickness
                                %(Song Note 1, p.27)
for i = 1:3
    densCorrTable(1, :, i) = densCalced(i, :);
    densCorrTable(2, :, i) = densExpted - densCalced(i, :);
end

%%
function densityRoiResultsCorr = correctWAXPhanDens(densityRoiResults, densCorrTable)

numRoi = size(densityRoiResults, 2);
densityRoiResultsCorr = zeros(1, numRoi);
x = [2 2 2; 4 4 4; 6 6 6];
y = [densCorrTable(1, :, 1); densCorrTable(1, :, 2); densCorrTable(1, :, 3)];
z = [densCorrTable(2, :, 1); densCorrTable(2, :, 2); densCorrTable(2, :, 3)];

thickness = [6 4 2 6 4 2 6 4 2];
for i = 1:numRoi
    densityCorr = griddata(x, y, z, thickness(i), densityRoiResults(1, i));
    densityRoiResultsCorr(i) = densityRoiResults(1, i) + densityCorr;
end

%%
function [fitParam, fitAnalysis] = fitDensSurf(densCorrTable)

%convert densCorrTable to a 2D density matrix, i.e. [th den_calc den_true]
x = [2; 2; 2; 4; 4; 4; 6; 6; 6];
y = [densCorrTable(1, :, 1)'; densCorrTable(1, :, 2)'; densCorrTable(1, :, 3)'];
z = [0; 50; 100; 0; 50; 100; 0; 50; 100];
densMat = [x y z];

% % for Model 1
% params0_M1 = [1 -0.03 0.8 0.005 0.005 0.001];
% [params sumSqr] = mySurfFit(densMat, params0_M1);
    
% %for Model 2
% params0_M2 = [0.1 0.4 0.02 -0.05 0.0005 -0.0001];
% [params sumSqr] = mySurfFit(densMat, params0_M2);

%for Model 3
params0_M3 = [1 1 0.0005 -0.05 0.0005];
[params sumSqr] = mySurfFit(densMat, params0_M3);

%calculate fitting error
nData = size(densMat, 1);
nParams = length(params);
rootMSE = sqrt(sumSqr/(nData - nParams));
dataMean = mean(densMat(:, 3));
CV = rootMSE/dataMean*100;

SSerr = sumSqr;
SStot = sum((densMat(:, 3)-dataMean).^2);
rSquared = 1 - SSerr/SStot;

fitParam =  params;
fitAnalysis = [rootMSE, dataMean, CV, rSquared];

%     %for debug, plot the fitted surface
%     if i == 1
%         h = figure;
%     else
%         figure(h);
%     end
% %small range plot
% %     x = zeros(3, 3);
% %     y = zeros(3, 3);
% %     z = zeros(3, 3);
% %     for ii = 1:3
% %         for jj = 1:3
% %             x(ii, jj) = densMat(3*(ii-1)+jj, 1);
% %             y(ii, jj) = densMat(3*(ii-1)+jj, 2);
% %             z(ii, jj) = applyCorr(x(ii, jj), y(ii, jj), params);
% %         end
% %     end
% 
% %large range plot
%     [x, y] = meshgrid(0:0.5:6, -50:20:150);
%     z = applyCorr(x, y, params);

% mesh(x, y, z);
% hold on;
% scatter3(densMat(:, 1), densMat(:, 2), densMat(:, 3), '.', 'SizeData', 72^1.4);
% hold off;

%%
function [params sumSqr]= mySurfFit(data, params0)

sumSqr = @(p) calcSumSqr(data, p);

options = optimset('MaxFunEvals', 1e+8, 'TolFun', 1e-12);
[params sumSqr] = fminsearch(sumSqr, params0, options);

%%
function chiSqr = calcSumSqr(data, p)

x = data(:, 1);
y = data(:, 2);
z = data(:, 3);

zFit = applyCorr(x, y, p);
chiSqr = sum((z - zFit).^2);

%%
function densOut = applyCorr(thick, density, p)

x = thick;
y = density;

%Model 1
% densOut = p(1) + p(2)*x + p(3)*y + p(4)*x.^2 + p(5)*x.*y + p(6)*y.^2;

%Model 2
% densOut = p(1) + p(2)*y + p(3)*y.^2 + p(4)*x.*y + p(5)*x.*y.^2 + p(6)*y.^3;

%Model 3
densOut = p(1) + p(2)*y + p(3)*y.^2 + p(4)*x.*y + p(5)*x.*y.^2;

