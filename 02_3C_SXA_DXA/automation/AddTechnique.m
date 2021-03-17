%script to correct the technnique which was buggy during the saving
%operation
global Recognition Database

for localIndex=806:1491
    Info.AcquisitionKey=localIndex;
    try
        RetrieveInDatabase('ACQUISITION');
        CharacterRecognition;
        if Error.TECHNIQUE
            TechniqueID=3;
        else
            switch Recognition.TECHNIQUE
                case 'MO/MO'
                    TechniqueID=1;
                case 'MO/RH'
                    TechniqueID=2;
                case 'RH/RH'
                    TechniqueID=4;
                otherwise
                    TechniqueID=3;
            end
        end
        mxDatabase(Database.Name,['update acquisition set Technique_id=''',num2str(TechniqueID),''' where acquisition_ID=''',num2str(Info.AcquisitionKey),'''']);
        [num2str(localIndex),':',Recognition.TECHNIQUE,':',num2str(TechniqueID)]
    end
end