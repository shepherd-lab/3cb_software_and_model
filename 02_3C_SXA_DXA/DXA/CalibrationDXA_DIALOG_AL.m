% Calculate the coefficients ci and di in X=[coeff2 coeff]
% from the Calibration Points.
global CalibrationPoints Info


[FileName,PathName] = uigetfile('\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\AL_SeleniaData\CalibrationFiles\*.txt', 'Choose a calibration file');
CalibrationPoints=load([PathName,FileName]);

Data=[CalibrationPoints(:,1) CalibrationPoints(:,2) CalibrationPoints(:,3) CalibrationPoints(:,4)];

Data(:,3)=Data(:,3)/1000;
Data(:,4)=Data(:,4)/1000;

Data(:,3)=Data(:,3)./Data(:,4);
B=[Data(:,1) Data(:,2)];
A=[ones(size(Data,1),1) Data(:,3) Data(:,4) Data(:,3).^2 Data(:,4).^2 Data(:,3).*Data(:,4)];
global X
X=A\B

Result=A*X
figure;plot(Result(:,2),'o');hold on;
plot(Data(:,2),'rx');
ylabel('%Glandular');xlabel('ROI');

Info.DXAAnalysisRetrieved = false;

dev_thickness = (sum((Data(:,1)-Result(:,1)).^2)./size(Data,1)).^0.5
dev_density = (sum((Data(:,2)-Result(:,2)).^2)./size(Data,1)).^0.5

save([PathName,'\CalibrationCoeffCC_3C01008.mat'],'X');


