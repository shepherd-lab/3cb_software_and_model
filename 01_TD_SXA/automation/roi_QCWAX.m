function  roi_QCWAX()
%[densityRoiResults, densityRoiResultsCorr] =
global ROI Analysis Info Image figuretodraw QCAnalysisData flag MachineParams thickness_ROI thickness_ROIproj Error phleanref_vect SXAAnalysis GEN3_thicknesses 

flag.SXAphantomDisplay = false;
tz = Analysis.params(4);

Error.SXAroiFitFailure = false;
Error.SXAroiFitWarning = false;

SXARoi = zeros(9, 2);     %the nine regions of SXA phantom
SXARoi(:, 1) = [1.2, 1.9, 2.6, 3.3, 4, 4.7, 5.4, 6.1, 6.8];   %thickness
indexOrder = [1, 7, 4, 2, 8, 5, 3, 9, 6];

% % % if Analysis.Ibkg<0             %commented by Am 02282014 
%to prevent negative values in background
% % %     
% % %     Analysis.Ibkg =Analysis.Ibkg -1500; 
% % % end;

% % % Analysis.Ibkg=0;

SXARoi(:, 2) = Analysis.roi_values(indexOrder)-Analysis.Ibkg; %attenuation value

Gen3Roi = zeros(9, 3);    %the nine regions of Gen3 phantom
Gen3Roi(:, 1) = [6, 4, 2, 6, 4, 2, 6, 4, 2];      %thickness
Gen3Roi(:, 2) = [100, 100, 100, 50, 50, 50, 0, 0, 0];     %density

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

if Info.centerlistactivated == 75
     k = 150/100 ;
      m =  48 * 150 / 200;
end

if strcmpi(Analysis.film_identifier(1:3),'mar') | strcmpi(Analysis.film_identifier(1:3),'Avo')| strcmpi(Analysis.film_identifier(1:3),'NC_')|strcmpi (Info.machine_id,'21')||strcmpi (Info.machine_id,'22')|strcmpi (Info.machine_id,'23')|strcmpi (Info.machine_id,'24')|strcmpi (Info.machine_id,'25')|strcmpi (Info.machine_id,'26') |strcmpi (Info.machine_id,'75')
    GEN3_thicknesses = [ 60.51 59.59 58.58 60.51 59.59 58.58];  %%Machine 21 23 24 25 26 are GE machines UVM 
    Angle_gen = 1.1;
else
    GEN3_thicknesses = [ 62.57 57.95 52.85  62.57 57.95 52.85];
    Angle_gen = 5.29;
end
%             bkgr = background_phantomdigital(Image.OriginalImage);
%             Analysis.BackGroundThreshold = bkgr+5000
%            Analysis.BackGround = Image.OriginalImage<Analysis.BackGroundThreshold;

%figure;imagesc(Analysis.BackGround);colormap(gray);
% [xmax,ymin,ymax,xmin] = edge_roi(1-Analysis.BackGround);

%         [xmin,ymin] =  ginput(1);   %for manual pointing to ROI
%         [xmax,ymax] =  ginput(1);
%Analysis.midpoint = round(ROI.rows/2);
Analysis.ROIbreast_midpoint =  round(ROI.rows/2);
if Info.DigitizerId > 3
    if flag.small_paddle ==  true  %small paddle
        X_angle = Analysis.rx - MachineParams.rx_correction
        Y_angle = Analysis.ry - MachineParams.ry_correction
    else
        X_angle = Analysis.rx- MachineParams.rx_correction% - MachineParams.rx_correction;
        Y_angle = Analysis.ry - MachineParams.ry_correction
    end
    %X_angle = 0;
    thickness_ROI = thickness_ROIcreation_v8(X_angle,Y_angle);
else
    X_angle = 0;
    Y_angle = Analysis.AngleHoriz;
    thickness_ROI = thickness_ROIcreation_film(X_angle,Y_angle);
end


thickness_ROIproj = projection_conversion(thickness_ROI);
Analysis.X_angle_orig = X_angle;
Analysis.Y_angle_orig = Y_angle;
% figure;imagesc(thickness_ROI);colormap(gray);hold on;
%          plot(x_corner,y_corner,'r*'); hold off;
%         [x_corner,y_corner] =  ginput(1);
%         y_corner = round(y_corner);
%         x_corner = round(x_corner);
% Analysis.thicknessDSP7 = thickness_ROI(y_corner,x_corner);
Analysis.thicknessDSP7 = tz -  MachineParams.bucky_distance;


