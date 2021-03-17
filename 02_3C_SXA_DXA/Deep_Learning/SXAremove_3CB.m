function dream_python_pngcreationUCSF()
global Image Info Analysis ROI   BreastMask
Info.DigitizerId = 9;
input_dir = 'F:\Dream_contest2\Training_Nikulin\DDSM_1\src\DICOMS_3CBraw';
 output = [];
 dcm_files = dir(input_dir);
 len = length(dcm_files);
  count = 0;
 for i = 1:len
     try
    dicom_fname = [dcm_files(i).folder,'\',dcm_files(i).name];
    info_dicom = dicominfo(dicom_fname);
    XX=double(dicomread(dicom_fname));
    orientation = info_dicom.PatientOrientation;
    image_flipped = flip_image2(XX,orientation);
%     Image.image = image_flipped;
%     Image.OriginalImage = Image.image;
%     Image.maxOriginalImage = double(max(max(Image.OriginalImage)));
%     Image.minOriginalImage = double(min(min(Image.OriginalImage)));
%     ReinitImage(image_flipped,'OPTIMIZEHIST');
%     draweverything;
     figure;imagesc(image_flipped);colormap(gray);
%     sz_im = size(Image.image);
    
    mask= (image_flipped > 0);
    stats = regionprops(mask,'Image','Area','PixelIdxList');
    [maxValue,index] = max([stats.Area]);
    breast_mask = zeros(size(image_flipped));
    breast_mask(stats(index).PixelIdxList)=1;
%     figure;imagesc(breast_mask);colormap(gray);
     se = strel('disk',3);   
    breast_mask = imdilate(breast_mask,se);
%     figure;imagesc( breast_mask);colormap(gray);
    image_flipped  = image_flipped.*breast_mask;   
%     figure;imagesc(image_flipped);colormap(gray);
%     ROIDetection('ROOT');    
%
    image2 = deflip_image2(image_flipped,orientation);     
%     figure;imagesc(image2);colormap(gray);
    dicom_fname = [dcm_files(i).folder,'_noSXA\',dcm_files(i).name];
    dicomwrite(uint16(image2),dicom_fname,info_dicom,'CreateMode','copy');
    count = count + 1
     catch
         output = {output;dcm_files(i).name}
     end    
    a= 1;
 end
  
a = 1;
end

 
          