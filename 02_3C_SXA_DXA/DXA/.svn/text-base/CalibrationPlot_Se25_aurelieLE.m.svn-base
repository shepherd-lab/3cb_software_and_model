%plot of the DXA calibration
function CalibrationPlot_Se25()
global X;
global CalibrationPoints;

f1=figure;plot3(CalibrationPoints(:,4),CalibrationPoints(:,5),CalibrationPoints(:,2),'o','markersize',5,'markerfacecolor','black','markeredgecolor','black');
hold on,
f2=figure;plot(CalibrationPoints(:,4),CalibrationPoints(:,5),'o','markersize',3,'markerfacecolor','black','markeredgecolor','black');
hold on;
grid on;

coef2=X(:,1);
coef=X(:,2);

MinRST=min(CalibrationPoints(:,5))-0.1; % automatic choice of the scale
MaxRST=max(CalibrationPoints(:,5))+0.1; 

MinLE=min(CalibrationPoints(:,3))-100;
MaxLE=max(CalibrationPoints(:,3))+100;

% densities = [0 30 45 50 60 70 100];
%densities = [25  65 100];
densities = [0	50 100]; %input the densities
	
for i=1:3
    Glandular = densities(i);
    LE=(MinLE:1:MaxLE)';
    RST=InvertPolynomial_density(LE/1000,Glandular,coef);
    MyLine=[LE RST Glandular*ones(size(LE))];
    figure(f1);
    plot3(MyLine(:,1),MyLine(:,2),MyLine(:,3),'r');
    figure(f2);
    plot(MyLine(:,1),MyLine(:,2),'r');
end

d = SecondOrder(1.2418,0.831,coef)% RST,HE,coef
th = SecondOrder(1.2418,0.831,coef2)

for Thickness=0.4:0.2:1
    RST=(MinRST:0.0001:MaxRST)';
    LE=1000*InvertPolynomial_thickness(RST,Thickness,coef2);
    Glandular=SecondOrder(RST,LE/1000,coef);
    [mini,minIndex]=min(Glandular<0);
    [mini,maxIndex]=min(Glandular<100);    
    MyLine=[LE(minIndex:maxIndex) RST(minIndex:maxIndex) Glandular(minIndex:maxIndex)];
    figure(f1);
    plot3(MyLine(:,1),MyLine(:,2),MyLine(:,3),'r');
    figure(f2);
    plot(MyLine(:,1),MyLine(:,2),'r');
end

figure (f1)
grid on
set(gca,'zlim',[0 102]);zlabel('Glandular','fontsize',16);
set(gca,'xlim',[MinLE MaxLE]);xlabel('LE','fontsize',16);
set(gca,'ylim',[MinRST MaxRST]);ylabel('R','fontsize',16);
set(gcf,'color',[1 1 1]);
title('DXA Calibration','fontsize',20);

figure (f2)
grid on
set(gca,'xlim',[MinLE MaxLE]);xlabel('LE','fontsize',16);
set(gca,'ylim',[MinRST MaxRST]);ylabel('R','fontsize',16);
set(gcf,'color',[1 1 1]);
title('DXA Calibration','fontsize',20);

function Glandular=SecondOrder(RST,LE,coef)
    Glandular=coef(1)+coef(2)*RST+coef(3)*LE+coef(4)*(RST).^2+coef(5)*(LE).^2+coef(6)*LE.*RST;
    
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
    
