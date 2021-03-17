function DoAllStructuralAnalysis
global Database Info ROI Outline CurrentImage StructuralAnalysis FreeFormResults BigResult Analysis
%%%% do automatically all the structural analysis

AcquisitionList=cell2mat(mxDatabase(Database.Name,'select acquisition_id from acquisition where study_id=''sxadxa'''));
dynamic=65536;

UnderSamplingFactor=1;
%dynamic=4096;    
UnderSamplingFactor=3;
BreastFraction=1;
    
BigResult=[];
if (1)
    %open Excel Activex 
    excel.activex = actxserver('excel.application');
    eWorkbooks = get(excel.activex, 'Workbooks');
    eWorkbook = Add(eWorkbooks);
    excel.eActiveSheet = get(excel.activex, 'ActiveSheet');
    set(excel.activex, 'Visible', 1);    
    set(Range(excel.eActiveSheet, 'A1:Y1'), 'Value', {'AcqID','ContourResults','FD_TH_5','FD_TH_10','FD_TH_15','FD_TH_20','FD_TH_25','FD_TH_30','FD_TH_35','FD_TH_40','FD_TH_45','FD_TH_50','FD_TH_55','FD_TH_60','FD_TH_65','FD_TH_70','FD_TH_75','FD_TH_80','FD_TH_85','FD_TH_90','FD_RMS','CD_Y','CD_SLOPE','HZ_PROJ','CALDWELL'});
end    

for indexDoAll=1:1%size(AcquisitionList,1)
    %try to find if a ROI has been done previoulsy. Otherwise, compute it
    %automatically
    Info.AcquisitionKey=AcquisitionList(indexDoAll);    
    Info.CommonAnalysisKey=cell2mat(mxDatabase(Database.Name,['select commonanalysis_id from commonanalysis where acquisition_id=',num2str(Info.AcquisitionKey)],1));

    if length(Info.CommonAnalysisKey)>0
        Info.AcquisitionKey=0;
        RetrieveinDatabase('COMMONANALYSIS');
        Outline.x(1:10)
    else
        %compute ROI and skinedge
        RetrieveinDatabase('ACQUISITION');
        ROIDetection('ROOT');
        skindetection('FROMGUI');
    end
    CurrentImage=ROI.image;    
    figure;imagesc(CurrentImage);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    CropThreshold=Analysis.BackGroundThreshold+1000;    %Boone threshold to be in parenchymal tissues
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    %Erase ouside of the skin edge
    midpoint=ceil(length(Outline.x)/2);
    for index=1:midpoint
        CurrentImage(1:ceil(BreastFraction*(Outline.y(index)-Analysis.midpoint)+Analysis.midpoint),ceil(BreastFraction*Outline.x(index)))=0;
        CurrentImage(ceil(BreastFraction*(Outline.y(length(Outline.y)-index)-Analysis.midpoint)+Analysis.midpoint):end,ceil(BreastFraction*Outline.x(index)))=0;        
    end    
    CurrentImage(:,ceil(BreastFraction*midpoint):end)=0;
%    figure;imagesc(CurrentImage);
    
    %apply a threshold to keep only parenchyma and undersample
    CurrentImage=UndersamplingN((CurrentImage>CropThreshold).*(CurrentImage-CropThreshold),UnderSamplingFactor);
    
