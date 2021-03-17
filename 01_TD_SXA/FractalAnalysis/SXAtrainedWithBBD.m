%process data
global Database Info;
columns = {'FD_TH_5','FD_TH_10','FD_TH_15','FD_TH_20','FD_TH_25','FD_TH_30','FD_TH_35','FD_TH_40','FD_TH_45','FD_TH_50','FD_TH_55','FD_TH_60','FD_TH_65','FD_TH_70','FD_TH_75','FD_TH_80','FD_TH_85','FD_TH_90','FD_RMS','CD_Y','CD_SLOPE','HZ_PROJ','CALDWELL','constant'};



%BBD first to train coefficient
BigResult=load('BigResultsBBD');

A=BigResult(:,3:end);   %fractal result
A=[A ones(size(A,1),1)];   %add a constant column
A(:,end-6)=[];  %delete this column, FD_TH_90 than can have infinite number (too close from 100%)
InitialSize=size(A,2)-1;
columns(end-6)=[];
B=BigResult(:,2);


X=(A'*A)^-1*A'*B;
R2=1-sum((A*X-B).^2)/sum((B-mean(B)).^2)
StructuralResult=A*X;
figure;plot(B,A*X,'.');

%retrieve SXA fractal analysis
BigResult=load('BigResultsSXA');

A=BigResult(:,3:end);   %fractal result
A=[A ones(size(A,1),1)];   %add a constant column
A(:,end-6)=[];  %delete this column, FD_TH_90 than can have infinite number (too close from 100%)
InitialSize=size(A,2)-1;
columns(end-6)=[];
B=BigResult(:,2);

R2=1-sum((A*X-B).^2)/sum((B-mean(B)).^2)
StructuralResult=A*X;
figure;plot(B,A*X,'.');


    %put the results in the database
    for index2=1:size(A,1)
        Info.AcquisitionKey=BigResult(index2,1);
        Info.CommonAnalysisKey=cell2mat(mxDatabase(Database.Name,['select commonanalysis_id from commonanalysis where acquisition_id=',num2str(Info.AcquisitionKey)],1));
        %retrieve the common analysis key
        key=funcFindNextAvailableKey(Database,'StructuralAnalysis');
        mxDatabase(Database.Name,['insert into StructuralAnalysis values (',num2str(key),',',num2str(Info.CommonAnalysisKey),',',num2str(StructuralResult(index2)),',',num2str(Info.Operator),',''',date,''')'])
    end




