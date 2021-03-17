%test flip or not flip
% open All the images in mammo_CPMC database and try to see if flip or not
% flip is working fine

global Image Info

AcqIDList=cell2mat(mxDatabase('mammo_CPMC','select acquisition_ID from acquisition'));
for indexId=1:size(AcqIDList);
    Info.AcquisitionKey=AcqIDList(indexId);
    RetrieveInDatabase('ACQUISITION');
    FlipOrNotFlip(Image.image)
    waitforbuttonpress;  
end