function report_icad_analysis()
global startdir_report
%_filename = '\\researchstg\aaData\Breast Studies\iCAD\SOP_patientid.xlsx';
xls_filename = '\\researchstg\aaData\Breast Studies\iCAD\sop_table.xls';
xls_3CBresults = '\\researchstg\aaData\Breast Studies\iCAD\REDCap 24JAN17.xlsx';
%sop = readtable(xls_filename);
% sop1 = '1.2.840.113681.2225183346.01.587.42595.587785.87';

[sop_num,sop_txt,sop_raw] = xlsread(xls_filename);

[num_3CB,txt_3CB,raw_3CB] = xlsread(xls_3CBresults);
% [Index1, index2] = find(contains(sop_txt,sop1))
% sop_cur = char(sop_txt(Index1, index2))
% pat_cur = char(sop_txt(Index1, 4))

%mat_file = '\\researchstg\aaData\Breast Studies\iCAD\run1.mat';
%mat_file = '\\researchstg\aaData\Breast Studies\iCAD\RESULTS\icad_051917.mat';
 mat_file = '\\researchstg\aaData\Breast Studies\iCAD\RESULTS\icad_run2.mat';
 
% mat_file = '\\researchstg\aaData\Breast Studies\iCAD\RESULTS\icad_051817.mat';
load(mat_file);

%YourTable.Locations = regexprep( YourTable.Locations, '^[^-]+-', '', 'lineanchors');

num_pats = length(pat);
% num_xmls = length(pat{1}.icad_struct);
% num_masses = pat{1}.icad_struct{1}.num_masses;
% num_clusters = pat{1}.icad_struct{1}.num_clusters;

% pat_cell = {'3C01059','3C01072','3C01084','3C01092','3C01108','3C02065','3C02112'};
annot_UCSF = '\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\UCSF_Annotation_images\Annotations\';
annot_MOFF = '\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\Moffitt\Moffitt_Annotation_images\Annotations\';
annot_pilot = '\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\UCSF_pilot\Pilot_Annotations\';
UCSF_dir = '\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\';
MOFF_dir = '\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\Moffitt\';
pilot_dir = '\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\UCSF_pilot\';
startdir_report = '\\researchstg\aaData\Breast Studies\iCAD\AutomaticReports\';
%CreateReport('NEW',1);
PowerPoint('INIT');
output = [];
for ipat= 320 % 1:num_pats   %[1]  %[110, 112, 128, 130, 131, 148, 7, 8, 28, 37, 48, 51] 
    try
    num_xmls = length(pat{1,ipat}.icad_struct);
    PowerPoint('AddSlide');
    mass_name = [];
    mass_prob = [];
    clus_prob = [];
    clus_name = [];
    ucalcs_cent = [];
    
     ll = cellfun('length',pat{1,ipat}.icad_struct{1,1}.dcm_fname);
     len = length(ll);
%     len = length(pat{1,ipat}.icad_struct{1,1}.dcm_fname);      
        if len == 2
            dcm_name = char(pat{1,ipat}.icad_struct{1,1}.dcm_fname(2));
        else
            dcm_name = char(pat{1,ipat}.icad_struct{1,1}.dcm_fname);
        end
      [pathstr,short_name,ext] = fileparts(dcm_name);
      [Index1, index2] = find(contains(sop_txt,short_name));
%         sop_cur = char(sop_txt(Index1, index2))
        pat_cur = char(sop_txt(Index1, 1));
        kk = char(txt_3CB(:,1));
        len_kk = size(kk);
        
        for is = 1:len_kk(1)                      
            hh = replace(kk(is,:),'_','');
            hh = replace(hh,'-','');
            txt_3CB{is,1} = hh;
        end
        [Index1, index2] = find(contains(txt_3CB,pat_cur(1:end-3)));
        finding_cur = cell2mat(raw_3CB(Index1, 18));
        if ~isempty(finding_cur) | ~isnan(finding_cur)
            finding_cur = finding_cur(1);
        else
            continue;
        end
        birads = cell2mat(raw_3CB(Index1, 19));
        birads = birads(1);
        calcification = cell2mat(txt_3CB(Index1, 20));
        %calcification = calcification(1);
        
        finding_cur =  finding_cur(1);
        if  finding_cur == 1
            lesion_type = 'invasive';
        elseif finding_cur == 2
            lesion_type = 'DCIS';
        elseif finding_cur == 3
            lesion_type = 'FA';
        elseif finding_cur == 4
            lesion_type = 'Phyllodes';
        elseif finding_cur == 5
            lesion_type = 'Benign';
        end        
              
        if  calcification == 1
            calc_type = 'Yes';
        else
            calc_type = 'No';
        end
        
           
    
