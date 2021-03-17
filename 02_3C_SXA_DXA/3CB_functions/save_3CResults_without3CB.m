function save_3CResults_without3CB(first, last, center) %first, last, center
%global ROI Image patient_ID flip_info FreeForm file MaskROI_breast Result Tmask3C ROI flip_info maps file;
global Image file flip_info FreeForm2 FreeForm
% % first = 2;
% % last = 96;
% % center = 'moff';
count = 0;
%%%%%% directory cycle
for i=[first:last]
%      try
    if strfind(center,lower('ucsf'))
        parentdir = ['\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\',center,'\3C01',num2str(i,'%03.0f'),'\png_files\'];
        dirname_annotations = '\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\UCSF_Annotation_images\Annotations\';
        dirname_towrite_maps = ['\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\',center,'\3CB_maps_wo3CBorig\'];
        patient_id = ['3C01',num2str(i,'%03.0f')];
    else
        parentdir = ['\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\',center,'\3C02',num2str(i,'%03.0f'),'\png_files\'];
        dirname_annotations = '\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\Moffitt\Moffitt_Annotation_images\Annotations\';
        dirname_towrite_maps = ['\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\',center,'\3CB_maps_wo3CBorig\'];
        patient_id = ['3C02',num2str(i,'%03.0f')];
    end
    
    file.startpath =  parentdir;   
    flip_info = [];
    %%%%%%%%%% image open %%%%%%%%%%%%%%%%%%%%
    option = 'Breast ZM10new';
    view = 'CC';
    file.fname = [parentdir,'FFHEraw.png'];
    openLEHEfiles_fromdirectory(parentdir,view,option);
   % thickfile_name = [pathName,fileName];
      
   fileNametemp = [parentdir,'LE', view,'*raw_Mat_v8.0.mat'];
   dd = dir(fileNametemp);
   fileName = [parentdir,dd.name]; 
     thickfile_name = [fileName]; %LECCxxraw_Mat_v8.0.mat
     load(thickfile_name);
    Image.Tmask3C = double(thickness_map)/1000;
    annofile_name = [dirname_annotations, patient_id, '_', view, '_annotation.mat']; 
    LoadAnnotation_wo3CB(annofile_name);
    save_maps_wo3CB(dirname_towrite_maps, patient_id, view);
    % figure;imagesc(maps.LEPres);colormap(gray);hold on;plot(maps.lesion.xy(:,1), maps.lesion.xy(:,2),'g-');
    FreeForm = FreeForm2;
    FreeForm2 = [];
    
    view = 'ML';
    file.fname = [parentdir,'HE',view,'.png'];
    openLEHEfiles_fromdirectory(parentdir,view,option);
    fileNametemp = [parentdir,'LE', view,'*raw_Mat_v8.0.mat'];
   dd = dir(fileNametemp);
   fileName = [parentdir,dd.name]; 
     thickfile_name = [fileName]; %LECCraw_Mat_v8.0.mat
    load(thickfile_name);
    annofile_name = [dirname_annotations, patient_id, '_', view, '_annotation.mat']; 
    LoadAnnotation_wo3CB(annofile_name);
    save_maps_wo3CB(dirname_towrite_maps, patient_id, view);  
    FreeForm = FreeForm2;
   FreeForm2 = [];
    
   % figure;imagesc(maps.LEPres);colormap(gray);hold on;plot(maps.lesion.xy(:,1), maps.lesion.xy(:,2),'g-');
%     catch
%        ll= lasterror
%          FreeForm = FreeForm2;
%      count = count + 1
%     end
end
 a = 1;
 
 % % %     
% % %     fileName = ['LE',view,'raw_Mat_v8.0.mat'];
% % %     thickfile_name = [parentdir,fileName]; %LECCraw_Mat_v8.0.mat
% % %     load(thickfile_name);
% % %     Image.Tmask3C = double(thickness_map)/1000 % + 0.5 for 3C01019;% - 0.7 for  3C01014;
% % %     Tmask3C = Image.Tmask3C;
% % %      figure;imagesc(Image.Tmask3C);colormap(gray);      