% Angle_gen = 5.29;

if (~isnan(Analysis.y_1) & ~isnan(Analysis.x_1))
    Analysis.thicknessWax1 = thickness_ROIproj(Analysis.y_1,Analysis.x_1);
    plot(Analysis.x_1,Analysis.y_1+ROI.ymin,'*b');hold on;text(Analysis.x_1,Analysis.y_1+ROI.ymin,num2str(1),'Color', 'y');hold on;
else
    Analysis.thicknessWax1 = [];
end
if (~isnan(Analysis.y_2) & ~isnan(Analysis.x_2))
    thicknessWax2 = thickness_ROIproj(Analysis.y_2,Analysis.x_2);
    Analysis.thicknessWax2 = thicknessWax2 - tan((Angle_gen-Analysis.Y_angle)*pi/180)*50/10;;
    plot(Analysis.x_2,Analysis.y_2+ROI.ymin,'*b');hold on;text(Analysis.x_2,Analysis.y_2+ROI.ymin,num2str(2),'Color', 'y');hold on;
else Analysis.thicknessWax2 = [];
end
if (~isnan(Analysis.y_3) & ~isnan(Analysis.x_3))
    thicknessWax3 = thickness_ROIproj(Analysis.y_3,Analysis.x_3);
    Analysis.thicknessWax3 = thicknessWax3 - tan((Angle_gen-Analysis.Y_angle)*pi/180)*105/10;;
    plot(Analysis.x_3,Analysis.y_3+ROI.ymin,'*b');hold on;text(Analysis.x_3,Analysis.y_3+ROI.ymin,num2str(3),'Color', 'y');hold on;
else Analysis.thicknessWax3 = [];
end
if (~isnan(Analysis.y_4) && ~isnan(Analysis.x_4))
    Analysis.thicknessWax4 = thickness_ROIproj(Analysis.y_4,Analysis.x_4);
    plot(Analysis.x_4,Analysis.y_4+ROI.ymin,'*b');hold on;text(Analysis.x_4,Analysis.y_4+ROI.ymin,num2str(4),'Color', 'y');hold on;
else Analysis.thicknessWax4 = [];
end
if (~isnan(Analysis.y_5) & ~isnan(Analysis.x_5))
    thicknessWax5 = thickness_ROIproj(Analysis.y_5,Analysis.x_5);
    Analysis.thicknessWax5 = thicknessWax5 - tan((Angle_gen-Analysis.Y_angle)*pi/180)*50/10;;
    plot(Analysis.x_5,Analysis.y_5+ROI.ymin,'*b');hold on;text(Analysis.x_5,Analysis.y_5+ROI.ymin,num2str(5),'Color', 'y');hold on;
else Analysis.thicknessWax5 = [];
end
if (~isnan(Analysis.y_6) & ~isnan(Analysis.x_6))
    thicknessWax6 = thickness_ROIproj(Analysis.y_6,Analysis.x_6);
    Analysis.thicknessWax6 = thicknessWax6 - tan((Angle_gen-Analysis.Y_angle)*pi/180)*105/10;;
    plot(Analysis.x_6,Analysis.y_6+ROI.ymin,'*b');hold on;text(Analysis.x_6,Analysis.y_6+ROI.ymin,num2str(6),'Color', 'y');hold on;
else Analysis.thicknessWax6 = [];
end
%         figure;imagesc(thickness_ROI);colormap(gray);hold on;
%         plot(Analysis.x_6,Analysis.y_6,'*b');hold on;
%         plot(Analysis.x_5,Analysis.y_5,'*b');hold on;
%         plot(Analysis.x_4,Analysis.y_4,'*b');hold on;
%         plot(Analysis.x_3,Analysis.y_3,'*b');hold on;
%         plot(Analysis.x_2,Analysis.y_2,'*b');hold on;
%         plot(Analysis.x_1,Analysis.y_1,'*b');hold off;