%    figure;imagesc(CurrentImage);colormap(gray);
    
    %compute primitive of histogram of the breast
    bins=[0:1000]*(dynamic-CropThreshold)/1000;
    FlatImage=reshape(CurrentImage,prod(size(CurrentImage)),1);
    Histc = histc(FlatImage,bins);
    Histc(1)=0;   %erase background from calculation
    Histp=cumsum(Histc);
    Histp=Histp/Histp(end);
    
    %fractal analysis 
    FractalCurrentImage=CurrentImage;
    x=1:4;
    for k=x       
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Fractal dimension of thresholded image "FD_th"
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        for indexFractalThreshold=1:18
            FractalThreshold=0.05*indexFractalThreshold;
            [maxi,thresholdindex]=max(Histp>FractalThreshold);
            threshold=bins(thresholdindex);
            
            %compute fractal dimension (feature 1: FD_th_x%)
            image = (FractalCurrentImage>threshold);
            [gradiant,gradimage]=MyGradiant(image);
            FD_Th(k,indexFractalThreshold)=log10(gradiant);
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Fractal dimension of RMS %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        %destroy the zeros 
        FlatImage=reshape(FractalCurrentImage,1,prod(size(FractalCurrentImage)));        
        Sorted=sort(FlatImage,2);
        [maxi,index]=max(Sorted>0);
        Sorted(1:index-1)=[];
        resultVar(k)=log10(var(Sorted))/2;

        %%%%%%%%%%%%%%%%%%%%%
        %%%%% CALDWELL %%%%%%
        %%%%%%%%%%%%%%%%%%%%%
        tempImage=abs(FractalCurrentImage(1:end-1,1:end-1)-FractalCurrentImage(2:end,1:end-1))+abs(FractalCurrentImage(1:end-1,1:end-1)-FractalCurrentImage(1:end-1,2:end));
        CalwellSurface(k)=log10(sum(sum(tempImage)));
        
        FractalCurrentImage=UnderSamplingN(FractalCurrentImage,2);
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% Continuous dimension %%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    CdYintX=[1:5]; 
    for k=CdYintX          
        S=4*k+1;
        %Prolongate Image to avoid border effect
        ImageYint2=[CurrentImage(:,1)*ones(1,2*k) CurrentImage CurrentImage(:,end)*ones(1,2*k)];
        ImageYint2=[ones(2*k,1)*ImageYint2(1,:); ImageYint2; ones(2*k,1)*ImageYint2(end,:)];        
        
        filter=ones(S)/S^2;
        ConvImage=conv2(ImageYint2,filter,'valid');        
        ImageYint3=CurrentImage-ConvImage;
%        figure;imagesc(ImageYint3);colormap(gray);
 
        [gradiant,imageGrad]=MyGradiant(ImageYint3);
        GradYint(k)=log10(gradiant);
    end
    
    %fractal analysis FD_TH
    for indexFractalThreshold=1:18
        p = polyfit(x,FD_Th(:,indexFractalThreshold)',1);
        StructuralAnalysis.FDTH(indexDoAll,indexFractalThreshold)=-p(1)/log10(2);
        %figure;plot(FD_Th(:,indexFractalThreshold));        
    end
    %fractal analysis RMS
    p = polyfit(x,resultVar,1);
    StructuralAnalysis.RMS(indexDoAll)=-p(1)/log10(2);

    %Caldwell
    p = polyfit(x,CalwellSurface,1);
    StructuralAnalysis.Caldwell(indexDoAll)=-p(1)/log10(2);
    
    %continuous dimension
    p = polyfit(log10(CdYintX),GradYint,1);
    StructuralAnalysis.CDslope(indexDoAll)=p(1);
    StructuralAnalysis.CDIntercept(indexDoAll)=p(2);

    %HZ_PROJ
    signal=sum(CurrentImage');
    %find the row where the number of pixel id less than 10 and destroy them
    pixels=sum(CurrentImage'>0);
    RowsToKeep=pixels>=10;    
    [Sorted,indexSort]=sort(RowsToKeep);
    [maxi,index]=max(Sorted);
    signal=signal./pixels;
    signal(indexSort(1:index-1))=[];
%    figure;plot(signal);
    StructuralAnalysis.HZPROJ(indexDoAll)=(var(signal))^0.5;
    
    
    %%%% Compare with freeform result
    DatabaseResults=cell2mat(mxDatabase(Database.Name,['select freeform_result from freeformanalysis,commonanalysis,acquisition where freeformanalysis.commonanalysis_id=commonanalysis.commonanalysis_id and commonanalysis.acquisition_id=acquisition.acquisition_id and acquisition.acquisition_id=',num2str(Info.AcquisitionKey)]));
    if length(DatabaseResults)>0
        FreeFormResults(indexDoAll)=mean(mean(DatabaseResults));
    else
        FreeFormResults(indexDoAll)=0;        
    end
   
    resultsToBeSent=[Info.AcquisitionKey FreeFormResults(indexDoAll) StructuralAnalysis.FDTH(indexDoAll,:) StructuralAnalysis.RMS(indexDoAll) StructuralAnalysis.CDIntercept(indexDoAll) StructuralAnalysis.CDslope(indexDoAll) StructuralAnalysis.HZPROJ(indexDoAll) StructuralAnalysis.Caldwell(indexDoAll)];
    set(Range(excel.eActiveSheet, ['A',num2str(indexDoAll+1),':Y',num2str(indexDoAll+1)]), 'Value', resultsToBeSent);
    BigResult=[BigResult;resultsToBeSent];
end

save('BigResult','BigResult','-ascii');
