% Calculate the coefficients ci and di in X=[coeff2 coeff]
% from the Calibration Points.
global CalibrationPoints;
% CalibrationPoints=load('U:\alaidevant\Experiments\p148al1_TT002\CalibrationPoints_TT002sheet1.txt');
% CalibrationPoints=load('U:\alaidevant\Experiments\p108al1_cal051707\CalibrationPoints_p108al13mm-allC2av.txt');
%CalibrationPoints=load('A:\Breast Studies\Tlsty_P01_data\p148al1_TT002R\calibration_files\CalibrationPoints_p108al13mm-allC2av.txt');
% % CalibrationPoints=load('\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\Tlsty_P01_data\p148al1_TT002R\calibration_files\CalibrationPoints_p108al13mm-allC2av.txt');
% CalibrationPoints=load('U:\alaidevant\Experiments\p126al_cal052307\CalibrationPoints_p126al16mm-allC.txt');
% CalibrationPoints=load('U:\alaidevant\Experiments\p112al1_cal051707\CalibrationPoints_p112al13mm-all1.txt');
% CalibrationPoints=load('U:\alaidevant\Experiments\p144al1_cal061207\CalibrationPoints_p145al13mm25-all.txt');
% CalibrationPoints=load('U:\alaidevant\Experiments\p144al1_cal061207\CalibrationPoints_p144al13mm25-all.txt');
% CalibrationPoints=load('U:\alaidevant\Experiments\p156al1_cal062007\CalibrationPoints_p156al13mm-allI0.txt');
% CalibrationPoints=load('U:\alaidevant\Experiments\p166al1_cal062907\CalibrationPoints_p167al13mm-allAUTODCnc.txt');
% CalibrationPoints=load('U:\alaidevant\Experiments\p31al2_cal091107\CalibrationPoints_p31al2.txt');
CalibrationPoints=load('A:\Breast Studies\Tlsty_P01_data\TT004\CalibrationPoints_p23al2_25kVp_100_39_280.txt');

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

dev_thickness = (sum((Data(:,1)-Result(:,1)).^2)./size(Data,1)).^0.5
dev_density = (sum((Data(:,2)-Result(:,2)).^2)./size(Data,1)).^0.5


