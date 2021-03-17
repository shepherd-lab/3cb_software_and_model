% Calculate the coefficients ci and di in X=[coeff2 coeff]
% from the Calibration Points.
%global CalibrationPoints Info
function CalibrationCoeffs_Dialog()
global X
[FileName,PathName] = uigetfile('\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\*.mat', 'Choose a calibration file');
load([PathName,FileName]);
xx = X

% % % Data=[CalibrationPoints(:,1) CalibrationPoints(:,2) CalibrationPoints(:,3) CalibrationPoints(:,4)];
% % % 
% % % Data(:,3)=Data(:,3)/1000;
% % % Data(:,4)=Data(:,4)/1000;
% % % 
% % % Data(:,3)=Data(:,3)./Data(:,4);
% % % B=[Data(:,1) Data(:,2)];
% % % A=[ones(size(Data,1),1) Data(:,3) Data(:,4) Data(:,3).^2 Data(:,4).^2 Data(:,3).*Data(:,4)];
% % % global X
% % % X=A\B
% % % 
% % % Result=A*X
% % % figure;plot(Result(:,2),'o');hold on;
% % % plot(Data(:,2),'rx');
% % % ylabel('%Glandular');xlabel('ROI');
% % % 
% % % Info.DXAAnalysisRetrieved = false;
% % % 
% % % dev_thickness = (sum((Data(:,1)-Result(:,1)).^2)./size(Data,1)).^0.5
% % % dev_density = (sum((Data(:,2)-Result(:,2)).^2)./size(Data,1)).^0.5
% % % 
% % % save([PathName,'\CalibrationCoeffCC_3C01008.mat'],'X');


