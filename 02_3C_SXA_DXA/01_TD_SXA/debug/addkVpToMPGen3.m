function addkVpToMPGen3

SQLstatement = ['SELECT acquisition_id ', ...
                'FROM MachineParametersGen3 '];
entryRead = mxDatabase('mammo_cpmc', SQLstatement);
acqList = cell2mat(entryRead);

n = length(acqList);
for i = 1:n
    SQLstatement = ['SELECT kVp ', ...
                    'FROM acquisition ', ...
                    'WHERE acquisition_id = ', num2str(acqList(i))];
    entryRead = mxDatabase('mammo_cpmc', SQLstatement);
    kVp = entryRead{1};
    SQLstatement = ['UPDATE MachineParametersGen3 ', ...
                    'SET kVp = ', num2str(kVp), ' ', ...
                    'WHERE acquisition_id = ', num2str(acqList(i))];
	mxDatabase('mammo_cpmc', SQLstatement);
end