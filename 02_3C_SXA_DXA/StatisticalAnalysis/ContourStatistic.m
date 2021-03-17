global Database;

data=mxDatabase(Database.Name','select acquisition.acquisition_id,freeform_result,freeform_analysis_date from acquisition,commonanalysis,freeformanalysis where commonanalysis.acquisition_id=acquisition.acquisition_id and freeformanalysis.commonanalysis_id=commonanalysis.commonanalysis_id order by acquisition.acquisition_id');

VarResults=[];
TimeDistance=[];
ShortTermList=[];
LongTermList=[];
PlotList=[];
DataList=[];
CurrentID=-100;
for index=1:size(data,1)
    acquisition_ID=cell2mat(data(index,1));
    if acquisition_ID~=CurrentID
        if size(DataList,1)>1  %compute previous result
            %SORT THE results by date
            [SortedValues,indexSort]=sort(DataList,1);
            DataList=DataList(indexSort(:,2),:);
            VarResults=[VarResults;var(DataList(:,1))];            
            for index2=1:size(DataList,1)-1
                DifferenceTime=DataList(end,2)-DataList(index2,2);
                MeasurementDifference=DataList(end,1)-DataList(index2,1);
                if DifferenceTime>50
                    LongTermList=[LongTermList,MeasurementDifference];
                    PlotList=[PlotList;DataList(1,1) DataList(end,1)];
                else
                    ShortTermList=[ShortTermList,MeasurementDifference];                    
                end
            end
            DifferenceTime=DataList(end,2)-DataList(1,2);            
            if DifferenceTime>50            
                PlotList=[PlotList;DataList(1,1) DataList(end,1)];
            end
        end
        CurrentID=acquisition_ID;
        DataList=[cell2mat(data(index,2)) datenum(cell2mat(data(index,3)))];
    else
        DataList=[DataList;cell2mat(data(index,2)) datenum(cell2mat(data(index,3)))];
    end
end


figure;plot(PlotList(:,1),PlotList(:,2),'.');hold on;plot([1:100],'r');

B=PlotList(:,1);
A=[ones(size(PlotList(:,2))) PlotList(:,2)];

X=(A'*A)^-1*A'*B;
R2=1-sum((A*X-B).^2)/sum((B-mean(B)).^2)


