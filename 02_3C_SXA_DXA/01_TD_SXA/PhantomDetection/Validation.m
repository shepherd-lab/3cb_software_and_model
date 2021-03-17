%% validation of the phantom detection on previously analyzed scans
%Lionel HERVE
%12-12-04
global Database ctrl figuretodraw Info Error
counter=0;
powerpoint('INIT');
AcqIDList=mxDatabase(Database.Name,'select acquisition_id from acquisition where acquisition_id>3000 and acquisition_id<3500');
for index=1:size(AcqIDList,1)
    AcqID=AcqIDList{index};
    if size(mxDatabase(Database.Name,['select * from skippedsxaanalysis where acquisitionid=',num2str(AcqID)]),1)==0
        counter=counter+1;
        %         if counter==2
        try
            Database.Step=1;
            Info.AcquisitionKey=AcqID;
            RetrieveInDatabase('ACQUISITION');
            imagemenu('AutomaticCrop');
            Error.PhantomDetection=0;
            PhantomDetection;
        end
        set(ctrl.separatedfigure,'value',true);
        powerpoint('ADDSLIDE');
        draweverything(5,'PHANTOMLINE');
        PowerPoint('copypastefigure','position',[0 0 0.5 1],'LockAspectRatio',false);
        delete(figuretodraw);
    end
end
