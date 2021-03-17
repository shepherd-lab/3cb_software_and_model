function removeAcqIdByDate

dateSet = '20090723';

[fName, pName] = uigetfile('*.txt', 'Select an acquisition list file');
if ~isequal(fName, 0)
    listIn = textread([pName, fName]);
    n = length(listIn);
    listOut = zeros(size(listIn));
    nOut = 0;
    for i = 1:n
        acqId = listIn(i);
        SQLstatement = ['SELECT date_acquisition ', ...
                        'FROM acquisition ', ...
                        'WHERE acquisition_id = ', num2str(acqId)];
        entryRead = mxDatabase('mammo_cpmc', SQLstatement);
        if str2double(entryRead{1}) >= str2double(dateSet)
            nOut = nOut + 1;
            listOut(nOut) = listIn(i);
        end
    end
    %delete empty entries
    listOut(nOut+1:end) = [];
    %save new list file
    newFileName = [pName, fName(1:end-4), '_new.txt'];
    fid = fopen(newFileName, 'wt');
    fprintf(fid, '%d\n', listOut);
    fclose(fid);
end
