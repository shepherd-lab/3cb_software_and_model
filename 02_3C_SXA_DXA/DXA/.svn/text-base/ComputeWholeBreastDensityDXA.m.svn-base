function  ComputeWholeBreastDensityDXA()
global Image ROI ctrl Analysis  DXAroi_thickness DXAroi_material DXAroi_materialManual DXAroi_thicknessManual
global BreastMask MaskROIproj Outline BreastMaskManual thickness_mapproj DXAAnalysis SXAAnalysis Info
global DXAroi_thicknessCrop 
%external ROI should be selected before in manual regime from GIU,
 Error.DENSITY=false;
 if isempty(ROI)
     set(ctrl.text_zone,'String','Please calculate ROI and Skin Detection first');
 end
 
temproi=Image.LE(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1);

size_ROI = size(temproi);
res = 0.014;
DXAAnalysis = [];
Analysis.Step = 6;
try
    %% Whole Breast calculation with automatic skin detection:
    if get(ctrl.CheckAutoSkin,'value')
        %% "Total" breast with "MaskROIprojTotal", "Crop" breast with "MaskROIproj"

        if ~isempty(BreastMask)
            %% Material image
            DXAroi_material = funcclim(Image.material(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1).*BreastMask,-50,200);
            %% Thickness image
            DXAroi_thickness = funcclim(Image.thickness(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1).*BreastMask,-0.5,20); 
             %% Breast area
            DXAAnalysis.DXABreastAreaPixelsTotal = bwarea(BreastMask);
            DXAAnalysis.DXABreastAreaTotal = bwarea(BreastMask)*(Analysis.Filmresolution*0.1)^2;
             %% Breast volume
            DXAAnalysis.DXABreastVolumeProj = sum(sum( DXAroi_thickness.*(BreastMask)*(Analysis.Filmresolution*0.1)^2)); 
             %% average Percentage density calculation
            DXAAnalysis.DXADensityPercentageTotal=nansum(nansum(DXAroi_material.*DXAroi_thickness))/sum(sum(DXAroi_thickness)); 
            DXAAnalysis.DXAroi_material = DXAroi_material;
            DXAAnalysis.DXAroi_thickness = DXAroi_thickness;
        end

        if ~isempty(MaskROIproj)
            %% Material image
            DXAroi_materialCrop = funcclim(Image.material(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1).*MaskROIproj,-50,200);
             %% Thickness image 
            DXAroi_thicknessCrop = funcclim(Image.thickness(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1).*MaskROIproj,-0.5,20);
             %% Breast area
            DXAAnalysis.DXABreastAreaPixelsCrop = bwarea(MaskROIproj);
            DXAAnalysis.DXABreastAreaCrop = bwarea(MaskROIproj)*(Analysis.Filmresolution*0.1)^2;
            %% Breast volume
            %Analysis.DXABreastVolumeReal = sum(sum( thickness_mapreal.*(~breast_Maskcorr)*(Analysis.Filmresolution*0.1)^2));
            DXAAnalysis.DXABreastVolumeProjCrop = sum(sum(DXAroi_thicknessCrop.*(MaskROIproj)*(Analysis.Filmresolution*0.1)^2));
            %% average Percentage density calculation
            DXAAnalysis.DXADensityPercentageCrop=nansum(nansum(DXAroi_material.*DXAroi_thicknessCrop))/sum(sum(DXAroi_thicknessCrop));
        end
            %% Display the results:
         set(ctrl.text_zone,'String',strcat('DXA Total Volume Projected: ',num2str(DXAAnalysis.DXABreastVolumeProj),...
            ', DXA Total Breast average Percentage Density: ',num2str(DXAAnalysis.DXADensityPercentageTotal),'%'));

        %% Plot the DXA and SXA thickness profiles in the middle of the breast
        if Info.Analysistype ~= 16
            x1 = [1, ROI.xmax];
            y1 = [ROI.ymax/2,ROI.ymax/2-60];
            signal1 = improfile(DXAroi_thickness,x1,y1);
            figure;plot(signal1);hold on;
            if  ~isempty(SXAAnalysis)
                signal1 = improfile(Analysis.SXAthickness_mapproj,x1,y1);
                plot(signal1,'r');xlabel('Pixels');ylabel('Thickness (cm)');
            end
        end
         %% Calculation on a selected Manual ROI:
    else
        BreastMask = []; % manual drawing of the ROI
        [C,I]=max(Outline.x);
        Npoint=size(Outline.x,2);
        innerline1_x=Outline.x(1:I-1);
        innerline1_y=Outline.y(1:I-1);
        innerline2_x=Outline.x(Npoint:-1:Npoint-I+2);
        innerline2_y=Outline.y(Npoint:-1:Npoint-I+2);

        ImageDensity=0;
        y1=min(innerline2_y,innerline1_y);
        y2=max(innerline2_y,innerline1_y);

        BreastMaskManual=zeros(size(ROI.image));
        for x=1:I-1
            BreastMaskManual(y1(x):y2(x),x)=1;
        end

        %figure; imagesc(BreastMaskManual); colormap(gray);

        %% Material image
        DXAroi_materialManual = funcclim(Image.material(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1).*BreastMaskManual,-50,200);

        %% Thickness image
        DXAroi_thicknessManual  = funcclim(Image.thickness(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1).*BreastMaskManual,-0.5,20);

        %% Breast area
        DXAAnalysis.DXABreastAreaPixelsManual = bwarea(BreastMaskManual);
        DXAAnalysis.DXABreastAreaManual = bwarea(BreastMaskManual)*(Analysis.Filmresolution*0.1)^2;

        %% Breast volume
        DXAAnalysis.DXABreastVolumeManual = sum(sum( DXAroi_thicknessManual.*(BreastMaskManual)*(Analysis.Filmresolution*0.1)^2));

        %% average Percentage density calculation
        DXAAnalysis.DXADensityPercentageManual=nansum(nansum(DXAroi_materialManual .*DXAroi_thicknessManual ))/sum(sum(DXAroi_thicknessManual ));

        if (isfield(Analysis,'SXAThicknessImageTotal') & isfield(Analysis,'SXADensityPercentageTotal'))
            SXAAnalysis.SXABreastVolumeManual = sum(sum(Analysis.SXAThicknessImageTotal.*(BreastMaskManual)*(Analysis.Filmresolution*0.1)^2));
            SXAAnalysis.SXADensityPercentageManual=nansum(nansum(Analysis.SXADensityPercentageTotal.*(Analysis.SXAThicknessImageTotal.*BreastMaskManual)))/sum(sum(Analysis.SXAThicknessImageTotal.*BreastMaskManual));
        end
        %% Display the results:
        set(ctrl.text_zone,'String',strcat('DXA ROI Volume: ',num2str(Analysis.DXABreastVolumeManual),', DXA ROI average Percentage Density:Image Density: ',num2str(Analysis.DXADensityPercentageManual),'%'));
    end

        format short g;
        dxa_analysis = DXAAnalysis
        sxa_analysis = SXAAnalysis
 
catch
         errmsg = lasterr
         Error.DENSITY = true;
         Analysis.Step = 6;
end    
    a = 1;

