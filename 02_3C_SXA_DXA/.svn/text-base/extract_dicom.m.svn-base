function [parameters, info] = extract_dicom(filename)
    
   XX = dicomread(filename);
    XX1=round(UnderSamplingN(XX,2));
    clear XX;
    png_filename=[filename 'png.png' ];
    mmax = max(max(XX1))
    mmin = min(min(XX1))
    I = -log( XX1 /mmax )* 10000;
    mmax = max(max(I))
    mmin = min(min(I))
    %{  
    XX1 = -log( XX /mmax );
    mmax1 = max(max(XX1))
    mmin1 = min(min(XX1))
    XX2 = XX1 * 10000;  
    mmax2 = max(max(XX2))
    mmin2 = min(min(XX2))
    %XX3 = XX2 - mmin2;
    %} 
    figure;imagesc(I); colormap(gray);
    imwrite(uint16(I),png_filename,'PNG');
    info = dicominfo(filename);
    parameters{1} = info.KVP;
    parameters{2} = info.Exposure;
    parameters{3} = info.ExposureControlMode;
    parameters{4} = info.FilterMaterial;
    parameters{5} = info.AnodeTargetMaterial;
    parameters{6} = info.BodyPartThickness;
    %parameters{7} = info.ImageComments;
   % s = xlswrite('tempdata2.xls',parameters );
    p = parameters;