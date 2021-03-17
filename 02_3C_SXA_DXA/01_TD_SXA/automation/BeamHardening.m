%Lionel HERVE
%4-29-04
%retrieve all the SXA analysis and compute the thickness of the two wedges

global Database Info Image Analysis ctrl

%content={};
columntitle={'Fat Wegde Thickness';'Lean Wegde Thickness'};

SXAIDList=cell2mat(mxDatabase(Database.Name,'select sxaanalysis_id from sxaanalysis'));
for index=1:size(SXAIDList)
    Info.SXAAnalysisKey=SXAIDList(index);
    acquisitionID=cell2mat(mxDatabase(Database.Name,['select commonanalysis.acquisition_ID from commonanalysis,sxaanalysis where sxaanalysis.commonanalysis_id=commonanalysis.commonanalysis_id and sxaanalysis.sxaanalysis_id=',num2str(SXAIDList(index))]));
    if acquisitionID>=896
        Database.Step=2;    
        RetrieveInDatabase('SXAANALYSIS');    
        PhantomDetection;

        set(CheckControl,'value',false);
        waitfor(CheckControl,'value',true);
        set(ctrl.Cor,'value',true);
    %    ButtonProcessing('CorrectionAsked');
    %    content(index,1)={mean(mean(Image.image(Analysis.PhantomFaty(1):Analysis.PhantomFaty(2),Analysis.PhantomFatx(1):Analysis.PhantomFatx(2))))};
    %    content(index,2)={mean(mean(Image.image(Analysis.PhantomLeany(1):Analysis.PhantomLeany(2),Analysis.PhantomLeanx(1):Analysis.PhantomLeanx(2))))};
    %    set(ctrl.LE,'string',num2str(cell2mat(content(index,1))));
    %    set(ctrl.HE,'string',num2str(cell2mat(content(index,2)))); 
        mxdatabase(Database.Name,['update sxaanalysis set Distance1=',num2str(Analysis.PhantomD1),', Distance2=',num2str(Analysis.PhantomD2),' where sxaanalysis_id=',num2str(Info.SXAAnalysisKey)]);
        mxdatabase(Database.Name,['update sxaanalysis set Phantom_Position=',num2str(Analysis.PhantomPosition),' where sxaanalysis_id=',num2str(Info.SXAAnalysisKey)]);    
    end
end
%CopyResultsToExcel(content,columntitle);