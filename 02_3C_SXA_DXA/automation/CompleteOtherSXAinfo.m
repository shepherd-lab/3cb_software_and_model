% Complete OtherSXAInfo
% Lionel HERVE
% 10-29-04
global Database Analysis ctrl Phantom Info

SXAListKey=mxDatabase(Database.Name,'select sxaanalysis_id from sxaanalysis where sxaanalysis_id>1496');
for index=1:size(SXAListKey,1)
    Info.SXAAnalysisKey=SXAListKey{index};
    Database.Step=2;
    RetrieveInDatabase('SXAANALYSIS');
    QACode=cell2mat(mxDatabase(Database.Name,['select QA_code from QA_code_results where acquisition_id=',num2str(Info.AcquisitionKey)]));
    if ~sum(QACode==30)
        Field={};
        RoomID=get(ctrl.Center,'value');
        BRAND=((RoomID==13)||(RoomID==15)||(RoomID==16)||(RoomID==17))+1;
        PhantomDetection;
        try
            Phantom.Angle=Phantom.Angle+0;
        catch 
            Phantom.Angle=-90;
        end
        mxDatabase(Database.Name,['insert into OtherSXAinfo values(''',num2str(funcFindNextAvailableKey(Database,'OtherSXAinfo')),''',''',num2str(Info.SXAAnalysisKey),''',''',num2str(BRAND),''',''',num2str(Analysis.Phantomfatlevel),''',''',num2str(Analysis.Phantomleanlevel),''',''',num2str(Phantom.Angle),''',''',num2str(floor(Analysis.OriginalPhantomfatlevel)),''',''',num2str(floor(Analysis.OriginalPhantomleanlevel)),''');']);
    end
end