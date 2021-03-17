function CalibrationDXA_3C_fat_water_protein(type)
%This function is used to calculate the calibration coefficients.  It
%deletes the information in the global variable X, then stores the
%coefficients in X after computing them.
%
%Parameters
%Name       Type            Description
%type       string          This string should be either 'QUADRATIC' or
%                           'CUBIC'. It specifies the type of approximation
%                           to use when computing the calibration
%                           coefficients.

% Calculate the coefficients ci and di in X=[coeff1 coeff2]
% from the Calibration Points.

%%%%%%%%%%%%%%%%%%%%%%- Global Variables -%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global X  file Image Info
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Set the type of approximation to the global variable
Info.type3C = type;

%Get the current directory & ask the user where to store the file
my_path = file.startpath;
[fileName, pathName]=uigetfile([my_path '\*.txt'], 'Please select calibration file.');

%Load the calibration points file and store it in a variable
CalibrationPoints=load(fullfile(pathName, fileName));

%Store the vectors from the file into a variable, and divide the mm units
%by 10 to put them into cm units
%? Later, make it so that the titles of each column is in the header and
%automatically retreived.  As of now, the columns are as follows:
%1: Water (mm)   2: Lipid (mm)   3: mean LE     4: mean HE       5: total lipid+water+protein (mm)
%6: mean RST = mean(LE./HE)      7: std LE       8: std HE       9: std RST'
Data=[CalibrationPoints(:,1)/10 CalibrationPoints(:,2)/10 CalibrationPoints(:,3) CalibrationPoints(:,4) CalibrationPoints(:,5)/10 CalibrationPoints(:,6)];


%for i = 1:1:1
deform_Data = Data;

%Remove the ROIs that are emperically prone to error on the 3CB CP Phantom
%
% % % remove_logical = zeros(size(Data));
% % % %remove_these = [7 19 32 41 51 4 1 16 37 14 10 34 25 38 30 36 31]; these are for error-prone
% % % remove_these = [1 2 5 6 7 8 11 12 13 14 17 18 19 20 23 24 25 26 29 30 31 32 35 36 37 38 41 42 43 44 47 48 49 51]; %these are to only use the 4cm ROIs
% % % for i = 1:1:size(remove_these,2)
% % %     remove_logical(remove_these(i)) = 1;
% % % end
% % % remove_logical = logical(remove_logical);
% % % 
% % % deform_Data(remove_logical,:) = [];
%}


%Empty the global variable X
X = [];


s_p = 1;
e_p = size(deform_Data,1);

%? Why are LE & HE divided by 1000?
LE = deform_Data(s_p:e_p,3)/1000;
HE = deform_Data(s_p:e_p,4)/1000;
R = deform_Data(s_p:e_p,6); %LE./HE;
T =  deform_Data(s_p:e_p,5); %T is total thicknesses in cm
t_water = deform_Data(s_p:e_p,1); %phantom water thicknesses in cm
t_lipid = deform_Data(s_p:e_p,2); %phantom lipid thicknesses in cm
t_protein = T-(t_water+t_lipid); %phantom protein thicknesses in cm

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Define the coefficient matrix A and the LHS of the equation B = Ax.  You
%have to edit this if you want to swap what is calculated (protein vs.
%water).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
B=[t_water t_lipid];   % water and lipid thicknesses in cm
%B=[t_protein t_lipid];  % protein & lipid thicknesses in cm

%Create the coefficient matrix A w/ either cubic or qudratic.  A is a 51x10
%matrix in the quadratic case, and a 51x13 for the cubic case.  This would
%mean that
%
%equation tfat = a1 + a2*HE + a3*R + a4*T + a5*HE^2 + a6*R^2 + a7*T^2 +
%a8*HE*R + a9*HE*T + a10*T*R
% % Info.type3C = 'CUBIC';
% % type = Info.type3C;
if strcmp(type,'QUADRATIC')
    A=[ones(size(T,1),1) HE R T HE.^2 R.^2 T.^2 HE.*R HE.*T T.*R ];
else
    A=[ones(size(T,1),1) HE R T HE.^2 R.^2 T.^2 HE.*R HE.*T T.*R HE.^3 R.^3 T.^3];
end

