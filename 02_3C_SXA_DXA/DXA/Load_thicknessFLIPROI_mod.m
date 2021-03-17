function [ output_args ] = Load_thicknessFLIPROI( input_args )
global  Image Tmask3C ROI flip_info 
    [fileName, pathName]=uigetfile('\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\*.mat', 'Please select thickness map file.');
    thickfile_name = [pathName,fileName];
    load(thickfile_name);
     if max(max(thickness_map)) > 1000
        Image.Tmask3C = double(thickness_map/1000);
     end
%      else% + 0.5 for 3C01019;% - 0.7 for  3C01014;
% %      Image.Tmask3C = double(imread(thickfile_name))/1000;
%        Image.Tmask3C = double(thickness_map);
%      end
     Tmask3C = Image.Tmask3C;
     figure;imagesc(Image.Tmask3C);colormap(gray);
end

