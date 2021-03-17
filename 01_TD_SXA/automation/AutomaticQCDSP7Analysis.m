%AutomaticSXAAnalysis
%Do the SXA analysis Sequence
%Lionel HERVE
%6-17-04

function AutomaticQCDSP7Analysis

global   Info  Analysis Error  QCAnalysisData figuretodraw flag MachineParams Database

VALIDATION_MODE = true;
Error.DENSITY=false;
SaveBool= true;
Info.ReportCreated = false; 
Error.SkinEdgeFailed = false;
flag.EdgeMode='Auto';
%% Automatic ROI and Skin detection 
 try
     PhantomDetection();
 catch
     SaveInDatabase('QACODES');
     nextpatient(0);
     return;
 end
     
 try
      if ~VALIDATION_MODE
         DensityROIResults = roi_QCDSP7();
         Analysis.roi_DSP7values = DensityROIResults(:,2);
         Analysis.density_DSP7 = DensityROIResults(:,1);
         DSP7density_fit();
         [a_offset,b_slope] = grayscale_fit();
         Analysis.a_offset = a_offset;
         Analysis.b_slope = b_slope;
         SaveInDatabase('COMMONANALYSIS'); 
         saveDSP7CalibParams();
         a = 1;
      else
         DensityROIResults = roi_QCDSP7();
         Analysis.roi_DSP7values = DensityROIResults(:,2);
         Analysis.density_DSP7 = DensityROIResults(:,1);
         [a_offset,b_slope] = grayscale_fit();
         Analysis.a_offset = a_offset;
         Analysis.b_slope = b_slope;
         grayscaleImage_correction(a_offset, b_slope);
         PhantomDetection();
         DensityROIResultsCorr = roi_QCDSP7(); 
         Analysis.roi_DSP7valGSCorr = DensityROIResultsCorr(:,2); 
         Analysis.density_DSP7Corr = DensityROIResultsCorr(:,1);
         %[A2,A1,A0] = DSP7density_fit();
% % %      if ~VALIDATION_MODE
% % %           roi_QCWAX();  %[DensityROIResults, DensityROIResultsCorr] =
% % %          SaveInDatabase('COMMONANALYSIS'); 
% % %          saveGen3CalibParams(Analysis, Info, MachineParams, Database.Name);
% % %      end
% % %      
        % Analysis.densityDSP7_quadcorr = A2*Analysis.density_DSP7.^2 + A1*Analysis.density_DSP7 + A0;
    
           %%%    validation   %%%% 
% %          DensityROIResults = roi_QCDSP7();
% %          Analysis.roi_DSP7values = DensityROIResults(:,2);
% %          Analysis.density_DSP7 = DensityROIResults(:,1);  
         ATable = extract_A2A1A0_values(Database.Name, Info.acqDate, Info.kVp,Info.centerlistactivated, MachineParams.padSize);
         
         A2 = ATable(1);
         A1 = ATable(2);
         A0 = ATable(3);
         Analysis.DSP7references = [23.08,46.15,57.69,61.54,69.23,76.92,100.00]';
         Analysis.densityDSP7_quadcorr = A2*Analysis.density_DSP7.^2 + A1*Analysis.density_DSP7 + A0;
         Analysis.AbsDensityErrorCorr = mean(abs(Analysis.densityDSP7_quadcorr - Analysis.DSP7references));
         Analysis.DensityError = mean((Analysis.density_DSP7 - Analysis.DSP7references));
         Analysis.AbsDensityError = mean(abs(Analysis.density_DSP7 - Analysis.DSP7references));
         a =1;
      end
catch

    Error.SkinEdgeFailed = true;
    errmsg = lasterr

    try
        SaveInDatabase('QACODES');
    catch
        errmsg = lasterr
        try
            SaveInDatabase('QACODES');
        catch
            errmsg = lasterr
            nextpatient(0);
            return;
        end
    end
    nextpatient(0);
    return;
end


%% Report creation

if SaveBool
    %% Add QA codes
    try
        SaveInDatabase('QACODES');
    catch
        errmsg = lasterr
        try
            SaveInDatabase('QACODES');
        catch
            errmsg = lasterr
            nextpatient(0);
            return;
        end
    end
      
