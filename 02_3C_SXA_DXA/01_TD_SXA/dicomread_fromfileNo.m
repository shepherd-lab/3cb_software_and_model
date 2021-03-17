function dicomread_fromfile(file_name)
   %acq_idlist = readscan('C:\Documents and Settings\smalkov\My Documents\SeleniaImages\selenia5april.txt', ); 
  % len = length(acq_idlist);
  %'C:\Documents and Settings\smalkov\My Documents\SeleniaImages\selenia26april.txt'  
    
    fid = fopen(file_name);
    C = textscan(fid, '%s');
    fclose(fid);
    len = size(C{1})
    Dw = 'C:\Documents and Settings\smalkov\My Documents\SeleniaImages\26April\';
    Dr = 'E:\VARZOS.NICOLETTE_06023020_MG_17Apr2006\';   
  for i = 1:len(1)
    nv = C{1}{i}
    filename_read = [Dr, nv];
    filename_write = [Dw, nv];
    info = dicominfo(filename_read);
    mat_filename=[filename_write '.mat' ];
    save(mat_filename, 'info');
    XX = dicomread(filename_read);
    XX1=round(UnderSamplingN(XX,2));
    clear XX;
    mmax = max(max(XX1))
    mmin = min(min(XX1))
    I = -log( XX1 /mmax )* 10000;
    png_filename=[filename_write 'rawpng.png' ];
    imwrite(uint16(I),png_filename,'PNG');
  end
   
  function content = dicomread_fromdisk(disk_name,dir_name)
    a = dir(disk_name);
    len = size(a);
   % cmd /c  dir  P:\aaSTUDIES\Breast Studies\Hawaii DXA Study\Source Data\LE_HE_images\Breast_scans /b > C:\titles.txt
   % A = [];
   % B = [];
   % file_name = 'C:\Documents and Settings\smalkov\My Documents\SeleniaImages\selenia09May_2.txt' 
    % fid = fopen(file_name,'a');
    for i = 1:len(1)
        fa = dir([disk_name,'\',a(i).name]);
        sza = size(fa);
        lena = sza(1);
        for k = 3:lena
          b = fa(k).name  
          fprintf(fid,'%s\n',b);
          %fwrite(fid,b,'uint8')
          % fwrite(fid,'\n','uint8')
        end
    end
  fclose(fid)
  

  %fid = fopen(file_name);
  %  C = textscan(fid, '%s');
  %  fclose(fid);
   % len = size(C{1})
    Dw = 'C:\Documents and Settings\smalkov\My Documents\SeleniaImages\09May\';
    Dr = 'E:\';   
 
    
    for i = 1:len(1)
    nv = C{1}{i}
    filename_read = [Dr, nv];
    filename_write = [Dw, nv];
    info = dicominfo(filename_read);
    mat_filename=[filename_write '.mat' ];
    save(mat_filename, 'info');
    XX = dicomread(filename_read);
    XX1=round(UnderSamplingN(XX,2));
    clear XX;
    mmax = max(max(XX1))
    mmin = min(min(XX1))
    I = -log( XX1 /mmax )* 10000;
    png_filename=[filename_write 'rawpng.png' ];
    imwrite(uint16(I),png_filename,'PNG');
  end 
  
  
  
  %mmax = max(max(XX1))
    %mmin = min(min(XX1))
    %I = -log( XX1 /mmax )* 10000;
    %mmax = max(max(I))
    %mmin = min(min(I))
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
  
    
   % parameters{1} = info.KVP;
   % parameters{2} = info.Exposure;
   % parameters{3} = info.ExposureControlMode;
   % parameters{4} = info.FilterMaterial;
   % parameters{5} = info.AnodeTargetMaterial;
   % parameters{6} = info.BodyPartThickness;
    %parameters{7} = info.ImageComments;
   % s = xlswrite('tempdata2.xls',parameters );
    %p = parameters
end