%     Position=PowerPoint('gettextposition');
%     Position1(2) = Position(2);
    PowerPoint('addtext','text',['patient ID:   ',pat_cur(1:end-3)],'position',[0.02 0.0],'bold',true,'underlined',true,'fontsize',1.2,'carriage',1);
    Position1=PowerPoint('gettextposition');
%     PowerPoint('addtext','text','','position',[0.02 0.1],'bold',true,'underlined',true,'fontsize',1.2,'carriage',1);
%    Position = Position1;
       catch
       error(lasterr) 
    end

    for j=1:num_xmls
        try
        num_masses = pat{1,ipat}.icad_struct{1,j}.num_masses;
        num_clusters = pat{1,ipat}.icad_struct{1,j}.num_clusters;
        
        len = length(pat{1,ipat}.icad_struct{1,j}.dcm_fname);
        
        if len == 2
            dcm_name = char(pat{1,ipat}.icad_struct{1,j}.dcm_fname(2));
        else
            dcm_name = char(pat{1,ipat}.icad_struct{1,j}.dcm_fname);
        end
        
        [pathstr,short_name,ext] = fileparts(dcm_name);
        [Index1, index2] = find(contains(sop_txt,short_name))
        sop_cur = char(sop_txt(Index1, index2))
        pat_cur = char(sop_txt(Index1, 1));
        
        if length(dcm_name) == 2
            filename = char(dcm_name{2});
        else
            filename = char(dcm_name);
        end
        info_dicom = dicominfo(filename);
        % dicom_image = double(dicomread(info_dicom));
        if isfield(info_dicom,'ExposureInuAs')
            mAs = info_dicom.ExposureInuAs/1000;
        else
            mAs = info_dicom.ExposureinuAs/1000;
        end
        view_id = info_dicom.ViewPosition(1:2);
        kVp = info_dicom.KVP;
        
        
        if ~isempty(strfind(pat_cur,'3C01')) | ~isempty(strfind(pat_cur,'3CB'))
            annofile_name = [annot_UCSF, pat_cur,'_annotation.mat'];
            pres_imagename =  [UCSF_dir, pat_cur(1:end-3),'\ForPresentation\png_files\LE',view_id,num2str(kVp),'_origPres.png'];
        elseif ~isempty(strfind(pat_cur,'3C02'))
            % annofile_name = [annot_MOFF, char(pat_cell{i}),'_',view_id,'_annotation.mat'];
            annofile_name = [annot_MOFF, pat_cur,'_annotation.mat'];
            pres_imagename =  [MOFF_dir, pat_cur(1:end-3),'\ForPresentation\png_files\LE',view_id,num2str(kVp),'_origPres.png'];
        elseif ~isempty(strfind(pat_cur,'3CB'))  
            annofile_name = [annot_pilot, pat_cur,'_annotation.mat'];
            pres_imagename =  [pilot_dir, pat_cur,'.png'];
        else
            annofile_name = [];
            pres_imagename = [];
        end
        dd = dir(pres_imagename);
        if isempty(dd)
           pres_image2 = [pres_imagename(1:end-13),'Pres.png'];
           dd = dir(pres_image2);
           if isempty(dd)
               pres_image2 = [pres_imagename(1:end-15),'Pres.png'];
           end
           pres_image = double(imread(pres_image2,'png'));
        else    
           pres_image2 = double(imread(pres_imagename,'png'));
           pres_image = round(UnderSamplingN(pres_image2,2));
        end
        load(annofile_name);
        %         [m n]=(size(dicom_image));
        %         pres_image = imresize(image,[m n]);
        
      
        % atten_image = log_convertSXA(dicom_image,mAs, kVp);
        skin_points = pat{1,ipat}.icad_struct{1,j}.breast.skin_points;
        
        h = figure('Name',pat_cur);imagesc(pres_image);colormap(gray); %pres_image
        title(pat_cur); hold on;
        plot(round(skin_points(:,2)/2), round(skin_points(:,1)/2), '-b'); hold on;
        for ik=1:FreeForm.FreeFormnumber
            if ~isempty(strfind(pat_cur,'3CB')) 
               plot(FreeForm.FreeFormCluster(ik).face(:,1),FreeForm.FreeFormCluster(ik).face(:,2),'-y');hold on;
            text(mean(FreeForm.FreeFormCluster(ik).face(:,1)),mean(FreeForm.FreeFormCluster(ik).face(:,2))+50,lesion_type,'Color','yellow','FontSize',8);
            else
            plot(FreeForm.FreeFormCluster(ik).face(:,1),FreeForm.FreeFormCluster(ik).face(:,2),'-y');hold on;
            text(mean(FreeForm.FreeFormCluster(ik).face(:,1)),mean(FreeForm.FreeFormCluster(ik).face(:,2))+50,lesion_type,'Color','yellow','FontSize',8);
            end
        end
        
        mass_name = [];
        mass_prob = [];
        mass_cent = [];
        mass_line = [];
        
        if num_masses ~= 0
            for kn=1:num_masses
                mass_cent = pat{1,ipat}.icad_struct{1,j}.masses(kn).centroid;
                mass_line = pat{1,ipat}.icad_struct{1,j}.masses(kn).polyline;
                %                 plot(mass_cent(2), mass_cent(1), '.g');
                figure(h); plot(round(mass_line(:,2)/2), round(mass_line(:,1)/2), '-g'); hold on;
                 mass_name{kn,1} = pat{1, ipat}.icad_struct{1, j}.masses(kn).mass_name;
                 mass_prob(kn) = round(pat{1, ipat}.icad_struct{1, j}.masses(kn).prob_finding);
                 text(round(mass_cent(2)/2),round(mass_cent(1)/2)-50,num2str(mass_prob(kn)),'Color','green','FontSize',8);hold on;
                 
            end
            
        end
        clus_name = [];
        clus_prob = [];
        clus_cent = [];
        if num_clusters ~= 0
            for km=1:num_clusters
                ucalcs_line = [];
                ucalcs_cent = [];
                num_ucalcs =  pat{1,ipat}.icad_struct{1,j}.calc(km).num_ucalcs;
                clus_prob(km) = round(pat{1, ipat}.icad_struct{1, j}.calc(km).prob_finding);   
                clus_cent = pat{1, ipat}.icad_struct{1, j}.calc(km).centroid;   
                clus_name{km,1} = pat{1, ipat}.icad_struct{1, j}.calc(km).clus_name;
                text(round(clus_cent(2)/2),round(clus_cent(1)/2)-50,num2str(clus_prob(km)),'Color','red','FontSize',8);hold on;                
                for kk = 1:num_ucalcs
                    ucalcs_cent = pat{1,ipat}.icad_struct{1,j}.calc(km).ucalcs(kk).ucalcs_cent;
                    %                     plot(ucalcs_cent(2), ucalcs_cent(1), '.r');
                    ucalcs_line = pat{1,ipat}.icad_struct{1,j}.calc(km).ucalcs(kk).polyline;
                    figure(h); plot(round(ucalcs_line(:,2)/2), round(ucalcs_line(:,1)/2), '-r'); hold on;
                    
                end
            end
        end
         
          if j== 1
              X = 0.1;
          else
              X = 0.6; 
          end
         hold off;  copyfigure_handle = h;
         
         Position = [X 0.0];
         
        %lts_3CB = [3, 0.3, 0.14, 3.44];
         %PowerPoint('addtext','text',['patient ID:   ',pat_cur],'position',[X 0.3 0.45 0.65],'bold',true,'underlined',true,'fontsize',1.0);
        PowerPoint('addtext','text',[''],'position',[Position1(1) Position1(2)],'carriage',2);         
        %iCAD
        PowerPoint('addtext','text',['Results of iCAD: '],'position',[Position(1) Position1(2)],'bold',true,'underlined',true,'fontsize',1.2,'carriage',1);  
        %Position1=PowerPoint('gettextposition');
        PowerPoint('addtext','text',['Number of masses = ', num2str(num_masses)],'carriage',1) 
        for ii = 1:num_masses
