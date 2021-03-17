%Lionel HERVE
%4-29-04
%retrieve all the SXA analysis and compute the size of the file

global Database Info Image Analysis ctrl

excel.activex = actxserver('excel.application');
eWorkbooks = get(excel.activex, 'Workbooks');
eWorkbook = Add(eWorkbooks);
excel.eActiveSheet = get(excel.activex, 'ActiveSheet');
set(excel.activex, 'Visible', 1);    

set(Range(excel.eActiveSheet, ['A1:E1']), 'value',{'AcquisitionID', 'SFMR patient_id', 'Digitization Date', 'SXAresult','Film Size','QAcodes...'});

IDList=mxDatabase(Database.Name,'select acquisition_id,filename,patient_id,date_acquisition from acquisition');
for index=1:size(IDList)
    set(Range(excel.eActiveSheet, ['A',num2str(index+1),':A',num2str(index+1)]), 'value',IDList(index,1));
    set(Range(excel.eActiveSheet, ['B',num2str(index+1),':B',num2str(index+1)]), 'value',IDList(index,3));    
    set(Range(excel.eActiveSheet, ['C',num2str(index+1),':C',num2str(index+1)]), 'value',IDList(index,4));        
    s = dir(cell2mat(IDList(index,2)));
    if (s.bytes>4800000)
        filmSize='BIG';
    else
        filmSize='LITTLE';
    end
    set(Range(excel.eActiveSheet, ['E',num2str(index+1),':E',num2str(index+1)]), 'value',{filmSize});
    SXAresult=mxDatabase(Database.Name,['select sxaresult,acquisition.acquisition_id from sxaanalysis,acquisition,commonanalysis where commonanalysis.acquisition_id=acquisition.acquisition_id and sxaanalysis.commonanalysis_id=commonanalysis.commonanalysis_id and acquisition.acquisition_id=',num2str(cell2mat(IDList(index,1)))]);
    if size(SXAresult,1)
        set(Range(excel.eActiveSheet, ['D',num2str(index+1),':D',num2str(index+1)]), 'value',SXAresult(1));
    else
        set(Range(excel.eActiveSheet, ['D',num2str(index+1),':D',num2str(index+1)]), 'value',{'Skipped'});
    end        
    
    QAcodes=mxDatabase(Database.Name,['select QA_code,description from QA_code_results,QAcode,acquisition where QAcode=QA_code and QA_code_results.acquisition_id=acquisition.acquisition_id and acquisition.acquisition_id=',num2str(cell2mat(IDList(index,1)))])
    for i=1:size(QAcodes)
        set(Range(excel.eActiveSheet, [funcComputeExcellLetter(5+cell2mat(QAcodes(i,1))),num2str(index+1),':',funcComputeExcellLetter(5+cell2mat(QAcodes(i,1))),num2str(index+1)]), 'value',QAcodes(i,2));
    end
end
