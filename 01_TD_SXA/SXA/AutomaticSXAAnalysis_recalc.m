%AutomaticSXAAnalysis
%Do the SXA analysis Sequence
%Lionel HERVE
%6-17-04

function  AutomaticSXAAnalysis
global ctrl Image Error ReportText AutomaticAnalysis Database Info Recognition Correction Analysis QA Threshold Site ROI h_init
global Database bb MachineParams h_slope
%tic
time = 0;
auto = AutomaticAnalysis;
%database = Database
inf = Info;
rec = Recognition;
cor = Correction;
anal = Analysis;
Analysis.AngleHoriz = [];
Analysis.DensityPercentage = [];
Analysis.DensityPercentageAngle = [];
Analysis.roi_values = [];
Analysis.roi_valuescorr = [];
Analysis.ph_slope80 = [];
Analysis.ph_offset = [];
Analysis.km = [];
Analysis.klean = [];
Analysis.Phantomleanlevel = [];
Analysis.Phantomfatlevel = [];
Analysis.params = [];
Analysis.rx = [];
Analysis.ry = [];
Analysis.ph_thickness = [];
Error.DENSITY=false;
Error.SkinEdgeFailed = false;
AutomaticAnalysis.StructuralAnalysisDone = false;
%qa = QA
control = ctrl;
%im = Image
%sit = Site
%Analysis.signal = -1
%version_type = version_retreiving(Info.AcquisitionKey);
step = 0.7;
1.2 + 6*step
bb.bb1(1).z = 1.2 ; 
bb.bb2(1).z = 1.2 + 3*step;
bb.bb3(1).z = 1.2 + 6*step;
bb.bb4(1).z = 1.2 + 2*step;
bb.bb5(1).z = 1.2 + 5*step;
bb.bb6(1).z = 1.2 + 8*step;
bb.bb7(1).z = 1.2 + 1*step;
bb.bb8(1).z = 1.2 + 4*step;
bb.bb9(1).z = 1.2 + 7*step;

acqs_filename = 'new_9000.txt';
temp_acqs = textread(acqs_filename,'%u'); 
acquisitionkeyList = temp_acqs;
for i=1:length(acquisitionkeyList)
 %tic
 Info.AcquisitionKey = acquisitionkeyList(i); 
 RetrieveInDatabase('ACQUISITION');  
 hnd = get(0,'Children')
 if find(hnd == h_init)
     delete(h_init);
  end
                   
 if find(hnd == h_slope)
     delete(h_slope);
  end
try %.sxastepanalysis_id 
  p = mxDatabase(Database.Name,['SELECT ALL SXAStepAnalysis.sxastepanalysis_id,SXAStepAnalysis.sxastepresult,SXAStepAnalysis.ROI_value1,SXAStepAnalysis.ROI_value2,SXAStepAnalysis.ROI_value3,SXAStepAnalysis.ROI_value4,SXAStepAnalysis.ROI_value5,SXAStepAnalysis.ROI_value6,SXAStepAnalysis.ROI_value7,SXAStepAnalysis.ROI_value8,SXAStepAnalysis.ROI_value9 FROM acquisition,commonanalysis,SXAStepAnalysis WHERE acquisition.acquisition_id = commonanalysis.acquisition_id  AND SXAStepAnalysis.commonanalysis_id = commonanalysis.commonanalysis_id  AND acquisition.acquisition_id = ',num2str(Info.AcquisitionKey)]);  
  params = mxDatabase(Database.Name,['SELECT ALL SXAStepAnalysis.angle_rx,SXAStepAnalysis.angle_ry,SXAStepAnalysis.angle_rz,SXAStepAnalysis.coord_tz,SXAStepAnalysis.coord_tx,SXAStepAnalysis.coord_ty FROM acquisition,commonanalysis,SXAStepAnalysis WHERE acquisition.acquisition_id = commonanalysis.acquisition_id  AND SXAStepAnalysis.commonanalysis_id = commonanalysis.commonanalysis_id  AND acquisition.acquisition_id = ',num2str(Info.AcquisitionKey)]);  
  
