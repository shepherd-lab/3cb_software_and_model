%plot of the DXA calibration for BIG PHANTOM
function CalibrationPlot_Se25()
global X;
global CalibrationPoints;

f1=figure;plot3(CalibrationPoints(:,4),CalibrationPoints(:,5),CalibrationPoints(:,2),'o','markersize',5,'markerfacecolor','black','markeredgecolor','black');
hold on,
f2=figure;plot(CalibrationPoints(:,4),CalibrationPoints(:,5),'o','markersize',3,'markerfacecolor','black','markeredgecolor','black');
hold on;plot(17168,1.640260951,'o','markersize',3,'markerfacecolor','g','markeredgecolor','g');hold on;
plot(17235,1.635427908,'o','markersize',3,'markerfacecolor','m','markeredgecolor','m');
grid on;

coef2=X(:,1);
coef=X(:,2);

MinRST=min(CalibrationPoints(:,5))-0.1; % automatic choice of the scale
MaxRST=max(CalibrationPoints(:,5))+0.1; 

MinHE=min(CalibrationPoints(:,4))-100;
MaxHE=max(CalibrationPoints(:,4))+100;

% densities = [0 30 45 50 60 70 100]; %input the densities
densities = [23.07692308 46.15384615 57.69230769 61.53846154 69.23076923 76.92307692 100];
    
for i=1:7 % 7 density steps
    Glandular = densities(i);
    HE=(MinHE:1:MaxHE)'; 
    RST=InvertPolynomial_density(HE/1000,Glandular,coef);
    MyLine=[HE RST Glandular*ones(size(HE))];
    figure(f1);
    plot3(MyLine(:,1),MyLine(:,2),MyLine(:,3),'b');
    figure(f2);
    plot(MyLine(:,1),MyLine(:,2),'r');
end

% d = SecondOrder(1.2418,0.831,coef)% RST,HE,coef
% th = SecondOrder(1.2418,0.831,coef2)

for Thickness=[4 5 6 7]
    RST=(MinRST:0.0001:MaxRST)';
    HE=1000*InvertPolynomial_thickness(RST,Thickness,coef2);
    Glandular=SecondOrder(RST,HE/1000,coef);
%     Glandular=SecondOrder(RST,HE,coef);
    [mini,minIndex]=min(Glandular<0);
    [mini,maxIndex]=min(Glandular<100);    
    MyLine=[HE(minIndex:maxIndex) RST(minIndex:maxIndex) Glandular(minIndex:maxIndex)];
    figure(f1);
    plot3(MyLine(:,1),MyLine(:,2),MyLine(:,3),'b');
    figure(f2);
    plot(MyLine(:,1),MyLine(:,2),'r');
end

figure (f1)
grid on
set(gca,'zlim',[0 102]);zlabel('Glandular','fontsize',16);
set(gca,'xlim',[MinHE MaxHE]);xlabel('HE','fontsize',16);
set(gca,'ylim',[MinRST MaxRST]);ylabel('R','fontsize',16);
set(gcf,'color',[1 1 1]);
% title('DXA Calibration','fontsize',20);

figure (f2)
grid on
set(gca,'xlim',[MinHE MaxHE]);xlabel('HE','fontsize',16);
set(gca,'ylim',[MinRST MaxRST]);ylabel('R','fontsize',16);
set(gcf,'color',[1 1 1]);
% title('DXA Calibration','fontsize',20);

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
    