%  xmax = round(Analysis.xmax);
%  ymax = round(Analysis.ymax);
%  xmin = round(Analysis.xmin);
%  ymin = round(Analysis.ymin);
figure(figuretodraw);
funcBox(ROI.xmin,ROI.ymin,ROI.xmin+ROI.columns,ROI.ymin+ROI.rows,'r',3); hold on;
%draweverything;
% another roi
roi_grscale.xmin = round(ROI.xmin+40*k);
roi_grscale.ymin = round(ROI.ymin+100*k);
roi_grscale.xmax = round(ROI.xmin+ROI.columns-50*k);
roi_grscale.ymax = round(ROI.ymin+ROI.rows-100*k);
xmin = roi_grscale.xmin;
ymin = roi_grscale.ymin;
xmax = roi_grscale.xmax;
ymax = roi_grscale.ymax;

if roi_grscale.ymin < 0 %JW roi_grscale.ymin in some cases negative
    roi_grscale.ymin = 1
end
roi_grscale.rows=roi_grscale.ymax-roi_grscale.ymin+1;
roi_grscale.columns=roi_grscale.xmax-roi_grscale.xmin+1;

roi_grscale.image=Image.image(roi_grscale.ymin:roi_grscale.ymin+roi_grscale.rows-1,roi_grscale.xmin:roi_grscale.xmin+roi_grscale.columns-1);
% % % Analysis.midpoint = round(roi_grscale.rows/2);
%Analysis.ROIbreast_midpoint = round(roi_grscale.rows/2);
QCAnalysisData.Draw.MainBox=[210,1250] * k;
QCAnalysisData.Draw.Compartments=9;
QCAnalysisData.Draw.BorderY=75 * k;
%QCAnalysisData.Draw.BorderX=280/box_scale * k;
QCAnalysisData.Draw.BorderX=75 * k;

%set(ctrl.CheckBreast,'value',true);
x1=roi_grscale.xmin + 230*k;
x2=x1+QCAnalysisData.Draw.MainBox(1);
y1= roi_grscale.ymin + m;
y2= y1 + QCAnalysisData.Draw.MainBox(2);
%         xr1 = xmin;
%         xr2 = xr1 + roi_grscale.columns - 43;
%         yr1 = ymin + 48;
%         yr2 = yr1 + roi_grscale.rows-96;
%
%         x_corner = xmin + roi_grscale.columns - 43;
%         y_corner = ymin + m;


%         figure;imagesc(Image.image);colormap(gray);hold on;
%         plot(x_corner,y_corner,'r*');
%         if Info.PhantomComputed == false
%                 PhantomDetection();
%         end
QCAnalysisData.MainBox=plot(0,0,'g','linewidth',2);
for index=1:9
    QCAnalysisData.Box(index)=plot(0,0,'g','linewidth',2);
end