end
   figure(figuretodraw);
  % pause(1);
   %
   set(QCAnalysisData.MainBox,'xdata',0,'ydata',0);
   for index=1:QCAnalysisData.Draw.Compartments
      set(QCAnalysisData.Box(index),'xdata',0,'ydata',0);
   end
  %}
%% Go to next patient
% save if the analysis was ok otherwise choose nextpatient

if (Error.DENSITY &(SaveBool)) %
    nextpatient(0);
else
    nextpatient(1); %0 is for temporary
end

%%
function ATable = extract_A2A1A0_values(dbName, imgAcqDate, imgVolt, machID, padSize)
global Info Analysis
% 
SQLstatement = ['SELECT TOP 1 * FROM DensityDSP7Corr',...
               ' WHERE (paddle_size lIKE ''', padSize, '''',')',...
               ' AND (machine_id = ', num2str(machID), ') ',...
               ' AND (version LIKE ''%Version7.1%'') AND (date_acquisition =',...
               ' (SELECT MAX(date_acquisition)  FROM DensityDSP7Corr',...
               ' WHERE (paddle_size lIKE ''', padSize, '''',')',...
               ' AND (machine_id = ', num2str(machID), ') ',...
               ' AND (version LIKE ''%Version7.1%'') ',...
               ' AND (CONVERT(CHAR(8), date_acquisition, 112) <= CONVERT(CHAR(8),''',imgAcqDate,''', 112)))) ',...
               ' ORDER BY commonanalysis_id DESC'];         
 
kentryRead = mxDatabase(dbName, SQLstatement);

SQLstatement = ['SELECT MAX(date_acquisition), MIN(date_acquisition) FROM DensityDSP7Corr',...
               ' WHERE (paddle_size lIKE ''', padSize, '''',')',...
               ' AND (machine_id = ', num2str(machID), ') ',...
               ' AND (version LIKE ''%Version7.1%'')'];
            
mm_kdate = mxDatabase(dbName, SQLstatement);
min_kdate_char = char(mm_kdate(2));
max_kdate_num = datenum(mm_kdate(1), 'yyyymmdd');
min_kdate_num = datenum(mm_kdate(2), 'yyyymmdd');
imgAcqDate_num = datenum(imgAcqDate, 'yyyymmdd');

SQLstatement = ['SELECT TOP 1 *  FROM DensityDSP7Corr',...
               ' WHERE (paddle_size lIKE ''', padSize, '''',')',...
               ' AND (machine_id = ', num2str(machID), ') ',...
               ' AND (version LIKE ''%Version7.1%'')',...
               ' AND date_acquisition LIKE ''',min_kdate_char(1:8),'''',...
               ' ORDER BY commonanalysis_id DESC'];  % 'WHERE paddle_size = ''', padSize, '''', ...
kentry_min = mxDatabase(dbName, SQLstatement);
           
if ~isempty(kentryRead)
    acq_DSP7date = kentryRead{1,4};
    acq_DSP7date_num = datenum(acq_DSP7date, 'yyyymmdd');
    diff_date = imgAcqDate_num - acq_DSP7date_num;
    Analysis.GEN3commanal_id = kentryRead{1,3};

else
    kentryRead = kentry_min;
    diff_date = imgAcqDate_num - min_kdate_num;
    Analysis.GEN3commanal_id = kentryRead{1,3};

end
Analysis.DSP7diffdays = diff_date;

% % % SQLstatement = [' SELECT MAX(date_acquisition) FROM kTableGen3 ', ...
% % %                 'WHERE paddle_size = ''', padSize, '''', ...
% % %                 ' AND machine_id = ', num2str(machID), ' ', ...
% % %                 ' AND version LIKE ''%Version7.1%'''];
% % % max_kdate =  mxDatabase(dbName, SQLstatement);
% % % max_kdate_num = datenum( max_kdate, 'yyyymmdd');

kStartCol = 9;               
    kList = [];        


 if ~isempty(kentryRead)
      kList = cell2mat(kentryRead(1, kStartCol:end));
    else
      kList = cell2mat(kentryRead(1, kStartCol:end));
 end

numVal = round(length(kList)/3);

ATable = zeros(numVal, 3);
for i = 1:numVal
    ATable(i, :) = kList(3*i-2:3*i);
end
    
a  = 1;



