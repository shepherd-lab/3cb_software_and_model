%Export Excel
%Lionel HERVE
%6-18-03

% First, open an Excel Server.
excel.activex = actxserver('excel.application');

% Insert a new workbook.
eWorkbooks = get(excel.activex, 'Workbooks');
eWorkbook = Add(eWorkbooks);

% Get a handle to the active sheet.
excel.eActiveSheet = get(excel.activex, 'ActiveSheet');

% Put a MATLAB array into Excel.
excel.eActiveSheetRange = Range(excel.eActiveSheet, 'A1', 'A1');
set(excel.eActiveSheetRange, 'Value', {SimulationX.result.title1});
excel.eActiveSheetRange = Range(excel.eActiveSheet, 'B1', 'B1');
set(excel.eActiveSheetRange, 'Value', {SimulationX.result.title2});
for j=1:size(SimulationX.result.energies,2)
    excel.eActiveSheetRange = Range(excel.eActiveSheet, ['A',num2str(j+1)], ['A',num2str(j+1)]);
    set(excel.eActiveSheetRange, 'Value', {SimulationX.result.energies(j)});
    excel.eActiveSheetRange = Range(excel.eActiveSheet, ['B',num2str(j+1)], ['B',num2str(j+1)]);
    set(excel.eActiveSheetRange, 'Value', {SimulationX.result.variable(j)});
end

set(excel.activex, 'Visible', 1);

clear j;
