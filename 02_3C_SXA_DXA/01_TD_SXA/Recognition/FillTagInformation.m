global Database Info TagTool Image OriginalTag
TagToolfnc('FROMGUI')
TagTool.DataSaved=uicontrol('style','checkbox','visible','off');
f1=figure;
f2=figure;  
%Test the reading on all the acquisition

AcqList=cell2mat(mxDatabase(Database.Name,'select acquisition_id from acquisition where acquisition_id>1509'));

for index=1:length(AcqList)
    Info.AcquisitionKey=AcqList(index);  
    Info.AcquisitionKey
    RetrieveInDatabase('ACQUISITION');
    
    try
        CharacterRecognition;
    end
    
    set(TagTool.ctrlTechnique,'value',TECHNIQUE);
    set(TagTool.ctrlmAs,'string',num2str(MAS));
    set(TagTool.ctrlkVp,'string',num2str(KVP));        
    set(TagTool.ctrlPressure,'string',num2str(DAN));        
    set(TagTool.ctrlThickness,'string',num2str(MM));           
    
    figure(f1);imagesc(OriginalTag);colormap(gray);
    figure(TagTool.figure);    
    
    set(TagTool.DataSaved,'value',false);        
    waitfor(TagTool.DataSaved,'value',true);
    
end