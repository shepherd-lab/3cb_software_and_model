% Calculate the coefficients ci and di in X=[coeff2 coeff]
% from the Calibration Points.
function CalibrationDXA_AUTO()

global InfoDXA
global X

% CalibrationPoints_filename='CalibrationPoints_p127al2_BP2_32_65.txt';
% PathName='\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\AL_SeleniaData\CalibrationFiles\';
% CalibrationPoints=load([PathName,CalibrationPoints_filename]);

CalibrationPoints = load(InfoDXA.Calibration_filename);


Data=[CalibrationPoints(:,1) CalibrationPoints(:,2) CalibrationPoints(:,3) CalibrationPoints(:,4)];

Data(:,3)=Data(:,3)/1000;
Data(:,4)=Data(:,4)/1000;

Data(:,3)=Data(:,3)./Data(:,4);
B=[Data(:,1) Data(:,2)];
A=[ones(size(Data,1),1) Data(:,3) Data(:,4) Data(:,3).^2 Data(:,4).^2 Data(:,3).*Data(:,4)];

X=A\B

Result=A*X

%{
figure;plot(Result(:,2),'o');hold on;
plot(Data(:,2),'rx');
ylabel('%Glandular');xlabel('ROI');
%}

dev_thickness = (sum((Data(:,1)-Result(:,1)).^2)./size(Data,1)).^0.5
dev_density = (sum((Data(:,2)-Result(:,2)).^2)./size(Data,1)).^0.5
a = 1;


