function getInfoFromDb( )

[fName, pName] = uigetfile('*.txt', 'Select an acquisition list file');
if ~isequal(fName, 0)
    listIn = textread([pName, fName]);
    n = length(listIn);
    
%     verList = {'Version6.5', 'Version7.0.C4'};
%     numVers = length(verList);
    error3D = zeros(n, 1);

    for i = 1:n
        acqId = listIn(i);
        
        %get date of each acquisition id
        SQLstatement = ['SELECT error_3Dreconstruction ', ...
                        'FROM SXAStepAnalysis ', ...
                        'WHERE commonanalysis_id = (', ...
                            'SELECT MAX(commonanalysis_id) ', ...
                            'FROM commonanalysis ', ...
                            'WHERE acquisition_id = ', num2str(acqId), ...
                            ' AND version LIKE ''%C4'')'];
        entryRead = mxDatabase('mammo_cpmc', SQLstatement);
        if ( ~isempty(entryRead) )
            error3D(i) = entryRead{1};
        else
            error3D(i) = NaN;
        end
        
        if mod(i, 200) == 0
            display(['xlsLine = ', num2str(i)])
        end
    end
end