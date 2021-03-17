function  LoadAnnotation_auto(annofile_name)
global  Image ROI flip_info FreeForm patient_ID image file
    FreeForm = [];
%     [fileName, pathName]=uigetfile('\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\UCSF_Annotation_images\AnnotationsUCSF_Bonnie\*.mat', 'Please select Annotation file.');
%     %[fileName, pathName]=uigetfile('\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\Moffitt\Moffitt_Annotation_images\Annotations\Annotations _submitted 3-21-14\*.mat', 'Please select Annotation file.');
%     annofile_name = [pathName,fileName];
    load(annofile_name);
    
%      figure;imagesc(image);colormap(gray); hold on;
%      plot(FreeForm.FreeFormCluster.face(:,1),FreeForm.FreeFormCluster.face(:,2),'-g');
    %flip_info = [Info.flipH Info.flipV];
    
%     if ~isempty(strfind(file.startpath,'UCSF')) %commented by SM on 10-05-2016
%              

% added freefrom select for freeform.freeformcluster sypks 4.3.2018
% this solves many issues relating to loading .mat files into FreeForm data
% structure since some structures have multiple fields (different setups)
% from past calculations and use.
        
        if flip_info(1) == true & flip_info(2) == true
            for i=1:length(FreeForm.FreeFormCluster(1,FreeForm.FreeFormSelect,:)) %error !!!length(FreeForm.FreeFormnumber)
            FreeForm.FreeFormCluster(1,FreeForm.FreeFormSelect,i).face = flip_xy(FreeForm.FreeFormCluster(1,FreeForm.FreeFormSelect,i).face, size(image), 'flipH')
             FreeForm.FreeFormCluster(1,FreeForm.FreeFormSelect,i).face = flip_xy(FreeForm.FreeFormCluster(1,FreeForm.FreeFormSelect,i).face, size(image), 'flipV')
            end 
            image=flipdim(image,2);  %Horizontal
             image=flipdim(image,1); %Vertical
        elseif flip_info(1) == true & flip_info(2) == false
            for i=1:length(FreeForm.FreeFormCluster(1,FreeForm.FreeFormSelect,:))
            FreeForm.FreeFormCluster(1,FreeForm.FreeFormSelect,i).face = flip_xy(FreeForm.FreeFormCluster(1,FreeForm.FreeFormSelect,i).face, size(image), 'flipH')
            end
            image=flipdim(image,2);    
        elseif flip_info(1) == false & flip_info(2) == true
           for i=1:length(FreeForm.FreeFormCluster(1,FreeForm.FreeFormSelect,:)) 
            FreeForm.FreeFormCluster(1,FreeForm.FreeFormSelect,i).face = flip_xy(FreeForm.FreeFormCluster(1,FreeForm.FreeFormSelect,i).face, size(image), 'flipV')
           end 
            image=flipdim(image,1);    
        elseif flip_info(1) == false & flip_info(2) == false
            ;
        end
%     else
%         flip_info = [0 0];
%     end
       
    
    Image.LEPresFlipped = image;
    clear image;
    % Image.Tmask3C = double(imread(thickfile_name))/1000;
    
    %figure;imshow(image);colormap(gray); hold on;
%     figure;imagesc(Image.LEPres);colormap(gray);hold on;
% %     figure;imagesc(Image.LEPresFlipped);colormap(gray); hold on;
% %      plot(FreeForm.FreeFormCluster.face(:,1),FreeForm.FreeFormCluster.face(:,2),'-g');
end

%% ORIGINAL UNTOUCHED FROM UCSF 4.3.2018 sypks
%{
function  LoadAnnotation_auto(annofile_name)
global  Image ROI flip_info FreeForm patient_ID image file
    FreeForm = [];
%     [fileName, pathName]=uigetfile('\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\UCSF_Annotation_images\AnnotationsUCSF_Bonnie\*.mat', 'Please select Annotation file.');
%     %[fileName, pathName]=uigetfile('\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\Moffitt\Moffitt_Annotation_images\Annotations\Annotations _submitted 3-21-14\*.mat', 'Please select Annotation file.');
%     annofile_name = [pathName,fileName];
    load(annofile_name);
    
%      figure;imagesc(image);colormap(gray); hold on;
%      plot(FreeForm.FreeFormCluster.face(:,1),FreeForm.FreeFormCluster.face(:,2),'-g');
    %flip_info = [Info.flipH Info.flipV];
    
%     if ~isempty(strfind(file.startpath,'UCSF')) %commented by SM on 10-05-2016
%              

        if flip_info(1) == true & flip_info(2) == true
            for i=1:length(FreeForm.FreeFormCluster(1,:)) %error !!!length(FreeForm.FreeFormnumber)
            FreeForm.FreeFormCluster(1,i).face = flip_xy(FreeForm.FreeFormCluster(1,i).face, size(image), 'flipH')
             FreeForm.FreeFormCluster(1,i).face = flip_xy(FreeForm.FreeFormCluster(1,i).face, size(image), 'flipV')
            end 
            image=flipdim(image,2);  %Horizontal
             image=flipdim(image,1); %Vertical
        elseif flip_info(1) == true & flip_info(2) == false
            for i=1:length(FreeForm.FreeFormCluster(1,:))
            FreeForm.FreeFormCluster(1,i).face = flip_xy(FreeForm.FreeFormCluster(1,i).face, size(image), 'flipH')
            end
            image=flipdim(image,2);    
        elseif flip_info(1) == false & flip_info(2) == true
           for i=1:length(FreeForm.FreeFormCluster(1,:)) 
            FreeForm.FreeFormCluster(1,i).face = flip_xy(FreeForm.FreeFormCluster(1,i).face, size(image), 'flipV')
           end 
            image=flipdim(image,1);    
        elseif flip_info(1) == false & flip_info(2) == false
            ;
        end
%     else
%         flip_info = [0 0];
%     end
       
    
    Image.LEPresFlipped = image;
    clear image;
    % Image.Tmask3C = double(imread(thickfile_name))/1000;
    
    %figure;imshow(image);colormap(gray); hold on;
%     figure;imagesc(Image.LEPres);colormap(gray);hold on;
% %     figure;imagesc(Image.LEPresFlipped);colormap(gray); hold on;
% %      plot(FreeForm.FreeFormCluster.face(:,1),FreeForm.FreeFormCluster.face(:,2),'-g');
end




%}


