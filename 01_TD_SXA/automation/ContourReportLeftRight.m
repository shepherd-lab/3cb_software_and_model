%% create a report with left-right images of the 2 last contour analyses of
% the same image
% Lioenl HERVE
% 10-26-04
%
%%%%%%%%%%%%%%%%%%%%%%%%


%%
global Database ctrl figuretodraw Info Error
PowerPoint('INIT');

content=mxDatabase(Database.Name, 'select freeformanalysis_id,patient_id,acquisition.acquisition_id,view_description,date_acquisition,freeform_result,contour_area,breast_area,freeform_analysis_date from acquisition,commonanalysis,mammo_view,freeformanalysis where mammoview_id=view_id and freeformanalysis.commonanalysis_id=commonanalysis.commonanalysis_id and commonanalysis.acquisition_id=acquisition.acquisition_id and study_id=''SOY'' order by patient_id, view_id, freeformanalysis_id');
content(size(content,1)+1,:)={0,'',0,'','',0,0,0,''}; % add a fake line at the end


PatientID=content{1,2}; ViewName=content{1,4};
for i=90:size(content)
    CurrentPatientID=content{i,2};
    CurrentViewName=content{i,4};
    if (~strcmp(CurrentViewName,ViewName))||(~strcmp(CurrentPatientID,PatientID))
        if strcmp(content{i-1,2},content{i-2,2})&strcmp(content{i-1,4},content{i-2,4})
            PowerPoint('ADDSLIDE');

            Info.FreeFormAnalysisKey=content{i-2,1};
            Database.Step=2;
            RetrieveInDatabase('FREEFORMANALYSIS');
            PowerPoint('AddText','text',['SOY / Patient ID:',content{i-2,2}],'position',[0 0],'fontsize',2,'bold',true);
            PowerPoint('AddText','text',content{i-2,4},'fontsize',1.5,'bold',true);
            PowerPoint('AddText','text',['Acquisition Date:',content{i-2,5}]);
            PowerPoint('AddText','text',['Density:',num2str(content{i-2,6}),'%=',num2str(content{i-2,7}),'/',num2str(content{i-2,8})]);
            PowerPoint('AddText','text',['Reading Date:',num2str(content{i-2,9})]);            
            set(ctrl.separatedfigure,'value',true);
            Error.PhantomDetection=1;draweverything(2,'PHANTOMLINE');
            PowerPoint('copypastefigure','position',[0.0 0.2 0.5 0.8],'LockAspectRatio',false);
            delete (figuretodraw);

            Info.FreeFormAnalysisKey=content{i-1,1};
            Database.Step=2;
            RetrieveInDatabase('FREEFORMANALYSIS');
            PowerPoint('AddText','text',['SOY / Patient ID:',content{i-1,2}],'position',[0.5 0],'fontsize',2,'bold',true);
            PowerPoint('AddText','text',content{i-1,4},'fontsize',1.5,'bold',true);
            PowerPoint('AddText','text',['Acquisition Date:',content{i-1,5}]);
            PowerPoint('AddText','text',['Density:',num2str(content{i-1,6}),'%=',num2str(content{i-1,7}),'/',num2str(content{i-1,8})]);
            PowerPoint('AddText','text',['Reading Date:',num2str(content{i-2,9})]);                        
            set(ctrl.separatedfigure,'value',true);
            Error.PhantomDetection=1;draweverything(2,'PHANTOMLINE');
            PowerPoint('copypastefigure','position',[0.5 0.2 0.5 0.8],'LockAspectRatio',false);
            delete (figuretodraw);

        end


    end
    ViewName=CurrentViewName;
    PatientID=CurrentPatientID;
end