function report_parser()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
global pat10 patient_id
% % %   file_name = '\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\RO13CBQIA_DATA.xls'
% % %   [num_data, txt_data, report_data] = xlsread(file_name,'RO13CBQIA_DATA');
  
%   load('\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\misc\patient_data.mat');
   xls_fname = '\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\Results\Auto_3C_analysis_runs\REDCap 24JAN17.xlsx';
%   xls_fname = '\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\Results\Auto_3C_analysis_runs\REDCap_13JUL17.xlsx';
  %   xls_fname = '\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\Results\Pathology_results\RO13CBQIA_DATA_LABELS_2017-10-23.xlsx';
  [num_data,txt_data,raw] = xlsread(xls_fname);
   report_data = raw;
  
  %patient_id = '3C01010';
  if strcmp(patient_id(3:4),'01')
      pat_id = [patient_id(1:2),'_',patient_id(3:4),'_',patient_id(5:end)];
  else
      pat_id = [patient_id(1:2),'-',patient_id(3:4),'-',patient_id(5:end)];
  end
  
%   pat_id = erase(pat_id,'_');
%    pat_id = erase(pat_id,'-');
  sz = size(report_data);
%  ind_patient = find(startsWith(report_data(:,1),pat_id))
   ind_patient = find(strcmp(pat_id,report_data(:,1)));
% % %   for i = 1:sz(2)
% % %       ind = find(report_data(:
% % %   end
% %   pi = 11;
  pi = ind_patient(1)
  pat_names = report_data(1,:);
  pat_num = num_data(pi,:);
  pat_raw = report_data(pi,:);
  pat_txt = txt_data(pi,:);
  check_ind = ones(size(pat_raw));
  active_ind = ones(size(pat_raw));
  uncheck_ind =strfind(pat_txt,'Unchecked')
  empty_ind1 = find(cellfun(@isempty,uncheck_ind));
  check_ind(empty_ind1)= 0;
  
% %   num_ind = cellfun(@isnumeric, pat_raw);
  Fx = @(x) any(isnan(x));
  nan_ind = cellfun(Fx,pat_raw);
% %   empty_ind = find(cellfun(@isempty, pat_txt));
% %   active_ind(empty_ind)=0;
  
  empty_all = logical(nan_ind) |  logical(check_ind);
  pat_raw(empty_all)=[];
  pat_names(empty_all)=[];
  pat10 = [pat_names',pat_raw']
  ind_checked = find(strcmp('Checked',pat10(:,2)));
  for i=1:length(ind_checked)
      ii = ind_checked(i);
      k = cell2mat(strfind(pat10(ii,1), '(choice='));
      kstring = char(pat10(ii,1));
      pat10{ii,2} = kstring(k+8:end-1);
      pat10{ii,1} = kstring(1:k-1);
  end
% %   CreateReport('NEW');
% % CreateReport('ADD3CIMAGES');
  CreateReport('ADD3CRADIOLOGYFORM');
a = 1;
end

