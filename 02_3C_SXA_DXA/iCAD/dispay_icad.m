function dispay_icad()

mat_file = '\\researchstg\aaData\Breast Studies\iCAD\run1.mat';
load(mat_file);

num_pats = length(pat);
num_xmls = length(pat{1}.icad_struct);
num_masses = pat{1}.icad_struct{1}.num_masses;
num_clusters = pat{1}.icad_struct{1}.num_clusters;
pat_cell = {'3C01059','3C01072','3C01084','3C01092','3C01108','3C02065','3C02112'};
annot_UCSF = 'N:\Breast Studies\3C_data\RO1_3Cimages\UCSF\UCSF_Annotation_images\Annotations\';
annot_MOFF = 'N:\Breast Studies\3C_data\RO1_3Cimages\Moffitt\Moffitt_Annotation_images\Annotations\';
for i=1:7%:num_pats
    num_xmls = length(pat{i}.icad_struct); 
    for j=1:num_xmls
    num_masses = pat{i}.icad_struct{j}.num_masses;
    num_clusters = pat{i}.icad_struct{j}.num_clusters
    dcm_name = pat{i}.icad_struct{j}.dcm_fname;
    if length(dcm_name) == 2
        filename = char(dcm_name{2});
    else
        filename = char(dcm_name);
    end
    info_dicom = dicominfo(filename);
    dicom_image = double(dicomread(info_dicom));
    if isfield(info_dicom,'ExposureInuAs')
        mAs = info_dicom.ExposureInuAs/1000;
    else
        mAs = info_dicom.ExposureinuAs/1000;
    end
    view_id = info_dicom.ViewPosition(1:2);
    
        if i<=5
            annofile_name = [annot_UCSF, char(pat_cell{i}),'_',view_id,'_annotation.mat'];
        else
            annofile_name = [annot_MOFF, char(pat_cell{i}),'_',view_id,'_annotation.mat'];
        end
       
        load(annofile_name);
%         [m n]=(size(dicom_image));
%         pres_image = imresize(image,[m n]);        
        
        kVp = info_dicom.KVP;
        atten_image = log_convertSXA(dicom_image,mAs, kVp);
        skin_points = pat{i}.icad_struct{j}.breast.skin_points;
        h = figure('Name',char(pat_cell{i}));imagesc(atten_image);colormap(gray); hold on;
        plot(skin_points(:,2), skin_points(:,1), '-b'); hold on;
         for ik=1:FreeForm.FreeFormnumber
        plot(FreeForm.FreeFormCluster(ik).face(:,1)*2,FreeForm.FreeFormCluster(ik).face(:,2)*2,'-y');
         end 
       
         
        if num_masses ~= 0
            for kn=1:num_masses
                mass_cent = pat{i}.icad_struct{j}.masses(kn).centroid;
                mass_line = pat{i}.icad_struct{j}.masses(kn).polyline;
                %                 plot(mass_cent(2), mass_cent(1), '.g');
                figure(h); plot(mass_line(:,2), mass_line(:,1), '-g');
            end
            
        end
        if num_clusters ~= 0
            for km=1:num_clusters
                num_ucalcs =  pat{i}.icad_struct{j}.calc(km).num_ucalcs;
                
                for kk = 1:num_ucalcs
                    ucalcs_cent = pat{i}.icad_struct{j}.calc(km).ucalcs(kk).ucalcs_cent;
                    %                     plot(ucalcs_cent(2), ucalcs_cent(1), '.r');
                    ucalcs_line = pat{i}.icad_struct{j}.calc(km).ucalcs(kk).polyline;
                    figure(h); plot(ucalcs_line(:,2), ucalcs_line(:,1), '-r');
                end
            end
        end
        a= 1;
    
    end
    
    
    
    %annotations
    %     dicom_file = info_dicom.SOPInstanceUID
    % %     SQLStatement = ['SELECT *  FROM [mammo_CPMC].[dbo].[DICOMinfo], [mammo_CPMC].[dbo].[acquisition]  where acquisition.dicom_id =  DICOMinfo.DICOM_ID and DICOMinfo.SOPInstanceUID like ''%', dicom_file, '%'''];
    %
    % %      SQLStatement = ['SELECT *  FROM [mammo_CPMC].[dbo].[DICOMinfo] where [mammo_CPMC].[dbo].[DICOMinfo].SOPInstanceUID like ''%', dicom_file, '%'''];
    % %
    % %         SQLStatement = ['SELECT *  FROM [mammo_CPMC].[dbo].[DICOMinfo], [mammo_CPMC].[dbo].[acquisition]  where DICOMinfo.DICOM_ID = acquisition.DICOM_ID and acquisition_id = ',num2str(ACQIDList(index))] ;
    %
    %         SQLStatement = ['SELECT *  FROM [mammo_CPMC].[dbo].[DICOMinfo]  where DICOMinfo.SOPInstanceUID like ''%', dicom_file, '%'''];
    %
    % %      SQLStatement = ['SELECT *  FROM dbo.DICOMinfo where dbo.DICOMinfo.SOPInstanceUID like ''%', dicom_file, '%'''];
    %
    %
    %     Database.Name = 'mammo_CPMC';
    %
    %     aa=mxDatabase(Database.Name,SQLStatement);
    % %     patient_id =
    
    
    
end
a = 1;
end

%         if icad_struct{i}.num_clusters ~= 0
%             for ii = 1: icad_struct{i}.num_clusters
% %                 pat(count).icad_struct{i}.calc{ii} = icad_struct.calc{ii};
% %                 pat(count).icad_struct{i}.num_clusters = icad_struct.num_clusters;
%                   pat(count).icad_struct{i}.calc{ii} = icad_struct.calc{ii};
%             end
%         else
%             pat(count).icad_struct{i}.num_clusters(i) = 0;
%         end
%
%         if icad_struct(i).num_masses ~= 0
%             for ii = 1: icad_struct(i).num_masses
%             pat(count).icad_struct(i).masses(ii) = icad_struct(i).masses(i);
%             pat(count).icad_struct(i).num_masses = icad_struct(i).num_masses;
%             end
%         else
%             pat(count).num_masses(i) = 0;
%         end