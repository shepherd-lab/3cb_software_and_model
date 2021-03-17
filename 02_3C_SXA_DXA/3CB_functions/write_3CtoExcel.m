function write_3CtoExcel(results3C,center)
global maps flag
% write DXA analysis into excel table
%     rootdir=[pwd,'\'];
%run_number = maps.results.Analysis_run;         % need to find location where this variable is set sypks 08142018
run_number = 3;      %temp hardcode sypks 12-17-2018

%% Modification to excel write sypks 08-14-2018

% original
% % if ~isempty(findstr(center,'ucsf'))
% %     dir_run1 = ['O:\SRL\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\Results\Auto_3C_analysis_runs\Run',num2str(run_number),'\'];
% %     fileName = ['UCSF_run',num2str(run_number),'.xlsx'];
% % elseif ~isempty(findstr(center,'moff'))
% %     dir_run1 = ['O:\SRL\aaData\Breast Studies\3C_data\RO1_3Cimages\Moffitt\Results_Moffitt\Auto_3C_analysis_runs\Run',num2str(run_number),'\'];
% %     fileName = ['MOFF_run',num2str(run_number),'.xlsx']; 
% % else
% %     dir_run1 = [];
% %     fileName = [];
% % end

% modification sypks 08-14-2018
if ~isempty(findstr(center,'ucsf'))
    dir_run1 = ['O:\SRL\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\Results\Auto_3C_analysis_runs\Run',num2str(run_number),'\'];
    fileName = ['UCSF_run',num2str(run_number),'.xlsx'];
elseif ~isempty(findstr(center,'moff'))
    dir_run1 = ['O:\SRL\aaData\Breast Studies\3C_data\RO1_3Cimages\Moffitt\Results_Moffitt\Auto_3C_analysis_runs\Run',num2str(run_number),'\'];
    fileName = ['MOFF_run',num2str(run_number),'.xlsx']; 
else
    dir_run1 = [];
    fileName = [];
   
end
    
%%
    filePathName = [dir_run1, fileName];
    try
    xlsLineNum = getXlsLines(filePathName, 'sheetIndex', 1);
    catch
      msgbox('Cannot find file run file','3CB output excel file problem','error');
    end
    
   % xlswrite(filePathName, tableEntry, shtName, ['A', num2str(lineNum)]);
%     try
   if xlsLineNum == 1
      
 sht1Title = {'patient_id', 'ROIWmean', 'ROIWmed', 'ROIWskew', 'ROIWkurt', 'ROIWent', 'ROIWstd','ROILmean', 'ROILmed', 'ROILskew', 'ROILkurt', 'ROILent', 'ROILstd','ROIPmean', 'ROIPmed', 'ROIPskew', 'ROIPkurt', 'ROIPent', 'ROIPstd', ...
'bkgrW1mean', 'bkgrW1med', 'bkgrW1skew', 'bkgrW1kurt', 'bkgrW1ent', 'bkgrW1std', 'bkgrL1mean', 'bkgrL1med', 'bkgrL1skew', 'bkgrL1kurt', 'bkgrL1ent', 'bkgrL1std', 'bkgrP1mean', 'bkgrP1med', 'bkgrP1skew', 'bkgrP1kurt', 'bkgrP1ent', 'bkgrP1std', ...
'bkgrW2mean', 'bkgrW2med', 'bkgrW2skew', 'bkgrW2kurt', 'bkgrW2ent', 'bkgrW2std', 'bkgrL2mean', 'bkgrL2med', 'bkgrL2skew', 'bkgrL2kurt', 'bkgrL2ent', 'bkgrL2std', 'bkgrP2mean', 'bkgrP2med', 'bkgrP2skew', 'bkgrP2kurt', 'bkgrP2ent', 'bkgrP2std', ...
'bkgrW3mean', 'bkgrW3med', 'bkgrW3skew', 'bkgrW3kurt', 'bkgrW3ent', 'bkgrW3std', 'bkgrL3mean', 'bkgrL3med', 'bkgrL3skew', 'bkgrL3kurt', 'bkgrL3ent', 'bkgrL3std', 'bkgrP3mean', 'bkgrP3med', 'bkgrP3skew', 'bkgrP3kurt', 'bkgrP3ent', 'bkgrP3std', ...
'breastWmean', 'breastWmed', 'breastWskew', 'breastWkurt', 'breastWent', 'breastWstd', 'breastLmean', 'breastLmed', 'breastLskew', 'breastLkurt', 'breastLent', 'breastLstd', 'breastPmean', 'breastPmed', 'breastPskew	', 'breastPkurt', 'breastPent', 'breastPstd', ...
'slopeWmean', 'offsetWmean', 'slopeWmed', 'offsetWmed', 'slopeWstd', 'offsetWstd', 'slopeWskew', 'offsetWskew', 'slopeWkurt', 'offsetWkurt', 'slopeWent', 'offsetWent', 'slopePmean', 'offsetPmean', '	slopePmed', ...
'offsetPmed', 'slopePstd', 'offsetPstd', 'slopePskew', 'offsetPskew', 'slopePkurt', 'offsetPkurt', 'slopePent', 'offsetPent', 'slopeLmean', 'slopeLmed', 'offsetLmed', 'slopeLstd', 'offsetLstd', 'slopeLskew', ...
'offsetLskew', 'slopeLkurt', 'offsetLkurt', 'slopeLent', 'offsetLent', 'ROISXAmean', 'ROISXAmed', 'ROISXAskew', 'ROISXAkurt', 'ROISXAent', 'ROISXAstd','bkgrSXA1mean', 'bkgrSXA1med', 'bkgrSXA1skew', 'bkgrSXA1kurt', 'bkgrSXA1ent', 'bkgrSXA1std', ...
'bkgrSXA2mean', 'bkgrSXA2med', 'bkgrSXA2skew', 'bkgrSXA2kurt', 'bkgrSXA2ent', 'bkgrSXA2std', 'bkgrSXA3mean', 'bkgrSXA3med', 'bkgrSXA3skew', 'bkgrSXA3kurt', 'bkgrSXA3ent', 'bkgrSXA3std', 'breastSXAmean', 'breastSXAmed', 'breastSXAskew', 'breastSXAkurt', 'breastSXAent', 'breastSXAstd', ...
'slopeSXAmean', 'offsetSXAmean', 'slopeSXAmed', 'offsetSXAmed', 'slopeSXAstd', 'offsetSXAstd', 'slopeSXAskew', 'offsetSXAskew', 'slopeSXAkurt', 'offsetSXAkurt', 'slopeSXAent', 'offsetSXAent', 'lesion_area', 'breast_area	', 'negROIW	', ...
'negROIL', 'negROIP', 'negbkgrW1', 'negbkgrL1', 'negbkgrP1', 'negbkgrW2', 'negbkgrL2', 'negbkgrP2', 'negbkgrW3', 'negbkgrL3', 'negbkgrP3', 'negbreastW', 'negbreastL', 'negbreastP', 'lesionID', ...
'Analysis_date', 'Analysis_run'};																										

      
      
    xlswrite(filePathName, sht1Title, '3CBanalysis');
    xlsLineNum = xlsLineNum + 1;
    xlswrite(filePathName,results3C , '3CBanalysis', ['A', num2str(xlsLineNum)]);
   else
     xlsLineNum = xlsLineNum + 1; 
    xlswrite(filePathName,results3C , '3CBanalysis', ['A', num2str(xlsLineNum)]);
   end
%    catch
% %       msgbox('Please close UCSF_run1.xls file if open!','3CB output excel file problem','error');
%     end

end

  
 

