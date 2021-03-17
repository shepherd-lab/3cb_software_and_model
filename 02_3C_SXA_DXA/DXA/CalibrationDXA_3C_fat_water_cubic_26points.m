function CalibrationDXA_3C_fat_water_cubic_26points(src, event)
global X patient_ID file Image

% Calculate the coefficients ci and di in X=[coeff2 coeff]
% from the Calibration Points.

% CalibrationPoints=load('\\ming.radiology.ucsf.edu\Working_Directory\Shepherd Shared Folders\Publications-Presentations\2008\Papers\3C Breast\CalibrationFiles_delrin\20090122_4thSet\CalibrationPoints20090122_26kVp_2-4_30-20-10-5_no4cm30.txt');
% CalibrationPoints=load('\\ming.radiology.ucsf.edu\Working_Directory\Shepherd Shared Folders\Publications-Presentations\2008\Papers\3C Breast\CalibrationFiles_delrin\20090122_4thSet\CalibrationPoints20090122_26kVp_2-4_30-20-10-5.txt');
%CalibrationPoints=load('\\ming.radiology.ucsf.edu\Working_Directory\Shepherd Shared Folders\Publications-Presentations\2008\Papers\3C Breast\CalibrationFiles_delrin\20090122_4thSet\CalibrationPoints20090122_26kVp_2-4_30-20-10-5_onlyfat.txt');
% CalibrationPoints=load('\\ming.radiology.ucsf.edu\Working_Directory\Shepherd Shared Folders\Publications-Presentations\2008\Papers\3C Breast\CalibrationFiles_delrin\20090122_4thSet\CalibrationPoints20090122_26kVp_all_noonlyfat_no65075100.txt');

% CalibrationPoints=load('\\ming.radiology.ucsf.edu\Working_Directory\Shepherd Shared Folders\Publications-Presentations\2008\Papers\3C Breast\CalibrationFiles_delrin\20081211_3rdSet\CalibrationPoints20081211_26kVp_2-4_30-20-10-5.txt');
% CalibrationPoints=load('\\ming.radiology.ucsf.edu\Working_Directory\Shepherd Shared Folders\Publications-Presentations\2008\Papers\3C Breast\CalibrationFiles_delrin\20081203_2ndSet\CalibrationPoints20081203_26kVp_2-4_30-20-10-5.txt');
%CalibrationPoints=load('\\ming.radiology.ucsf.edu\Working_Directory\Shephe
%rd Shared Folders\Publications-Presentations\2008\Papers\3C Breast\CalibrationFiles_delrin\20090122_4thSet\CalibrationPoints20090122_26kVp_2-4_30-20-10-5_onlyfat.txt');
%CalibrationPoints=load('\\ming\aaDATA\Breast Studies\3C_data\20100216 - A7028613\20100305_37_29_CalibrationPoints_corrected.txt');
%[fileName, pathName]=uigetfile('\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\*.txt', 'Please select calibration file.');
[fileName, pathName]=uigetfile('\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\*.txt', 'Please select calibration file.');
CalibrationPoints=load(fullfile(pathName, fileName));
%CalibrationPoints=load('\\ming\aaDATA\Breast Studies\3C_data\20100127\20100305_52_32kVp_CalibrationPoints.txt');
%CalibrationPoints=load('\\ming\aaDATA\Breast Studies\3C_data\20100216 - A7016776\20100210_37_27_CalibrationPoints_corrected.txt');
%Calibration Data file format:   columns - [t_fat t_water HE R T]
%CalibrationPoints=load('\\ming\aaDATA\Breast Studies\AL_SeleniaData\20100407\png_files\20100407_25_CalibrationPoints_45dark.txt');
%CalibrationPoints=load('\\ming\aaDATA\Breast Studies\3C_data\20100311\20100311_25_CalibrationPoints.txt');
%CalibrationPoints=load('\\ming\aaDATA\Breast Studies\3C_data\20100311\20100311_25_CalibrationPoints.txt');
Data=[CalibrationPoints(:,1)/10 CalibrationPoints(:,2)/10 CalibrationPoints(:,3) CalibrationPoints(:,4) CalibrationPoints(:,5)/10];
X = [];
%Data(:,3)=Data(:,3)/1000; %HE
LE = Data(:,3)/1000;
HE = Data(:,4)/1000;
R =  LE./HE;
T =  Data(:,5); %T - total thickness in cm 
B=[Data(:,1) Data(:,2)]; % water and lipid
Data(:,6)= Data(:,5)-(Data(:,1)+Data(:,2));

%equation tfat = a1 + a2*HE + a3*R + a4*T + a5*HE^2 + a6*R^2 + a7*T^2 +
%a8*HE*R + a9*HE*T + a10*T*R
%A=[ones(size(Data,1),1) HE R T HE.^2 R.^2 T.^2 HE.*R HE.*T T.*R ];
A=[ones(size(Data,1),1) HE R T HE.^2 R.^2 T.^2 HE.*R HE.*T T.*R HE.^3 R.^3 T.^3];

% A=[ones(size(Data,1),1) HE R T HE.^2 R.^2 T.^2 HE.*R HE.*T T.*R HE.^3 R.^3 T.^3];

X=A\B;
%X=pinv(A)*B;
Result=A*X
Result(:,3) = Data(:,5)-(Result(:,1)+Result(:,2));
% % % figure;plot(HE,R,'bo'); 
format long g;
%%% for temporary

pname = file.startpath;
[pathstr,name,ext] = fileparts(Image.fnameLE)
save([pname,'CalibrationCoeffs_',name,'.mat'],'X'); %_No6cm100
%%%
xc = X
figure;plot(Result(:,1),'o');hold on;  %blue 'o' - calculated data 
plot(Data(:,1),'rx');                  %red  'x' - real data
ylabel('Thickness water');xlabel('Number of ROI'); grid on;
legend('Calculted water','Real thickness');

figure;plot(Result(:,2),'o');hold on;  %blue 'o' - calculated data 
plot(Data(:,2),'rx');                  %red  'x' - real data
ylabel('Thickness fat');xlabel('Number of ROI'); grid on;
legend('Calculted fat','Real thickness');

figure;plot(Result(:,3),'o');hold on;  %blue 'o' - calculated data 
plot(Data(:,6),'rx');                  %red  'x' - real data
ylabel('Thickness protein');xlabel('Number of ROI'); grid on;
legend('Calculted protein','Real thickness');


dev_twater = (sum((Data(:,1)-Result(:,1)).^2)./size(Data,1)).^0.5
dev_tfat = (sum((Data(:,2)-Result(:,2)).^2)./size(Data,1)).^0.5
dev_tprotein = (sum((Data(:,6)-Result(:,3)).^2)./size(Data,1)).^0.5

water_error=dev_twater/max(Data(:,1))*100
fat_error=dev_tfat/max(Data(:,2))*100
protein_error=dev_tprotein/max(Data(:,6))*100





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