%             Position=PowerPoint('gettextposition');
%             Position1=PowerPoint('gettextposition');
            PowerPoint('addtext','text',['Probability of mass ',char(mass_name{ii,1}), '= ', num2str(mass_prob(ii))],'carriage',1) 
            %,'position',[Position(1) Position1(2)]); PowerPoint('addtext','text',['1. Benign breast tissue with columnar cell changes and associated microcalcifications.'],'position',[Position(1)+0.4 Position1(2)],'carriage',1);
        
           %Point('addtext','text',['Probability of mass ',char(mass_name{i,1}), '= ', mass_prob(i)],'position',[0.02 0.0],'bold',true,'underlined',true,'fontsize',1.0);
        end    
%         PowerPoint('addtext','text',['Number of masses = ', num2str(num_masses)],'carriage',1) 
        PowerPoint('addtext','text',['Number of clusters = ', num2str(num_clusters)],'carriage',1) 
        for in = 1:num_clusters
%             Position=PowerPoint('gettextposition');
%             Position1=PowerPoint('gettextposition');
            PowerPoint('addtext','text',['Probability of calc cluster ',char(clus_name{in,1}), '= ', num2str(clus_prob(in))],'carriage',1) 
            %,'position',[Position(1) Position1(2)]); PowerPoint('addtext','text',['1. Benign breast tissue with columnar cell changes and associated microcalcifications.'],'position',[Position(1)+0.4 Position1(2)],'carriage',1);
        
           %Point('addtext','text',['Probability of mass ',char(mass_name{i,1}), '= ', mass_prob(i)],'position',[0.02 0.0],'bold',true,'underlined',true,'fontsize',1.0);
        end    