%         figure(report_handle);
%         funcBox(roi_grscale.xmin,roi_grscale.ymin-ROI.ymin,roi_grscale.xmin+roi_grscale.columns,roi_grscale.ymin+roi_grscale.rows,'b',3);
figure(figuretodraw);
funcBox(roi_grscale.xmin,roi_grscale.ymin,roi_grscale.xmin+roi_grscale.columns,roi_grscale.ymin+roi_grscale.rows,'b',3); hold off; %hold on;
% % %         set(QCAnalysisData.MainBox,'xdata',[x1,x2,x2,x1,x1],'ydata',[y1,y1,y2,y2,y1]);
%         h_phant = findobj('Tag','GEN3');
%         figure(h_phant);hold on;
%         funcBox(roi_grscale.xmin,roi_grscale.ymin,roi_grscale.xmin+roi_grscale.columns,roi_grscale.ymin+roi_grscale.rows,'b',3);
for index=1:QCAnalysisData.Draw.Compartments
    % % %             X1=x1+QCAnalysisData.Draw.BorderX;
    % % %             X2=x2-QCAnalysisData.Draw.BorderX;
    % % %             Y1=y1+(y2-y1)/(QCAnalysisData.Draw.Compartments)*(index-1)+QCAnalysisData.Draw.BorderY;
    % % %             Y2=y1+(y2-y1)/(QCAnalysisData.Draw.Compartments)*(index)-QCAnalysisData.Draw.BorderY;
    j=index;
    l=0;
    if j > 3 && j <= 6
        j=index-3;
        l=1;
    elseif j > 6
        j=index-6;
        l=2;
    end
    
    if roi_grscale.xmin == 1
        Xwidth = round((Analysis.x_3 - Analysis.x_2)*2.055);
    else
        Xwidth =   round(roi_grscale.columns/3);
    end
    
    if j == 1 | j == 4 | j == 7
        k = 0;
    else
        k = 1;
    end
    
    % % %                     X1=xmin+ Xwidth*(j-1) - k*roi_grscale.xmin + QCAnalysisData.Draw.BorderX;
    % % %                     X2=xmin+ Xwidth*j - roi_grscale.xmin - QCAnalysisData.Draw.BorderX;
    
    X1=xmin+(roi_grscale.columns/3)*(j-1)+QCAnalysisData.Draw.BorderX;
    X2=xmin+(roi_grscale.columns/3)*(j-1)+QCAnalysisData.Draw.BorderX+(roi_grscale.columns-(QCAnalysisData.Draw.BorderX*6))/3;
    if index <=4
        Y1=ymin+(roi_grscale.rows/3)*(l)+QCAnalysisData.Draw.BorderY;
        Y2=ymin+(roi_grscale.rows/3)*(l)+QCAnalysisData.Draw.BorderY+(roi_grscale.rows-(QCAnalysisData.Draw.BorderY*6))/3;
    elseif index <=7
        Y1=ymin+(roi_grscale.rows/3)*(l)+QCAnalysisData.Draw.BorderY;
        Y2=ymin+(roi_grscale.rows/3)*(l)+QCAnalysisData.Draw.BorderY+(roi_grscale.rows-(QCAnalysisData.Draw.BorderY*6))/3;
    elseif index <=9
        Y1=ymin+(roi_grscale.rows/3)*(l)+QCAnalysisData.Draw.BorderY;
        Y2=ymin+(roi_grscale.rows/3)*(l)+QCAnalysisData.Draw.BorderY+(roi_grscale.rows-(QCAnalysisData.Draw.BorderY*6))/3;
    end
    % % %             pause(1);
    % % %             set(QCAnalysisData.Box(index),'xdata',[X1,X2,X2,X1,X1],'ydata',[Y1,Y1,Y2,Y2,Y1]);
    % % %         end
    
    %DensityResults={};
    % % %         for index=1:QCAnalysisData.Draw.Compartments
    % % %             roi.xmin=floor(x1+QCAnalysisData.Draw.BorderX);
    % % %             roi.xmax=floor(x2-QCAnalysisData.Draw.BorderX);
    % % %             roi.ymin=floor(y1+(y2-y1)/(QCAnalysisData.Draw.Compartments)*(index-1)+QCAnalysisData.Draw.BorderY);
    % % %             roi.ymax=floor(y1+(y2-y1)/(QCAnalysisData.Draw.Compartments)*(index)-QCAnalysisData.Draw.BorderY);
    % % %             roi.rows=roi.ymax-roi.ymin+1;
    % % %             roi.columns=roi.xmax-roi.xmin+1;
    roi(index).xmin=floor(X1);
    roi(index).xmax=floor(X2);
    roi(index).ymin=floor(Y1);
    roi(index).ymax=floor(Y2);
    roi(index).rows=roi(index).ymax-roi(index).ymin+1;
    roi(index).columns=roi(index).xmax-roi(index).xmin+1;
    %pause(1);
    report_handle = findobj('Tag','GEN3');
    figure(report_handle); hold on;
    funcBox(roi(index).xmin-ROI.xmin+1,roi(index).ymin-ROI.ymin,roi(index).xmin+roi(index).columns-ROI.xmin+1,roi(index).ymin+roi(index).rows-ROI.ymin,'b',3);
    %             set(QCAnalysisData.Box(index),'xdata',[roi.xmin,roi.xmax,roi.xmax,roi.xmin,roi.xmin]-gen3.xmin+1,'ydata',[roi.ymin,roi.ymin,roi.ymax,roi.ymax,roi.ymin]-gen3.ymin);
    figure(figuretodraw);
    set(QCAnalysisData.Box(index),'xdata',[roi(index).xmin,roi(index).xmax,roi(index).xmax,roi(index).xmin,roi(index).xmin],'ydata',[roi(index).ymin,roi(index).ymin,roi(index).ymax,roi(index).ymax,roi(index).ymin]);
    hold on;
    % temproi=Image.image(roi.ymin:roi.ymin+roi.rows-1,roi.xmin:roi.xmin+roi.columns-1);
    Gen3Roi(index, 3) = mean(mean(Image.image(roi(index).ymin:roi(index).ymax, roi(index).xmin:roi(index).xmax)))-Analysis.Ibkg;
    Analysis.Step=8;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% for  validation %%%%%%%%%%%%%%%%%%%%%%%%
