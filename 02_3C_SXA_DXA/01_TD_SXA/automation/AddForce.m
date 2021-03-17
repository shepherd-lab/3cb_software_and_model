%script to add the Force I forgot to save in the database
global Recognition Database

for localIndex=806:1126
    localIndex
    Info.AcquisitionKey=localIndex;
    try
        RetrieveInDatabase('ACQUISITION');
        CharacterRecognition;
        mxdatabase(Database.Name,['update acquisition set force=',num2str(Recognition.DAN),' where acquisition_id=',num2str(Info.AcquisitionKey)]);
    end
end