%plot of the DXA calibration
function CalibrationPlot

CalibrationPoints=load('CalibrationPoints_mean_aurelie.txt'); %Thickness glandular, LE, HE, RST
%CalibrationPoints=load('CalibrationPoints_ProdigyHawaii.txt');
CalibrationPoints

f1=figure;plot3(CalibrationPoints(:,4),CalibrationPoints(:,5),CalibrationPoints(:,2),'o','markersize',5,'markerfacecolor','black','markeredgecolor','black');
hold on,
f2=figure;plot(CalibrationPoints(:,4),CalibrationPoints(:,5),'o','markersize',5,'markerfacecolor','black','markeredgecolor','black');
hold on;

% coef=[1522.437597 -4087.17244 -2065.65348 2355.784874 29.75419467 1777.450806];  %Glandular=SecondOrder(RST,HE/1000,coef)
% coef2=[-194.31031420731 114.77579188730 311.60877521479 -2.11948241846 -124.78756969700 -80.67223617062]; %Thckness=coef1+coef2*HE+coef3*RST+coef4*HE2+coef5*RST2+coef6*HE*RST

%coef = [864.19 -1962.2 -5.8802 1048.5 1.5451 -8.3225];
%coef2 = [34.46 -54.882 7.7317 21.597 -0.0025215 -3.9755];

% small step phantom aurelie
coef2=[5.1066;0.0015871;-339.43;3.8893e-009;0;-1.1413];
coef=[-1555.6;-0.48524;66835;-1.5995e-006;0;381.48];

MinRST=1.8;
MaxRST=3;
MaxHE=1000;

for Glandular=0:10:100
    HE=(000:MaxHE)';
    RST=InvertPolynomial(HE/1000,Glandular,coef);
    MyLine=[HE RST Glandular*ones(size(HE))];
    figure(f1);
    plot3(MyLine(:,1),MyLine(:,2),MyLine(:,3),'r');
    figure(f2);
    plot(MyLine(:,1),MyLine(:,2),'r');
end

SecondOrder(1.19,0.2,coef) %RST,HE,coef
SecondOrder(0.2,1.19,coef2)

for Thickness=0:24
    RST=(1.1:0.0001:1.3)';
    HE=1000*InvertPolynomial(RST,Thickness,coef2);
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
set(gca,'zlim',[0 100]);zlabel('Glandular','fontsize',16);
set(gca,'xlim',[0 1500]);xlabel('HE','fontsize',16);
set(gca,'ylim',[1.14 1.28]);ylabel('R','fontsize',16);
set(gcf,'color',[1 1 1]);
title('DXA Calibration','fontsize',20);

figure (f2)
grid on
set(gca,'xlim',[0 1500]);xlabel('HE','fontsize',16);
set(gca,'ylim',[1.14 1.28]);ylabel('R','fontsize',16);
set(gcf,'color',[1 1 1]);
title('DXA Calibration','fontsize',20);

function Glandular=SecondOrder(RST,HE,coef)
    Glandular=coef(1)+coef(2)*RST+coef(3)*HE+coef(4)*(RST).^2+coef(5)*(HE).^2+coef(6)*HE.*RST;
    
function X=InvertPolynomial(Y,Z,coef) 
%% take function z=coef1+coef2*x+coef3*y+coef4*x2+coef5*y2+coef6*x*y
    a=coef(4);
    b=coef(6)*Y+coef(2);
    c=coef(1)+coef(3)*Y+coef(5)*Y.^2-Z;
    Delta=b.^2-4*a*c;
    X=(-b+Delta.^0.5)/2/a;
    
    
