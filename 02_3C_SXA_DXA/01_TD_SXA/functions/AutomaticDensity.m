
function AutomaticDensity()

% Written by Amir Pasha M
% 05/14/2014
% UCSF, BBDG 

global Info Image ROI  Threshold  Analysis flag chestwall_Mask BreastMask Database boundary_mask   AutoThreshold_Image BW stats_biggest_Breast 
global DensityImageSkin  thickness_mapprojCrop  MaskROIproj thickness_mapreal breast_Maskcorr Automaticduration temproi SXAAnalysis inner_mask Error

tic
% Database.Name='mammo_CPMC';
Analysis.SXADensityPercentage_in=[];
Analysis.SXADensityPercentage_out=[];
Analysis.DenseVolume_in =[];
Analysis.DenseVolume_out=[];
Analysis.Threshold_density_real=[];


Threshold.Computed=true;
Threshold.plotflag=0;
Threshold.boundary_real=[];
boundary_mask=[];
kVp=Info.kVp;

if (Error.DENSITY|Error.NoCorrection| Error.NoBreast| Error.ROIFailed |Error.SkinEdgeFailed |Error.PhantomDetection |Error.PeripheryCalculation);
    
    nextpatient(0);
    multiWaitbar( 'CloseAll' );
    return;
    
end




try

% use mAs and kVp from Dicom table if mAs or kVp=0
if (Info.mAs==0)||(Info.kVp==0)
    
    try
        
        Dicom=mxDatabase(Database.Name,['select  FileSize,	KVP, ExposureInuAs, ...'
            'ExposureTime, DetectorTemperature  from DICOMinfo where DICOM_ID =(select DICOM_id from acquisition where acquisition_id=',num2str(Info.AcquisitionKey),')']);
        
        Info.kvpDicom=cell2mat(Dicom(2));
        Info.mAsDicom=(round(cell2mat(Dicom(3))))/1000;
        
        Info.mAs=Info.mAsDicom;
        Info.kVp=Info.kvpDicom;
    catch err
       rethrow(err);
    end
    
end



temproi=Image.image(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1);

try 
    
    
    cc = bwconncomp(BreastMask);
    stats_BreastMask= regionprops(cc ,temproi,'Area','MaxIntensity','MinIntensity',...
        'MeanIntensity');
    
    Analysis.Breast_Area=nnz(BreastMask);
    
    Breast_MinIntensity=min([stats_BreastMask.MinIntensity]);
    Breast_MaxIntensity=max([stats_BreastMask.MaxIntensity]);
    Breast_MeanIntensity=mean([stats_BreastMask.MeanIntensity]);
    
    B = [stats_BreastMask.Area];
    [~,biggest] = max(B);
    stats_biggest_Breast = stats_BreastMask(biggest);
    
    Analysis.Breast_MinIntensity=[stats_biggest_Breast.MinIntensity];
    Analysis.Breast_MaxIntensity=[stats_biggest_Breast.MaxIntensity];
    Analysis.Breast_MeanIntensity=[stats_biggest_Breast.MeanIntensity];
    
    
    
catch exception
    disp(exception)    
    Analysis.Breast_Area=0;
    Analysis.Breast_MinIntensity = 0;
    Analysis.Breast_MaxIntensity= 0;
    Analysis.Breast_MeanIntensity= 0;
    
end 

if Analysis.Breast_MeanIntensity>25800

   Breast='FattyBreast'; 
else
    
    Breast='DenseBreast'; 
end


