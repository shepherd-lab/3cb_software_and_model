function ReturnResults=StructuralAnalysisComputation
global ROI Outline Analysis Image StructuralAnalysis Error

dynamic=65536;
UnderSamplingFactor=3;
BreastFraction=1;

%% initialisation
StructuralAnalysis.FDTH=[];
StructuralAnalysis.RMS=0;
StructuralAnalysis.CDslope=0;
StructuralAnalysis.Caldwell=0;
StructuralAnalysis.Intercept=0;
Error.PC=false;

%%
try
    %Work on uncorrected images
  CurrentImage_notexcuded=Image.OriginalImage(ROI.ymin:ROI.ymax,ROI.xmin:ROI.xmax);
  %figure;
  %imagesc(CurrentImage_notexcuded); colormap(gray);
   %CurrentImage= CurrentImage_notexcuded;

   CurrentImage=excludePCmuscle(CurrentImage_notexcuded);
    clear CurrentImage_notexcuded;
    %Erase ouside of the skin edge
    midpoint=ceil(length(Outline.x)/2);
    for index=1:midpoint
        CurrentImage(1:ceil(BreastFraction*(Outline.y(index)-Analysis.midpoint)+Analysis.midpoint),ceil(BreastFraction*Outline.x(index)))=0;
        CurrentImage(ceil(BreastFraction*(Outline.y(length(Outline.y)-index)-Analysis.midpoint)+Analysis.midpoint):end,ceil(BreastFraction*Outline.x(index)))=0;        
    end    
    CurrentImage(:,ceil(BreastFraction*midpoint):end)=0;
    CurrentImage=UnderSamplingN(CurrentImage,UnderSamplingFactor);
   %  figure('Name', 'CurrentImage');
   %  imagesc(CurrentImage); colormap(gray);  
    %compute primitive of histogram of the breast
    bins=[0:1000]*(dynamic-Analysis.BackGroundThreshold)/1000;
    FlatImage=reshape(CurrentImage,prod(size(CurrentImage)),1);
    Histc = histc(FlatImage,bins);
    Histc(1)=0;   %erase background from calculation
    Histp=cumsum(Histc);
    Histp=Histp/Histp(end);
    %figure;
    %plot(Histp);
    %fractal analysis 
    FractalCurrentImage=CurrentImage;
   % figure;
   % imagesc(CurrentImage); colormap(gray);
   % figure;
    %imagesc(FractalCurrentImage); colormap(gray);
    x=1:4;
    for k=x       
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Fractal dimension of thresholded image "FD_th"
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        for indexFractalThreshold=1:17
            FractalThreshold=0.05*indexFractalThreshold;
            [maxi,thresholdindex]=max(Histp>FractalThreshold);
            threshold=bins(thresholdindex);
            
            %compute fractal dimension (feature 1: FD_th_x%)
            image = (FractalCurrentImage>threshold);
            [gradiant,gradimage]=myGradiant(image);
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
        %figure('Name', 'FractalCurrentImage');
        %imagesc(FractalCurrentImage); colormap(gray);  
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
 
        [gradiant,imageGrad]=MyGradiant(ImageYint3);
        GradYint(k)=log10(gradiant);
    end
    
    %fractal analysis FD_TH
    for indexFractalThreshold=1:17
        p = polyfit(x,FD_Th(:,indexFractalThreshold)',1);
        StructuralAnalysis.FDTH(indexFractalThreshold)=-p(1)/log10(2);
    end
    
    %fractal analysis RMS
    p = polyfit(x,resultVar,1);
    StructuralAnalysis.RMS=-p(1)/log10(2);

    %Caldwell
    p = polyfit(x,CalwellSurface,1);
    StructuralAnalysis.Caldwell=-p(1)/log10(2);
    
    %continuous dimension
    p = polyfit(log10(CdYintX),GradYint,1);
    StructuralAnalysis.CDslope=p(1);
    StructuralAnalysis.CDIntercept=p(2);

    %HZ_PROJ
    signal=sum(CurrentImage');
    %find the row where the number of pixel id less than 10 and destroy them
    pixels=sum(CurrentImage'>0);
    RowsToKeep=pixels>=10;    
    [Sorted,indexSort]=sort(RowsToKeep);
    [maxi,index]=max(Sorted);
    signal=signal./pixels;
    signal(indexSort(1:index-1))=[];
    StructuralAnalysis.HZPROJ=(var(signal))^0.5/1000;
        
    ReturnResults=[StructuralAnalysis.FDTH StructuralAnalysis.RMS StructuralAnalysis.CDIntercept StructuralAnalysis.CDslope StructuralAnalysis.HZPROJ StructuralAnalysis.Caldwell];
    StructuralAnalysis.Results=ReturnResults;
    str = StructuralAnalysis
    SaveInDatabase('STRUCTURALANALYSIS');
    ;
catch
   lasterr
   Error.PC=true; 
end