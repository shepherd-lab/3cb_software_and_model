function count = dicomread_fromdisk(disk_name,dir_name)
    a = dir(disk_name);
    len = size(a);
   % cmd /c  dir  P:\aaSTUDIES\Breast Studies\Hawaii DXA Study\Source Data\LE_HE_images\Breast_scans /b > C:\titles.txt
    %A = [];
    %B = [];
    %file_name = 'C:\Documents and Settings\smalkov\My Documents\SeleniaImages\selenia09May_2.txt' 
     %fid = fopen(file_name,'a');
   % Dw = 'C:\Documents and Settings\smalkov\My Documents\SeleniaImages\09May_2\';
     Dw = [dir_name,'\'];
    % Dr = 'E:\';   
   count = 0; 
   for i = 1:len(1)
        file_names = dir([disk_name,'\',a(i).name]);
        sza = size(file_names);
        lenf = sza(1);
        for k = 3:lenf
            filename_read = [disk_name,'\',a(i).name,'\',file_names(k).name]  
            filename_write = [Dw,file_names(k).name(1:end-4)];
            info = dicominfo(filename_read);
            mat_filename=[filename_write '.mat' ];
            save(mat_filename, 'info');
            XX = dicomread(filename_read);
            XX1=round(UnderSamplingN(XX,2));
            clear XX;
            mmax = max(max(XX1));
            mmin = min(min(XX1));
           % I = -log( XX1 /mmax )* 10000;
            png_filename=[filename_write 'png.png' ];
            imwrite(uint16(XX1),png_filename,'PNG');
            count = count +1
          %fprintf(fid,'%s\n',b);
          %fwrite(fid,b,'uint8')
          % fwrite(fid,'\n','uint8')
        end
   end

   
    
   
     
   
   
  end