try
    
    if strfind(Breast,'DenseBreast')
        
        switch kVp
            case  24
                
                if Info.thickness<=16
                    Min_Intensity= 18070.93;
                    Max_Intensity= 21813.60;
                elseif  16<Info.thickness<=18; %correct
                    Min_Intensity= 19070.93;
                    Max_Intensity= 21813.60;
                elseif  18<Info.thickness<=20;
                    Min_Intensity=16414.05 ;
                    Max_Intensity=19454.01 ;
                elseif  20<Info.thickness<=22;
                    Min_Intensity=16414.05 ;
                    Max_Intensity=19454.01 ;
                elseif  22<Info.thickness<=24;
                    Min_Intensity=16414.05 ;
                    Max_Intensity=19454.01 ;
                elseif  24<Info.thickness<=26;
                    Min_Intensity=25434.59 ;
                    Max_Intensity=31004.36 ;
                elseif  26<Info.thickness<=28;
                    Min_Intensity=24193.47 ;
                    Max_Intensity=54152.85 ;
                elseif  28<Info.thickness<=30;
                    Min_Intensity=23930.11 ;
                    Max_Intensity=34319.05 ;
                else
                    Min_Intensity=23930.11 ;
                    Max_Intensity=34319.05 ;
                end
                
            case 25
                
                if   Info.thickness<=28;
                    Min_Intensity=24270.79 ;
                    Max_Intensity=31562.66 ;
                elseif  28<Info.thickness<=30; % Correct
                    Min_Intensity=22197.07;   %Min_Intensity=24270.79 ;
                    Max_Intensity=37562.66 ;  %Max_Intensity=31562.66
                elseif  30<Info.thickness<=32;
                    Min_Intensity=23153.01 ;
                    Max_Intensity=37097.18 ;
                elseif  32<Info.thickness<=34;
                    Min_Intensity=25654.64 ;
                    Max_Intensity=93867.69 ;
                else
                    Min_Intensity=25654.64 ;
                    Max_Intensity=93867.69 ;
                end
                
            case 26
                
                if  Info.thickness<=34;
                    Min_Intensity=26536.78 ;
                    Max_Intensity=40291.71 ;
                elseif  34<Info.thickness<=36;
                    Min_Intensity=26000.78 ;  % correct %26536.78
                    Max_Intensity=40291.71 ;
                elseif  36<Info.thickness<=38;
                    Min_Intensity=26926.67 ;
                    Max_Intensity=52718.24 ;
                elseif  38<Info.thickness<=40;
                    Min_Intensity=28872.38 ;
                    Max_Intensity=48301.02 ;
                else
                    Min_Intensity=28872.38 ;
                    Max_Intensity=48301.02 ;
                end
                
            case 27
                
                if  Info.thickness<=38;
                    Min_Intensity=27897.27 ;
                    Max_Intensity=51943.50 ;
                elseif  38<Info.thickness<=40; %correct
                    Min_Intensity=28432.49 ;% Min_Intensity=27897.27 ;
                    Max_Intensity=33418.83 ; %Max_Intensity=51943.50 ;
                elseif  40<Info.thickness<=42;
                    Min_Intensity=28740.28 ;
                    Max_Intensity=54501.55 ;
                elseif  42<Info.thickness<=44;
                    Min_Intensity=28998.29 ;
                    Max_Intensity=45263.29 ;
                else
                    Min_Intensity=28998.29 ;
                    Max_Intensity=45263.29 ;
                end
                
            case 28
                
                if   Info.thickness<=44;
                    Min_Intensity= 29611.50;
                    Max_Intensity= 57027.80;
                elseif  44<Info.thickness<=46; % Almost correct
                    Min_Intensity= 27311.50;
                    Max_Intensity= 57027.80;
                elseif  46<Info.thickness<=48;
                    Min_Intensity=30409.19 ;
                    Max_Intensity=95611.96 ;
                elseif  48<Info.thickness<=50;
                    Min_Intensity=32048.85 ;
                    Max_Intensity=55324.82 ;
                else
                    Min_Intensity=32048.85 ;
                    Max_Intensity=55324.82 ;
                end
                
            case 29
                
                if  Info.thickness<=48;
                    Min_Intensity=31588.27 ;
                    Max_Intensity=55041.82 ;
                elseif  48<Info.thickness<=50;  % correct
                    Min_Intensity=30000.27 ; %31588.27  %28867.09
                    Max_Intensity=55041.82 ;
                elseif  50<Info.thickness<=52;
                    Min_Intensity=32145.98 ;
                    Max_Intensity=50380.49 ;
                elseif  52<Info.thickness<=54;
                    Min_Intensity=32905.41 ;
                    Max_Intensity= 68469.34;
                else
                    Min_Intensity=32905.41 ;
                    Max_Intensity= 68469.34;
                end
                
            case 30
                
                if   Info.thickness<=54;
                    Min_Intensity=32941.27 ;
                    Max_Intensity=57115.77 ;
                elseif  54<Info.thickness<=56;  %32941.27  %30053.44  % Correct
                    Min_Intensity=32941.27 ;
                    Max_Intensity=57115.77 ;
                elseif  56<Info.thickness<=58;
                    Min_Intensity=33629.81 ;
                    Max_Intensity=44798.19 ;
                elseif  58<Info.thickness<=60;
                    Min_Intensity=33897.16 ;
                    Max_Intensity=49388.68 ;
                else
                    Min_Intensity=33897.16 ;
                    Max_Intensity=49388.68 ;
                end
                
            case 31
                
                if  Info.thickness<=58;
                    Min_Intensity=33452.97 ;
                    Max_Intensity=50383.62 ;
                elseif  58<Info.thickness<=60;
                    Min_Intensity=32000.97; %Min_Intensity=33452.97  %correct
                    Max_Intensity=50383.62 ;
                elseif  60<Info.thickness<=62;
                    Min_Intensity=34139.78 ;
                    Max_Intensity=45738.76 ;
                elseif  62<Info.thickness<=64;
                    Min_Intensity=34674.88 ;
                    Max_Intensity=46688.12 ;
                else
                    Min_Intensity=34674.88 ;
                    Max_Intensity=46688.12 ;
                end
                
            case 32
                
                if  Info.thickness<=64;
                    Min_Intensity=33557.25 ;
                    Max_Intensity=51214.40 ;
                elseif  64<Info.thickness<=66; % correct
                    Min_Intensity=33557.25 ; %33557.25  30043.39
                    Max_Intensity=51214.40 ;
                elseif  66<Info.thickness<=68;
                    Min_Intensity=34794.52 ;
                    Max_Intensity=61474.04 ;
                elseif  68<Info.thickness<=70;
                    Min_Intensity=34920.68 ;
                    Max_Intensity=53707.79 ;
                elseif  70<Info.thickness<=72;
                    Min_Intensity=36261.75 ;
                    Max_Intensity=46578.91 ;
                elseif  72<Info.thickness<=74;
                    Min_Intensity=35784.89 ;
                    Max_Intensity=59702.00 ;
                elseif  74<Info.thickness<=76;
                    Min_Intensity=36795.76 ;
                    Max_Intensity=63489.15 ;
                elseif  76<Info.thickness<=78;
                    Min_Intensity=37051.82 ;
                    Max_Intensity=47495.98 ;
                elseif  78<Info.thickness<=80;
                    Min_Intensity=37395.86 ;
                    Max_Intensity=52508.97 ;
                else
                    Min_Intensity=37395.86 ;
                    Max_Intensity=52508.97 ;
                end
                
            case 33
                
                if  Info.thickness<=78;
                    Min_Intensity=37303.66 ;
                    Max_Intensity=55895.97 ;
                elseif  78<Info.thickness<=80; %Correct
                    Min_Intensity=37303.66 ;
                    Max_Intensity=55895.97 ;
                elseif  80<Info.thickness<=82;
                    Min_Intensity=38712.33 ;
                    Max_Intensity=48654.59 ;
                elseif  82<Info.thickness<=84;
                    Min_Intensity=36686.54 ;
                    Max_Intensity=43627.44 ;
                elseif  84<Info.thickness<=86;
                    Min_Intensity=38354.91 ;
                    Max_Intensity=50889.47;
                elseif  86<Info.thickness<=88;
                    Min_Intensity=38881.81 ;
                    Max_Intensity=55989.98 ;
                    
                else
                    Min_Intensity=38881.81 ;
                    Max_Intensity=55989.98 ;
                end
                
            case 34
                
                
                if  88<Info.thickness; % Almost correct
                    Min_Intensity=39681.81 ;
                    Max_Intensity=55989.98 ;
                else
                    Min_Intensity=39681.81 ;
                    Max_Intensity=55989.98 ;
                end
                
            otherwise
                
                if kVp>34
                    
                    Min_Intensity=38881.81  ;
                    Max_Intensity=55989.98 ;
                    
                else
                    Min_Intensity= 18070.93;
                    Max_Intensity= 21813.60;
                end
        end
        
    else
        
        switch kVp
            case  24
                
                if  Info.thickness<26
                    Min_Intensity=17051.18 ; %Min_Intensity=28051.18  % correct
                    Max_Intensity=33859.72 ;
                elseif  26<Info.thickness<=28; %Correct
                    Min_Intensity=28051.18 ;
                    Max_Intensity=33859.72 ;
                else
                    Min_Intensity=28051.18 ;
                    Max_Intensity=33859.72 ;
                end
                
            case 25
                
                if   Info.thickness<=28;
                    Min_Intensity=25197.07 ;
                    Max_Intensity=28788.06 ;
                elseif  28<Info.thickness<=30; %correct
                    Min_Intensity=22197.07 ; %Min_Intensity=25197.07
                    Max_Intensity=28788.06 ; % Max_Intensity=28788.06
                    
                elseif  32<Info.thickness<=34;
                    Min_Intensity=26137.53 ;
                    Max_Intensity=37706.34 ;
                else
                    Min_Intensity=26137.53 ;
                    Max_Intensity=37706.34 ;
                end
                
            case 26
                
                if  Info.thickness<=34;
                    Min_Intensity=26020.87 ;
                    Max_Intensity=86543.23 ;
                elseif  34<Info.thickness<=36; %correct
                    Min_Intensity=26000.78 ;
                    Max_Intensity=86543.23 ;
                elseif  36<Info.thickness<=38;
                    Min_Intensity=27313.05 ;
                    Max_Intensity=51726.37 ;
                elseif  38<Info.thickness<=40;
                    Min_Intensity=26951.24 ;
                    Max_Intensity=34338.57 ;
                else
                    Min_Intensity=26951.24 ;
                    Max_Intensity=34338.57 ;
                end
                
            case 27
                
                if  Info.thickness<=38;
                     Min_Intensity=27432.49 ;
                    Max_Intensity=33418.83 ;
                elseif  38<Info.thickness<=40;  %correct
                    Min_Intensity=28432.49 ;
                    Max_Intensity=33418.83 ;
                elseif  40<Info.thickness<=42;
                    Min_Intensity=30011.59 ;
                    Max_Intensity=60820.85 ;
                elseif  42<Info.thickness<=44;
                    Min_Intensity=28697.26 ;
                    Max_Intensity=52780.38 ;
                else
                    Min_Intensity=28697.26 ;
                    Max_Intensity=52780.38 ;
                end
                
            case 28
                
                if   Info.thickness<=44;
                   Min_Intensity= 25000.91;  % Tested and should be 25000
                    Max_Intensity= 56342.76;
                elseif  44<Info.thickness<=46;  % Almost correct
                    Min_Intensity= 30000.91;
                    Max_Intensity= 56342.76;
                elseif  46<Info.thickness<=48;
                    Min_Intensity=30810.80 ;
                    Max_Intensity=65194.02 ;
                elseif  48<Info.thickness<=50;
                    Min_Intensity=30466.36 ;
                    Max_Intensity=59236.10 ;
                else
                    Min_Intensity=30466.36 ;
                    Max_Intensity=59236.10 ;
                end
                
            case 29
                
                if  Info.thickness<=48;
                    Min_Intensity=31741.31 ; %31588.27  %28867.09
                    Max_Intensity=45910.41 ;
                elseif  48<Info.thickness<=50;
                    Min_Intensity=29300.27 ; ; %31588.27  %28867.09
                    Max_Intensity=45910.41 ;
                elseif  50<Info.thickness<=52;
                    Min_Intensity=32275.66 ;
                    Max_Intensity=59181.11 ;
                elseif  52<Info.thickness<=54;
                    Min_Intensity=31878.41 ;
                    Max_Intensity=57074.03;
                else
                    Min_Intensity=31878.41 ;
                    Max_Intensity=57074.03;
                end
                
            case 30
                
                if   Info.thickness<=54;
                    Min_Intensity=32181.12 ;
                    Max_Intensity=59186.30 ;
                elseif  54<Info.thickness<=56;  %32941.27  %30053.44 % Correct
                    Min_Intensity=32181.12 ;
                    Max_Intensity=59186.30 ;
                elseif  56<Info.thickness<=58;
                    Min_Intensity=33712.51;
                    Max_Intensity=59277.70 ;
                elseif  58<Info.thickness<=60;
                    Min_Intensity=33593.16 ;
                    Max_Intensity=57622.71 ;
                else
                    Min_Intensity=33593.16 ;
                    Max_Intensity=57622.71 ;
                end
                
            case 31
                
                if  Info.thickness<=58;
                    Min_Intensity=33874.61;
                    Max_Intensity=48253.00 ;
                elseif  58<Info.thickness<=60; %Correct
                    Min_Intensity=32400.00;    %33874.61;
                    Max_Intensity=48253.00 ;
                elseif  60<Info.thickness<=62;
                    Min_Intensity=33905.27 ;
                    Max_Intensity=58180.93 ;
                elseif  62<Info.thickness<=64;
                    Min_Intensity=35569.37 ;
                    Max_Intensity=62843.51 ;
                else
                    Min_Intensity=35569.37 ;
                    Max_Intensity=62843.51 ;
                end
                
            case 32
                
                if  Info.thickness<=64;
                    Min_Intensity=32979.08 ; %33557.25  30043.39
                    Max_Intensity=56048.54 ;
                elseif  64<Info.thickness<=66;
                     Min_Intensity=32300.25 ; %Min_Intensity=35143.39 ; %33557.25  30043.39 
                    Max_Intensity=51214.40 ;% Max_Intensity=56048.54 ;     
                elseif  66<Info.thickness<=68;
                    Min_Intensity=34816.12 ;
                    Max_Intensity=62983.90;
                elseif  68<Info.thickness<=70;
                    Min_Intensity=34529.67 ;
                    Max_Intensity=58550.89 ;
                elseif  70<Info.thickness<=72;
                    Min_Intensity=34134.80 ;
                    Max_Intensity=59306.21 ;
                elseif  72<Info.thickness<=74;
                    Min_Intensity=36528.80 ;
                    Max_Intensity=62489.81 ;
                elseif  74<Info.thickness<=76;
                    Min_Intensity=36664.28 ;
                    Max_Intensity=60441.80 ;
                elseif  76<Info.thickness<=78;
                    Min_Intensity=37265.37 ;
                    Max_Intensity=59437.63 ;
                elseif  78<Info.thickness<=80;
                    Min_Intensity=36946.38 ;
                    Max_Intensity=45120.78 ;
                else
                    Min_Intensity=36946.38 ;
                    Max_Intensity=45120.78 ;
                end
                
            case 33
                
                if  Info.thickness<=78;
                    Min_Intensity=36294.22 ;
                    Max_Intensity=53929.82 ;
                elseif  78<Info.thickness<=80; %Almost correct
                    Min_Intensity=36303.66 ;
                    Max_Intensity=55895.97 ;