% % % % %             if Info.DigitizerId >= 4
% % % % %               % Z4ComputeWAXPhantomDensity(roi,index);
% % % % %                Z4ComputeBreastDensityGEN3(roi,index);
% % % % %             else
% % % % %                 Analysis = funcComputePhantomDensity(roi,Image,Analysis);
% % % % %             end
% % % % %             %DensityResults{1,index}=Analysis.DensityPercentage;
% % % % %             %DensityResults{2,index}=mean(mean(Image.image(ROI.ymin:ROI.ymax,ROI.xmin:ROI.xmax)));
% % % % % % % %             DensityResults(1,index-1)=Analysis.DensityPercentage';
% % % % % % % %             DensityResults(2,index-1)=mean(mean(Image.image(roi.ymin:roi.ymax,roi.xmin:roi.xmax)));
% % % % %             DensityResults(1,index)=SXAAnalysis.roiDensity;
% % % % %             DensityResults(2,index)=SXAAnalysis.roiVolumeProj;
% % % % %             DensityResults(3,index)= SXAAnalysis.roiDenseVolume;
% % % % %             DensityResults(4,index)=SXAAnalysis.roiDensity_real;
% % % % %             DensityResults(5,index)=SXAAnalysis.roiVolumeProj_real;
% % % % %             DensityResults(6,index)= SXAAnalysis.roiDenseVolume_real;
% % % % %             DensityResults(7,index)=mean(mean(Image.image(roi.ymin:roi.ymax,roi.xmin:roi.xmax)));
% % % % %
% % % % %         end
% % % % %
% % % % % % % %          DensityROIResults = sortrows(DensityResults',2);
% % % % %          DensityROIResults = (DensityResults');
% % % % %          Analysis.density_GEN3 = DensityROIResults(:,1);
% % % % %          Analysis.volume_GEN3 = DensityROIResults(:,2);
% % % % %          Analysis.densevolume_GEN3 = DensityROIResults(:,3);
% % % % %          Analysis.density_GEN3_real = DensityROIResults(:,4);
% % % % %          Analysis.volume_GEN3_real = DensityROIResults(:,5);
% % % % %          Analysis.densevolume_GEN3_real = DensityROIResults(:,6);
% % % % %          Analysis.roi_GEN3values = DensityROIResults(:,7);
% % % % %          Analysis.density_diff = mean(Analysis.density_GEN3 - Analysis.density_GEN3_real);
% % % % %          Analysis.volume_diff = mean(Analysis.volume_GEN3 - Analysis.volume_GEN3_real);
% % % % %          Analysis.densevolume_diff = mean(Analysis.densevolume_GEN3 - Analysis.densevolume_GEN3_real);
% % % % %
% % % % %
% % % % %         Tz_thickness = 52.39;
% % % % %         %Tz_diff = Analysis.thicknessDSP7*10 - Tz_thickness;
% % % % %
% % % % %         Analysis.Diff_1 = Analysis.thicknessWax1*10 - GEN3_thicknesses(1);
% % % % %         Analysis.Diff_2 = Analysis.thicknessWax2*10  - GEN3_thicknesses(2);
% % % % %         Analysis.Diff_3 = Analysis.thicknessWax3*10  - GEN3_thicknesses(3);
% % % % %         Analysis.Diff_4 = Analysis.thicknessWax4*10  - GEN3_thicknesses(4);
% % % % %         Analysis.Diff_5 = Analysis.thicknessWax5*10  - GEN3_thicknesses(5);
% % % % %         Analysis.Diff_6 = Analysis.thicknessWax6*10  - GEN3_thicknesses(6);
% % % % %         Analysis.thickness_diff = mean([Analysis.Diff_1 Analysis.Diff_2 Analysis.Diff_3 Analysis.Diff_4 Analysis.Diff_5 Analysis.Diff_6]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% end for validation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Analysis.Diff_1 = Analysis.thicknessWax1*10 - GEN3_thicknesses(1);
Analysis.Diff_2 = Analysis.thicknessWax2*10  - GEN3_thicknesses(2);
Analysis.Diff_3 = Analysis.thicknessWax3*10  - GEN3_thicknesses(3);
Analysis.Diff_4 = Analysis.thicknessWax4*10  - GEN3_thicknesses(4);
Analysis.Diff_5 = Analysis.thicknessWax5*10  - GEN3_thicknesses(5);
Analysis.Diff_6 = Analysis.thicknessWax6*10  - GEN3_thicknesses(6);
Analysis.thickness_diff = mean([Analysis.Diff_1 Analysis.Diff_2 Analysis.Diff_3 Analysis.Diff_4 Analysis.Diff_5 Analysis.Diff_6]);
a = 1;

% %DSP scale based calculation
% %calculate kLean, km
% kTableDSP = calckValueDSP(SXARoi, Gen3Roi);
% Analysis.kTable = kTableDSP;
% %kTableDSP = Z4coef_tableSmall;
% %compute phantom density
% densityRoiResults = computeWAXPhanDensDSP(Gen3Roi, SXARoi, kTableDSP);

%WAX-water scale based calculation
%SXARoi = SXARoi + 2108; Gen3Roi = Gen3Roi +  + 2108;
[kTableWAX, SXAroiFit, SXAroiChiSqr, SXAroiUsed] = calckValueWAX(SXARoi, Gen3Roi);
if isnan(SXAroiFit)
    Error.DENSITY = true;
    Error.SXAroiFitFailure = true;
    error('No best-fit line was found on SXA ROI values!');
else
    if ( SXAroiUsed(end) - SXAroiUsed(1) < 5 )  %less than or equal to 5 roi used
        Error.SXAroiFitWarning = true;
    end
    
  
  kTableWAX_Negative=kTableWAX(kTableWAX(2:end,3)<0,3)    % AM 02282014
  
  kTableWAX_AboveThreshold=kTableWAX(kTableWAX(1,3)>5,3)  
  
    if kTableWAX_Negative<0 |  kTableWAX_AboveThreshold>5
        Info.roi_QCWAX_status='False';
        Message('It seems kTableWAX values are less than 0 or above 5 ');
    else 
         Info.roi_QCWAX_status='True';
    end;
    
         
    kt = kTableWAX
    a1 =  SXAroiFit
    b1 =  SXAroiChiSqr
    c1 =  SXAroiUsed
    
    densityRoiResults = computeWAXPhanDensWAX(Gen3Roi, SXAroiFit, kTableWAX)
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
    %Analysis.roi_DSP7values = densityRoiResults(2,:);   %this shouldn't be called DSP7 any more
    Analysis.roigen3_values =  Gen3Roi(:, 3)';
    %following this convention to
    %guarantee SaveInDatabase
    Analysis.densFitParam = densFitParam;
    Analysis.densFitAnalysis = densFitAnalysis;
    
    phleanref_vect = SXARoi(:, 2);  %this is global, will be saved to 'QCwaxSAXPhanomInfo'
    
    try
        CorrectMachineParametersCorrection;
    catch
    end
    
    
    
    % %New method of deriving Gen3 Phantom density
    % [kTableWAX, Gen3CoefOnH] = calcNewCoef(SXARoi, Gen3Roi);
    % %Analysis.newCoefTable = newCoefTable;
    % densityRoiResults = computeWAXPhanDensNew(Gen3Roi, SXARoi, kTableWAX, Gen3CoefOnH);
    
    %%%%%%%%%%%%%%%%%% Validation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % %     for index=1:QCAnalysisData.Draw.Compartments
% % %       Analysis.Step=8;
% % %             
% % %             if Info.DigitizerId >= 4
% % %                %Z4ComputeWAXPhantomDensity(roi,index);
% % %                Z4ComputeBreastDensitynewGEN3(roi(index),index);
% % %             else    
% % %                 Analysis = funcComputePhantomDensity(roi(index),Image,Analysis);
% % %             end
% % %             DensityResults(1,index)=SXAAnalysis.roiDensity;
% % %             DensityResults(2,index)=SXAAnalysis.roiVolumeProj;
% % %             DensityResults(3,index)= SXAAnalysis.roiDenseVolume;
% % %             DensityResults(4,index)=SXAAnalysis.roiDensity_246cm;
% % %             DensityResults(5,index)=SXAAnalysis.roiVolumeProj_246cm;
% % %             DensityResults(6,index)= SXAAnalysis.roiDenseVolume_246cm;
% % %             DensityResults(7,index)=mean(mean(Image.image(roi(index).ymin:roi(index).ymax,roi(index).xmin:roi(index).xmax)));
% % %     end
% % %          DensityROIResults = (DensityResults');
% % %          Analysis.density_GEN3 = DensityROIResults(:,1);
% % %          Analysis.volume_GEN3 = DensityROIResults(:,2);
% % %          Analysis.densevolume_GEN3 = DensityROIResults(:,3);
% % %          Analysis.density_GEN3_246cm = DensityROIResults(:,4);
% % %          Analysis.volume_GEN3_246cm = DensityROIResults(:,5);
% % %          Analysis.densevolume_GEN3_246cm = DensityROIResults(:,6); 
% % %          Analysis.roi_GEN3values = DensityROIResults(:,7);
% % %          Analysis.density_diff = mean(Analysis.density_GEN3 - Analysis.density_GEN3_246cm);
% % %          Analysis.volume_diff = mean(Analysis.volume_GEN3 - Analysis.volume_GEN3_246cm);
% % %          Analysis.densevolume_diff = mean(Analysis.densevolume_GEN3 - Analysis.densevolume_GEN3_246cm);
% % %          
% % %         
% % %         Tz_thickness = 52.39;
% % %         %Tz_diff = Analysis.thicknessDSP7*10 - Tz_thickness;
% % %         
% % %         Analysis.Diff_1 = Analysis.thicknessWax1*10 - GEN3_thicknesses(1);
% % %         Analysis.Diff_2 = Analysis.thicknessWax2*10  - GEN3_thicknesses(2);
% % %         Analysis.Diff_3 = Analysis.thicknessWax3*10  - GEN3_thicknesses(3);
% % %         Analysis.Diff_4 = Analysis.thicknessWax4*10  - GEN3_thicknesses(4);
% % %         Analysis.Diff_5 = Analysis.thicknessWax5*10  - GEN3_thicknesses(5);
% % %         Analysis.Diff_6 = Analysis.thicknessWax6*10  - GEN3_thicknesses(6);
% % %         Analysis.thickness_diff = mean([Analysis.Diff_1 Analysis.Diff_2 Analysis.Diff_3 Analysis.Diff_4 Analysis.Diff_5 Analysis.Diff_6]);
         
          a = 1;
    
    
end
%% calculating k valus on the WAX-water reference
function [kValueWAX, SXAcoef, SXAchiSqr, roiUsed] = calckValueWAX(SXARoi, Gen3Roi)
global Image Analysis Info
% % % SXARoi(:,2) = SXARoi(:,2);
% % % Gen3Roi(:,2) = Gen3Roi(:,2);
%thkSortedGen3Roi = sortrows(Gen3Roi, [1, 2]);
denSortedGen3Roi = sortrows(Gen3Roi, [2, 1]);
SXAthick = SXARoi(:, 1);
SXAatnu = SXARoi(:, 2);
SXAcoef = zeros(1,3);

if Info.DigitizerId >=5%Info.centerlistactivated == 55 | Info.centerlistactivated == 56  | Info.centerlistactivated == 53  %strcmp(Analysis.film_identifier(1:3),'mar')
    thickForK = [0.6;SXAthick; 7.5; 8.0];
else
    thickForK = [0.6; SXAthick; 7.5; 8.0; 8.5; 9.0; 9.5; 10.0];
end


numH = length(thickForK);
kValueWAX = zeros(numH, 3);    %1st ~ 3rd col: h, kLean, km
SXAmat = 80;
Gen3CoefOnH = zeros(3, 3);  %row: density 0, 50, 100
%column: a, b, c in a*x^2+b*x+c
thick_all = 0:10;
%   figure; hold on 
for i = 1:3 %For each density, fit for VD vs. H
    stepThick = denSortedGen3Roi(3*i-2:3*i, 1);
    Gen3Atnu = denSortedGen3Roi(3*i-2:3*i, 3);
    Gen3CoefOnH(i, :) = polyfit(stepThick, Gen3Atnu, 2);
    gen3_att(i,:) = Gen3CoefOnH(i, 1)*thick_all.^2 + Gen3CoefOnH(i, 2).*thick_all + Gen3CoefOnH(i, 3);
    %figure; plot(stepThick, Gen3Atnu, 'bo', thick_all, gen3_att(i,:), 'r-');
end
%  hold off
[SXAcoef, SXAchiSqr, roiUsed] = SXAroiBestFit(SXAthick, SXAatnu);
 V80m = SXAcoef(1)*SXAthick.^2 + SXAcoef(2).*SXAthick + SXAcoef(3);
 %figure;plot(SXAthick, SXAatnu, 'ob', SXAthick,V80m,'r-');
%figure; imagesc(Image.OriginalImage);colormap(gray);
if ( ~isnan(SXAcoef) )
    dens = [0; 50; 100];
    Gen3AtnuAtH = zeros(3, 1);
    for iterH = 1:numH %for each thickness of SXA phantom
        H = thickForK(iterH, 1);
        for i = 1:3 %three densities
            Gen3AtnuAtH(i) = Gen3CoefOnH(i, 1)*H^2 + Gen3CoefOnH(i, 2)*H + Gen3CoefOnH(i, 3);
        end
        %get VD0 and VD80
        Gen3CoefOnDens = polyfit(dens, Gen3AtnuAtH, 2);
        VD0 = Gen3CoefOnDens(3);
        VD80 = Gen3CoefOnDens(1)*SXAmat^2 + Gen3CoefOnDens(2)*SXAmat + Gen3CoefOnDens(3);
        dens_all = 0:100;
        VD_all = Gen3CoefOnDens(1)*dens_all.^2 + Gen3CoefOnDens(2).*dens_all + Gen3CoefOnDens(3);
        %figure; plot(dens,Gen3AtnuAtH, 'bo', dens_all, VD_all, 'r-');
        %get V80 at H
        V80 = SXAcoef(1)*H^2 + SXAcoef(2)*H + SXAcoef(3);
        
        kLean = VD80/V80;   %change  because of negatives
        %m80 = kLean*(2*SXAcoef(1)*H + SXAcoef(2));  % changed according to the paper MP,2009 by replacing with  2*SXAcoef(1)
        m80 = kLean*(SXAcoef(1)*H + SXAcoef(2));
        km = m80*H/(m80*H - VD80 + VD0);
% % %         if km<0   % Am 02182014 changed because of negatives values 
% % %             km=abs(km);
% % %         end
        
        kValueWAX(iterH, :) = [H, kLean, km];
    end
%     figure; plot(kValueWAX(:,1), kValueWAX(:,2), 'bo-');
%     figure; plot(kValueWAX(:,1), kValueWAX(:,3), 'bo-');
end
a = 1;
%%
function density = computeWAXPhanDensWAX(Gen3Roi, SXAroiFit, kTable)

density = zeros(2, 9);  %row 1: density%, row 2: attenuation

%generate lean & fat ref curves
[leanCurCoef, fatCurCoef] = computeLeanFatCurve(SXAroiFit, kTable)

for i = 1:9
    H = Gen3Roi(i, 1);
    atnuVal = Gen3Roi(i, 3);
    lean_H = leanCurCoef(1)*H^2 + leanCurCoef(2)*H + leanCurCoef(3);
    fat_H = fatCurCoef(1)*H^2 + fatCurCoef(2)*H + fatCurCoef(3);
    density(1, i) = interp1([fat_H lean_H], [0 80], atnuVal, 'linear', 'extrap');
    density(2, i) = atnuVal;
end

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