%A=[ones(size(T,1),1) HE R T HE.^2 R.^2 T.^2 HE.*R HE.*T T.*R HE.^3 R.^3 T.^3];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Lasso %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Use a lasso to fit the model
% % % 
% % % [ax1,Stats1] = lasso(A,B(:,1))  %,'CV',5
% % % X(:,1) = ax1(:,5)
% % % [ax2,Stats2] = lasso(A,B(:,2))
% % % X(:,2) = ax2(:,5)
ds = size(A);
d = ds(2);
lambda = 6;
X(:,1) = (A'*A+lambda*eye(d)) \ A'*B(:,1);
X(:,2) = (A'*A+lambda*eye(d)) \ A'*B(:,2);

% % % %%%%%%%%%%%%%%%%%%%%%%% end of Lasso %%%%%%%%%%%%%%%%%%%%
% % % BB1 = B(:,1);
% % % [B1 FitInfo] = lassoglm(A,BB1,'poisson','CV',30)
% % % X(:,1) = B1(:,10);
% % % BB2 = B(:,2);
% % % [B2 FitInfo] = lassoglm(A,BB2,'poisson','CV',30)
% % % X(:,2) = B2(:,10);

% % % [X(:,1),FLAG,RELRES,ITER,RESVEC,LSVEC] = lsqr(A,B(:,1),1e-15,30)
% % % Result(:,1)=A*X(:,1);
% % % [X(:,2),FLAG,RELRES,ITER,RESVEC,LSVEC] = lsqr(A,B(:,2),1e-15, 30)
% % % Result(:,2)=A*X(:,2);

% % % X(:,1) = lsqlin(A,B(:,1))
% % % Result(:,1)=A*X(:,1)
% % % X(:,2) = lsqlin(A,B(:,2))
% % % Result(:,2)=A*X(:,2)

% % % BB1 = B(:,1);
% % % X(:,1) = regress(BB1, A);
% % % Result(:,1)=A*X(:,1);
% % % BB2 = B(:,2);
% % % X(:,2) = regress(BB2, A);
% % % Result(:,2)=A*X(:,2);


%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Calculate the calibration coefficients
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%This is where the cvx function should go
% % % [a1, a2] = calc_3cb_coeff_cvx(A, t_water, t_lipid, t_protein);
% % % X = [a1 a2];
% % X=A\B;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Calculate the thicknesses of the phantom for use in calculating the error.
%You have to edit this if want to swap what is calculated (protein vs.
%water).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Result=A*X;
calc_lipid = Result(:,2)
%calc_water = Result(:,1);
%calc_protein = T-(calc_water+calc_lipid);

%Replace following two lines to calc prtoein instead of water from coeff
% % % calc_protein =  Result(:,1)
% % % calc_water = T-(calc_protein+calc_lipid)
calc_water =  Result(:,1)
calc_protein = T-(calc_water+calc_lipid)



format long g;
%%% for temporary


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Save the calibration coefficients
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % pname = file.startpath;
% % % [pathstr,name,ext] = fileparts(Image.fnameLE)
% % % save([pname,'CalibrationCoeffs_',name,'.mat'],'X'); %_No6cm100


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Calculate the error & plot data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xc = X

figure(2);plot(t_water,calc_water, 'o');
figure(3);plot(t_lipid,calc_lipid, '*');
figure(4);plot(t_protein,calc_protein, 'o');


dt = [t_water, t_lipid, t_protein, calc_water, calc_lipid, calc_protein];
figure(5);plot(calc_water,'o');hold on;  %blue 'o' - calculated data
plot(t_water,'rx');                  %red  'x' - real data
ylabel('Thickness water');xlabel('Number of ROI'); grid on;
legend('Calculted water','Real thickness');
hold off;

figure(6);plot(calc_lipid,'o');hold on;  %blue 'o' - calculated data
plot(t_lipid,'rx');                  %red  'x' - real data
ylabel('Thickness fat');xlabel('Number of ROI'); grid on;
legend('Calculted fat','Real thickness');
hold off;

figure(7);plot(calc_protein,'o');hold on;  %blue 'o' - calculated data
plot(t_protein,'rx');                  %red  'x' - real data
ylabel('Thickness protein');xlabel('Number of ROI'); grid on;
legend('Calculted protein','Real thickness');
hold off;


dev_twater = (sum((t_water-calc_water).^2)./size(t_water,1)).^0.5
dev_tfat = (sum((t_lipid-calc_lipid).^2)./size(t_lipid,1)).^0.5
dev_tprotein = (sum((t_protein-calc_protein).^2)./size(t_protein,1)).^0.5

water_error=dev_twater/max(t_water)*100
fat_error=dev_tfat/max(t_lipid)*100
protein_error=dev_tprotein/max(t_protein)*100


%Append data to excel file
% % % meanData = [water_error fat_error protein_error];% mean(mean(tempimage7)) mean_water mean_lipid mean_protein];
% % % xlsappend('TempData.xlsx', meanData);

%end
end

