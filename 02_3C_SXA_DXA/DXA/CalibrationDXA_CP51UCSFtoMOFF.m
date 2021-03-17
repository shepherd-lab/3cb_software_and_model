function CalibrationDXA_MOFFtoUCSF()
global XX 

[fileName, pathName]=uigetfile('\\researchstg\aaStudies\Breast Studies\3CB R01\Source Data\Bovine_experiment\Calibration_Bovine_Serghei\*.txt', 'Please select "CP51UCSFtoMOFF_xxkvp.txt" calibration file.');
 CalibrationPoints=load(fullfile(pathName, fileName));
 kvp = fileName(16:20);
clear XX;
X = [];
%%%Calibration of conversion UCSF CP51 space into into MOFF space
%%%%%% my calibration file
Data=CalibrationPoints;
% Data=[CalibrationPoints(:,1)/10 CalibrationPoints(:,2)/10 CalibrationPoints(:,3) CalibrationPoints(:,4) CalibrationPoints(:,5)/10];
%file contains UCSF R HE and MOFF R HE
R_u = Data(:,1);
HE_u = Data(:,2)/1000;

R_m = Data(:,3);
HE_m = Data(:,4)/1000;

B=[HE_m R_m]; % density and thickness
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

type = 'TWOCOMP';
if strfind(type,'TWOCOMP') 
     A=[ones(size(Data,1),1) HE_u R_u HE_u.^2 R_u.^2 HE_u.*R_u]; %quadratic
     fileName = ['quadXX_',fileName];
%    A=[ones(size(Data,1),1) HE_u R_u HE_u.^2 R_u.^2 HE_u.*R_u HE_u.^3 R_u.^3 HE_u.^2.*R_u R_u.^2.*HE_u];  %cubic
%    fileName = ['cubicXX_',fileName];
else
    A=[];
end

