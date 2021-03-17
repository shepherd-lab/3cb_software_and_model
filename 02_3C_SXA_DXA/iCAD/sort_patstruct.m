function sort_patstruct()
pat=[];
xls_filename = '\\researchstg\aaData\Breast Studies\iCAD\sop_table.xls';
xls_3CBresults = '\\researchstg\aaData\Breast Studies\iCAD\REDCap 24JAN17.xlsx';
   [sop_num,sop_txt,sop_raw] = xlsread(xls_filename);

[num_3CB,txt_3CB,raw_3CB] = xlsread(xls_3CBresults);
% [Index1, index2] = find(contains(sop_txt,sop1))
% sop_cur = char(sop_txt(Index1, index2))
% pat_cur = char(sop_txt(Index1, 4))

outmat_file = '\\researchstg\aaData\Breast Studies\iCAD\RESULTS\icad_run2.mat';
 mat_file1 = '\\researchstg\aaData\Breast Studies\iCAD\RESULTS\icad_051917.mat';
 mat_file2 = '\\researchstg\aaData\Breast Studies\iCAD\RESULTS\icad_051817.mat';
load(mat_file1);
pat1 = pat;
clear pat;
load(mat_file2);
pat = [pat1,pat];

%YourTable.Locations = regexprep( YourTable.Locations, '^[^-]+-', '', 'lineanchors');

num_pats = length(pat);
count = [];
for ipat= 1: num_pats
    
   ll = cellfun('length',pat{1,ipat}.icad_struct{1,1}.dcm_fname);
    len = length(ll);
        if len == 2
            dcm_name = char(pat{1,ipat}.icad_struct{1,1}.dcm_fname(2))
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
        if ~isempty(finding_cur)
            if  ~isnan(finding_cur) 
                finding_cur = finding_cur(1);
                pat{2,ipat} = finding_cur;
            else
                ipat3 = ipat
                count = [count; ipat];
                continue;
            end
        else
            count = [count; ipat];
            continue;
        end
       
       
end
aa = pat.';
aa(count,:) = [];
clear pat;
pat = sortrows(aa,2).';
save(outmat_file,'pat');
a = 1;

