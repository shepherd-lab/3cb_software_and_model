function Excel(RequestedAction,Data,Names)
global ExcelData

switch RequestedAction 
    case 'INIT'
        ExcelData.activex = actxserver('excel.application');
        ExcelData.eWorkbooks = get(ExcelData.activex, 'Workbooks');
        ExcelData.eWorkbook = Add(ExcelData.eWorkbooks);
        ExcelData.eActiveSheet = get(ExcelData.activex, 'ActiveSheet');
        set(ExcelData.activex, 'Visible', 1);    
    case 'TRANSFERT'
        if ~exist('Names')
            Names={''};
        end
        set(Range(ExcelData.eActiveSheet, ['A1:',funcComputeExcellLetter(size(Names,2)),'1']), 'Value', Names);
        set(Range(ExcelData.eActiveSheet, ['A2:',funcComputeExcellLetter(size(Data,2)),num2str(1+size(Data,1))]), 'Value', Data);
    case 'SAVEAS'
        invoke(ExcelData.eWorkbook,RequestedAction,Data)
end