catch  
    errmsg = lasterr
    try
        p = mxDatabase(Database.Name,['SELECT ALL SXAStepAnalysis.sxastepanalysis_id,SXAStepAnalysis.ROI_value1,SXAStepAnalysis.ROI_value2,SXAStepAnalysis.ROI_value3,SXAStepAnalysis.ROI_value4,SXAStepAnalysis.ROI_value5,SXAStepAnalysis.ROI_value6,SXAStepAnalysis.ROI_value7,SXAStepAnalysis.ROI_value8,SXAStepAnalysis.ROI_value9 FROM acquisition,commonanalysis,SXAStepAnalysis WHERE acquisition.acquisition_id = commonanalysis.acquisition_id  AND SXAStepAnalysis.commonanalysis_id = commonanalysis.commonanalysis_id  AND acquisition.acquisition_id = ',num2str(Info.AcquisitionKey)]);  
        params = mxDatabase(Database.Name,['SELECT ALL SXAStepAnalysis.angle_rx,SXAStepAnalysis.angle_ry,SXAStepAnalysis.angle_rz,SXAStepAnalysis.coord_tz,SXAStepAnalysis.coord_tx,SXAStepAnalysis.coord_ty FROM acquisition,commonanalysis,SXAStepAnalysis WHERE acquisition.acquisition_id = commonanalysis.acquisition_id  AND SXAStepAnalysis.commonanalysis_id = commonanalysis.commonanalysis_id  AND acquisition.acquisition_id = ',num2str(Info.AcquisitionKey)]);  
        
         % if(strfind(errmsg, 'Subscripted assignment dimension mismatch'))
    catch
         errmsg = lasterr   
         nextpatient(0);
         return;
    end
end   

  sxastep_id = max(cell2mat(p(end,1)));  
 %for testing only           
%{
try
  values = mxDatabase(Database.Name,['SELECT ALL sxastepresult,ROI_value1,ROI_value2,ROI_value3,ROI_value4,ROI_value5,ROI_value6,ROI_value7,ROI_value8,ROI_value9 FROM SXAStepAnalysis WHERE  SXAStepAnalysis.sxastepanalysis_id = ',num2str(sxastep_id)]);  
  params = mxDatabase(Database.Name,['SELECT ALL angle_rx,angle_ry,angle_rz, coord_tz, coord_tx,coord_ty FROM SXAStepAnalysis WHERE  SXAStepAnalysis.sxastepanalysis_id = ',num2str(sxastep_id)]);  
 % values = mxDatabase(Database.Name,['SELECT ALL SXAStepAnalysis FROM acquisition,commonanalysis,SXAStepAnalysis WHERE acquisition.acquisition_id = commonanalysis.acquisition_id  AND SXAStepAnalysis.commonanalysis_id = commonanalysis.commonanalysis_id  AND acquisition.acquisition_id = ',num2str(Info.AcquisitionKey)]); 

catch  
    errmsg = lasterr
    try
       values = mxDatabase(Database.Name,['SELECT ALL sxastepresult,ROI_value1,ROI_value2,ROI_value3,ROI_value4,ROI_value5,ROI_value6,ROI_value7,ROI_value8,ROI_value9 FROM SXAStepAnalysis WHERE  SXAStepAnalysis.sxastepanalysis_id = ',num2str(sxastep_id)]);  
       params = mxDatabase(Database.Name,['SELECT ALL angle_rx,angle_ry,angle_rz, coord_tz, coord_tx,coord_ty FROM SXAStepAnalysis WHERE  SXAStepAnalysis.sxastepanalysis_id = ',num2str(sxastep_id)]);  
       % if(strfind(errmsg, 'Subscripted assignment dimension mismatch'))
    catch
         errmsg = lasterr   
         nextpatient(0);
         return;
    end
end   
%}

Analysis.roi_values = cell2mat(p(end,3:end));

sxastepresult_dsp = cell2mat(p(end,2));
tz_value = cell2mat(params(end,4));
Analysis.ph_thickness = (tz_value - MachineParams.bucky_distance) / MachineParams.linear_coef; 
Analysis.ry = cell2mat(params(end,2));
Analysis.rx = cell2mat(params(end,1));

Analysis.params = cell2mat(params);

Analysis.SXAanalysisStatus = 3;
Automatic_BDMDanalysis = 1;

SaveBool=1;
Analysis.Height1=0;
Analysis.Height2=0;
%Error.DENSITY=1;
Analysis.DensityPercentage=-1;
Correction.Filename='Aborted';
if Info.DigitizerId == 4
    Error.Correction=false;
    Error.BIGPADDLE=false;
else
    Error.Correction=true;
end
    AutomaticAnalysis.Step=0;
    
    
   try
   %% ROI
        AutomaticAnalysis.Step=4;
        CallBack=get(ctrl.ROI,'callback');
        eval(CallBack);

