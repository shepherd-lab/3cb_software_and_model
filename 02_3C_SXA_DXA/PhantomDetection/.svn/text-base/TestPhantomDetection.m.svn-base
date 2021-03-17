%test phantomdetection
global Image Info Database

AcqIDList=cell2mat(mxDatabase(Database.Name,'select acquisition_ID from acquisition where phantom_id=6'));
for indexId=27:size(AcqIDList);
    Info.AcquisitionKey=AcqIDList(indexId);
    RetrieveInDatabase('ACQUISITION');
    if FlipOrNotFlip(Image.OriginalImage)
        imagemenu('flip');
    end
    try
        PhantomDetection;
    catch
        'Failed'
    end
    waitforbuttonpress;  
end