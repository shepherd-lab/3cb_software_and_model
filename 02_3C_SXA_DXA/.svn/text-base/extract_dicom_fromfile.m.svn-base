function  extract_dicom_fromfile()
   %acq_idlist = readscan('C:\Documents and Settings\smalkov\My Documents\SeleniaImages\selenia5april.txt', ); 
  % len = length(acq_idlist);
    fid = fopen('C:\Documents and Settings\smalkov\My Documents\SeleniaImages\selenia5april.txt');
    C = textscan(fid, '%s');
    fclose(fid);
   
    
   D = 'C:\Documents and Settings\smalkov\My Documents\SeleniaImages\5April\';
   %str_list = num2str(acq_idlist(i));
   %nv = C{1}{1}
   %filename = [D, nv];

  for i = 18:32%len
   nv = C{1}{i}
    filename = [D, nv];
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
    %figure;imagesc(I); colormap(gray);
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
    p = parameters
end