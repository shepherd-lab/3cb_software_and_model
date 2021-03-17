% Calculate the coefficients ci and di in X=[coeff2 coeff]
% from the Calibration Points.

CalibrationPoints=load('\\ming.radiology.ucsf.edu\Working_Directory\Shepherd Shared Folders\Publications-Presentations\2008\Papers\3C Breast\CalibrationPoints20080826.txt');

%Calibration Data file format:   columns - [t_fat t_water HE R T]

Data=[CalibrationPoints(:,1) CalibrationPoints(:,2) CalibrationPoints(:,3) CalibrationPoints(:,4) CalibrationPoints(:,5)];

%Data(:,3)=Data(:,3)/1000; %HE
HE = Data(:,3)/1000;
R =  Data(:,4); %R = LE/HE
T =  Data(:,5); %T - total thickness in cm 
B=[Data(:,1) Data(:,2)];
Bfat=[Data(:,1)];
Bwater=[Data(:,2)];
tfat =  Data(:,1);
twater = Data(:,2);

%equation quadratic
%tfat = a1 + a2*HE + a3*R + a4*T + a5*HE^2 + a6*R^2 + a7*T^2 + a8*HE*R + a9*HE*T + a10*T*R

%equation conic
%tfat = a1 + a2*HE + a3*R + a4*T + a5*HE^2 + a6*R^2 + a7*T^2 + a8*(-tfat*HE) + a9*(-tfat*R) + a10*(-tfat*T)

Afat=[ones(size(Data,1),1) HE R T HE.^2 R.^2 T.^2 (-tfat.*HE) (-tfat.*R) (-tfat.*T)];
Awater = [ones(size(Data,1),1) HE R T HE.^2 R.^2 T.^2 (-twater.*HE) (-twater.*R) (-twater.*T)];

% A=[ones(size(Data,1),1) HE R T HE.^2 R.^2 T.^2];
global X

X0fat = [7.2234;    0.1899;   -5.9673;   -0.5100;   -0.0060;    1.1629;    0.0619;    0.0564;   -0.5256;   -0.1239];
X0water = [-2.8544;    0.1682;    2.8422;   -0.4060;   -0.0043;   -0.7278;    0.0262;    0.0179;   -0.3668;   -0.0835];
X0 = [X0fat',X0water'];
[y,feval] = find_coeff(X0, Data);

X = [y(1:10)',y(11:20)']

Xfat=Afat\Bfat
Xwater=Awater\Bwater

% X = [Xfat,Xwater]

Result_fat=Afat*Xfat
Result_water=Awater*Xwater
Result = [Result_fat,Result_water]

figure;plot(Result(:,2),'o');hold on;  %blue 'o' - calculated data 
plot(Data(:,2),'rx');                  %red  'x' - real data
ylabel('Thickness water');xlabel('Number of ROI'); grid on;
legend('Calculted thickness','Real thickness');

Data_protein=Data(:,5)-Data(:,2)-Data(:,1);
Result_protein=Data(:,5)-Result(:,2)-Result(:,1);

dev_tfat = (sum((Data(:,1)-Result(:,1)).^2)./size(Data,1)).^0.5
dev_twater = (sum((Data(:,2)-Result(:,2)).^2)./size(Data,1)).^0.5
dev_tprotein = (sum((Data_protein-Result_protein).^2)./size(Data,1)).^0.5

fat_error=dev_tfat/max(Data(:,1))*100
water_error=dev_twater/max(Data(:,2))*100
protein_error=dev_tprotein/max(Data_protein)*100


figure;plot(Result_protein,'o');hold on;  %blue 'o' - calculated data 
plot(Data_protein,'rx');                  %red  'x' - real data
ylabel('Thickness protein');xlabel('Number of ROI'); grid on;
legend('Calculted thickness','Real thickness');

figure;plot(Result(:,1),'o');hold on;  %blue 'o' - calculated data 
plot(Data(:,1),'rx');                  %red  'x' - real data
ylabel('Thickness fat');xlabel('Number of ROI');grid on;
legend('Calculted thickness','Real thickness');


