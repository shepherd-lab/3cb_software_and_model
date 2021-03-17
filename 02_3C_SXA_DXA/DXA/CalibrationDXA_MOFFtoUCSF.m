function CalibrationDXA_MOFFtoUCSF()
global XX 

[fileName, pathName]=uigetfile('\\researchstg\aaStudies\Breast Studies\3CB R01\Source Data\Bovine_experiment\Calibration_Bovine_Serghei\*.txt', 'Please select calibration file.');
 CalibrationPoints=load(fullfile(pathName, fileName));

X = [];

%%%%%% my calibration file
Data=CalibrationPoints;
% Data=[CalibrationPoints(:,1)/10 CalibrationPoints(:,2)/10 CalibrationPoints(:,3) CalibrationPoints(:,4) CalibrationPoints(:,5)/10];
HE_u = Data(:,2)/1000;
HE_m = Data(:,4)/1000;
R_u = Data(:,1);
R_m = Data(:,3);

B=[HE_u R_u]; % density and thickness
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

type = 'TWOCOMP';
if strfind(type,'TWOCOMP') 
    A=[ones(size(Data,1),1) HE_m R_m HE_m.^2 R_m.^2 HE_m.*R_m ];
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
figure;plot(Result(:,1),'o');hold on;  %blue 'o' - calculated data 
plot(HE_u,'rx');                  %red  'x' - real data
ylabel('HE_u');xlabel('Number of ROI'); grid on;
legend('Calculted HE_u', 'Real HE_u');

figure;plot(Result(:,2),'o');hold on;  %blue 'o' - calculated data 
plot(R_u,'rx');                  %red  'x' - real data
ylabel('R_u');xlabel('Number of ROI'); grid on;
legend('Calculted Ru','Real R_u');

HE_uR= Result(:,1);
R_uR = Result(:,2);
ND = length(HE_uR);
NT = length(R_uR);
dev_first = (sum((HE_u-HE_uR).^2)./ND(1)).^0.5
dev_second = (sum((R_u-R_uR).^2)./NT(1)).^0.5

HE_error=dev_first/max(HE_uR)*100
R_error=dev_second/max(R_uR)*100
fileName = ['XX_',fileName];
fn = fullfile(pathName, fileName);
% xx_fname = [fn(1:end-4),'_XX.txt'];
data = [R_uR HE_uR R_u HE_u];
save(fn,'XX','-ascii');
XX
a =1;


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


