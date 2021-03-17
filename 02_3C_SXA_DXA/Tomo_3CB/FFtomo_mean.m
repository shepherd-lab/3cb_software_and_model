function FFHE_mean = FFtomo_mean()
   dir_name = 'X:\Breast Studies\3C_data\RO1_3Cimages\UCSF\3CB_TOMO\BR3D_40cm\FFHE\png_files';
   im_test = imread([dir_name,'\FFHE1raw.png']);
   im = zeros(size(im_test));
   fname_towrite =  [dir_name,'\FFHEmean.png'];
   for i=1:9
       fname = [dir_name,'\FFHE',num2str(i),'raw.png'];
       im_cur = double(imread(fname));
       im = imadd(im,im_cur);
   end
   FFHE_mean = im/9;
   figure;imagesc( FFHE_mean);colormap(gray);
   figure;imagesc( im_test);colormap(gray);
   imwrite(uint16(FFHE_mean),fname_towrite);
   a = 1;
   
   %%
   
   
   dir_name = 'X:\Breast Studies\3C_data\RO1_3Cimages\UCSF\3CB_TOMO\BR3D_40cm\FFLE\png_files';
   im_test = imread([dir_name,'\FFLE1raw.png']);
   im_ones = ones(size(im_test));
   fname_towrite =  [dir_name,'\FFLEmean.png'];
   imwrite(uint16(im_ones),fname_towrite);
       