%                     Min_Intensity=35294.22 ;
%                     Max_Intensity=53929.82 ;
                elseif  80<Info.thickness<=82;
                    Min_Intensity=36779.71 ;
                    Max_Intensity=63414.51 ;
                elseif  82<Info.thickness<=84;
                    Min_Intensity=37727.37 ;
                    Max_Intensity=48373.74 ;
                elseif  84<Info.thickness<=86;
                    Min_Intensity=38290.25 ;
                    Max_Intensity=58749.79;
                elseif  86<Info.thickness<=88;
                    Min_Intensity=37492.22 ;
                    Max_Intensity=45216.79 ;
                    
                elseif  88<Info.thickness<=90;
                    Min_Intensity=37971.80 ;
                    Max_Intensity=44207.21 ;
                    
                else
                    Min_Intensity=37971.80 ;
                    Max_Intensity=44207.21 ;
                end
                
            case 34
                
                if  Info.thickness<=88;
                    Min_Intensity=37971.80 ;
                    Max_Intensity=44207.21 ;
                elseif  88<Info.thickness<=90;
                    Min_Intensity=38224.18 ;
                    Max_Intensity=50371.41 ;
                else 
                    Min_Intensity=38224.18 ;
                    Max_Intensity=50371.41 ;
                end
                
            otherwise
                
                if kVp>34
                    
                    Min_Intensity=38224.18 ;
                    Max_Intensity=50371.41 ;
                    
                else
                    Min_Intensity=28051.18 ;
                    Max_Intensity=33859.72 ;
                end
        end
    end
    
