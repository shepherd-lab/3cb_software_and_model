%Lionel HERVE
%5-03-04
%retrieve all the SXA analysis and do a automatic threshold analysis
function  ThresholdAnalysisDone = ThresholdCalculation()

global Database Info Image Analysis ctrl Threshold ok_continue
%global Phantom Error figuretodraw axestodraw ChestWallData

 PercentThreshold30 = 0.3;
Analysis.Threshold_density = zeros(20,1);
index = 0;
 Threshold.plotflag = 0 
Analysis.SaveInFile = false;
Analysis.SurfaceMuscle = 0;
%content={};
%columntitle={'acquisitionID';'Lean Wegde Thickness'};

   %SXAIDList=cell2mat(mxDatabase(Database.Name,'select sxaanalysis_id from sxaanalysis'));
    Threshold.Ref0=(Analysis.Phantomfatlevel-Analysis.Phantomleanlevel)/(Analysis.RefFat-Analysis.RefGland)*(0-Analysis.RefFat)+Analysis.Phantomfatlevel;  %take into account the phantom doesn't necessary span 0 to 100%
    Threshold.Ref100=(Analysis.Phantomfatlevel-Analysis.Phantomleanlevel)/(Analysis.RefFat-Analysis.RefGland)*(100-Analysis.RefGland)+Analysis.Phantomleanlevel;  %take into account the phantom doesn't necessary span 0 to 100%
    if (isnan(Threshold.Ref0) | isnan(Threshold.Ref100))
         ThresholdAnalysisDone = false;
    else
       % Ref0=(Analysis.Phantomfatlevel-Analysis.Phantomleanlevel)/(Analysis.RefFat-Analysis.RefGland)*(Analysis.RefFat-0)+Analysis.Phantomfatlevel;  %take into account the phantom doesn't necessary span 0 to 100%
       % Ref100=(Analysis.Phantomfatlevel-Analysis.Phantomleanlevel)/(Analysis.RefFat-Analysis.RefGland)*(100-Analysis.RefGland)+Analysis.Phantomleanlevel;  %take into account the phantom doesn't necessary span 0 to 100%    
       % Threshold.Ref0 = Analysis.Ref0;
       % Threshold.Ref100 =  Ref100;
        Threshold.value30 = (Threshold.Ref0+PercentThreshold30*(Threshold.Ref100-Threshold.Ref0))/Image.maximage;

        for PercentThreshold = 0.05:0.05:0.95                % 0.1:0.01:0.15  
            index = index + 1;
            %Threshold.value=(Ref0+PercentThreshold*(Ref100-Ref0))         %/Image.maximage;
            Threshold.value=(Threshold.Ref0+PercentThreshold*(Threshold.Ref100-Threshold.Ref0))/Image.maximage; ; 
            Threshold.threshold=(Threshold.Ref0+PercentThreshold*(Threshold.Ref100-Threshold.Ref0))/(Threshold.Ref100-Threshold.Ref0) ; 
            Threshold.PercentThreshold = PercentThreshold;
            
           % histogrammanagement('DrawHistLine',0);
            functhresholdcontour;
           % draweverything;
            % set(axestodraw,'nextPlot','add'); %

            %Analysis.Threshold_densityAll(index) = Threshold.pixels/Threshold.DensitySurface*100;
            diff_surface = Analysis.Surface-Analysis.SurfaceMuscle;
            Analysis.Threshold_densityAll(index) = Threshold.pixels/(diff_surface)*100;

       end
        Threshold.plotflag = 1; 
        draweverything;

        Analysis.Threshold_density =   Analysis.Threshold_densityAll(6);
        ThresholdAnalysisDone = true;
    end
    
        %funcaddinDatabase(Database,'AutomaticThresholdAnalysis',{num2str(Info.SXAAnalysisKey),num2str(Threshold.pixels/Analysis.Surface*100),date});
 % end  
%end