%             
%          PowerPoint('addtext','text',[''],'position',[Position(1) Position1(2)]); PowerPoint('addtext','text',finding_str(39:end),'position',[Position(1)+0.25 Position1(2)],'carriage',1.0);
%        Position1=PowerPoint('gettextposition');
        
       %3CB
        PowerPoint('addtext','text',['Results of 3CB'],'bold',true,'underlined',true,'fontsize',1.2,'carriage',1);  
%         Position1=PowerPoint('gettextposition'); 
        PowerPoint('addtext','text',['Lesion type = ', lesion_type],'carriage',1); 
        PowerPoint('addtext','text',['BIRADS density = ', num2str(birads)],'carriage',1) ;
        PowerPoint('addtext','text',['Calcification = ', calc_type],'carriage',1) ;
           
%        if ~isempty(results_3CB) % & sz(1)<= 1
%             PowerPoint('addtext','text',[', cm:'],'position',[Position(1) Position1(2)]); PowerPoint('addtext','text',[num2str(results_3CB(1,1)),'/',num2str(results_3CB(1,2)),'/',num2str(results_3CB(1,3)),'/',num2str(results_3CB(1,4))],'position',[Position(1)+0.4 Position1(2)],'carriage',1.0);
%             Position1=PowerPoint('gettextposition');
%         else
        PowerPoint('copypastefigure','position',[X-0.1 0.30 0.5 0.75],'LockAspectRatio',false);delete(h);
         
%         PowerPoint('addtext','text',['Results of iCAD and 3CB'],'bold',true,'underlined',true,'fontsize',1.2,'carriage',1.0);
%        
%         PowerPoint('addtext','text',[''],'position',[Position(1) Position1(2)],'carriage',0.5);    
%         PowerPoint('addtext','text',['Other Benign Breast Diseases'],'bold',true,'underlined',true,'fontsize',1.0,'carriage',1.0);  
%         Position1=PowerPoint('gettextposition');
%         
%         Position1=PowerPoint('gettextposition');
%         PowerPoint('addtext','text',['Calcifications:'],'position',[Position(1) Position1(2)]); PowerPoint('addtext','text',['Yes'],'position',[Position(1)+0.4 Position1(2)],'carriage',1.0);
         
          a= 1;
        
%     end % CC and MLO views
    
    
    
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
       catch
        output = [output; pat_cur]
%        error(lasterr)
        end
        continue
    end
    a = 1
     

a = 1;

 %error(lasterr)
 
  
  try  
 if mod(ipat,100)==0 %& Info.SaveStatus ~= 0    
   PowerPoint('saveclose','text',[startdir_report,'run3_',num2str(ipat),'.ppt']);
   PowerPoint('INIT');
 end
  catch
       error(lasterr)
  end

   
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