catch exception 
    disp(exception)
end




try
    
    SQLstatement2=['SELECT ALL commonanalysis.commonanalysis_id, commonanalysis.ChestWall_ID FROM acquisition,commonanalysis', ...
        'WHERE acquisition.acquisition_id = commonanalysis.acquisition_id  AND commonanalysis.acquisition_id =', num2str(Info.AcquisitionKey),'order by ChestWall_ID'];
    
    chwall_ids=mxDatabase(Database.Name,SQLstatement2);
    chwall_ids = chwall_ids(1,:);
    
    
    if ~isempty(chwall_ids)
        
        chestwall_Mask = excludeSXAmuscle(temproi);
        
    else
        chestwall_Mask = excludeContourMuscle(temproi);
    end
    %figure; imagesc(BreastMask); colormap(gray);
    BreastMask = BreastMask .* chestwall_Mask;
    
catch exception 
    disp('Automatic Muscle removal Failed')
end

if Info.QualityControl==true;
funcThresholdContour;
end


Analysis.Min_Intensity=Analysis.Breast_MinIntensity;
Analysis.Max_Intensity=Analysis.Breast_MaxIntensity;
Analysis.Mean_Intensity=Analysis.Breast_MeanIntensity;

try
if strfind(Info.SeriesDescription,'CC')
%% Remve Muscle for all CC view 
[iy ix]=size(BreastMask);
cx=2;cy=iy/2%-iy/10;
r=iy/2;
X0=10;
Y0=20;
a=30; %  Define how big width is 
b=iy/4;  
[x,y]=meshgrid(-(cx-1):(ix-cx),-(cy-1):(iy-cy));
Muscle_mask=((x-X0)/a).^2+((y-Y0)/b).^2<=1;
% figure;imagesc(Muscle_mask); colormap(bone) 
Cropped_Image_1=temproi.*(~Muscle_mask);
BreastMask_WithoutMuscle=BreastMask.*(~Muscle_mask);
Cropped_Image=Cropped_Image_1;
else 
%     Muscle_Removal_MLO;  % Temprorary commented 
    Cropped_Image=temproi;
    Cropped_Image=Cropped_Image_1;
    s=size(Cropped_Image);
    Muscle_mask=zeros(s);
  
