function dream_python_pngcreationUCSF()
global Image Info Analysis ROI   BreastMask
Info.DigitizerId = 9;
input_dir = 'F:\Dream_contest2\Training_Nikulin\DDSM_1\src\DICOMS_3CBraw';

 output = [];
 dcm_files = dir(input_dir);
 len = length(dcm_files);
 numrows = 1152;
 numcols = 832;
  count = 0;
  png_fnamestack = [input_dir,'_noSXApng\stack.png'];
 
  dicom_fname = [dcm_files(3).folder,'\',dcm_files(3).name];
   info_dicom = dicominfo(dicom_fname);
 for i = 7:10
%      try
    dicom_fname = [dcm_files(i).folder,'\',dcm_files(i).name];
%      info_dicom = dicominfo(dicom_fname);
    image2=double(dicomread(dicom_fname));
%     orientation = info_dicom.PatientOrientation;
%     image_flipped = flip_image2(XX,orientation);
%      image_flipped = XX;
%      if strcmp(info_dicom.PresentationIntentType, 'FOR PROCESSING')         
%          breast_mask = zeros(size(image_flipped));
%          mask= (image_flipped > 0); 
%          stats = regionprops(mask,'Image','Area','PixelIdxList');   
%         [maxValue,index] = max([stats.Area]);
%         breast_mask = zeros(size(image_flipped));
%         breast_mask(stats(index).PixelIdxList)=1;
%      else
        breast_mask = zeros(size(image2));
        phantom_mask = zeros(size(image2));
        se_1 = strel('disk',20); 
        se_2 = strel('disk',10); 
        
       image2(find(image2<0)) = 1;        
       image = -log(image2)*1000 + 9000;
%         figure;imagesc(image);colormap(gray);
         
         Ibkg = background_phantomdigital(image(20:end-50, 50:end-50)*10)/10;
     
%         level = graythresh(image(20:end-50, 50:end-50));
%         if level == 0
%             level = 0.4412;
%         end
%         mask = imbinarize(image,level);
        mask = image>Ibkg+300;
        mask = imdilate(mask,se_1);            
         mask = imerode(mask,se_2);
          figure;imagesc(mask);colormap(gray);
        
        
%         figure;imagesc(mask);colormap(gray);
        stats = regionprops(mask,'FilledImage','Area','PixelIdxList');   
        [maxValue,index] = max([stats.Area]);
        breast_mask(stats(index).PixelIdxList)=1;
%         figure;imagesc(mask);colormap(gray);
     if length(stats) > 1
        stats(index) = [];
        [maxValue,index] = max([stats.Area]);
        phantom_mask(stats(index).PixelIdxList)=1;
%         figure;imagesc(mask);colormap(gray);
         se = strel('disk',150);  
           se1 = strel('disk',50);  
        im1 =    imdilate(phantom_mask,se1);
        out_mask = imdilate(phantom_mask,se) - im1;
%         figure;imagesc(out_mask);colormap(gray);
%         bkgr_image = out_mask.*image_flipped;
        index = find(out_mask==1);
        mean_val = mean(image(index));
        phantom_mask = imdilate(phantom_mask,se);
        index = find(phantom_mask==1);
        image(index) = mean_val;   
        image = image - mean_val;
     else
           se = strel('disk',150);  
           se1 = strel('disk',50);  
        im1 =    imdilate(breast_mask,se1);
        out_mask = imdilate(breast_mask,se) - im1;
%         figure;imagesc(out_mask);colormap(gray);
%         bkgr_image = out_mask.*image_flipped;
        index = find(out_mask==1);
        mean_val = mean(image(index));
        breast_mask = imdilate(breast_mask,se);
        index = find(breast_mask==1);
        image(index) = mean_val;   
        image = image - mean_val;
     end    
     
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      se3 = strel('disk',3);    
                breast_mask = imdilate(breast_mask,se3);
                BW=breast_mask;
                bkBW = ~BW;
                stats1 = regionprops(BW,'centroid','Area','PixelIdxList');
                [maxValue1,index1]  = max([stats1.Area]);
                cent1 = stats1(index1).Centroid;
                 breast_mask = zeros(size(image));
                 breast_mask(stats1(index1).PixelIdxList)=1;
                stats2 = regionprops(bkBW,'centroid','Area','PixelIdxList');
                [maxValue2,index2]  = max([stats2.Area]);
                cent2= stats2(index2).Centroid;  
                image = image.*breast_mask;
    
                if cent1(1) > cent2(1)
                    image =flip(image,2);
                    breast_mask =flip(breast_mask,2);
                end
     
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     
     
     
     
%         level = graythresh(image(20:end-50, 50:end-50));
%         if level == 0
%             level = 0.4412;
%         end
%         breast_mask = imbinarize(image,level);
        breast_mask = imdilate(breast_mask,se_2);
        image  = image.*breast_mask;
%         figure;imagesc(image);colormap(gray);
        image2 = TOPHAT3(image, breast_mask);
       
                if cent1(1) > cent2(1)
                    image2 =flip(image2,2);
                    breast_mask =flip(breast_mask,2);
                end
         figure;imagesc(image2);colormap(gray);   
%          image2 = histeq(image2)
%           figure;imagesc(image2);colormap(gray); 
    % breast commente by one %   
%      se = strel('disk',3);   
% %     image2 = deflip_image2(image_flipped,orientation); 
% %     image2 = image_flipped;
%    
%     se = strel('disk',150);  
%     se1 = strel('disk',50);  
%     out_breast = imdilate(breast_mask,se) - breast_mask;
%     index = find(out_breast==1);
%     mean_bkgr = mean(image(index));
%     image = image - mean_bkgr;
%     image  = image.*breast_mask;
%    image2 = imresize(image,[numrows numcols]);
   count = count + 1
   image3 = imresize(image2,[64 64]);
%    imwrite(image_stack(:, :, count),  png_fnamestack, 'WriteMode', 'append',  'Compression','none');
   
%       figure;imagesc(image3);colormap(gray);
   png_fname = [dcm_files(i).folder,'_noSXApng\',dcm_files(i).name(1:end-4),'.png'];
   jpg_fname = [dcm_files(i).folder,'_noSXApng\JPG\',dcm_files(i).name(1:end-4),'.jpg'];
%     dicomwrite(uint16(image2),dicom_fname,info_dicom,'CreateMode','copy');
    imwrite(uint16(image2),png_fname);
    imwrite(uint8(image3),jpg_fname);
%     figure;imagesc(image2);colormap(gray);
%     end  
    
%      catch
%          output = {output;dcm_files(i).name}
%      end    
    a= 1;
 end
%    dicomwrite(image_stack,dicom_fname,info_dicom,'CreateMode','copy');
 
a = 1;
end

 
          