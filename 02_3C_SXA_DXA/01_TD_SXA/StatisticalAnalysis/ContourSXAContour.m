%Statistical Analysis to check correlation between left and right sxa
%results
global Database;

[AcqList]=mxDatabase(Database.Name,'select distinct acquisition_id from commonanalysis,sxaanalysis where sxaanalysis.commonanalysis_id=commonanalysis.commonanalysis_id');
Result=[];

for index=1:size(AcqList,1)
    AcqId=cell2mat(AcqList(index));
    [Data1]=mxDatabase(Database.Name,['select sxaresult,sxa_analysis_date from commonanalysis,sxaanalysis where commonanalysis.acquisition_id=',num2str(AcqId),' and sxaanalysis.commonanalysis_id=commonanalysis.commonanalysis_id and flatfieldcorrection_id=4']);    
    [Data2]=mxDatabase(Database.Name,['select freeform_result,freeform_analysis_date from commonanalysis,freeformanalysis where commonanalysis.acquisition_id=',num2str(AcqId),' and freeformanalysis.commonanalysis_id=commonanalysis.commonanalysis_id']);
    if (size(Data1,1)>0)&(size(Data2,1)>0)
        Data1=[cell2mat(Data1(:,1)) datenum(cell2mat(Data1(:,2)))];
        Data2=[cell2mat(Data2(:,1)) datenum(cell2mat(Data2(:,2)))];    
        [SortData1,index1]=sort(Data1,1);
        [SortData2,index2]=sort(Data2,1);    
        Data1=Data1(index1(:,2));
        Data2=Data2(index2(:,2));        
        Result=[Result;Data1(end,1) Data2(end,1)];
    end
    index
end
    