end
catch exception
    disp('Automatic Muscle Removal Failed');
  
end
    


% w = find ( Min_Intensity<= Cropped_Image <=Max_Intensity );
% ww = find ( Cropped_Image >Max_Intensity);
% www=find (  Cropped_Image< Min_Intensity );
z=Min_Intensity<=Cropped_Image(:)<= Max_Intensity ;
zz=Cropped_Image(:)> Max_Intensity ;
zzz=Cropped_Image(:)< Min_Intensity ;
Cropped_Image(z) = 255;
Cropped_Image(zz) = 0;
Cropped_Image(zzz) =0;

% Cropped_Image(w) = 255;
% Cropped_Image(ww) = 0;
% Cropped_Image(www) =0;

% figure;imagesc(Cropped_Image);colormap(gray);


Cropped_Image=Cropped_Image.* BreastMask;
% Cropped_Image=im2double(Cropped_Image);
% % %
Image.ThresholdMask_real = zeros(size(Image.image));
Image.ThresholdMask_real(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1) = Cropped_Image;


[boundary_mask,L] = bwboundaries(Cropped_Image,'noholes');  % first method to find boundry
% % figure;imshow(label2rgb(L, @jet, [.5 .5 .5]))
% % hold on
% % for k = 1:length(boundary_mask)
% %     boundary = boundary.mask{k};
% % %     plot(boundary(:,2), boundary(:,1), 'r', 'LineWidth', 2)
% % end


