function  create_3Creport(  )
global maps_CC maps_ML acqs_filename  mapsML_noflip mapsCC_noflip image FreeForm maps patient_id
% % UNTITLED2 Summary of this function goes here
% %   Detailed explanation goes here
% %  [fileName, pathName]=uigetfile('\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\UCSF_Annotation_images\AnnotationsUCSF_Bonnie\*.mat', 'Please select CC Annotation file.');
% %   %[fileName, pathName]=uigetfile('\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\Moffitt\Moffitt_Annotation_images\Annotations\Annotations _submitted 3-21-14\*.mat', 'Please select Annotation file.');
% %     annofile_name = [pathName,fileName];
% %     load(annofile_name);
CreateReport('NEW');
%[FileName,PathName] = uigetfile('\\researchstg\aaDATA\Breast Studies\*.txt','Select the acquisition list txt-file ');

acqs_filename = '\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\misc\reports_ids_RSNApresentation5.txt';
% %       acqs_filename = [PathName,'\',FileName]; 
temp_acqs = textread(acqs_filename,'%s');

count = 0;
count2 = 0;
for i = 1:length(temp_acqs)
      try
    %     % patient_id = '3C01010';
    annotCC_name = [];
    annotML_name = [];
    patient_id = char(temp_acqs(i));
    if strcmp(patient_id(3:4),'01')
        annotCC_name= ['\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\UCSF_Annotation_images\Annotations\',patient_id,'_CC_annotation.mat'];
        annotML_name=['\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\UCSF_Annotation_images\Annotations\',patient_id,'_ML_annotation.mat'];
    else
        annotCC_name= ['\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\Moffitt\Moffitt_Annotation_images\Annotations\Annotations\',patient_id,'_CC_annotation.mat'];
        annotML_name=['\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\Moffitt\Moffitt_Annotation_images\Annotations\Annotations\',patient_id,'_ML_annotation.mat'];
    end
        
    load(annotCC_name);
    mapsCC_noflip.LEPres = image; %origi    nal image
    mapsCC_noflip.lesion.xy = FreeForm.FreeFormCluster.face;
    clear image FreeForm;
    % %  [fileName, pathName]=uigetfile('\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\UCSF_Annotation_images\AnnotationsUCSF_Bonnie\*.mat', 'Please select ML Annotation file.');
    % %   %[fileName, pathName]=uigetfile('\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\Moffitt\Moffitt_Annotation_images\Annotations\Annotations _submitted 3-21-14\*.mat', 'Please select Annotation file.');
    % %     annofile_name = [pathName,fileName];
    % %     load(annofile_name);
    load(annotML_name);
    mapsML_noflip.LEPres = image;
    mapsML_noflip.lesion.xy = FreeForm.FreeFormCluster.face;
    clear image FreeForm;
    load(['\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\3CB_Maps_Results\RSNA_presentation\3CBResults_',patient_id,'_CC.mat']);
    maps_CC = maps; clear maps;
    load(['\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\3CB_Maps_Results\RSNA_presentation\3CBResults_',patient_id,'_ML.mat']);
    maps_ML = maps; clear maps;
    
    % % xy = mapsCC_noflip.lesion.xy;
    % % minx = min(xy(:,1));maxx = max(xy(:,1));miny = min(xy(:,2));maxy = max(xy(:,2));
    % % ROI.xmin = minx; ROI.ymin = miny; ROI.columns = (maxx - minx); ROI.rows = (maxy-miny)
    % % roicc = maps_CC.LEPres(ROI.ymin-ROI.rows*0.5:ROI.ymin+ROI.rows*1.5-1,ROI.xmin-ROI.columns*0.5:ROI.xmin+ROI.columns*1.5-1);
    % % plot(xy(:,1)-ROI.xmin+ROI.columns*0.5, xy(:,2)-ROI.ymin+ROI.rows*0.5, '-g');
    
    %
    
    acqs_filename = '\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\';
    
    CreateReport_colors('ADD3CIMAGES');
    report_parser();
    
    % % CreateReport('ADD3CRADIOLOGYFORM');
    % % CreateReport('ADD3CQIARESULTS');
    % % CreateReport('ADD3CPATHOLOGYFORM');
      catch
        count = count + 1
    end
    %counts = i
    count2 = count2 + 1
    patid = patient_id
end


