% Calculate the coefficients ci and di in X=[coeff2 coeff]
% from the Calibration Points.

CalibrationPoints=load('\\ming.radiology.ucsf.edu\Working_Directory\Shepherd Shared Folders\Publications-Presentations\2008\Papers\3C Breast\CalibrationPoints20080826_nowater_only6fat.txt');

%Calibration Data file format:   columns - [t_fat t_water HE R T]

Data=[CalibrationPoints(:,1) CalibrationPoints(:,2) CalibrationPoints(:,3) CalibrationPoints(:,4) CalibrationPoints(:,5)];

%Data(:,3)=Data(:,3)/1000; %HE
HE = Data(:,3)/1000;
R =  Data(:,4); %R = LE/HE
T =  Data(:,5); %T - total thickness in cm 
B=[Data(:,1) Data(:,2)];

%equation tfat = a1 + a2*HE + a3*R + a4*T + a5*HE^2 + a6*R^2 + a7*T^2 +
%a8*HE*R + a9*HE*T + a10*T*R

A=[ones(size(Data,1),1) HE R T HE.^2 R.^2 T.^2 HE.*R HE.*T T.*R];
% A=[ones(size(Data,1),1) HE R T HE.^2 R.^2 T.^2];
global X
X=A\B

Result=A*X
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

%% 3D plot:
figure;
scatter3(Data(:,3),Data(:,4),Data(:,5),'rx')
xlabel('HE'); ylabel('R'); zlabel('T'); 

%% Bland Altman?
g=Data(:,2)./(Data(:,1)+Data(:,2));
figure;plot(g,Result_protein,'o');hold on;  %blue 'o' - calculated data 
plot(g,Data_protein,'rx');                  %red  'x' - real data
ylabel('Thickness protein');xlabel('t_w/(t_w+t_f)'); grid on;
legend('Calculted thickness','Real thickness');

