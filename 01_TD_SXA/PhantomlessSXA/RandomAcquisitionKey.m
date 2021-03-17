function [Random_acq, acquisitionkeyList]=RandomAcquisitionKey( )

global Database ctrl Info ROI flag Analysis data  AutomaticAnalysis SXAAnalysis debugMode SXAreport%#ok<NUSED>
global StructuralAnalysis FreeForm f0 ok_continue  QA Error ChestWallData Correction Phantomless  PhantomlessSXA temp_acqs %#ok<NUSED>

%Written by Amir Pasha Mahmoudzadeh
%version 1.0
%09/12/2013

SaveCommonAnalysis=false;
StructuralAnalysis = [];
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
warning off;
Info.ReportCreated = false;
time = 0;
auto = AutomaticAnalysis
inf=Info
Random_acq=0;
Info.AcquisitionKey=0;
A=1;


if  Analysis.Auto==true      %%% temp_acqs~=0
    
    B=mxDatabase(Database.Name,'select COUNT (acquisition_id) from acquisition ');
    temp_acqs=mxDatabase(Database.Name,'select acquisition_id from acquisition ');
    acquisitionkeyList=temp_acqs;
    B=cell2mat(B);
    

else
    [B,c]=size(temp_acqs);
    acquisitionkeyList =temp_acqs;
    
end;


randomArray = floor(A + (B-A)*rand(1,1));
Random_acq=temp_acqs(randomArray,:);

Info.AcquisitionKey=cell2mat(Random_acq);
Info.acquisitionkeyList=acquisitionkeyList;


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

end

