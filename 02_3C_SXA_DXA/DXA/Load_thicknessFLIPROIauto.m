function [ output_args ] = Load_thicknessFLIPROIauto( thickfile_name )
global  Image Tmask3C ROI flip_info 
%   0806618 comments added by sypks

%     [fileName, pathName]=uigetfile('\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\*.mat', 'Please select thickness map file.');
%     thickfile_name = [pathName,fileName];

%   load thickness file in and scale if value is greater than 1000
%   as of 080618 it is unclear as to why scaling is done 

    load(thickfile_name);
     if max(max(thickness_map)) > 1000
        Image.Tmask3C = double(thickness_map/1000);
     else
         Image.Tmask3C = double(thickness_map);
     end
     
%      else% + 0.5 for 3C01019;% - 0.7 for  3C01014;
% %      Image.Tmask3C = double(imread(thickfile_name))/1000;
%        Image.Tmask3C = double(thickness_map);
%      end
     Tmask3C = Image.Tmask3C;
% %      Tmask3C = Image.Tmask3C - 0.1;
%      figure;imagesc(Image.Tmask3C);colormap(gray);
end

