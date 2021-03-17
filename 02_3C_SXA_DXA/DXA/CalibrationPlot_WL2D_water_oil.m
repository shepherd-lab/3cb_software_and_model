%plot of the DXA calibration for BIG PHANTOM
function CalibrationPlot_Se25()
global X;
global CalibrationPoints Data2;

CalibrationPoints = Data2;
% f2=figure;plot(CalibrationPoints(:,4),CalibrationPoints(:,3),'o','markersize',3,'markerfacecolor','black','markeredgecolor','black');
f2=figure;plot(CalibrationPoints(:,3),CalibrationPoints(:,4),'o','markersize',3,'markerfacecolor','black','markeredgecolor','black');

hold on;
grid on;

coef2=X(:,2);
coef=X(:,1);

MinRST=min(CalibrationPoints(:,3))-0.1; % automatic choice of the scale
MaxRST=max(CalibrationPoints(:,3))+0.1; 

MinHE=min(CalibrationPoints(:,4))-1000;
MaxHE=max(CalibrationPoints(:,4))+1000;

% densities = [0 30 45 50 60 70 100]; %input the densities
densities = [0  50 100];
    
for i=1:3
    Glandular = densities(i);
    HE=(MinHE:5000:MaxHE)'; 
    RST=InvertPolynomial_density(HE/1000,Glandular,coef);
    MyLine=[HE RST Glandular*ones(size(HE))];
    figure(f2);
    plot(MyLine(:,1),MyLine(:,2),'r');
end

d = SecondOrder(1.2418,0.831,coef)% RST,HE,coef
th = SecondOrder(1.2418,0.831,coef2)

for Thickness=2:2:6
    RST=(MinRST:0.0001:MaxRST)';
    HE=1000*InvertPolynomial_thickness(RST,Thickness,coef2);
    Glandular=SecondOrder(RST,HE/1000,coef);
    [mini,minIndex]=min(Glandular<0);
    [mini,maxIndex]=min(Glandular<100);    
    MyLine=[HE(minIndex:maxIndex) RST(minIndex:maxIndex) Glandular(minIndex:maxIndex)];
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
    Delta=(b.^2-4*a*c);
    X=(-b+Delta.^0.5)/2/a;
   % X = sqrt(X.*conj(X));
    %X=(-b+realsqrt(Delta))/2/a;
    