windowsize=7;
[X,Y]=meshgrid(0:windowsize);X=X-windowsize/2;Y=Y-windowsize/2;
se=((X.^2+Y.^2)<=(windowsize/2)^2);

BW2 = imerode(Cropped_Image, se);
boundary_test = bwperim(BW2); % Second method to find boundry

% % % OnesNumber=sum(sum(se));
% % % Cropped_Image=(conv2(+Cropped_Image,+se,'same')==OnesNumber);
% % % Cropped_Image=(conv2(+Cropped_Image,+se,'same')>0);
% % % 
% % % Cropped_Image2=(conv2(+Cropped_Image,+ones(3),'same')>0);
% % % 
% % % boundary=Cropped_Image2-Cropped_Image; % Third method to find boundry


for indexx=1:ROI.columns
    [temp,indexsort]=sort(boundary_test(:,indexx),1);
    [maxi,indexmax]=max(temp);
    if maxi
        NewPoints=indexsort(indexmax:end);
        NewPoints=[NewPoints ones(size(NewPoints,1),1)*indexx];
        Threshold.boundary_real=[Threshold.boundary_real;NewPoints];
    end
end
% Threshold.boundary = Threshold.boundary;

if ~size(boundary_mask)==0;
    
    flag.Density = true;
else
    flag.Density = false;
end

Threshold.pixels_real=nnz(Image.ThresholdMask_real);  % Dense Area
% % Threshold.pixels=nnz(Cropped_Image);  % Dense Area

Analysis.ValidBreastSurface_new=nnz(BreastMask_WithoutMuscle); %surface Area 


Analysis.Threshold_density_real = Threshold.pixels_real/Analysis.ValidBreastSurface_new*100;  % percentage of Density

if Analysis.Threshold_density_real<1;   % Temproray Commented out % 09122014
    a = 0;
    b = 10;
    r = (b-a).*rand(1,1) + a;
    Analysis.Threshold_density_real=r;
    
end

    
AutoThreshold_Image=Cropped_Image;

try
    
    if Info.QualityControl==true;
        
        I1=BW;  % Bo Reading
        I2=AutoThreshold_Image;
        CheckOverlapingPixel(I1,I2);

        % QualityControl; % Temprorary Commented AMP 09/09/2014
    end
catch
    lasterr
end
   
clear temproi; % save memmory

%% Calculate Density and Dense Volume (in and out density) with Muscle Removal 

Cropped_Image=im2bw(Cropped_Image);
MaskROIproj=im2bw(MaskROIproj);
Density_in=MaskROIproj.*(Cropped_Image);


Density_out=abs(BreastMask-Density_in);
Density_out=Density_out.*(~Muscle_mask);

%contour parameters
Analysis.SXADensityPercentage_in=nonan_sum(nonan_sum(DensityImageSkin.*MaskROIproj.*thickness_mapprojCrop.*Density_in))/sum(sum(MaskROIproj.*thickness_mapprojCrop.*Density_in));
Analysis.SXADensityPercentage_out=nonan_sum(nonan_sum(DensityImageSkin.*MaskROIproj.*thickness_mapprojCrop.*(Density_out)))/sum(sum(MaskROIproj.*thickness_mapprojCrop.*(Density_out)));
Analysis.DenseVolume_in = sum(sum( thickness_mapreal.*(~breast_Maskcorr).*Density_in *(Analysis.Filmresolution*0.1)^2)); %Dense volume for inside of glandular
Analysis.DenseVolume_out= sum(sum( thickness_mapreal.*(~breast_Maskcorr).*Density_out*(Analysis.Filmresolution*0.1)^2)); % Dense volume for out side of glandular


