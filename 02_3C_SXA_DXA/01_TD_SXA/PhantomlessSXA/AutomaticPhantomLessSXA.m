function  AutomaticPhantomLessSXA

% Written by Amir Pasha M
%
% Version:
%   1.0;     12/02/2013 (Original)
%   1.1      12/17/2013 : Fixed minor bugs 
% Comments:  plz comment when you change something 
% Copyright BBDG.

global Database ctrl Info ROI flag Analysis data  AutomaticAnalysis SXAAnalysis debugMode SXAreport%#ok<NUSED>
global StructuralAnalysis FreeForm f0 ok_continue  QA Error ChestWallData Correction Phantomless  PhantomlessSXA%#ok<NUSED>

SaveCommonAnalysis=false;
StructuralAnalysis = [];
warning off;
Info.ReportCreated = false;
time = 0;
auto = AutomaticAnalysis
inf=Info
Analysis.AngleHoriz = [];
Error.DENSITY=false;
Error.SkinEdgeFailed = false;
Error.PeripheryCalculation=false;
Error.PhantomDetection = false;
Error.NoBreast=false;
Error.StepPhantomFailure = false;
Error.FeaturesFailed=false;
Error.ROIFailed = false;
Error.PhantomlessFailed=false;
Analysis.PhantomID=[];
AutomaticAnalysis.PhantomlessisDone=true;

multiWaitbar('Automaic Phantomless Analysis Progress', 1/5, 'Color', [0.2 0.9 0.3]  )

try
    version=Info.Version;
catch
    errmsg = lasterr
    try
        version_type = version_retreiving(Info.AcquisitionKey);
    catch
        nextpatient(0);
        multiWaitbar( 'CloseAll' );
        return;
    end
end

            

if strfind(version,'Version8')
    version.Status=true;
else
    version.Status=false;
    nextpatient(0);
    Message('Sorry! Phantomless SXA requires Verion 8.0 or later!');
    beep
    disp('Sorry! Phantomless SXA requires Verion 8.0 or later!');
    multiWaitbar( 'CloseAll' );
    return;
end


if verLessThan('images','8.0')
    beep
    disp('SORRY! Phantomless SXA requires Image Processing Toolbox Ver. 8.0 or later!');
    multiWaitbar( 'CloseAll' );
    return
end

try
  if ((~isempty(findstr( Info.PerformedProcedureStepDescription,'Weekly QC')))|(~isempty(findstr( Info.ViewPosition,'PHANTOM')))|(~isempty(findstr( Info.SeriesDescription,'Phantom')))|...
            (~isempty(findstr( Info.patient_id,'111111')))| (~isempty(findstr( Info.patient_id,'S1')))|(~isempty(findstr( Info.patient_id,'RM')))|(~isempty(findstr( Info.patient_id,'DSM')))) %#ok<FSTR,*OR2>
        Message('There is no Breast...');
        Error.NoBreast=true;
        AutomaticAnalysis.StructuralAnalysisDone=0;
        try
            SaveInDatabase('QACODES');
        catch
            errmsg = lasterr
            nextpatient(0);
            multiWaitbar( 'CloseAll' );
            return;
        end
        nextpatient(0);
        multiWaitbar( 'CloseAll' );
        return;
    end;
    
catch 
   
end
 
try 
    Message('Retrieve or compute common analysis...');
    %% try to see if a commonanalysis has already been done
    commonanalysisID=max(cell2mat(mxDatabase(Database.Name,['select commonanalysis_id from commonanalysis where acquisition_id=' num2str(Info.AcquisitionKey)])));
    if size(commonanalysisID,1)==0
%%ROI
try
    CallBack=get(ctrl.ROI,'callback');
    eval(CallBack);

catch
    
    if   Error.NoBreast
        Message('There is no Breast...');
        Error.NoBreast=true;
        
        try
            SaveInDatabase('QACODES');
        catch
            errmsg = lasterr
            nextpatient(0);
            multiWaitbar( 'CloseAll' );
            return;
        end
        
    else
        Error.ROIFailed = true;
        try
            SaveInDatabase('QACODES');
        catch
            errmsg = lasterr
            nextpatient(0);
            multiWaitbar( 'CloseAll' );
            return;
        end
    end
    errmsg = lasterr
    nextpatient(0);
    multiWaitbar( 'CloseAll' );
    return;
end
      
      
%% Skin detection
try
    CallBack=get(ctrl.SkinDetection,'callback');  %press on SkinDection button
    eval(CallBack);                                   
    SaveInDatabase('COMMONANALYSIS'); % Needs to be saved before going to  next step
                   
catch
    
    Error.SkinEdgeFailed = true;
    errmsg = lasterr
    %SaveInDatabase('QACODES');
    try
        SaveInDatabase('QACODES');
    catch
        errmsg = lasterr
        try
            SaveInDatabase('QACODES');
        catch
            errmsg = lasterr
            nextpatient(0);
            multiWaitbar( 'CloseAll' );
            return;
        end
    end
    Analysis.Step = 1.5;
    nextpatient(0);
    multiWaitbar( 'CloseAll' );
    return;
