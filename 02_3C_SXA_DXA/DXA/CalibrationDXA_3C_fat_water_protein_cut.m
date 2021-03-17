function CalibrationDXA_3C_fat_water_cubic_26points()

type = 'QUADRATIC';
X = [];

%%%%%% load calibration file with columns: 
% water thickness (cm), lipid thickness, HE attenuation, R=LE/HE, T(total thickness) %%%%%% 
[fileName, pathName]=uigetfile('*.txt', 'Please select calibration file.');
CalibrationPoints=load(fullfile(pathName, fileName));
Data=[CalibrationPoints(:,1)/10 CalibrationPoints(:,2)/10 CalibrationPoints(:,3) CalibrationPoints(:,4) CalibrationPoints(:,5)/10];
HE = Data(:,3)/1000;
R =  Data(:,4);
T =  Data(:,5); %T - total thickness in cm 
Data(:,6)= Data(:,5)-(Data(:,1) + Data(:,2));%protein
B=[Data(:,1) Data(:,2)]; % water and lipid  Data(:,6)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if strfind(type,'QUADRATIC')
    A=[ones(size(Data,1),1) HE R T HE.^2 R.^2 T.^2 HE.*R HE.*T T.*R ];
else  %'CUBIC'
    A=[ones(size(Data,1),1) HE R T HE.^2 R.^2 T.^2 HE.*R HE.*T T.*R HE.^3 R.^3 T.^3];
end

ds = size(A);
d = ds(2);
lambda = 2;  %regularization coefficient, when lambda = 0 it is linear regression for solving A*X=B
X(:,1) = (A'*A+lambda*eye(d)) \ A'*B(:,1);
X(:,2) = (A'*A+lambda*eye(d)) \ A'*B(:,2);

%linear regression: by pinv and \ for solving A*X=B
%X=pinv(A)*B;
% % X=A\B; 

Result=A*X
Result(:,3) = Data(:,5)-(Result(:,1)+Result(:,2));

format long g;

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


dev_first = (sum((Data(:,1)-Result(:,1)).^2)./size(Data,1)).^0.5
dev_second = (sum((Data(:,2)-Result(:,2)).^2)./size(Data,1)).^0.5
dev_third = (sum((Data(:,6)-Result(:,3)).^2)./size(Data,1)).^0.5

water_error=dev_first/max(Data(:,1))*100
fat_error=dev_second/max(Data(:,2))*100
protein_error=dev_third/max(Data(:,6))*100
a =1;