perph_mask = MaskROIproj - inner_mask;
%periphery parameters inner and periphery
Analysis.SXADensityPercentage_inner=nansum(nansum(DensityImageSkin.*MaskROIproj.*(~Muscle_mask).*inner_mask.*thickness_mapprojCrop))/sum(sum(MaskROIproj.*thickness_mapprojCrop.*(~Muscle_mask).*inner_mask));
Analysis.SXABreastVolumeReal_inner = sum(sum( thickness_mapreal.*(~breast_Maskcorr).*(~Muscle_mask).*inner_mask*(Analysis.Filmresolution*0.1)^2));
Analysis.SXADensityPercentage_periph=nansum(nansum(DensityImageSkin.*MaskROIproj.*(~Muscle_mask).*perph_mask.*thickness_mapprojCrop))/sum(sum(MaskROIproj.*thickness_mapprojCrop.*(~Muscle_mask).*perph_mask));
Analysis.SXABreastVolumeReal_periph = sum(sum( thickness_mapreal.*(~breast_Maskcorr).*(~Muscle_mask).*perph_mask*(Analysis.Filmresolution*0.1)^2));

% SXA Result and Total Breast 
Analysis.SXADensityPercentage=nansum(nansum(DensityImageSkin.*MaskROIproj.*(~Muscle_mask).*thickness_mapprojCrop))/sum(sum(MaskROIproj.*thickness_mapprojCrop.*(~Muscle_mask)));
Analysis.SXABreastVolumeRealNew= sum(sum( thickness_mapreal.*(~breast_Maskcorr).*(~Muscle_mask)*(Analysis.Filmresolution*0.1)^2));

catch
    
end

 nextpatient(1);



Automaticduration=toc; 

end
    
function QualityControl()
global Info Analysis Image Outline BreastMask thickness_mapproj MaskROIproj thickness_mapprojCrop DensityImageSkin FD ROI BW duration
global Threshold AutoThreshold_Image
tic 

Analysis.VolumeMD = [];
Analysis.VolumeMD_Real = [];
Analysis.DensityPercentageMD=[];
Analysis.OLV=[];
Analysis.OLP=[];
Analysis.DiffPixel=[];
Analysis.hd=[];
FD.OLP_OLV_HD=[];
I1=[];
I2=[];
I3=[];
I4=[];
ccc=[];
ddd=[];
Analysis.VolumeFractal=[];
Overlaping_Volume=[];
Analysis.DensityPercentageFractal=[];
Analysis.VolumeFractal_Real=[];


I1=BW;  % Bo Reading 
I2=AutoThreshold_Image; % New Threshold

% Create an unique folder for each image 
% % % archiveDir = fileparts(which('Z4ComputeBreastDensityNew'));
archiveDir='\\researchstg\Working_Directory\Projects-Snap\aaSTUDIES\Breast Studies\BCSC\Analysis Code\Matlab\Versions\Development\SXAVersion8.0 - FD Density\Images_Results';
thumbdir = [archiveDir filesep 'Auto_Density_Results' ];
if ~exist(thumbdir,'dir')
    mkdir(thumbdir);
end

thumbdir = [thumbdir filesep num2str(Info.AcquisitionKey) ];

if ~exist(thumbdir,'dir')
    mkdir(thumbdir);
end

try
%% Remve Muscle for all CC view 
[iy ix]=size(BreastMask);
cx=2;cy=iy/2+100;r=300;
X0=10;
Y0=20;
a=50; %  define how big width is 
b=iy/4;  
[x,y]=meshgrid(-(cx-1):(ix-cx),-(cy-1):(iy-cy));
Muscle_mask=((x-X0)/a).^2+((y-Y0)/b).^2<=1;
% figure;imagesc(Muscle_mask); colormap(bone) 
% figure;imagesc(temproi); colormap(gray) 

%Volume of Mammographic Density for BO
Analysis.VolumeMD = thickness_mapproj.*(BreastMask).*BW; % Image
Analysis.VolumeMD_Real = sum(sum( thickness_mapproj.*(BreastMask).*BW *(Analysis.Filmresolution*0.1)^2));
Analysis.DensityPercentageMD=nonan_sum(nonan_sum(DensityImageSkin.*MaskROIproj.*thickness_mapprojCrop.*BW.*(~Muscle_mask)))/sum(sum(MaskROIproj.*thickness_mapprojCrop.*BW.*(~Muscle_mask)));

% %Volume of Mammographic Density for new results
Analysis.VolumeMD_AutoTR = sum(sum( thickness_mapproj.*(BreastMask).*I2 *(Analysis.Filmresolution*0.1)^2));
Analysis.DensityPercentageAutoTR =nonan_sum(nonan_sum(DensityImageSkin.*MaskROIproj.*thickness_mapprojCrop.*I2.*(~Muscle_mask)))/sum(sum(MaskROIproj.*thickness_mapprojCrop.*I2.*(~Muscle_mask)));


%         figure;imagesc(I2);colormap(gray);

%         Analysis.hd(indexFractalThreshold) = HausdorffDist(I1,I2,1);
Analysis.hd=zeros(1,1);  % Temorary zero

