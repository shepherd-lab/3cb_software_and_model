%process data
%%
global Database Info;

BigResult=mxdatabase(Database.Name,'select acquisition.acquisition_id,structuralanalysis.* from acquisition,commonanalysis,structuralanalysis where structuralanalysis.commonanalysis_id=commonanalysis.commonanalysis_id and commonanalysis.acquisition_id=acquisition.acquisition_id and study_id=''BBD'' order by acquisition.acquisition_id');
columns = {'FD_TH_5','FD_TH_10','FD_TH_15','FD_TH_20','FD_TH_25','FD_TH_30','FD_TH_35','FD_TH_40','FD_TH_45','FD_TH_50','FD_TH_55','FD_TH_60','FD_TH_65','FD_TH_70','FD_TH_75','FD_TH_80','FD_TH_85','FD_RMS','CD_Y','CD_SLOPE','HZ_PROJ','CALDWELL','constant'};
%%

A=cell2mat([BigResult(:,1) BigResult(:,5:end)]);
A=[A ones(size(A,1),1)];   %add a constant column
InitialSize=size(A,2)-1;
['Number of parenchymal analyses=',num2str(size(A,1))]

%% Retrieve Last Free Form Analysis
FreeForm=LastFreeFormAnalysis('BBD');
['Number of freeform analyses=',num2str(size(FreeForm,1))]


%% Match Free Form and parenchymal complexity analyses
[B,A,mixture]=Match(FreeForm,A);
B(:,1)=[]; %remove acqID
A(:,1)=[]; %remove acqID

%%
%AnalysisMode='AllCoefLimitedTraining'
AnalysisMode='LimitedCoefAllTraining'

R2=[];
if strcmpi(AnalysisMode,'LimitedCoefAllTraining')
    for index=0:InitialSize-1
        if index>0
            Cor=0;
            for i=1:size(A,2)-1
                A2=A;
                A2(:,i)=[];
                X=(A2'*A2)^-1*A2'*B;
                tempCor=1-sum((A2*X-B).^2)/sum((B-mean(B)).^2);
                if tempCor>Cor
                    resultIndex=i;
                    Cor=tempCor;
                end
            end
            A3=[A(:,resultIndex) ones(size(A,1),1)];
            X=(A3'*A3)^-1*A3'*B;        
            IndividualR2=1-sum((A3*X-B).^2)/sum((B-mean(B)).^2);
            
            A(:,resultIndex)=[];
            ['eliminate: ',cell2mat(columns(resultIndex)),'  (',num2str(IndividualR2),')']        
            columns(resultIndex)=[];
        end    
        X=(A'*A)^-1*A'*B;
        
        if index==0
            StructuralResult=A*X;
            figure;plot(B,A*X,'.');
        end
        
        R2(index+1)=1-sum((A*X-B).^2)/sum((B-mean(B)).^2);
        
        VariableName=['regress',num2str(index)];
        eval([VariableName,'=[A*X,B];']);
        save(VariableName,VariableName,'-ascii');
    end
    
    figure;plot(InitialSize-[0:index],R2);
else
    ResultPlot=figure;
    IndividualR2=[];
    IndividualR3=[];
    IndexMem=[];    
    for index=size(A,2)+1:size(A,1)-1
        IndexMem=[IndexMem,index];            
        tempIndividualR2=[];
        tempIndividualR3=[];
        for i=1:10 %number of random permutation to sum
            [RandomValue,RandomIndex]=sort(rand(1,size(A,1)));
            TrainingIndex=RandomIndex(1:index);
            TestIndex=RandomIndex(index+1:end);
                        
            %TrainingSet=A2
            A2=A(TrainingIndex,:);
            B2=B(TrainingIndex);
            X=(A2'*A2)^-1*A2'*B2;        
            R2=1-sum((A2*X-B2).^2)/sum((B2-mean(B2)).^2);
            if R2~=NaN
                tempIndividualR2=[tempIndividualR2 R2];
            end
            
            %TestSet=A3
            A3=A(TestIndex,:);
            B3=B(TestIndex);
            R2=1-sum((A3*X-B3).^2)/sum((B3-mean(B3)).^2);
            if (R2>-100)&&(R2<100)
                tempIndividualR3=[tempIndividualR3 R2];
            end
        end
        figure(ResultPlot);
        IndividualR2=[IndividualR2,mean(tempIndividualR2)];
        IndividualR3=[IndividualR3,mean(tempIndividualR3)];        
        plot(IndexMem,IndividualR2);hold on;plot(IndexMem,IndividualR3);hold off;set(gca,'ylim',[0 1]);
        drawnow;
    end
end





