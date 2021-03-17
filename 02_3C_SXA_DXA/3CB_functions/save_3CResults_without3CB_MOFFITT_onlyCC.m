function save_3CResults_without3CB_moff(first, last, center) %first, last, center
%global ROI Image patient_ID flip_info FreeForm file MaskROI_breast Result Tmask3C ROI flip_info maps file;
global Image file flip_info
% % first = 2;
% % last = 96;
% % center = 'moff';
count = 0;
%%%%%% directory cycle
for i=[first:last]
     try
    if strfind(center,lower('ucsf'))
        parentdir = ['\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\',center,'\3C01',num2str(i,'%03.0f'),'\png_files\'];
        parentPresdir = ['\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\',center,'\3C01',num2str(i,'%03.0f'),'\ForPresentation\png_files\'];
        dirname_annotations = '\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\UCSF_Annotation_images\Annotations\';
        dirname_towrite_maps = ['\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\',center,'\3CB_maps_wo3CBorig\'];
        patient_id = ['3C01',num2str(i,'%03.0f')];
    else
        parentdir = ['\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\',center,'\3C02',num2str(i,'%03.0f'),'\png_files\'];
        parentPresdir = ['\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\',center,'\3C02',num2str(i,'%03.0f'),'\ForPresentation\png_files\'];
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
    openLEHEfiles_fromdirectory(parentdir,parentPresdir,view,option);
   % thickfile_name = [pathName,fileName];
   if  ~isempty(strfind(lower(file.startpath),'moff'))
       if i < 46 | i == 50
           fileName = ['LE',view,'raw_Mat.mat'];
           fileName = [parentdir,fileName];
       else
           fileNametemp = [parentdir,'LE', view,'*raw_Mat_v8.0.mat'];
           dd = dir(fileNametemp);
           fileName = [parentdir,dd.name];
           %       fileName = ['LE',view,'raw_Mat_v8.0.mat'];
       end
   else
       fileNametemp = [parentdir,'LE', view,'*raw_Mat_v8.0.mat'];
       dd = dir(fileNametemp);
       fileName = [parentdir,dd.name];
   end
%     thickfile_name = [parentdir,fileName]; %LECCraw_Mat_v8.0.mat   
    thickfile_name = [fileName];
    load(thickfile_name);
    
    Image.Tmask3C = double(thickness_map)/1000;
    annofile_name = [dirname_annotations, patient_id, '_', view, '_annotation.mat']; 
    LoadAnnotation_wo3CB(annofile_name, patient_id);
    save_maps_wo3CB(dirname_towrite_maps, patient_id, view);
    % figure;imagesc(maps.LEPres);colormap(gray);hold on;plot(maps.lesion.xy(:,1), maps.lesion.xy(:,2),'g-');
    
%     view = 'ML';
%     file.fname = [parentdir,'HE',view,'.png'];
%     openLEHEfiles_fromdirectory(parentdir,parentPresdir,view,option);
%     if  ~isempty(strfind(lower(file.startpath),'moff'))
%         if (i < 46 | i == 50)
%             fileName = ['LE',view,'raw_Mat.mat'];
%             fileName = [parentdir,fileName];
%         else
%             fileNametemp = [parentdir,'LE', view,'*raw_Mat_v8.0.mat'];
%             dd = dir(fileNametemp);
%             fileName = [parentdir,dd.name];
%             %       fileName = ['LE',view,'raw_Mat_v8.0.mat'];
%         end
%         
%     else
%         fileNametemp = [parentdir,'LE', view,'*raw_Mat_v8.0.mat'];
%         dd = dir(fileNametemp);
%         fileName = [parentdir,dd.name];
%     end
%     thickfile_name = [fileName];
% %     thickfile_name = [parentdir,fileName]; %LECCraw_Mat_v8.0.mat
%     load(thickfile_name);
%     annofile_name = [dirname_annotations, patient_id, '_', view, '_annotation.mat']; 
%     LoadAnnotation_wo3CB(annofile_name, patient_id);
%     save_maps_wo3CB(dirname_towrite_maps, patient_id, view);   
   % figure;imagesc(maps.LEPres);colormap(gray);hold on;plot(maps.lesion.xy(:,1), maps.lesion.xy(:,2),'g-');
    catch
        lasterror
     count = count + 1
    end
end
 a = 1;
 
 % % %     
% % %     fileName = ['LE',view,'raw_Mat_v8.0.mat'];
% % %     thickfile_name = [parentdir,fileName]; %LECCraw_Mat_v8.0.mat
% % %     load(thickfile_name);
% % %     Image.Tmask3C = double(thickness_map)/1000 % + 0.5 for 3C01019;% - 0.7 for  3C01014;
% % %     Tmask3C = Image.Tmask3C;
% % %      figure;imagesc(Image.Tmask3C);colormap(gray);      