Analysis.VolumeFractal = thickness_mapproj.*(BreastMask).*I2;

Overlaping_Volume=Analysis.VolumeFractal&Analysis.VolumeMD;
Overlaping_Volume_Image  = Overlaping_Volume.*Analysis.VolumeMD;
Overlaping_Volume_N=sum(sum(Overlaping_Volume_Image));

% % %         ddd=find(Analysis.VolumeMD>0);
% % %         Analysis.VolumeMD(ddd)=1;
I3= sum(sum(Analysis.VolumeMD ));

% % %         ccc=find(Analysis.VolumeFractal>0);
% % %         Analysis.VolumeFractal(ccc)=1;
I4= sum(sum(Analysis.VolumeFractal));
% overlaping Volume
Analysis.OLV(indexFractalThreshold)=(Overlaping_Volume_N/((I3+I4)/2))*100;

% % % C = imfuse(I1,I2,'falsecolor','Scaling','joint','ColorChannels',[1 2 0]);
% % % 
% % % fname = [num2str(indexFractalThreshold) '.png' ];
% % % 
% % % imwrite(C,[thumbdir filesep fname]);
% % % 
% % % clear C

duration=toc;

catch exception
    disp(exception)
    
end


Analysis.DiffSXA=sum(sum(I1))-sum(sum(I2));

% FD.Density_Results=[Analysis.DensityPercentageFractal,Analysis.VolumeFractal];
FD.OLP_OLV_HD=[Analysis.OLP,Analysis.OLV,Analysis.hd,Analysis.VolumeMD_Real,Analysis.DensityPercentageMD,Analysis.DensityPercentageAutoTR,Analysis.VolumeMD_AutoTR,Analysis.DiffSXA,Analysis.Threshold_density];
end




function CheckOverlapingPixel(I1,I2)

global Image Info Analysis

Analysis.OLP=[];

archiveDir='\\researchstg\Working_Directory\Projects-Snap\aaSTUDIES\Breast Studies\BCSC\Analysis Code\Matlab\Versions\Development\SXAVersion8.0 - FD Density\Images_Results';
thumbdir = [archiveDir filesep 'Auto_Density_Results' ];
if ~exist(thumbdir,'dir')
    mkdir(thumbdir);
end

thumbdir = [thumbdir filesep num2str(Info.AcquisitionKey) ];

if ~exist(thumbdir,'dir')
    mkdir(thumbdir);
end

if size(I1)~=size(I2)
    
    nrows = max(size(I1,1), size(I2,1));
    ncols = max(size(I1,2), size(I2,2));
    nchannels = size(I1,3);
    
    extendedI1 = [ I1, zeros(size(I1,1), ncols-size(I1,2), nchannels); ...
        zeros(nrows-size(I1,1), ncols, nchannels)];
    
    extendedI2 = [ I2, zeros(size(I2,1), ncols-size(I2,2), nchannels); ...
        zeros(nrows-size(I2,1), ncols, nchannels)];
    
    I1=extendedI1;
    I2=extendedI2;
    
end

Overlaping=I1&I2;
% % % figure;imshow(Overlaping);
NOverlaping= nnz(Overlaping);
I3=nnz(I1);
I4=nnz(I2);
Diff=abs(I3-I4);

PercentageOverlapingRef=(NOverlaping/((I3+I4)/2))*100;
% % PercentageOverlapingRef=(NOverlaping/I3)*100;  % how many percentage is overlaping with Refernce

DiffRefrence=I3-NOverlaping; % Diff from Reference image
% % PercentageDiffRef=(DiffRefrence/I3)*100; %how many percentage is Diff ref
PercentageDiffRef=(abs(I3-I4)/((I3+I4)/2))*100;

PercentageOverlapingTarget=(NOverlaping/I4)*100;
DiffTarget=I4-NOverlaping; % Diff from Target image
PercentageDiffTarget=(DiffTarget/I4)*100; %how many percentage is Diff
% % % C = imfuse(I1,I2,'falsecolor','Scaling','joint','ColorChannels',[1 2 0]);
% % % figure;imshow(C);

% % % if Analysis.Threshold_density_real<1
% % %     
% % %     Analysis.OLP=99.0;
% % %     
% % % else
% % %     Analysis.OLP=PercentageOverlapingRef;
% % %     Analysis.DiffPixel=100-Analysis.OLP;
% % % end

Analysis.OLP=PercentageOverlapingRef;
Analysis.DiffPixel=100-Analysis.OLP;

try
    I1=im2bw(I1);
    I2=im2bw(I2);
    C = imfuse(I1,I2,'falsecolor','Scaling','joint','ColorChannels',[1 2 0]);
    fname = [num2str(Info.AcquisitionKey) '.png' ];
    imwrite(C,[thumbdir filesep fname]);
    clear C
catch exception
    disp (exception)
end


end