ds = size(A);
d = ds(2);
lambda = 0.01;
XX(:,1) = (A'*A+lambda*eye(d)) \ A'*B(:,1);
XX(:,2) = (A'*A+lambda*eye(d)) \ A'*B(:,2);

%X=pinv(A)*B;
%  X=A\B; %right regression
 Result=A*XX

% % % figure;plot(HE,R,'bo'); 
format long g;

%%%
xc = XX

figure;plot(Result(:,1),'o');hold on;  %blue 'o' - calculated data 
plot(HE_m,'rx');                  %red  'x' - real data
ylabel('HE_u');xlabel('Number of ROI'); grid on;
legend('Calculted HE_u', 'Real HE_m');

figure;plot(Result(:,2),'o');hold on;  %blue 'o' - calculated data 
plot(R_m,'rx');                  %red  'x' - real data
ylabel('R_u');xlabel('Number of ROI'); grid on;
legend('Calculted Ru','Real R_m');

HE_mR= Result(:,1);
R_mR = Result(:,2);
ND = length(HE_mR);
NT = length(R_mR);
dev_first = (sum((HE_m-HE_mR).^2)./ND(1)).^0.5
dev_second = (sum((R_m-R_mR).^2)./NT(1)).^0.5

HE_error=dev_first/max(HE_mR)*100
R_error=dev_second/max(R_mR)*100

fn = fullfile(pathName, fileName);
% xx_fname = [fn(1:end-4),'_XX.txt'];
data = [R_mR HE_mR R_m HE_m];
figure;plot(HE_mR, R_mR,'bo',HE_m,R_m,'r*');
save(fn,'XX','-ascii');
XX
%%
%apply XX to calculate MOFF BV HE and R values
% [fileName, pathName]=uigetfile('\\researchstg\aaStudies\Breast Studies\3CB R01\Source Data\Bovine_experiment\Calibration_Bovine_Serghei\Bovine_234567cm_calibration\Calibration_points\*.txt', 'Please select BV calibration file.');
BVfileName = ['\\researchstg\aaStudies\Breast Studies\3CB R01\Source Data\Bovine_experiment\Calibration_Bovine_Serghei\Bovine_234567cm_calibration\Calibration_points\BV_60points_',kvp,'.txt'];
BVCalibrationPoints=load(BVfileName);

HE_BVu = BVCalibrationPoints(:,4)/1000;
R_BVu = BVCalibrationPoints(:,6);
coef = XX(:,1);
coef2 = XX(:,2);

% A=[ones(size(Data,1),1) HE_BVu R_BVu HE_BVu.^2 R_BVu.^2 HE_BVu.*R_BVu]; %quadratic

HE_BVm =  coef(1) + coef(2)*HE_BVu + coef(3)*R_BVu + coef(4)*HE_BVu.^2 + coef(5)*R_BVu.^2 + coef(6)*HE_BVu.*R_BVu;
R_BVm =  coef(1) + coef2(2)*HE_BVu + coef2(3)*R_BVu + coef2(4)*HE_BVu.^2 + coef2(5)*R_BVu.^2 + coef2(6)*HE_BVu.*R_BVu;

BVMOFFCalibrationPoints = BVCalibrationPoints;

BVMOFFCalibrationPoints(:,4) = HE_BVm*1000;
BVMOFFCalibrationPoints(:,6) = R_BVm;
BVMOFFCalibrationPoints(:,3) = HE_BVm.*R_BVm;
fileName = ['MOFF',fileName];
fn = fullfile(pathName, fileName);
save(fn,'BVMOFFCalibrationPoints','-ascii');
a =1;

%%
% find XXX coefficientsfor BV in Moffitt
% Data2=BVMOFFCalibrationPoints;
% Data=[CalibrationPoints(:,1)/10 CalibrationPoints(:,2)/10 CalibrationPoints(:,3) CalibrationPoints(:,4) CalibrationPoints(:,5)/10];
%file contains UCSF R HE and MOFF R HE
Data2=[BVMOFFCalibrationPoints(:,1)/10 BVMOFFCalibrationPoints(:,2)/10 BVMOFFCalibrationPoints(:,3) BVMOFFCalibrationPoints(:,4) BVMOFFCalibrationPoints(:,5)/10];
LE = Data2(:,3)/1000;
HE = Data2(:,4)/1000;
R =  LE./HE;
T =  Data2(:,5); %T - total thickness in cm 
Data2(:,6)= Data2(:,5)-(Data2(:,1) + Data2(:,2));%protein
B=[Data2(:,1) Data2(:,2)]; 
type = 'QUADRATIC';
clear A Result;
if strfind(type,'QUADRATIC')
    A=[ones(size(Data2,1),1) HE R T HE.^2 R.^2 T.^2 HE.*R HE.*T T.*R ];
   % A=[ones(size(Data,1),1) HE R T  ];
elseif   strfind(type,'LINEAR')
     A=[ones(size(Data2,1),1) HE R T ];
elseif  strfind(type,'CUBIC')
    A=[ones(size(Data2,1),1) HE R T HE.^2 R.^2 T.^2 HE.*R HE.*T T.*R HE.^3 R.^3 T.^3];
else
    A=[];
end

ds = size(A);
d = ds(2);
lambda = 0.1;

XXX(:,1) = (A'*A+lambda*eye(d)) \ A'*B(:,1);
XXX(:,2) = (A'*A+lambda*eye(d)) \ A'*B(:,2);
Result=A*XXX

Result(:,3) = Data2(:,5)-(Result(:,1)+Result(:,2));

XXX

fileName = ['XXX_',fileName];
fn = fullfile(pathName, fileName);
save(fn,'XXX','-ascii');

figure;plot(Result(:,1),'o');hold on;  %blue 'o' - calculated data 
plot(Data2(:,1),'rx');                  %red  'x' - real data
ylabel('Thickness water');xlabel('Number of ROI'); grid on;
legend('Calculted water','Real thickness');

figure;plot(Result(:,2),'o');hold on;  %blue 'o' - calculated data 
plot(Data2(:,2),'rx');                  %red  'x' - real data
ylabel('Thickness fat');xlabel('Number of ROI'); grid on;
legend('Calculted fat','Real thickness');

figure;plot(Result(:,3),'o');hold on;  %blue 'o' - calculated data 
plot(Data2(:,6),'rx');                  %red  'x' - real data
ylabel('Thickness protein');xlabel('Number of ROI'); grid on;
legend('Calculted protein','Real thickness');


dev_first = (sum((Data2(:,1)-Result(:,1)).^2)./size(Data2,1)).^0.5
dev_second = (sum((Data2(:,2)-Result(:,2)).^2)./size(Data2,1)).^0.5
dev_third = (sum((Data2(:,6)-Result(:,3)).^2)./size(Data2,1)).^0.5

water_error=dev_first/max(Data2(:,1))*100
fat_error=dev_second/max(Data2(:,2))*100
protein_error=dev_third/max(Data2(:,6))*100

a = 1;
%%
% % % figure;plot(Data(:,1),Result(:,1), 'o');
% % % figure;plot(Data(:,2),Result(:,2), '*');
% % % figure;plot(Data(:,6),Result(:,3), 'o');
% % % 
% % % dw = Data(:,1);
% % % dl = Data(:,2);
% % % dp = Data(:,6);
% % % rw = Result(:,1);
% % % rl = Result(:,2);
% % % rp = Result(:,3);
% % % 
% % % dt = [dw, dl, dp, rw, rl, rp];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Lasso %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % b = regress(B(:,1), A);
% % ds.Linear = b;
% % % %% Use a lasso to fit the model
% % % [ax,Stats] = lasso(A,B(:,1),'CV',5)
% % % %[ax Stats] = lasso(X,Y, 'CV', 5);
% % % 
% % % disp(B)
% % % disp(Stats)
% % % %% Create a plot showing MSE versus lamba
% % % lassoPlot(ax, Stats, 'PlotType', 'CV')
% % % 
% % % %% Identify a reasonable set of lasso coefficients
% % % % View the regression coefficients associated with Index1SE
% % % 
% % % ds.Lasso = ax(:,Stats.Index1SE);
% % % %disp(ds)
% % % X = ds.Lasso

%%  Create a plot showing coefficient values versus L1 norm
%lassoPlot(ax, Stats)
%%%%%%%%%%%%%%%%%%%%%%% end of Lasso %%%%%%%%%%%%%%%%%%%%

% % % X(:,1) = lsqr(A,B(:,1),1e-6)
% % % Result(:,1)=A*X(:,1)
% % % X(:,2) = lsqr(A,B(:,2),1e-6)
% % % Result(:,2)=A*X(:,2)


% % % X(:,1) = lsqlin(A,B(:,1))
% % % Result(:,1)=A*X(:,1)
% % % X(:,2) = lsqlin(A,B(:,2))
% % % Result(:,2)=A*X(:,2)

% % Result=A*X
% % Result(:,3) = Data(:,5)-(Result(:,1)+Result(:,2));




% % 
% % figure;plot(Result(:,2),'o');hold on;  %blue 'o' - calculated data 
% % plot(Data(:,2),'rx');                  %red  'x' - real data
% % ylabel('Water thickness (cm)','fontsize',14);xlabel('Number of ROI','fontsize',14); grid on;
% % legend('Calculted thickness','Real thickness');
% % 
% % Data_protein=Data(:,5)-Data(:,2)-Data(:,1);
% % Result_protein=Data(:,5)-Result(:,2)-Result(:,1);
% % 
% % dev_tlipid = (sum((Data(:,1)-Result(:,1)).^2)./size(Data,1)).^0.5
% % dev_twater = (sum((Data(:,2)-Result(:,2)).^2)./size(Data,1)).^0.5
% % dev_tprotein = (sum((Data_protein-Result_protein).^2)./size(Data,1)).^0.5
% % 
% % lipid_deltamax=max(abs(Data(:,1)-Result(:,1)))
% % water_deltamax=max(abs(Data(:,2)-Result(:,2)))
% % protein_deltamax=max(abs((Data_protein-Result_protein)))
% % 
% % lipid_error=dev_tlipid/mean(Data(:,1))*100
% % water_error=dev_twater/mean(Data(:,2))*100
% % protein_error=dev_tprotein/mean(Data_protein)*100
% % 
% % lipid_mean=mean(Data(:,1)-Result(:,1))
% % water_mean=mean(Data(:,2)-Result(:,2))
% % protein_mean=mean(Data_protein-Result_protein)
% % 
% % lipid_median=median(Data(:,1)-Result(:,1))
% % water_median=median(Data(:,2)-Result(:,2))
% % protein_median=median(Data_protein-Result_protein)
% % 
% % 
% % figure;plot(Result_protein,'o');hold on;  %blue 'o' - calculated data 
% % plot(Data_protein,'rx');                  %red  'x' - real data
% % ylabel('Protein Thickness (cm)','fontsize',14);xlabel('Number of ROI','fontsize',14); grid on;
% % legend('Calculted thickness','Real thickness','fontsize',18);
% % 
% % figure;plot(Result(:,1),'o');hold on;  %blue 'o' - calculated data 
% % plot(Data(:,1),'rx');                  %red  'x' - real data
% % ylabel('lipid Thickness (cm)','fontsize',14);xlabel('Number of ROI','fontsize',14);grid on;
% % legend('Calculted thickness','Real thickness','fontsize',18);
% % 
% % figure;plot(Data(:,1)./Data(:,2), R);
% % ylabel('LE/HE ratio');xlabel('Water/Lipid Thickness Ratio');
% %% 3D plot:
% figure;
% scatter3(Data(:,3),Data(:,4),Data(:,5),'rx')
% xlabel('HE'); ylabel('R'); zlabel('T'); 
% 
% %% 
% g=Data(:,2)./(Data(:,1)+Data(:,2));
% figure;plot(g,Result_protein,'o');hold on;  %blue 'o' - calculated data 
% plot(g,Data_protein,'rx');                  %red  'x' - real data
% ylabel('Protein Thickness (cm)','fontsize',14);xlabel('t_w/(t_w+t_f)','fontsize',14); grid on;
% legend('Calculted thickness','Real thickness'); set(legend,'Position',[0.4744 0.7752 0.2697 0.125],'FontSize',12);
% 
% figure;plot(g,Result(:,1),'o');hold on;  %blue 'o' - calculated data 
% plot(g,Data(:,1),'rx');                  %red  'x' - real data
% ylabel('Thickness lipid (cm)','fontsize',14);xlabel('t_w/(t_w+t_f)','fontsize',14); grid on;
% legend('Calculted thickness','Real thickness'); set(legend,'Position',[0.4744 0.7752 0.2697 0.125],'FontSize',12);
% 
% figure;plot(g,Result(:,2),'o');hold on;  %blue 'o' - calculated data 
% plot(g,Data(:,2),'rx');                  %red  'x' - real data
% ylabel('Water Thickness (cm)','fontsize',14);xlabel('t_w/(t_w+t_f)','fontsize',14); grid on;
% legend('Calculted thickness','Real thickness'); set(legend,'Position',[0.4744 0.7752 0.2697 0.125],'FontSize',12);
% 
% figure;plot(Data_protein,Result_protein-Data_protein,'o');  %blue 'o' - calculated data                  %red  'x' - real data
% ylabel('difference (calculated T - true T) (cm)','fontsize',14);xlabel('True Delrin thickness (cm)','fontsize',14); grid on;
% 
% figure;plot(Data(:,1),Result(:,1)-Data(:,1),'o');  %blue 'o' - calculated data                  %red  'x' - real data
% ylabel('difference (calculated T - true T) (cm)','fontsize',14);xlabel('True Wax thickness (cm)','fontsize',14); grid on;
% 
% figure;plot(Data(:,2),Result(:,2)-Data(:,2),'o');  %blue 'o' - calculated data                  %red  'x' - real data
% ylabel('difference (calculated T - true T) (cm)','fontsize',14);xlabel('True Water thickness (cm)','fontsize',14); grid on;
% 
% %% new plots
% fg=(Data(:,2)+Data_protein)./(Data(:,1)+Data(:,2)+Data_protein); % fibroglandular ratio
% figure; plot(fg,(Result_protein-Data_protein)./Data_protein*100,'d');
% ylabel('Percent protein error (%)','fontsize',14);xlabel('Fibroglandular ratio','fontsize',14); grid on;
% 
% figure; plot(fg,(Result(:,2)-Data(:,2))./Data(:,2)*100,'d');
% ylabel('Percent water error (%)','fontsize',14);xlabel('Fibroglandular ratio','fontsize',14); grid on;
% 
% figure; plot(fg,(Result(:,1)-Data(:,1))./Data(:,1)*100,'d');
% (Result(:,1)-Data(:,1))./Data(:,1)*100
% ylabel('Percent lipid error (%)','fontsize',14);xlabel('Fibroglandular ratio','fontsize',14); grid on;
% 
% figure;plot(fg,Result_protein,'o');hold on;  %blue 'o' - calculated data 
% plot(fg,Data_protein,'rx');                  %red  'x' - real data
% ylabel('Protein Thickness (cm)','fontsize',14);xlabel('Fibroglandular ratio','fontsize',14); grid on;
% legend('Calculted thickness','Real thickness'); set(legend,'Position',[0.4744 0.7752 0.2697 0.125],'FontSize',12);

%% new plots with markers
% 
% figure;
% plot(fg(25:26),(Result(25:26,1)-Data(25:26,1))./Data(25:26,1)*100,'MarkerSize',10,'Marker','pentagram','LineStyle','none');hold on;
% plot(fg(19:24),(Result(19:24,1)-Data(19:24,1))./Data(19:24,1)*100,'^');hold on;
% plot(fg(13:18),(Result(13:18,1)-Data(13:18,1))./Data(13:18,1)*100,'d');hold on;
% plot(fg(7:12),(Result(7:12,1)-Data(7:12,1))./Data(7:12,1)*100,'s');hold on;
% plot(fg(1:6),(Result(1:6,1)-Data(1:6,1))./Data(1:6,1)*100,'o');hold on;
% ylabel('Percent lipid error (%)','fontsize',14);xlabel('Fibroglandular ratio','fontsize',14); grid on;
% legend('"0% protein"','"5% protein"','"10% protein"','"20% protein"','"30% protein"'); set(legend,'Position',[0.1405 0.6627 0.5018 0.2452],'FontSize',11);
% 
% figure; 
% % plot(fg(25:26),(Result(25:26,2)-Data(25:26,2))./Data(25:26,2)*100,'MarkerSize',10,'Marker','pentagram','LineStyle','none');hold on;
% plot(fg(19:24),(Result(19:24,2)-Data(19:24,2))./Data(19:24,2)*100,'^');hold on;
% plot(fg(13:18),(Result(13:18,2)-Data(13:18,2))./Data(13:18,2)*100,'d');hold on;
% plot(fg(7:12),(Result(7:12,2)-Data(7:12,2))./Data(7:12,2)*100,'s');hold on;
% plot(fg(1:6),(Result(1:6,2)-Data(1:6,2))./Data(1:6,2)*100,'o');hold on;
% ylabel('Percent water error (%)','fontsize',14);xlabel('Fibroglandular ratio','fontsize',14); grid on;
% legend('"5% protein"','"10% protein"','"20% protein"','"30% protein"'); set(legend,'Position',[0.1405 0.6627 0.5018 0.2452],'FontSize',11);
% 
% figure; 
% % plot(fg(25:26),(Result_protein(25:26)-Data_protein(25:26))./Data_protein(25:26)*100,'MarkerSize',10,'Marker','pentagram','LineStyle','none');hold on;
% plot(fg(19:24),(Result_protein(19:24)-Data_protein(19:24))./Data_protein(19:24)*100,'^');hold on;
% plot(fg(13:18),(Result_protein(13:18)-Data_protein(13:18))./Data_protein(13:18)*100,'d');hold on;
% plot(fg(7:12),(Result_protein(7:12)-Data_protein(7:12))./Data_protein(7:12)*100,'s');hold on;
% plot(fg(1:6),(Result_protein(1:6)-Data_protein(1:6))./Data_protein(1:6)*100,'o');hold on;
% ylabel('Percent protein error (%)','fontsize',14);xlabel('Fibroglandular ratio','fontsize',14); grid on;
% legend('"5% protein"','"10% protein"','"20% protein"','"30% protein"'); set(legend,'Position',[0.1405 0.6627 0.5018 0.2452],'FontSize',11);
% 
% %% new plots with markers 26 points
% figure;
% plot(fg(25:26),Result(25:26,1),'MarkerSize',10,'Marker','pentagram','LineStyle','none');hold on;
% plot(fg(19:24),Result(19:24,1),'^');hold on;
% plot(fg(13:18),Result(13:18,1),'d');hold on;
% plot(fg(7:12),Result(7:12,1),'s');hold on;
% plot(fg(1:6),Result(1:6,1),'o');hold on;  %blue 'o' - calculated data 
% plot(fg,Data(:,1),'rx');                  %red  'x' - real data
% ylabel('Lipid Thickness (cm) ','fontsize',14);xlabel('Fibroglandular ratio','fontsize',14); grid on;
% legend('Estimated thickness "0% protein"','Estimated thickness "5% protein"','Estimated thickness "10% protein"','Estimated thickness "20% protein"','Estimated thickness "30% protein"','True thickness'); set(legend,'Position',[0.1405 0.6627 0.5018 0.2452],'FontSize',11);
% 
% figure;
% plot(fg(25:26),Result(25:26,2),'MarkerSize',10,'Marker','pentagram','LineStyle','none');hold on;
% plot(fg(19:24),Result(19:24,2),'^');hold on;
% plot(fg(13:18),Result(13:18,2),'d');hold on;
% plot(fg(7:12),Result(7:12,2),'s');hold on;
% plot(fg(1:6),Result(1:6,2),'o');hold on;  %blue 'o' - calculated data 
% plot(fg,Data(:,2),'rx');                  %red  'x' - real data
% ylabel('Water Thickness (cm) ','fontsize',14);xlabel('Fibroglandular ratio','fontsize',14); grid on;
% legend('Estimated thickness "0% protein"','Estimated thickness "5% protein"','Estimated thickness "10% protein"','Estimated thickness "20% protein"','Estimated thickness "30% protein"','True thickness'); set(legend,'Position',[0.1405 0.6627 0.5018 0.2452],'FontSize',11);
% 
% figure;
% plot(fg(25:26),Result_protein(25:26),'MarkerSize',10,'Marker','pentagram','LineStyle','none');hold on;
% plot(fg(19:24),Result_protein(19:24),'^');hold on;
% plot(fg(13:18),Result_protein(13:18),'d');hold on;
% plot(fg(7:12),Result_protein(7:12),'s');hold on;
% plot(fg(1:6),Result_protein(1:6),'o');hold on;  %blue 'o' - calculated data 
% plot(fg,Data_protein,'rx');                  %red  'x' - real data
% ylabel('Protein Thickness (cm) ','fontsize',14);xlabel('Fibroglandular ratio','fontsize',14); grid on;
% legend('Estimated thickness "0% protein"','Estimated thickness "5% protein"','Estimated thickness "10% protein"','Estimated thickness "20% protein"','Estimated thickness "30% protein"','True thickness'); set(legend,'Position',[0.1405 0.6627 0.5018 0.2452],'FontSize',11);


