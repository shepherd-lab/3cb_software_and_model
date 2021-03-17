function dream_python_pngcreationUCSF()
global Image Info Analysis ROI   BreastMask
Info.DigitizerId = 9;
input_dir = 'C:\Dream_contest2\Training_Nikulin\DDSM_1\src\DICOMS_3CBpres';
% output_dir = 'C:\Dream_contest2\Training_Nikulin\DDSM_1\src\DICOMS_3CBpres_noSXApng';
 output = [];
 dcm_files = dir(input_dir);
 len = length(dcm_files);
  numrows = 1152;
 numcols = 832;
  count = 0;
 for i = 1:len
     try
    dicom_fname = [dcm_files(i).folder,'\',dcm_files(i).name];
%     info_dicom = dicominfo(dicom_fname);
    image=double(dicomread(dicom_fname));
%     orientation = info_dicom.PatientOrientation;
%     image_flipped = flip_image2(XX,orientation);
   
%     Image.image = image_flipped;
%     Image.OriginalImage = Image.image;
%     Image.maxOriginalImage = double(max(max(Image.OriginalImage)));
%     Image.minOriginalImage = double(min(min(Image.OriginalImage)));
%     ReinitImage(image_flipped,'OPTIMIZEHIST');
%     draweverything;
%     figure;imagesc(image_flipped);colormap(gray);
%     sz_im = size(Image.image);
    
    mask= (image > 0);
    stats = regionprops(mask,'Image','Area','PixelIdxList');
    [maxValue,index] = max([stats.Area]);
    breast_mask = zeros(size(image));
    breast_mask(stats(index).PixelIdxList)=1;
%     figure;imagesc(breast_mask);colormap(gray);
     se = strel('disk',3);   
    breast_mask = imdilate(breast_mask,se);
%     figure;imagesc( breast_mask);colormap(gray);
    image  = image.*breast_mask;   
%     figure;imagesc(image_flipped);colormap(gray);
%     ROIDetection('ROOT');    
%
     image2 = imresize(image,[numrows numcols]);
    
%     figure;imagesc(image2);colormap(gray);
   png_fname = [dcm_files(i).folder,'_noSXApng\',dcm_files(i).name(1:end-4),'.png'];
     imwrite(uint16(image2),png_fname);
   
    count = count + 1
     catch
         output = {output;dcm_files(i).name}
     end    
    a= 1;
 end
  
a = 1;
end

 
          