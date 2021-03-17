%Lionel HERVE
%5-03-04
%retrieve all the SXA analysis and do a automatic threshold analysis
function AutoThreshAnalysis()
global Database Info Image Analysis ctrl Threshold ok_continue
%global Phantom Error figuretodraw axestodraw ChestWallData

 PercentThreshold30 = 0.3;
Analysis.Threshold_density = zeros(20,1);
index = 0;
 Threshold.plotflag = 0 
Analysis.SaveInFile = false;

%content={};
%columntitle={'acquisitionID';'Lean Wegde Thickness'};

   %SXAIDList=cell2mat(mxDatabase(Database.Name,'select sxaanalysis_id from sxaanalysis'));
%for index=1:size(SXAIDList)
   % SQLstatement=['SELECT  sxaanalysis.sxaanalysis_id FROM acquisition,commonanalysis,OtherSxaInfo,SXAAnalysis WHERE acquisition.acquisition_id = commonanalysis.acquisition_id  AND commonanalysis.commonanalysis_id = sxaanalysis.commonanalysis_id   AND acquisition.acquisition_id =',num2str(Info.AcquisitionKey)];
  SQLstatement= ['SELECT ALL SXAAnalysis.SXAAnalysis_id FROM acquisition,commonanalysis,SXAAnalysis WHERE acquisition.acquisition_id = commonanalysis.acquisition_id  AND commonanalysis.commonanalysis_id = sxaanalysis.commonanalysis_id  AND acquisition.acquisition_id = ',num2str(Info.AcquisitionKey)];  
    sxa_id=cell2mat(mxDatabase(Database.Name,SQLstatement));;
    len = length(sxa_id)
 % if len ~= 0
   % Info.SXAAnalysisKey= sxa_id(len) 
    Info.SXAAnalysisKey= max(sxa_id);
    Database.Step=2;    
   % Analysis.ThresholdOnly = true;
    SQLstatement= ['SELECT ALL FreeFormAnalysis.FreeFormAnalysis_id  FROM acquisition,commonanalysis,FreeFormAnalysis WHERE acquisition.acquisition_id = commonanalysis.acquisition_id  AND commonanalysis.commonanalysis_id = freeformanalysis.commonanalysis_id  AND commonanalysis.acquisition_id = ',num2str(Info.AcquisitionKey)];  
    
    Info.FreeFormAnalysisKey=max(cell2mat(mxDatabase(Database.Name,SQLstatement)));;  
    %SELECT ALL acquisition.acquisition_id,FreeFormAnalysis.FreeFormAnalysis_id,FreeFormAnalysis.commonanalysis_id,FreeFormAnalysis.freeform_result FROM acquisition,commonanalysis,FreeFormAnalysis WHERE acquisition.acquisition_id = commonanalysis.acquisition_id  AND commonanalysis.commonanalysis_id = freeformanalysis.commonanalysis_id  AND commonanalysis.acquisition_id = '816'  
    if ~isempty(Info.FreeFormAnalysisKey)
      RetrieveInDatabase('FREEFORMANALYSIS'); 
    end  
    freeform_chestwall_id = Analysis.ChestWallID;
    RetrieveInDatabase('SXAANALYSIS'); 
    
 %{   
  %% ROI detection
    AutomaticAnalysis.Step=4;
    CallBack=get(ctrl.ROI,'callback');
    eval(CallBack);

%% Skin detection
        AutomaticAnalysis.Step=5;
        CallBack=get(ctrl.SkinDetection,'callback');  %press on SkinDection button
        eval(CallBack);
%}
    set(ctrl.CheckBreast,'value',true);   
    set(ctrl.Cor,'value',true);
    ButtonProcessing('CorrectionAsked');
    Analysis.Phantomfatlevel=mean(mean(Image.image(Analysis.PhantomFaty(1):Analysis.PhantomFaty(2),Analysis.PhantomFatx(1):Analysis.PhantomFatx(2))));
    Analysis.Phantomleanlevel=mean(mean(Image.image(Analysis.PhantomLeany(1):Analysis.PhantomLeany(2),Analysis.PhantomLeanx(1):Analysis.PhantomLeanx(2))));   
  
   % Hleancorr = 43 * tan(-Analysis.AngleHoriz * 1.1 * 6.28 /360) + 1 ;
   % Analysis.Phantomleanlevel = Analysis.Phantomleanlevel + Hleancorr  * 2860;
   
    if Analysis.PhantomID == 3
       Hleancorr = 39 * tan(-Analysis.AngleHoriz * 1.1 * 6.28 /360); %+ 1 
       Analysis.Phantomleanlevel = Analysis.Phantomleanlevel + Hleancorr  * 3000;
       %Leanref_corr = Analysis.Phantomleanlevel + (Hleancorr + Hfat_ROI) * 3000;
    elseif Analysis.PhantomID == 5
       Hleancorr = 20 * tan(-Phantom.AngleHoriz * 1.1 * 6.28 /360);  %43
       Leanref_corr = Analysis.Phantomleanlevel + Hleancorr * 2860;
    else
       Hleancorr = 43 * tan(-Analysis.AngleHoriz * 1.1 * 6.28 /360) + 1  %43
       Analysis.Phantomleanlevel = Analysis.Phantomleanlevel + Hleancorr  * 2860;
       %Leanref_corr = Analysis.Phantomleanlevel + (Hleancorr + Hfat_ROI) * 2860;
   end
    
    
    Threshold.Ref0=(Analysis.Phantomfatlevel-Analysis.Phantomleanlevel)/(Analysis.RefFat-Analysis.RefGland)*(0-Analysis.RefFat)+Analysis.Phantomfatlevel;  %take into account the phantom doesn't necessary span 0 to 100%
    Threshold.Ref100=(Analysis.Phantomfatlevel-Analysis.Phantomleanlevel)/(Analysis.RefFat-Analysis.RefGland)*(100-Analysis.RefGland)+Analysis.Phantomleanlevel;  %take into account the phantom doesn't necessary span 0 to 100%
    
   % Ref0=(Analysis.Phantomfatlevel-Analysis.Phantomleanlevel)/(Analysis.RefFat-Analysis.RefGland)*(Analysis.RefFat-0)+Analysis.Phantomfatlevel;  %take into account the phantom doesn't necessary span 0 to 100%
   % Ref100=(Analysis.Phantomfatlevel-Analysis.Phantomleanlevel)/(Analysis.RefFat-Analysis.RefGland)*(100-Analysis.RefGland)+Analysis.Phantomleanlevel;  %take into account the phantom doesn't necessary span 0 to 100%    
   % Threshold.Ref0 = Analysis.Ref0;
   % Threshold.Ref100 =  Ref100;
    Threshold.value30 = (Threshold.Ref0+PercentThreshold30*(Threshold.Ref100-Threshold.Ref0))/Image.maximage;
     %press on correction button
     ComputeDensity;
   
    for PercentThreshold = 0.05:0.05:0.95                % 0.1:0.01:0.15  
        index = index + 1;
        %Threshold.value=(Ref0+PercentThreshold*(Ref100-Ref0))         %/Image.maximage;
        Threshold.value=(Threshold.Ref0+PercentThreshold*(Threshold.Ref100-Threshold.Ref0))/Image.maximage; ; 
        Threshold.threshold=(Threshold.Ref0+PercentThreshold*(Threshold.Ref100-Threshold.Ref0))/(Threshold.Ref100-Threshold.Ref0) ; 
        Threshold.PercentThreshold = PercentThreshold;
        histogrammanagement('DrawHistLine',0);
        functhresholdcontour;
        draweverything;
        % set(axestodraw,'nextPlot','add'); %

        %Analysis.Threshold_densityAll(index) = Threshold.pixels/Threshold.DensitySurface*100;
        diff_surface = Analysis.Surface-Analysis.SurfaceMuscle;
        Analysis.Threshold_densityAll(index) = Threshold.pixels/(diff_surface)*100;
   
   end
    Threshold.plotflag = 1; 
    draweverything;
   
    Analysis.Threshold_density =   Analysis.Threshold_densityAll(6);
    Message('Creating report...');
    CreateReport('ADDCOMMON');
    CreateReport('ADDDENSITY');
    %threshold_results = [ Analysis.Threshold_densityAll]
    file_name = 'threshold_results.txt';
    % density_results = [Info.AcquisitionKey Analysis.Threshold_densityAll Analysis.Threshold_densityAllgray]
    density_results = [Info.AcquisitionKey Analysis.Threshold_densityAll]
    %if Analysis.SaveInFile == true
       % fid = fopen(['P:\Temp\ThresholdAnalysis\thresholdanalysis',num2str(Info.AcquisitionKey)],'a+');
        %fwrite(fid,['P:\Temp\ThresholdAnalysis\thresholdanalysis',num2str(Info.AcquisitionKey)],'Analysis.Threshold_densityAll','real*8');  
    %save(['P:\Temp\ThresholdAnalysis\',file_name],'density_results','-ascii','-append');  
    % fclose(fid);
       ok_continue = true;
    %  end
    % else
    Threshold.plotflag = 0 
    NextPatient(1);
    %funcaddinDatabase(Database,'AutomaticThresholdAnalysis',{num2str(Info.SXAAnalysisKey),num2str(Threshold.pixels/Analysis.Surface*100),date});
 % end  
%end
