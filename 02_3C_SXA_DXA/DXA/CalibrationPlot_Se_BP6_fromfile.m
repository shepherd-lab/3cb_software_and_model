%plot of the DXA calibration for BIG PHANTOM
function CalibrationPlot_Se_BP7_fromfile()
global X;
global CalibrationPoints;

% f1=figure;plot3(CalibrationPoints(:,4),CalibrationPoints(:,5),CalibrationPoints(:,2),'o','markersize',5,'markerfacecolor','black','markeredgecolor','black');
% hold on,
[fileName, pathName]=uigetfile('\\researchstg\aaStudies\Breast Studies\Stiffness_mammo\TTDXA_images\*.txt', 'Please select Calibration file.');
cal_filename = [pathName,fileName];
CalibrationPoints = load(cal_filename);

  %%plot the fitting plot:
        Data=[CalibrationPoints(:,1) CalibrationPoints(:,2) CalibrationPoints(:,3) CalibrationPoints(:,4) CalibrationPoints(:,5)];
        
        Data(:,3)=Data(:,3)/1000;
        Data(:,4)=Data(:,4)/1000;

        Data(:,3)=Data(:,3)./Data(:,4);
        B=[Data(:,1) Data(:,2)];
        A=[ones(size(Data,1),1) Data(:,3) Data(:,4) Data(:,3).^2 Data(:,4).^2 Data(:,3).*Data(:,4)];
        
        X=A\B

        Result=A*X
        figure;plot(Result(:,2),'o');hold on;
        plot(Data(:,2),'rx');
        ylabel('%Glandular');xlabel('ROI');

        Info.DXAAnalysisRetrieved = false;

        dev_thickness = (sum((Data(:,1)-Result(:,1)).^2)./size(Data,1)).^0.5
        dev_density = (sum((Data(:,2)-Result(:,2)).^2)./size(Data,1)).^0.5
        
        CalibrationPlot_Se_BP6()





    
