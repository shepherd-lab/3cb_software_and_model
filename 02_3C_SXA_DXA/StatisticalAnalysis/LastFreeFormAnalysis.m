function OutPut=LastFreeFormAnalysis(STUDY);
global Database;

data=mxDatabase(Database.Name',['select acquisition.acquisition_id,freeform_result,freeform_analysis_date from acquisition,commonanalysis,freeformanalysis where commonanalysis.acquisition_id=acquisition.acquisition_id and freeformanalysis.commonanalysis_id=commonanalysis.commonanalysis_id and study_id=''',STUDY,''' order by acquisition.acquisition_id']);

OutPut=[];
DataList=[];
CurrentID=-100;
for index=1:size(data,1)
    acquisition_ID=cell2mat(data(index,1));
    if (acquisition_ID~=CurrentID)
        if (CurrentID~=-100)
            if (size(DataList,1)>1)  %compute previous result
                %SORT THE results by date
                [SortedValues,indexSort]=sort(DataList,1);
                DataList=DataList(indexSort(:,2),:);
            end
            OutPut=[OutPut;CurrentID DataList(end,1)];
        end
        CurrentID=acquisition_ID;
        DataList=[cell2mat(data(index,2)) datenum(cell2mat(data(index,3)))];
    else
        DataList=[DataList;cell2mat(data(index,2)) datenum(cell2mat(data(index,3)))];
    end
end

