function nextID = getNextAnaID(fName)

acqList = textread(fName);
n = length(acqList);

SQLstatementCom = ['SELECT commonanalysis_id ', ...
                'FROM commonanalysis ', ...
                'WHERE acquisition_id = '];
found = 0;
i = 1;
while (i <= n && ~found)
    SQLstatement = [SQLstatementCom, num2str(acqList(i)), ' ', ...
                    'AND version = ''Version7.0.C1'''];
    entryRead = mxDatabase('mammo_cpmc', SQLstatement);
    if isempty(entryRead)
        found = 1;
        nextID = acqList(i);
    end
    i = i + 1;
end

if ~found
    nextID = [];
end