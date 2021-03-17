function  create_3Creport_Moffitt(  )
global maps_CC maps_ML acqs_filename  mapsML_noflip mapsCC_noflip image FreeForm maps patient_id
% % UNTITLED2 Summary of this function goes here
% %   Detailed explanation goes here
% %  [fileName, pathName]=uigetfile('\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\UCSF_Annotation_images\AnnotationsUCSF_Bonnie\*.mat', 'Please select CC Annotation file.');
% %   %[fileName, pathName]=uigetfile('\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\Moffitt\Moffitt_Annotation_images\Annotations\Annotations _submitted 3-21-14\*.mat', 'Please select Annotation file.');
% %     annofile_name = [pathName,fileName];
% %     load(annofile_name);
CreateReport('NEW');
%[FileName,PathName] = uigetfile('\\researchstg\aaDATA\Breast Studies\*.txt','Select the acquisition list txt-file ');

 acqs_filename = '\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\misc\reports_ids_UCSF_run2_invasive.txt';
% acqs_filename = '\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\Results\TrippleNegatives\tn_ucsf.txt';
% %       acqs_filename = [PathName,'\',FileName]; 
temp_acqs = textread(acqs_filename,'%s');

for i = 2:length(temp_acqs)
%          try
    %     % patient_id = '3C01010';
    patient_id = char(temp_acqs(i));
    
%     load(['\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\Moffitt\Moffitt_Annotation_images\Annotations\Annotations _submitted 3-21-14\',patient_id,'_CC_annotation.mat']);
     load(['\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\UCSF_Annotation_images\Annotations\',patient_id,'_CC_annotation.mat']);
   
    mapsCC_noflip.LEPres = image; %origi    nal image
    mapsCC_noflip.lesion.xy = FreeForm.FreeFormCluster.face;
    clear image FreeForm;
    % %  [fileName, pathName]=uigetfile('\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\UCSF_Annotation_images\AnnotationsUCSF_Bonnie\*.mat', 'Please select ML Annotation file.');
    % %   %[fileName, pathName]=uigetfile('\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\Moffitt\Moffitt_Annotation_images\Annotations\Annotations _submitted 3-21-14\*.mat', 'Please select Annotation file.');
    % %     annofile_name = [pathName,fileName];
    % %     load(annofile_name);
    
%     load(['\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\Moffitt\Moffitt_Annotation_images\Annotations\Annotations _submitted 3-21-14\',patient_id,'_ML_annotation.mat']);
    load(['\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\UCSF_Annotation_images\Annotations\',patient_id,'_ML_annotation.mat']);
    
    
    mapsML_noflip.LEPres = image;
    mapsML_noflip.lesion.xy = FreeForm.FreeFormCluster.face;
    clear image FreeForm;
   
    load(['\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\Results\Auto_3C_analysis_runs\Run2\3CBResults_',patient_id,'_CC_SM_run2.mat']);
%     load(['\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\3CB_Maps_Results\3CBResults_',patient_id,'_CC.mat']);
    maps_CC = maps; clear maps;
    load(['\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\Results\Auto_3C_analysis_runs\Run2\3CBResults_',patient_id,'_ML_SM_run2.mat']);
%     load(['\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\3CB_Maps_Results\3CBResults_',patient_id,'_ML.mat']);
    maps_ML = maps; clear maps;
    
    % % xy = mapsCC_noflip.lesion.xy;
    % % minx = min(xy(:,1));maxx = max(xy(:,1));miny = min(xy(:,2));maxy = max(xy(:,2));
    % % ROI.xmin = minx; ROI.ymin = miny; ROI.columns = (maxx - minx); ROI.rows = (maxy-miny)
    % % roicc = maps_CC.LEPres(ROI.ymin-ROI.rows*0.5:ROI.ymin+ROI.rows*1.5-1,ROI.xmin-ROI.columns*0.5:ROI.xmin+ROI.columns*1.5-1);
    % % plot(xy(:,1)-ROI.xmin+ROI.columns*0.5, xy(:,2)-ROI.ymin+ROI.rows*0.5, '-g');
    
    %
    
    acqs_filename = '\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\';
%    try
    CreateReport('ADD3CIMAGES');
    
    report_parser();
%    catch
%        continue;
%    end
    
    % % CreateReport('ADD3CRADIOLOGYFORM');
% %     CreateReport('ADD3CQIARESULTS');
% %     CreateReport('ADD3CPATHOLOGYFORM');
%     catch
%         continue;
%     end
    counts = i
    patid = patient_id
end


