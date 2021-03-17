function compBrArea65_66

[fName, pName] = uigetfile('*.txt', 'Select an acquisition list file');
if ~isequal(fName, 0)
    listIn = textread([pName, fName]);
    n = length(listIn);
    
    for i = 1:n
        acqId = listIn(i);
        SQLstatement = ['SELECT commonanalysis_id ', ...
                        'FROM commonanalysis ', ...
                        'WHERE acquisition_id = ', num2str(acqId), ' ', ...
                        'AND version = ''Version6.6'''];
        entryRead = mxDatabase('mammo_cpmc', SQLstatement);
        if ~isempty(entryRead)
            sprintf('acquisition_id = %d', acqId)
        end
    end
end