end

    else
        try
            Info.CommonAnalysisKey= commonanalysisID;
            RetrieveInDatabase('COMMONANALYSIS');
            
        catch
            if (Error.NoBreast| Error.ROIFailed |Error.SkinEdgeFailed)
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
                        multiWaitbar( 'CloseAll' );
                        return;
                    end
                    nextpatient(0);
                    multiWaitbar( 'CloseAll' );
                    return;
                end
                Analysis.Step = 1.5;
                nextpatient(0);
                multiWaitbar( 'CloseAll' );
               
                return;
            end
            
        end
    end
    

Info.SaveCommonAnalysis=true; 
    
catch
    lasterr
end

multiWaitbar('Automaic Phantomless Analysis Progress', 2/5, 'Color', [0.2 0.9 0.3]  )
%%%%%%%%%%%%%%%%%%%Check the StructuralAnalysis table%%%%%%%%%%%%%%%%%%%%

       StrucAcquisitionID=mxDatabase(Database.Name,['select * from StructuralAnalysis where acquisition_id=',num2str(Info.AcquisitionKey)]);
    if size(StrucAcquisitionID,1)==0
        AutomaticAnalysis.Step=8;
        Message('Computing Parenchymal Parameters...');
     try
         StructuralAnalysisComputation;
         if  Info.CommonAnalysisKey~=0   % Before going to InfoPhantomLessSXA we need 
                                         % to save them in Data base, otherwise we will get error
             SaveInDatabase('STRUCTURALANALYSIS');
         end
         
     catch

        Error.FeaturesFailed = true;
        errmsg = lasterr
 
        try
            SaveInDatabase('QACODES');
        catch
            errmsg = lasterr
            try
                SaveInDatabase('QACODES');
            catch
                errmsg = lasterr
                AutomaticAnalysis.StructuralAnalysisDone=0;
                nextpatient(0);
                multiWaitbar( 'CloseAll' );
                return;
            end

        end
        
        AutomaticAnalysis.StructuralAnalysisDone=0;
        nextpatient(0);
        multiWaitbar( 'CloseAll' );
        return;
     end
     
     AutomaticAnalysis.StructuralAnalysisDone=1;
     
    else
        Info.StrucAcquisitionID= StrucAcquisitionID;
        AutomaticAnalysis.StructuralAnalysisDone=1;
        % % %         RetrieveInDatabase('COMMONANALYSIS');
        % % %         draweverything;
    end
    

    
multiWaitbar('Automaic Phantomless Analysis Progress',  3/5, 'Color', [0.2 0.9 0.3]  )

% Extract All needed information from InfoPhantomLessSXA

AA = fopen('InfoPhantomLessSXA.m','r+');
count = 0;
while ~feof(AA)
    line = fgetl(AA);
    if isempty(line) || strncmp(line,'%',1) || ~ischar(line)
        continue
    end
    count = count + 1;
end
fprintf('%d lines\n',count);
% % % fclose(AA);

try
    
    %run('InfoPhantomLessSXA.m');
    
    InfoPhantomLessSXA;
catch
    Error.PhantomlessFailed = true;
    Message('PhantomLess SXA Failed! Check InfoPhantomLessSXA.m')
    
    try
        SaveInDatabase('QACODES');
    catch
        errmsg = lasterr
        try
            SaveInDatabase('QACODES');
        catch
            errmsg = lasterr
            AutomaticAnalysis.PhantomlessisDone=0;
            nextpatient(0);
            multiWaitbar( 'CloseAll' );
            return;
        end
        errmsg = lasterr
        AutomaticAnalysis.PhantomlessisDone=0;
        nextpatient(0);
        multiWaitbar( 'CloseAll' );
        return;
    end
    
end

multiWaitbar('Automaic Phantomless Analysis Progress',  4/5, 'Color', [0.2 0.9 0.3]  )

try  % sometimes there is no AcquisitionIDSXA
    if size(AcquisitionIDSXA,1)==1
        
        Info.Phantomless.checkSXAResult=true;
        
    else
        Info.Phantomless.checkSXAResult=false;
        
    end;
catch
end



if  AutomaticAnalysis.PhantomlessisDone ~= 0
    %      AutomaticAnalysis.Step=8; %check Automatic Analysis Step
    Message('Computing PhantomlessSXA Results...');
    
    try
        
        estimate_BD_BV;
multiWaitbar('Automaic Phantomless Analysis Progress', 5/5, 'Color', [0.2 0.9 0.3]  )
    catch
        
        Error.PhantomlessFailed = true;
        errmsg = lasterr
        %SaveInDatabase('QACODES');
        try
            SaveInDatabase('QACODES');
        catch
            errmsg = lasterr
            try
                SaveInDatabase('QACODES');
            catch
                errmsg = lasterr
                AutomaticAnalysis.PhantomlessisDone=0;
                nextpatient(0);
                multiWaitbar( 'CloseAll' );
                return;
            end
        end
        % % %         Analysis.Step = 1.5;
        AutomaticAnalysis.PhantomlessisDone=0;
        nextpatient(0);
        multiWaitbar( 'CloseAll' );
        return;
    end
    
    AutomaticAnalysis.PhantomlessisDone=1;
end



% % % multiWaitbar( 'CloseAll' );

if (Error.PhantomlessFailed | Error.NoBreast| Error.ROIFailed |Error.SkinEdgeFailed)
    nextpatient(0);
else
    nextpatient(1);
    
end

