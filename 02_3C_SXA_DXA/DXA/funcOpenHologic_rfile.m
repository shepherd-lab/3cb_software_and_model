
function funcOpenHologic()
global  acqs_filename Image ctrl Info Analysis Hist
%close all;

Info.DXAModeOn = 1;
%X = load('\\researchstg\Working_Directory\\Shepherd Shared Folders\Projects\Merk_DXA_CT\DXA_Hologic.txt', '-ASCII');
[FileName,PathName] = uigetfile('\\researchstg\Shepherd Shared Folders\Projects\Merk_DXA_CT\*.r*','Select the acquisition list txt-file ');
fname1 = strcat([PathName,FileName]);
Analysis.filename = fname1;
   dxa_resolution = 1;
% % %   %Grabs the High/Low images from the filename fname1
% % %     [airhigh1 airlow1 bonehigh1 bonelow1 tissuehigh1 tissuelow1 x_res y_res] = open_hologic(acqs_filename);
% % % 
% % %     %Processes raw high/low phase images into higher resolution R & HE image
% % %     [r_value he_value] = process_hologic(airhigh1, airlow1, bonehigh1, bonelow1, tissuehigh1, tissuelow1,x_res,y_res);

     %Grabs the High/Low images from the filename fname1
    [airhigh1 airlow1 bonehigh1 bonelow1 tissuehigh1 tissuelow1 x_res y_res] = open_hologic(fname1);

    %Processes raw high/low phase images into higher resolution R & HE image
    [r_value he_value] = process_hologic(airhigh1, airlow1, bonehigh1, bonelow1, tissuehigh1, tissuelow1,x_res,y_res);
    
% % %       [x_res, y_res, air_hi, air_lo, bone_hi, bone_lo, tissue_hi, tissue_lo] = ...
% % %         upsample(x_res, y_res, scan_type, air_hi, air_lo, bone_hi, bone_lo, tissue_hi, tissue_lo);
% % % 
% % %     % process raw high/low phase images into higher resolution hi/lo/R images
% % %     [air_r, air_hi, air_lo, tissue_r, tissue_hi, tissue_lo, bone_r, bone_hi, bone_lo, x_res] = ...
% % %         process_hologic(air_hi, air_lo, bone_hi, bone_lo, tissue_hi, tissue_lo, scan_type, x_res, BG_THRESHOLD);
    
    im_size = size(airhigh1); %one phase image size

    %Compare Physical Pixel Area
    image_y = [0 im_size(1)*y_res];
    image_x = [0 im_size(2)*x_res*6];

    % % %
       R_air1 = r_value;

    R_air1(R_air1<1) = 1;

    %Sets background pixels to "NaN" so as not to be counted in histogram
    bground_pix = find(R_air1==1);
    R_air_no_bg = R_air1;
    R_air1(bground_pix) = 0;
    R_air_no_bg(bground_pix) = NaN;

    %Sets the contrast window
    c_start = 1;
    c_end = 1.3;

    RST = R_air1;
    HE = he_value;
    HE(bground_pix) = 0;

% % %     coef2=X(:,1);
% % %     coef=X(:,2);
% % % 
% % %     material= coef(1)+coef(2)*RST+coef(3)*(HE/1000)+coef(4)*RST.^2+coef(5)*(HE/1000).^2+coef(6)*(HE/1000.*RST);%+50;
% % %     thickness=coef2(1)+ coef2(2)*RST+coef2(3)*(HE/1000)+coef2(4)*RST.^2+ coef2(5)*(HE/1000).^2+coef2(6)*(HE/1000.*RST);%-0.5;%-0.73;%+50;
% % %     material(bground_pix) = 0;
% % %     thickness(bground_pix) = 0;
% % %     Image.material = material;
% % %     Image.thickness = thickness;
% % %     Image.LE = RST.*HE;
    Image.HE = HE;
    Image.RST = RST;
    LE = RST.*HE;
    Image.LE = RST.*HE;
    Image.fnameLE = fname1;
% %      H = fspecial('disk',2);
% % %     femur_fat_muscle = imfilter(femur_fat_muscle,H,'replicate');
% %     material = imfilter(material,H,'replicate');
% %        figure;imagesc(material);colormap(gray);
% %        figure;imagesc(ness);colormap(gray);
% %        figure;imagesc(RST);colormap(gray);
% %        figure;imagesc(HE);colormap(gray);
     Analysis.Step = 0.5;
     draweverything;
       ReinitImage(Image.HE,'OPTIMIZEHIST');
%figure; imagesc(Image.LE);colormap(gray);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    set(ctrl.Cor,'value',false);
    ShowDXAImage('LE');  %show material image
    Result.image=[];
    funcActivateDeactivateButton;
       
       
       
       
       
       
a = 1;
%Opens the Hologic "r" file.
%Input: filename
%Output: Air High & Air Low Images.
function [airhigh airlow bonehigh bonelow tissuehigh tissuelow x_res y_res] = open_hologic(fname)

