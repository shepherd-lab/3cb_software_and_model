% Calculate the coefficients ci and di in X=[coeff2 coeff]
% from the Calibration Points.
global CalibrationPoints X;
CalibrationPoints=load('\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\WL2D_oil_water_points.txt');

Data=[CalibrationPoints(:,1) CalibrationPoints(:,2) CalibrationPoints(:,3) CalibrationPoints(:,4)];

% % % % [fileName, pathName]=uigetfile('\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\*.txt', 'Please select calibration file.');
% % % % CalibrationPoints=load(fullfile(pathName, fileName));

Data=[CalibrationPoints(:,1) CalibrationPoints(:,2) CalibrationPoints(:,3) CalibrationPoints(:,4) ];
X = [];
%Data(:,3)=Data(:,3)/1000; %HE
HE = Data(:,4)/1000;
R = Data(:,3);
B=[Data(:,1) Data(:,2)]; % density and thickness

%equation tfat = a1 + a2*HE + a3*R + a4*T + a5*HE^2 + a6*R^2 + a7*T^2 +
%a8*HE*R + a9*HE*T + a10*T*R

A=[ones(size(Data,1),1) HE R HE.^2 R.^2  HE.*R  ];

X=A\B;
%X=pinv(A)*B;
Result=A*X

% % % figure;plot(HE,R,'bo'); 
format long g;
%%% for temporary

% % % figure;plot(Data(:,1),Result(:,1), 'o');
% % % figure;plot(Data(:,2),Result(:,2), '*');

figure;plot(Result(:,1),'o');hold on;  %blue 'o' - calculated data 
plot(Data(:,1),'rx');                  %red  'x' - real data
ylabel('Thickness water');xlabel('Number of ROI'); grid on;
legend('Calculted water','Real thickness');

figure;plot(Result(:,2),'o');hold on;  %blue 'o' - calculated data 
plot(Data(:,2),'rx');                  %red  'x' - real data
ylabel('Thickness fat');xlabel('Number of ROI'); grid on;
legend('Calculted fat','Real thickness');

dev_thickness = (sum((Data(:,1)-Result(:,1)).^2)./size(Data,1)).^0.5
dev_density = (sum((Data(:,2)-Result(:,2)).^2)./size(Data,1)).^0.5

phant_data = [21031.52	2.161449101;...
            14229.47	2.259869834;...
            6791.8	2.391497099;...
            19294.76	2.117212653;...
            12923.69	2.196865601;...
            6023.74	2.3025695;...
            17559.52	2.039257337;...
            11607.03	2.094571996;...
            5238.97	2.173020651;...
            15652.61	1.917559436;...
            10167.8	1.949443341;...
            4403.91	1.989089241;...
            13582.11	1.717627084;...
            8665.33	1.720585367;...
            3530.88	1.672407445 ];
pHE = phant_data(:,1);
pR = phant_data(:,2);

coef=X(:,1);
coef2=X(:,2);

material= coef(1)+ coef(2)*(pHE/1000)+  coef(3)*pR + coef(4)*(pHE/1000).^2 + coef(5)*pR.^2 + coef(6)*(pHE/1000.*pR);%+50;
thickness= coef2(1)+ coef2(2)*(pHE/1000)+  coef2(3)*pR + coef2(4)*(pHE/1000).^2 + coef2(5)*pR.^2 + coef2(6)*(pHE/1000.*pR);%+50;


f2=figure;plot(CalibrationPoints(:,4),CalibrationPoints(:,3),'o','markersize',3,'markerfacecolor','black','markeredgecolor','black');
hold on; plot(pHE,pR,'o','markersize',3,'markerfacecolor','green','markeredgecolor','green');

result_data = [material thickness]
a = 1;


