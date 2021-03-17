function  flip_image()
      
     [FileName,PathName] = uigetfile('\\ming.radiology.ucsf.edu\aaData\Breast Studies\*.png','Select image file to flip');
     full_filename = [PathName,FileName]; 
     [pathstr,name,ext,versn] = fileparts(full_filename);
     fmat_name = [pathstr(1:end-9),'mat_files\',name,'.mat'];
     load(fmat_name);
     room_name = info_dicom.StationName;
     Info.Position = info_dicom.ViewPosition;
     Info.Laterality = info_dicom.ImageLaterality;

     if strcmp(room_name,'cpbmam1')
         Info.centerlistactivated = 1;
     elseif strcmp(room_name,'cpbmam2')
         Info.centerlistactivated = 2;
     elseif strcmp(room_name,'cpbmam3')
         Info.centerlistactivated = 3;
     elseif strcmp(room_name,'cpbmam4')
         Info.centerlistactivated = 4;
     elseif strcmp(room_name,'cpbmam5')
         Info.centerlistactivated = 5;  
     elseif strcmp(room_name,'cpbmam6')
         Info.centerlistactivated = 6;
     elseif strcmp(room_name,'cpbmam7')
         Info.centerlistactivated = 7;
     elseif strcmp(room_name,'CPMAM1')|strcmp(room_name,'selenia_01')| strcmp(room_name,'CBMAM1') | strcmp(room_name,'UCSF-ZM10')
         Info.centerlistactivated = 116;
     else
         error = 'machine was not found'
         return
     end
     
     image = imread(full_filename,'png');
     %figure; imagesc(image); colormap(gray);
     if Info.centerlistactivated ~= 116
        if (strcmp(Info.Position,'CC') & strcmp(Info.Laterality,'L'))
          image_flipped = flipdim(image,2);
        elseif strcmp(Info.Position,'CC') & strcmp(Info.Laterality,'R')
          image_flipped = flipdim(image,1);
        end
     elseif  Info.centerlistactivated == 116 
        image_flipped = flipdim(image,2);
        image_flipped = flipdim(image_flipped,1);
     else
         error = 'machine was not found'
         return;
     end
     name_length = length(full_filename);
     %f2 = full_filename(name_length-5,name_length);
     
     filename_flipped = [full_filename(1:end-4), '_flipped',full_filename(end-3:end)];
     imwrite(image_flipped,filename_flipped,'png');
     
     %figure; imagesc(image_flipped); colormap(gray);
     
     