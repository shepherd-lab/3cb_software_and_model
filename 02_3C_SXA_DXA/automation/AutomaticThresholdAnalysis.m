%Lionel HERVE
%5-03-04
%retrieve all the SXA analysis and do a automatic threshold analysis
function AutoThresholdAnalysis(
global Database Info Image Analysis ctrl Threshold
PercentThreshold=0.3;

%content={};
%columntitle={'acquisitionID';'Lean Wegde Thickness'};

SXAIDList=cell2mat(mxDatabase(Database.Name,'select sxaanalysis_id from sxaanalysis'));
%for index=1:size(SXAIDList)
    
    %Info.SXAAnalysisKey=SXAIDList(index);
    Database.Step=2;    
    RetrieveInDatabase('SXAANALYSIS');    
    set(ctrl.Cor,'value',true);
    ButtonProcessing('CorrectionAsked');

    Analysis.Phantomfatlevel=mean(mean(Image.image(Analysis.PhantomFaty(1):Analysis.PhantomFaty(2),Analysis.PhantomFatx(1):Analysis.PhantomFatx(2))));
    Analysis.Phantomleanlevel=mean(mean(Image.image(Analysis.PhantomLeany(1):Analysis.PhantomLeany(2),Analysis.PhantomLeanx(1):Analysis.PhantomLeanx(2))));   
    Hleancorr = 43 * tan(-Analysis.AngleHoriz * 1.1 * 6.28 /360) + 1 ;
    Analysis.Phantomleanlevel = Analysis.Phantomleanlevel + Hleancorr  * 2860;
    Ref0=(Analysis.Phantomfatlevel-Analysis.Phantomleanlevel)/(Analysis.RefFat-Analysis.RefGland)*(Analysis.RefFat-0)+Analysis.Phantomfatlevel;  %take into account the phantom doesn't necessary span 0 to 100%
    Ref100=(Analysis.Phantomfatlevel-Analysis.Phantomleanlevel)/(Analysis.RefFat-Analysis.RefGland)*(100-Analysis.RefGland)+Analysis.Phantomleanlevel;  %take into account the phantom doesn't necessary span 0 to 100%    
    
    Threshold.value=(Ref0+PercentThreshold*(Ref100-Ref0))/Image.maximage;
    histogrammanagement('DrawHistLine',0);
    functhresholdcontour;draweverything;
    Analysis.Theshold_density = Threshold.pixels/Analysis.Surface*100
    funcaddinDatabase(Database,'AutomaticThresholdAnalysis',{num2str(Info.SXAAnalysisKey),num2str(Threshold.pixels/Analysis.Surface*100),date});
    
%end