fid = fopen(fname,'r','l');
fseek(fid, 0, 'eof');
filesize = ftell(fid);
position=fseek(fid, 0, 'bof');

cols = 0;
rows = 0;

phases = 6;

while position<filesize

    recordname=fread(fid,1,'uint16'); %Read in 2byte record name
    recordlength=(fread(fid,1,'uint32')); %Read in 4byte record length
    position=position+recordlength;

    %Always use recordlength-6 because the recordlenght includes the length
    %of recordname(2 bytes) + length of recordlength (4bytes).
    switch (recordname)
        case 1,     record=fread(fid, recordlength-6,'uint8');name=record;
        case 3,     record= fread(fid, recordlength-6,'uint8');pat_id=char(record'); %Patient ID
        case 9,     record= fread(fid, recordlength-6,'uint8');sex=record; %sex
        case 55,    record= fread(fid, recordlength-6,'uint8');test=record;
        case 56,    record = fread(fid,recordlength-6,'uint8'); pointsize=char(record'); %Physical point size
        case 57,    record = fread(fid,recordlength-6,'uint8'); linesize=char(record'); %Physical line size
        case 58,    record = fread(fid,(recordlength-6)/2,'uint16'); cols = record/phases;
        case 59,    record = fread(fid,(recordlength-6)/2,'uint16'); rows = record; dxa_data = zeros([phases*cols*rows 1]);
        case 60,    record = fread(fid,(recordlength-6)/2,'uint16'); num_chan = record;
        case 61,    record = fread(fid,(recordlength-6)/2,'uint16'); phase_odd = record;
        case 62,    record = fread(fid,(recordlength-6)/2,'uint16'); phase_even = record;
        case 63,    record = fread(fid,(recordlength-6)/2,'uint16'); min_dat = record; %Minimum of Hi/Lo bone/tissue/air
        case 64,    record = fread(fid,(recordlength-6)/2,'uint16'); max_dat = record; %Max of hi/lo bone/tissue/air
        case 65,    record = fread(fid,(recordlength-6)/2,'uint16'); off_dat = record;
        case 69,    record = fread(fid,(recordlength-6)/2,'uint16'); left_right = record;
        case 75,    record = fread(fid,recordlength-6,'uint8'); test1=record;
        case 90,    record = fread(fid,recordlength-6,'uint8'); %Not Sure what this does
        case 91,    record = fread(fid,recordlength-6,'uint8'); %Not Sure what this does
        case 202,   record = fread(fid,(recordlength-6)/2,'uint16'); dxa_data = record; %%Read in data
        case 221,   record = fread(fid, (recordlength-6),'uint8'); header = record; %Read in Header
        case 223,   record = fread(fid,recordlength-6,'uint8'); %Not sure what this does
        case 291,   record = fread(fid,recordlength-6, 'uint8'); analysis_key = record;
        otherwise,  record = fread(fid,recordlength-6,'uint8'); %Not sure what this does
    end

end

fclose(fid);


x_res = str2double(pointsize)/10; %Best x-Resolution in cm (counting each measurement separately)
y_res = str2double(linesize)/10; %Resolution in cm

%Initializes matrices to create the individual images
phase = zeros([phases rows*cols]);
airhigh = zeros([rows cols]);
airlow = zeros([rows cols]);
bonehigh = zeros([rows cols]);
bonelow = zeros([rows cols]);
tissuehigh = zeros([rows cols]);
tissuelow = zeros([rows cols]);

%Separate data into 6 different phases
for j=1:rows*cols
    for k=1:phases
        phase(k,j) = dxa_data(phases*(j-1)+k);
    end
end

for j=1:rows
    for k=1:cols
        airhigh(j,k) = (phase(1,cols*(j-1)+k));
        airlow(j,k) = (phase(2,cols*(j-1)+k));
        bonehigh(j,k) = (phase(3,cols*(j-1)+k));
        bonelow(j,k) = (phase(4,cols*(j-1)+k));
        tissuehigh(j,k) = (phase(5,cols*(j-1)+k));
        tissuelow(j,k) = (phase(6,cols*(j-1)+k));
    end
end


end

%Processes the high/low images into high/low attenuation images by finding
%background and subtracting it out.
%Inputs: high & low energy images for each phase, x-resolution, y-resolution
%Ouputs: High resolution R & high resolution HE
function  [high_res_r high_res_he] = process_hologic(airhigh1, airlow1, bonehigh1, bonelow1, tissuehigh1, tissuelow1,x_res,y_res)

%
quarts=[0.25 0.5 0.75];

air_h_quant = quantile(airhigh1(:), quarts);
air_l_quant = quantile(airlow1(:), quarts);
bone_h_quant = quantile(bonehigh1(:), quarts);
bone_l_quant = quantile(bonelow1(:), quarts);
tissue_h_quant = quantile(tissuehigh1(:), quarts);
tissue_l_quant = quantile(tissuelow1(:), quarts);


% %Uses 25 percentile to find background of image
I_air_H0 = air_h_quant(1); I_air_L0 = air_l_quant(1);
I_bone_H0 = bone_h_quant(1); I_bone_L0 = bone_l_quant(1);
I_tissue_H0 = tissue_h_quant(1); I_tissue_L0 = tissue_l_quant(1);

%Sets all pixels within bground_thresh of background to the average value.
bground_thresh = 35;
airhigh1(abs(airhigh1-I_air_H0)<bground_thresh) = I_air_H0;
airlow1(abs(airlow1-I_air_L0)<bground_thresh) = I_air_L0;
bonehigh1(abs(bonehigh1-I_bone_H0)<bground_thresh) = I_bone_H0;
bonelow1(abs(bonelow1-I_bone_L0)<bground_thresh) = I_bone_L0;
tissuehigh1(abs(tissuehigh1-I_tissue_H0)<bground_thresh) = I_tissue_H0;
tissuelow1(abs(tissuelow1-I_tissue_L0)<bground_thresh)=I_tissue_L0;


%Calculates low and high attenuations by subtracting off background
atten_air_h = airhigh1-I_air_H0;
atten_air_l = airlow1-I_air_L0;
atten_bone_h = (bonehigh1-I_bone_H0);
atten_bone_l = (bonelow1-I_bone_L0);
atten_tissue_h = (tissuehigh1-I_tissue_H0);
atten_tissue_l = (tissuelow1-I_tissue_L0);



k_val = 0.98:0.0001:1.05;

k_size=size(k_val);

ripple_bone_he = zeros(size(k_val));
ripple_bone_le = zeros(size(k_val));
ripple_tissue_he = zeros(size(k_val));
ripple_tissue_le = zeros(size(k_val));

for i=1:k_size(2);

    temp1=atten_air_h-k_val(i)*atten_bone_h;
    ripple_bone_he(i)=abs(sum(sum(temp1)));
    temp1=atten_air_l-k_val(i).*atten_bone_l;
    ripple_bone_le(i)=abs(sum(sum(temp1)));
    temp1=atten_air_h-k_val(i).*atten_tissue_h;
    ripple_tissue_he(i)=abs(sum(sum(temp1)));
    temp1=atten_air_l-k_val(i).*atten_tissue_l;
    ripple_tissue_le(i)=abs(sum(sum(temp1)));
end


k_bone_he = k_val((ripple_bone_he==min(ripple_bone_he)));
k_bone_le = k_val((ripple_bone_le==min(ripple_bone_le)));
k_tissue_he = k_val((ripple_tissue_he==min(ripple_tissue_he)));
k_tissue_le = k_val((ripple_tissue_le==min(ripple_tissue_le)));


atten_bone_h = k_bone_he*atten_bone_h;
atten_tissue_h = k_tissue_he*atten_tissue_h;
atten_bone_l=k_bone_le*atten_bone_l;
atten_tissue_l=k_tissue_le*atten_tissue_l;

%Sets up matrices to make sure not to divide by zero
idx1 = find(atten_air_h==0);
atten_air_h(idx1) = 1;
atten_air_l(idx1) = 1;

idx2 = find(atten_bone_h==0);
atten_bone_h(idx2) = 1;
atten_bone_l(idx2) = 1;

idx3 = find(atten_tissue_h==0);
atten_tissue_h(idx3) = 1;
atten_tissue_l(idx3) = 1;

%Calculates R-Value from low & high attenuations for the three
%"adjusted" phases.
R_air = atten_air_l./atten_air_h;
R_bone = atten_bone_l./atten_bone_h;
R_tissue = atten_tissue_l./atten_tissue_h;

%Fixes an R-values < 1 to one.
R_air(R_air<1) = 1;
R_bone(R_bone<1) = 1;
R_tissue(R_tissue<1) = 1;


%Sets background pixels to zero
R_air(R_air==1) = 0;
R_bone(R_bone==1) = 0;
R_tissue(R_tissue==1) = 0;

im_size = size(airhigh1); %one phase image size

high_res_r = zeros(im_size(1),3*im_size(2));
high_res_he = zeros(im_size(1),3*im_size(2));


for i=1:im_size(1)
    for j=1:im_size(2)
        high_res_r(i,3*(j-1)+1) = R_air(i,j);
        high_res_r(i,3*(j-1)+2) = R_bone(i,j);
        high_res_r(i,3*(j-1)+3) = R_tissue(i,j);

        high_res_he(i,3*(j-1)+1) = atten_air_h(i,j);
        high_res_he(i,3*(j-1)+2) = atten_bone_h(i,j);
        high_res_he(i,3*(j-1)+3) = atten_tissue_h(i,j);
    end;
end;

%Compare Physical Pixel Area
% image_y = [0 im_size(1)*y_res];
% image_x = [0 im_size(2)*x_res*6];

% figure, subplot(1,2,1), imshow(high_res_r,[1.0 1.4],'XData',image_x,'YData',image_y), axis image, title('3x Res Image');
% subplot(1,2,2), imshow(R_air,[1.0 1.4],'XData',image_x,'YData',image_y), axis image, title('Low Res Air Image');
%

end



end



