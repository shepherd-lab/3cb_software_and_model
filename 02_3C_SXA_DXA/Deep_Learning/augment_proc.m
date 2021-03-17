function augment_proc()

% tsv_file = 'F:\Dream_contest2\Training_1\training_files\MGH_malignant2.tsv';
tsv_file = 'F:\Dream_contest2\Training_1\training_files\malignant_filenames2.tsv';
tsv_table = tdfread(tsv_file,'tsv');
fid = fopen(tsv_file);
C = textscan(fid, '%s %f'); %, 'HeaderLines', 1
fclose(fid);
name = C{1};
cancer = num2cell(C{2});
len = length(name);
input_dir = 'C:\Users\smalkov\Desktop\Training_1\trainingData\';
% output_dir448 =  'F:\Dream_contest2\trainingData_png448\';

count = 0;
 
 
%  results = zeros(2,len*32);
 results = cell(len*32,2);
 results(1:len,1) = name;
 results(1:len,2) = cancer;  
 len3 = 17;
 results2 = cell(len*len3,2);
 results2(1:len,1) = name;
 results2(1:len,2) = cancer;  

 for i = 1:len
     filename = [input_dir,char(name(i))];
     image = imread(filename);
     image_augm =  image_augmentation(image);
     sz2 = size(image_augm);
     len2 = sz2(3);
     for j=1:len2
        cur_name = char(name(i));
        fname= [cur_name(1:end-4),'_',num2str(j),'.png'];
        fname_full = [input_dir,fname];
        imwrite(image_augm(:,:,j),fname_full,'png');
        cur_index = len+len2*(i-1)+j
        results{len+len2*(i-1)+j,1} = fname;
        results{len+len2*(i-1)+j,2} = cell2mat(results(i,2));
        if j < 18
        results2{len+len3*(i-1)+j,1} = fname;
        results2{len+len3*(i-1)+j,2} = cell2mat(results(i,2));
        end
        
%         tsv_table(end+1,1)=filename;
%         tsv_table(end+1,2)=tsv_table(i,2);
       count = count + 1
     end    
     a = 1;
     
  
%     results{i-2,1} = png_files(i).name;
%     results{i-2,2} = cancer;    

end
  
  Excel('INIT');
  Excel('TRANSFERT',results);
%   
  Excel('INIT');
  Excel('TRANSFERT',results2);
 a = 1;
 end

%    png_fname = [png_files(i).folder,'\', png_files(i).name];
% %      info_dicom = dicominfo(dicom_fname);
%      pres_image = double(imread( png_fname ));    
%     
%     level = graythresh(pres_image);
%     BW = imbinarize(pres_image,level);
%     bkBW = ~BW;
%     
%     stats1 = regionprops(BW,'centroid','Area','PixelIdxList');
%     [maxValue1,index1]  = max([stats1.Area]);
%     cent1 = stats1(index1).Centroid;
%     stats2 = regionprops(bkBW,'centroid','Area','PixelIdxList');
%     [maxValue2,index2]  = max([stats2.Area]);
%     cent2= stats2(index2).Centroid;
%     breast_mask = zeros(size(pres_image));
%     breast_mask(stats1(index1).PixelIdxList)=1;
%     pres_image = pres_image.*breast_mask;
%     
%     if cent1(1) > cent2(1)
%         pres_image =flip(pres_image,2);
%         breast_mask =flip(breast_mask,2);
%     end
%     
%     [xmax,ymin,ymax,xmin] = funcROI(breast_mask);
%     final_image = pres_image(ymin:ymax,xmin:xmax);
%     final_mask =breast_mask(ymin:ymax,xmin:xmax);
%     vert_line = final_mask(:,round(xmax*0.14));
%     vert_index = find(vert_line==1);
%     ymax = max(vert_index);
%     ymin = min(vert_index);
%     size_final = size(final_image);
%     final_image =final_image(ymin:ymax,1:size_final(2));
%     final_image2 = uint16(imresize(final_image,[224 224]));
% %     final_image2 = entropyfilt(final_image2);    
%     filename = [output_dir,png_files(i).name];
%     imwrite(final_image2,filename,'png');
%     
%     final_image = uint16(imresize(final_image,[448 448]));
% %     final_image = entropyfilt(final_image);    
%     filename = [output_dir448,png_files(i).name];
%     name = [png_files(i).name,'.png'];
%     imwrite(final_image,filename,'png');

