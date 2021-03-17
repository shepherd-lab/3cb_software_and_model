% Automatic DXA Analysis
% for images retrieved from Database
% Aurelie 05/19/08

% Images (LE and HE) are already opened at this stage.

function  AutomaticDXAAnalysis()
global DXAAnalysis ROI ctrl Info ReportText Analysis Error SXAAnalysis

Error.DENSITY=false;
SaveBool= true;
Info.ReportCreated = false; 
Error.SkinEdgeFailed = false;
%% load the Calibration Points and calculate the ci and di coefficients (saved as X)
  try 
      CalibrationDXA_AUTO();

%% Show material
      AutomaticAnalysis.Step=1;
      ShowDXAImage('MATERIAL');
  catch
      errmsg = lasterr
      nextpatient(0);
      return;
  end
%%%%% Copy and paste of the Automatic SXA Analysis:

%% Automatic ROI and Skin detection 
try
    AutomaticAnalysis.Step=4;
    
    CallBack=get(ctrl.ROI,'callback');            % press on Auto ROI button
    eval(CallBack);

    AutomaticAnalysis.Step=5;

    CallBack=get(ctrl.SkinDetection,'callback');  % press on Auto SkinDection button
    eval(CallBack);
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

%% Density TODO

    AutomaticAnalysis.Step=6;
    
    CallBack=get(ctrl.WholeBreastDensityDXAButton,'callback');        %press on Density button
    eval(CallBack);
    
    
    if ~Error.DENSITY
        DXAAnalysis.FileNameDensity = [Info.fname(1:end-4),'DXADensity',Info.fname(end-3:end) ];
        DXAAnalysis.FileNameThickness = [Info.fname(1:end-4),'DXAThickness',Info.fname(end-3:end)];
             
        % save the density and thickness images
        imwrite(uint16(DXAAnalysis.DXAroi_material*100),DXAAnalysis.FileNameDensity,'png');
        imwrite(uint16(DXAAnalysis.DXAroi_thickness*1000),DXAAnalysis.FileNameThickness,'png');
        
        x1 = [1, ROI.xmax];
        y1 = [ROI.ymax/2,ROI.ymax/2-60];
        DXAAnalysis.signal1 = improfile(DXAAnalysis.DXAroi_thickness,x1,y1);
              
        x2 = [(ROI.xmax - ROI.xmin)*0.5  (ROI.xmax - ROI.xmin)*0.5];
        y2 = [1 ROI.ymax];
        DXAAnalysis.signal2 = improfile(funcclim(DXAAnalysis.DXAroi_thickness,0,10),x2,y2);
        
        FileNameThickness = [Info.fnameLE(1:end-4),'SXAThickness',Info.fnameLE(end-3:end)];
        
        s=dir (FileNameThickness);
        if ~isempty(s)
            SXAAnalysis.SXAroi_thickness = double(imread(FileNameThickness))/1000; 
            SXAAnalysis.signal1 = improfile(SXAAnalysis.SXAroi_thickness,x1,y1);
            SXAAnalysis.signal2 = improfile(SXAAnalysis.SXAroi_thickness,x2,y2);
        else
            SXAAnalysis.signal1 = [];
            SXAAnalysis.signal2 = [];
        end
        %figure;plot(DXAAnalysis.signal2);  hold on;
        %if  ~isempty(SXAAnalysis)
        %    signal1 = improfile(Analysis.SXAthickness_mapproj,x1,y1);
        %    plot(signal1,'r');xlabel('Pixels');ylabel('Thickness (cm)');
        %end
    end
    AutomaticAnalysis.Step=7;

%set(ctrl.Cor,'value',false); %% ??


%% Report creation
switch AutomaticAnalysis.Step
   
    case 1
        ReportText=[ReportText,'Database access (stop)@'];
    case 2
        %ReportText=[ReportText,'Phantom detection (stop)@'];
         ReportText=[ReportText,'Material Calculation (stop)@'];
    %ase 3
    %    ReportText=[ReportText,'Image correction (stop)@'];
    %    Error.NoCorrection=true;
    case 4
        ReportText=[ReportText,'ROI detection (stop)@'];
    case 5
        ReportText=[ReportText,'Skin detection (stop)@'];
    case 6
        ReportText=[ReportText,'Density computation (stop)@'];
        Error.DENSITY=true;
        Analysis.DensityPercentage=-1;
    %case 7
    %    ReportText=[ReportText,'BDMD computation (stop)@'];
    %case 8
    %    ReportText=[ReportText,'BDPC computation (stop)@'];
end

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

try
    
        ShowDXAImage('LE');
      
        Message('Creating report...');
        CreateReport('ADDCOMMON');
        CreateReport('DXASPECIFIC');      
        CreateReport('QACODES');
        CreateReport('ADDREPORTTEXT');
        if  Error.DENSITY == false
            %if Analysis.signal ~= -1
                 CreateReport('ADDREPORTTEXT');
                 CreateReport('ADDDXAPROFILES');
            %end
             
        end
        Info.ReportCreated = true;
    %end


catch
    errmsg = lasterr
    nextpatient(0);
    return;

end
%% Go to next patient
% save if the analysis was ok otherwise choose nextpatient

if (Error.DENSITY &(SaveBool)) %
    nextpatient(0);
else
    nextpatient(1); %0 is for temporary
end



