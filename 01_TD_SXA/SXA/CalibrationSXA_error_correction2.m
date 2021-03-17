% Calculate the coefficients ci and di in X=[coeff2 coeff]
% from the Calibration Points.
global CalibrationPoints;
CalibrationPoints=load('\\ming\aaDATA\Breast Studies\SM_DXASelenia\Digial_data\Error_correction_calibration\error_correction_calibration2.txt');
%CalibrationPoints=load('\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\SM_DXASelenia\Prodigy_3C\CalibrationProdigy_1Set_MRmonochromatic2.txt');
Data=[CalibrationPoints(:,1) CalibrationPoints(:,2) CalibrationPoints(:,3) CalibrationPoints(:,4)];

H = Data(:,2);
dh =  Data(:,3); %R = LE/HE
D = Data(:,4);
B=Data(:,1); %R monochromatic and T in cm

A=[ones(size(Data,1),1) H dh D H.^2 dh.^2  D.^2 H.*dh H.*D dh.*D ]; %H.^3 dh.^3 D.^3
%A=[ones(size(Data,1),1) R HE R.^2 HE.^2 HE.*R ];
%A=[ones(size(Data,1),1) Data(:,3) Data(:,4) Data(:,3).^2 Data(:,4).^2 Data(:,3).*Data(:,4)];
global X
X=A\B

Result=A*X

figure;plot(Result,'o');hold on;  %blue 'o' - calculated data 
plot(Data(:,1),'rx');   grid on;               %red  'x' - real data
ylabel('%FGV correction');xlabel('Number of points'); grid on;
legend('Fitted % correction','Real % correction');

% 
% figure;plot(Result(:,1),'o');hold on;
% plot(Data(:,1),'rx'); grid on;
% ylabel('Mass of 1 cm^2 area ');xlabel('Number of ROI');

dev_T = (sum((Data(:,1)-Result(:,1)).^2)./size(Data,1)).^0.5
corr_error = dev_T/mean(abs(Data(:,1)))*100
% dev_Rmono = (sum((Data(:,2)-Result(:,2)).^2)./size(Data,1)).^0.5

a= 1;