%% Skin detection
    
           AutomaticAnalysis.Step=5;
         % SkinDetection('ROOT');
           CallBack=get(ctrl.SkinDetection,'callback');  %press on SkinDection button
           eval(CallBack);
     catch
      % lasterr
           %QAcodeNumber = 3;
           %addoneqacode_inDatabase(Database.Name,QAcodeNumber, Info.AcquisitionKey);
           Error.SkinEdgeFailed = true;
           errmsg = lasterr
           SaveInDatabase('QACODES');
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
        
     %  part1 = toc

   AutomaticAnalysis.Room =  Info.centerlistactivated;
    
            
%% Density
       
            AutomaticAnalysis.Step=6;
            CallBack=get(ctrl.Density,'callback');  %press on Density button
            eval(CallBack);
            Analysis.FileNameDensity = [Info.fname(1:end-4),'Density',Info.fname(end-3:end) ]; 
            Analysis.FileNameThickness = [Info.fname(1:end-4),'Thickness',Info.fname(end-3:end)]; 
            densfile_name = Analysis.FileNameDensity;
            dens_image = uint16(Analysis.DensityImage*100);
            % temporary only for fat angle fitting
                %imwrite(dens_image,densfile_name,'png');
                %imwrite(uint16(Analysis.ThicknessImage*1000),Analysis.FileNameThickness,'png');
            %figure;
            %imagesc(uint16(Analysis.DensityImage*100)); colormap(gray);
                        %figure;
             %plot(Analysis.signal);
            %mxDatabase(Database.Name,['update sxastepanalysis set sxastepresult=''',num2str(Analysis.DensityPercentage),''' where sxastepanalysis_id=',num2str(Info.SXAAnalysisKey)]);
       
        set(ctrl.Cor,'value',false);
SaveBool = 0;
if SaveBool
%% Add QA codes
    try
        SaveInDatabase('QACODES');
    catch  
        errmsg = lasterr
        try
            SaveInDatabase('QACODES');
        % if(strfind(errmsg, 'Subscripted assignment dimension mismatch'))
        catch
             errmsg = lasterr   
             nextpatient(0);
             return;
        end
    end   
end

    
try
    if Analysis.PhantomID == 7 | Analysis.PhantomID == 8 | Analysis.PhantomID == 9
        % mxDatabase(Database.Name,['update acquisition set phantom_id=''',num2str(Analysis.PhantomID),''' where acquisition_id=',num2str(Info.AcquisitionKey)]);
        % for angle only
       try
        mxDatabase(Database.Name,['update sxastepanalysis set sxastepresult=''',num2str(Analysis.DensityPercentage),''' where sxastepanalysis_id=',num2str(sxastep_id)]);
        mxDatabase(Database.Name,['update sxastepanalysis set sxastepresult_dsp=''',num2str(sxastepresult_dsp),''' where sxastepanalysis_id=',num2str(sxastep_id)]);
        mxDatabase(Database.Name,['update sxastepanalysis set total_fatmass=''',num2str(Analysis.TotalFatMass),''' where sxastepanalysis_id=',num2str(sxastep_id)]);
        mxDatabase(Database.Name,['update sxastepanalysis set total_leanmass=''',num2str(Analysis.TotalLeanMass),''' where sxastepanalysis_id=',num2str(sxastep_id)]);
       catch  
            errmsg = lasterr
            try   
                mxDatabase(Database.Name,['update sxastepanalysis set sxastepresult=''',num2str(Analysis.DensityPercentage),''' where sxastepanalysis_id=',num2str(sxastep_id)]);
                mxDatabase(Database.Name,['update sxastepanalysis set sxastepresult_dsp=''',num2str(sxastepresult_dsp),''' where sxastepanalysis_id=',num2str(sxastep_id)]);
                mxDatabase(Database.Name,['update sxastepanalysis set total_fatmass=''',num2str(Analysis.TotalFatMass),''' where sxastepanalysis_id=',num2str(sxastep_id)]);
                mxDatabase(Database.Name,['update sxastepanalysis set total_leanmass=''',num2str(Analysis.TotalLeanMass),''' where sxastepanalysis_id=',num2str(sxastep_id)]); 
            catch
                 errmsg = lasterr   
                 nextpatient(0);
                 return;
            end
       end   

     end

catch
   errmsg = lasterr   
   nextpatient(0);
   return;

end

nextpatient(0);
%tend = toc
end
%{
if (Error.DENSITY|Error.NoCorrection|Error.StepPhantomFailure)&(SaveBool) %
    nextpatient(0);
else
    nextpatient(1);
    %nextpatient(0); % for angle only
end
%part5 = toc
%parts = [part1;part2; part3;part4;part5]
%}
;

