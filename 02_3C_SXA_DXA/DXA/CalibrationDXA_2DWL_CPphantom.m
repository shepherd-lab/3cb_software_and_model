% Calculate the coefficients ci and di in X=[coeff2 coeff]
% from the Calibration Points.
global CalibrationPoints X X2 X7 Data Data2 X3 X5 Data3 Data4 Data5 Data7;
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

%A=[ones(size(Data,1),1) HE R HE.^2 R.^2  HE.*R  ];
A=[ones(size(Data,1),1) R HE R.^2  HE.^2  HE.*R  ];
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

%100 6   21031.52	2.161449101;...
% 0  2     3530.88	1.672407445
Data2 = [    100 6   21031.52	2.161449101;...
             100 4       14229.47	2.259869834;...
              100 2      6791.8	2.391497099;...
              75 6      19294.76	2.117212653;...
              75 4       12923.69	2.196865601;...
              75 2        6023.74	    2.3025695;...
              50 6       17559.52	2.039257337;...
              50 4       11607.03	2.094571996;...
             50 2        5238.97	2.173020651;...
            25 6         15652.61	1.917559436;...
            25 4      10167.8	1.949443341;...
            25 2     4403.91	1.989089241;...
            0  6     13582.11	1.717627084;...
            0  4    8665.33	1.720585367;...
            0  2     3530.88	1.672407445
             ];
       % only 2 and 6 cm
         Data3 = [    100 6   21031.52	2.161449101;...
               100 2      6791.8	2.391497099;...
              75 6      19294.76	2.117212653;...
             75 2        6023.74	    2.3025695;...
              50 6       17559.52	2.039257337;...
             50 2        5238.97	2.173020651;...
            25 6         15652.61	1.917559436;...
            25 2     4403.91	1.989089241;...
            0  6     13582.11	1.717627084;...
            0  2     3530.88	1.672407445
            ];
        %%% only 4 cm
      Data4 = [    100 4       14229.47	2.259869834;...
               75 4       12923.69	2.196865601;...
               50 4       11607.03	2.094571996;...
              25 4      10167.8	1.949443341;...
              0  4    8665.33	1.720585367;...  
           ];
       %only 0 50 100 ;
    Data5 = [100 6   21031.52	2.161449101;...
             100 4     14229.47	2.259869834;...
             100 2      6791.8	2.391497099;...
             50 6       17559.52	2.039257337;...
             50 4       11607.03	2.094571996;...
             50 2        5238.97	2.173020651;...
             0  6     13582.11	1.717627084;...
             0  4    8665.33	1.720585367;...
             0  2     3530.88	1.672407445
            ];
        %only 25 75 ;
     Data6 = [75 6      19294.76	2.117212653;...
              75 4       12923.69	2.196865601;...
              75 2        6023.74	    2.3025695;...
             25 6         15652.61	1.917559436;...
             25 4      10167.8	1.949443341;...
             25 2     4403.91	1.989089241;...
            ];
        %only 2 and4 cm
       Data7 = [ 100 4       14229.47	2.259869834;...
                100 2      6791.8	2.391497099;...
               75 4       12923.69	2.196865601;...
              75 2        6023.74	    2.3025695;...
               50 4       11607.03	2.094571996;...
             50 2        5238.97	2.173020651;...
            25 4      10167.8	1.949443341;...
            25 2     4403.91	1.989089241;...
            0  4    8665.33	1.720585367;...
            0  2     3530.88	1.672407445
             ];
         %only 6 cm
         Data8 = [    100 6   21031.52	2.161449101;...
                      75 6      19294.76	2.117212653;...
                       50 6       17559.52	2.039257337;...
                       25 6         15652.61	1.917559436;...
                       0  6     13582.11	1.717627084;...
                        ];
        
% Data=[CalibrationPoints(:,1) CalibrationPoints(:,2) CalibrationPoints(:,3) CalibrationPoints(:,4)];

% % % % [fileName, pathName]=uigetfile('\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\*.txt', 'Please select calibration file.');
% % % % CalibrationPoints=load(fullfile(pathName, fileName));

X2 = [];
%Data(:,3)=Data(:,3)/1000; %HE
HE = Data2(:,3)/1000;
R = Data2(:,4);
B=[Data2(:,1) Data2(:,2)]; % density and thickness

%equation tfat = a1 + a2*HE + a3*R + a4*T + a5*HE^2 + a6*R^2 + a7*T^2 +
%a8*HE*R + a9*HE*T + a10*T*R
A=[ones(size(Data2,1),1) R HE R.^2  HE.^2  HE.*R  ];
X2=A\B;
%X=pinv(A)*B;
Result2=A*X2
error_density2 = (sum((Data2(:,1)-Result2(:,1)).^2)./size(Data2,1)).^0.5
error_thickness2 = (sum((Data2(:,2)-Result2(:,2)).^2)./size(Data2,1)).^0.5/6*100
%%
%calibrate only using 2 and 6 cm Data3
X3 = [];
HE3 = Data3(:,3)/1000;
R = Data3(:,4);
B=[Data3(:,1) Data3(:,2)]; % density and thickness
A=[ones(size(Data3,1),1) R HE3 R.^2  HE3.^2  HE3.*R  ];
X3=A\B;
Result3=A*X3
error_density3 = (sum((Data3(:,1)-Result3(:,1)).^2)./size(Data3,1)).^0.5
error_thickness3 = (sum((Data3(:,2)-Result3(:,2)).^2)./size(Data3,1)).^0.5/6*100
%%%%%%%%%%%%%%% 
%%
%%%%% validate only 4 cm;
HE4 = Data4(:,3)/1000;
R = Data4(:,4);
B=[Data4(:,1) Data4(:,2)]; % density and thickness
A=[ones(size(Data4,1),1) R HE4 R.^2  HE4.^2  HE4.*R  ];
Result4=A*X3
error_density4 = (sum((Data4(:,1)-Result4(:,1)).^2)./size(Data4,1)).^0.5
error_thickness4 = (sum((Data4(:,2)-Result4(:,2)).^2)./size(Data4,1)).^0.5/6*100
%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%
%%
% % % figure;plot(HE,R,'bo'); 
format long g;
%%% for temporary

