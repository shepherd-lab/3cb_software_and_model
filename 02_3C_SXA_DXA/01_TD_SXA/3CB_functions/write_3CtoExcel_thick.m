function write_3CtoExcel(resultsthick)
global Analysis
% write DXA analysis into excel table
%     rootdir=[pwd,'\'];

    dir_run1 = '\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\Results\Thickness_estimation\Results\';
     fileName = 'thickness_estimation.xlsx';
    
    filePathName = [dir_run1, fileName];
    try
    xlsLineNum = getXlsLines(filePathName, 'sheetIndex', 1);
    catch
      msgbox('Can not find .xls file in the root directory!','3CB output excel file problem','error');
    end
    
   % xlswrite(filePathName, tableEntry, shtName, ['A', num2str(lineNum)]);
%     try
   if xlsLineNum == 1
      
 sht1Title = {'acq_id', 'model_volume', 'breast_volume', 'calc_thickness', 'thickness', 'xdir_angle', 'y_angle','vol_diff'};																										

    xlswrite(filePathName, sht1Title, 'Sheet1');
    xlsLineNum = xlsLineNum + 1;
    xlswrite(filePathName,resultsthick , 'Sheet1', ['A', num2str(xlsLineNum)]);
   else
     xlsLineNum = xlsLineNum + 1; 
    xlswrite(filePathName,resultsthick , 'Sheet1', ['A', num2str(xlsLineNum)]);
   end
%    catch
% %       msgbox('Please close UCSF_run1.xls file if open!','3CB output excel file problem','error');
%     end

end

  
 

