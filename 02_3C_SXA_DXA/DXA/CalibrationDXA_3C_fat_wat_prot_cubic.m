% Calculate the coefficients ci and di in X=[coeff2 coeff]
% from the Calibration Points using 3 equations.

CalibrationPoints=load('\\ming.radiology.ucsf.edu\Working_Directory\Shepherd Shared Folders\Publications-Presentations\2008\Papers\3C Breast\CalibrationFiles_delrin\CalibrationPoints20081104_2-4_30-20-10-5_3C.txt');
% CalibrationPoints=load('Q:\Shepherd Shared Folders\Publications-Presentations\2008\Papers\3C Breast\CalibrationPoints_OnlyWater_20080826.txt');


%Calibration Data file format:   columns - [t_fat t_water HE R T]

Data=[CalibrationPoints(:,1) CalibrationPoints(:,2) CalibrationPoints(:,3) CalibrationPoints(:,4) CalibrationPoints(:,5) CalibrationPoints(:,6)];

%Data(:,3)=Data(:,3)/1000; %HE
HE = Data(:,4)/1000;
R =  Data(:,6); %R = LE/HE
T =  Data(:,6); %T - total thickness in cm 
B=[Data(:,1) Data(:,2) Data(:,3)]; % t_fat t_water t_protein

%equation tfat = a1 + a2*HE + a3*R + a4*T + a5*HE^2 + a6*R^2 + a7*T^2 +
%a8*HE*R + a9*HE*T + a10*T*R

A=[ones(size(Data,1),1) HE R T HE.^2 R.^2 T.^2 HE.*R HE.*T T.*R HE.^3 R.^3 T.^3];
% A=[ones(size(Data,1),1) HE R T HE.^2 R.^2 T.^2 HE.*R HE.*T T.*R HE.^3 R.^3 T.^3];
global X
X=A\B

Result=A*X
figure;plot(Result(:,2),'o');hold on;  %blue 'o' - calculated data 
plot(Data(:,2),'rx');                  %red  'x' - real data
ylabel('Water thickness (cm)','fontsize',14);xlabel('Number of ROI','fontsize',14); grid on;
legend('Calculted thickness','Real thickness');

dev_tfat = (sum((Data(:,1)-Result(:,1)).^2)./size(Data,1)).^0.5
dev_twater = (sum((Data(:,2)-Result(:,2)).^2)./size(Data,1)).^0.5
dev_tprotein = (sum((Data(:,3)-Result(:,3)).^2)./size(Data,1)).^0.5

fat_deltamax=max(Data(:,1)-Result(:,1))
water_deltamax=max(Data(:,2)-Result(:,2))
protein_deltamax=max(abs((Data(:,3)-Result(:,3))))

fat_error=dev_tfat/mean(Data(:,1))*100
water_error=dev_twater/mean(Data(:,2))*100
protein_error=dev_tprotein/mean(Data(:,3))*100

figure;plot(Result(:,3),'o');hold on;  %blue 'o' - calculated data 
plot(Data(:,3),'rx');                  %red  'x' - real data
ylabel('Protein thickness (cm)','fontsize',14);xlabel('Number of ROI','fontsize',14); grid on;