% % % figure;plot(Data(:,1),Result(:,1), 'o');
% % % figure;plot(Data(:,2),Result(:,2), '*');
% % % 
% % % figure;plot(Result2(:,1),'o');hold on;  %blue 'o' - calculated data 
% % % plot(Data2(:,1),'rx');                  %red  'x' - real data
% % % ylabel('Density');xlabel('Number of ROI'); grid on;
% % % legend('Calculted density','Density');
% % % 
% % % figure;plot(Result2(:,2),'o');hold on;  %blue 'o' - calculated data 
% % % plot(Data2(:,2),'rx');                  %red  'x' - real data
% % % ylabel('Thickness');xlabel('Number of ROI'); grid on;
% % % legend('Calculted thickness','Real thickness');

figure;plot(Result4(:,1),'o');hold on;  %blue 'o' - calculated data 
plot(Data4(:,1),'rx');                  %red  'x' - real data
ylabel('Thickness');xlabel('Number of ROI'); grid on;
legend('Calculted thickness','Real thickness');

% % f2=figure;plot(Data2(:,3),Data2(:,4),'o','markersize',3,'markerfacecolor','black','markeredgecolor','black'); hold on;
% % plot(Result3(:,3),Data2(:,4),'o','markersize',3,'markerfacecolor','black','markeredgecolor','black');
%%
%calibrate only using 0, 50 and 100 cm Data5
X5 = [];
HE5 = Data5(:,3)/1000;
R = Data5(:,4);
B=[Data5(:,1) Data5(:,2)]; % density and thickness
A=[ones(size(Data5,1),1) R HE5 R.^2  HE5.^2  HE5.*R  ];
X5=A\B;
Result5=A*X5
error_density5 = (sum((Data5(:,1)-Result5(:,1)).^2)./size(Data5,1)).^0.5
error_thickness5 = (sum((Data5(:,2)-Result5(:,2)).^2)./size(Data5,1)).^0.5/6*100
%%%%%%%%%%%%%%% 
%%
%%%%% validate only 25 and 75 cm;
HE6 = Data6(:,3)/1000;
R = Data6(:,4);
B=[Data6(:,1) Data6(:,2)]; % density and thickness
A=[ones(size(Data6,1),1) R HE6 R.^2  HE6.^2  HE6.*R  ];
Result6=A*X5
error_density6 = (sum((Data6(:,1)-Result6(:,1)).^2)./size(Data6,1)).^0.5
error_thickness6 = (sum((Data6(:,2)-Result6(:,2)).^2)./size(Data6,1)).^0.5/6*100
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%calibrate only using 0, 50 and 100 cm Data5
X7 = [];
HE7 = Data7(:,3)/1000;
R = Data7(:,4);
B=[Data7(:,1) Data7(:,2)]; % density and thickness
A=[ones(size(Data7,1),1) R HE7 R.^2  HE7.^2  HE7.*R  ];
X7=A\B;
Result7=A*X7
error_density7 = (sum((Data7(:,1)-Result7(:,1)).^2)./size(Data7,1)).^0.5
error_thickness7 = (sum((Data7(:,2)-Result7(:,2)).^2)./size(Data7,1)).^0.5/6*100
%%%%%%%%%%%%%%% 
%%
%%%%% validate only 25 and 75 cm;
HE8 = Data8(:,3)/1000;
R = Data8(:,4);
B=[Data8(:,1) Data8(:,2)]; % density and thickness
A=[ones(size(Data8,1),1) R HE8 R.^2  HE8.^2  HE8.*R  ];
Result8=A*X7
error_density8 = (sum((Data8(:,1)-Result8(:,1)).^2)./size(Data8,1)).^0.5
error_thickness8 = (sum((Data8(:,2)-Result8(:,2)).^2)./size(Data8,1)).^0.5/6*100
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
% % % pHE = phant_data(:,1);
% % % pR = phant_data(:,2);
% % % 
% % % coef=X(:,1);
% % % coef2=X(:,2);
% % % 
% % % material= coef(1)+ coef(2)*(pHE/1000)+  coef(3)*pR + coef(4)*(pHE/1000).^2 + coef(5)*pR.^2 + coef(6)*(pHE/1000.*pR);%+50;
% % % thickness= coef2(1)+ coef2(2)*(pHE/1000)+  coef2(3)*pR + coef2(4)*(pHE/1000).^2 + coef2(5)*pR.^2 + coef2(6)*(pHE/1000.*pR);%+50;
% % % 
% % % 
% % % f2=figure;plot(CalibrationPoints(:,4),CalibrationPoints(:,3),'o','markersize',3,'markerfacecolor','black','markeredgecolor','black');
% % % hold on; plot(pHE,pR,'o','markersize',3,'markerfacecolor','green','markeredgecolor','green');
% % % 
% % % result_data = [material thickness]
a = 1;


