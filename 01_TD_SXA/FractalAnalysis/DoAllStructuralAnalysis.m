function DoAllStructuralAnalysis
global Database Info ROI Outline
%%%% do automatically all the structural analysis

AcquisitionList=cell2mat(mxDatabase(Database.Name,'select acquisition_id from acquisition where study_id=''BBD'' and acquisition_id>=1305'));

if (0)
    %open Excel Activex
    excel.activex = actxserver('excel.application');
    eWorkbooks = get(excel.activex, 'Workbooks');
    eWorkbook = Add(eWorkbooks);
    excel.eActiveSheet = get(excel.activex, 'ActiveSheet');
    set(excel.activex, 'Visible', 1);
    set(Range(excel.eActiveSheet, 'A1:Y1'), 'Value', {'AcqID','ContourResults','FD_TH_5','FD_TH_10','FD_TH_15','FD_TH_20','FD_TH_25','FD_TH_30','FD_TH_35','FD_TH_40','FD_TH_45','FD_TH_50','FD_TH_55','FD_TH_60','FD_TH_65','FD_TH_70','FD_TH_75','FD_TH_80','FD_TH_85','FD_RMS','CD_Y','CD_SLOPE','HZ_PROJ','CALDWELL'});
end

for indexDoAll=1:size(AcquisitionList,1)
    %try to find if a ROI has been done previoulsy. Otherwise, compute it
    %automatically
    Info.AcquisitionKey=AcquisitionList(indexDoAll);
    Info.CommonAnalysisKey=cell2mat(mxDatabase(Database.Name,['select commonanalysis_id from commonanalysis where acquisition_id=',num2str(Info.AcquisitionKey)],1));
    if length(Info.CommonAnalysisKey)>0
        Info.CommonAnalysisKey=Info.CommonAnalysisKey(end);Info.AcquisitionKey=0;
        RetrieveinDatabase('COMMONANALYSIS');
        if ~strcmp(deblank(Info.PatientID),'111111111111')
            Info.AcquisitionKey
            Error.PC=false;
            StructuralAnalysisComputation;
            if ~Error.PC
                SaveInDatabase('STRUCTURALANALYSIS');
            end
        end
    end
end
