%plot of the DXA calibration
function CalibrationPlot_Se25()

%CalibrationPoints=load('CalibrationPoints_mean.txt'); %Thickness glandular, LE, HE, RST
%CalibrationPoints=load('CalibrationPoints_ProdigyHawaii_All.txt');
CalibrationPoints=load('C:\Documents and Settings\smalkov\My Documents\CalibrationFiles\DXA_Selenia\senograph25.txt');

CalibrationPoints

f1=figure;plot3(CalibrationPoints(:,4),CalibrationPoints(:,5),CalibrationPoints(:,2),'o','markersize',5,'markerfacecolor','black','markeredgecolor','black');
hold on,
f2=figure;plot(CalibrationPoints(:,4),CalibrationPoints(:,5),'o','markersize',3,'markerfacecolor','black','markeredgecolor','black');
hold on;
grid on;
%coef=[1522.437597 -4087.17244 -2065.65348 2355.784874 29.75419467 1777.450806];  %Glandular=SecondOrder(RST,HE/1000,coef)
%coef2=[-194.31031420731 114.77579188730 311.60877521479 -2.11948241846 -124.78756969700 -80.67223617062]; %Thckness=coef1+coef2*HE+coef3*RST+coef4*HE2+coef5*RST2+coef6*HE*RST
coef2 = [-137.45	302.08	-4.4535	-162.71	-0.033064	4.8232];
coef = [17272	-37688	621.12	20169	4.6657	-638.85];

%coef = [-936.9022	871.1212	-12.3583	-61.6678	1.2089	-0.9795];
%coef2 = [43.9789	-68.8993	6.7795	26.823	0.0135	-3.3405];
      
%coef = [864.19 -1962.2 -5.8802 1048.5 1.5451 -8.3225];
%coef2 = [34.46 -54.882 7.7317 21.597 -0.0025215 -3.9755];
         

MinRST=1.15;
MaxRST=1.45;
MaxHE=32000;
MinHE=10000;
%densities = [22.43055556 40.34722222 51.11111111 56.59722222 65.41666667 71.59722222 97.22222222];
 %densities = [25  65 100];
 densities = [0	30 45 50 60 70 100];
	

for i=1:7
    Glandular = densities(i);
    HE=(MinHE:1:MaxHE)';
    RST=InvertPolynomial_density(HE/1000,Glandular,coef);
    MyLine=[HE RST Glandular*ones(size(HE))];
    figure(f1);
    plot3(MyLine(:,1),MyLine(:,2),MyLine(:,3),'r');
    figure(f2);
    plot(MyLine(:,1),MyLine(:,2),'r');
end

d = SecondOrder(1.2418,0.831,coef)% RST,HE,coef
th = SecondOrder(1.2418,0.831,coef2)

for Thickness=2:4
    RST=(MinRST:0.0001:MaxRST)';
    HE=1000*InvertPolynomial_thickness(RST,Thickness,coef2);
    Glandular=SecondOrder(RST,HE/1000,coef);
    [mini,minIndex]=min(Glandular<0);
    [mini,maxIndex]=min(Glandular<100);    
    MyLine=[HE(minIndex:maxIndex) RST(minIndex:maxIndex) Glandular(minIndex:maxIndex)];
    figure(f1);
    plot3(MyLine(:,1),MyLine(:,2),MyLine(:,3),'r');
    figure(f2);
    plot(MyLine(:,1),MyLine(:,2),'r');
end

figure (f1)
grid on
set(gca,'zlim',[0 102]);zlabel('Glandular','fontsize',16);
set(gca,'xlim',[MinHE MaxHE]);xlabel('HE','fontsize',16);
set(gca,'ylim',[MinRST MaxRST]);ylabel('R','fontsize',16);
set(gcf,'color',[1 1 1]);
title('DXA Calibration','fontsize',20);

figure (f2)
grid on
set(gca,'xlim',[MinHE MaxHE]);xlabel('HE','fontsize',16);
set(gca,'ylim',[MinRST MaxRST]);ylabel('R','fontsize',16);
set(gcf,'color',[1 1 1]);
title('DXA Calibration','fontsize',20);

function Glandular=SecondOrder(RST,HE,coef)
    Glandular=coef(1)+coef(2)*RST+coef(3)*HE+coef(4)*(RST).^2+coef(5)*(HE).^2+coef(6)*HE.*RST;
    
function X=InvertPolynomial_density(Y,Z,coef) 
%% take function z=coef1+coef2*x+coef3*y+coef4*x2+coef5*y2+coef6*x*y
    a=coef(4);
    b=coef(6)*Y+coef(2);
    c=coef(1)+coef(3)*Y+coef(5)*Y.^2-Z;
    Delta=b.^2-4*a*c;
    X=(-b+Delta.^0.5)/2/a;
    
 function X=InvertPolynomial_thickness(Y,Z,coef) 
%% take function z=coef1+coef2*x+coef3*y+coef4*x2+coef5*y2+coef6*x*y
    a=coef(5);
    b=coef(6)*Y+coef(3);
    c=coef(1)+coef(2)*Y+coef(4)*Y.^2-Z;
    Delta=b.^2-4*a*c;
    X=(-b+Delta.^0.5)/2/a;
    