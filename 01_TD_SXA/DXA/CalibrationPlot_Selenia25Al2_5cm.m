function CalibrationPlot_Selenia25Al2_5cm()
%plot of the DXA calibration

a = pwd;
%CalibrationPoints=load('CalibrationPoints_mean.txt'); %Thickness glandular, LE, HE, RST
%CalibrationPoints=load('CalibrationPoints_ProdigyHawaii_All.txt');
%CalibrationPoints=load('C:\Documents and Settings\smalkov\My Documents\CalibrationFiles\DXA_Selenia\dxaSe_25Al_FF2up1000All3.txt'); %dxaSe_25Al_FF2up1000All3.txt %dxaSe_25FF1-6cm.txt dxaSe4_31k6mmAl-5000.txt

%
CalibrationPoints = load('dxaSe_25Al2-5cm.txt');
CalibrationPoints

f1=figure;
plot3(CalibrationPoints(:,4),CalibrationPoints(:,5),CalibrationPoints(:,2),'o','markersize',5,'markerfacecolor','black','markeredgecolor','black');
hold on,
f2=figure;
plot(CalibrationPoints(:,4),CalibrationPoints(:,5),'o','markersize',5,'markerfacecolor','black','markeredgecolor','black');
grid on;
hold on;

%coef=[1522.437597 -4087.17244 -2065.65348 2355.784874 29.75419467 1777.450806];  %Glandular=SecondOrder(RST,HE/1000,coef)
%coef2=[-194.31031420731 114.77579188730 311.60877521479 -2.11948241846 -124.78756969700 -80.67223617062]; %Thckness=coef1+coef2*HE+coef3*RST+coef4*HE2+coef5*RST2+coef6*HE*RST
  %25kVp Al 1-4cm 
 coef2 = [
     -37.921      
       32.888      
        1.048       
      -7.2122      
   -0.0016045      
     -0.29825     
   ]; 
 coef = [
   2827.9
   -2767.2
    -3.64
    680.36 
  0.26638
  -0.92972
  ];
   
 %{ 
  coef2 = [
      -15.488      
       13.785      
      0.99736       
      -3.1341      
  -0.00073777     
     -0.28427      
  ];   

coef = [
     2187.5
     -2286.8
    12.692
     603.46
      0.81494
     -13.025
     ];
%}
%31kVp 12-7cm
%{
coef2 = [
-29.104
35.759
0.88076
-12.675
-0.011266
-0.065352
];
coef = [
1471.8
-2102
-17.43
857.94
0.95234
-11.556
];
%}
%32kVp
%{
coef2 = [
-45.164
57.069
0.68609
-19.052
-0.0084081
-0.027664
];

coef = [
2839.6
-3987
11.013
1457.6
0.77412
-22.967
];
%}
%31 kVp
%{
coef2 = [
-73.012
87.749
0.84468
-28.16
-0.012313
-0.021915
];
coef = [
4344.3
-5654.6
0.054994
1939.1
0.87135
-19.657
];
%}
%FF no Al 
%{
coef2 = [
-32.16
64.91
0.2941
-34.756
-0.0012559
0.14183
];
coef = [
 355.7
-1100.7
-32.615
948.91
0.32971
2.9591
];   
%}

 %FF + Al 3mm
%{
coef2 = [
-37.921
32.888
1.048
-7.2122
-0.0016045
-0.29825
];

coef = [
2827.9
-2767.2
-3.64
680.36
0.26638
-0.92972
];
%}
%25kVp, Al3mmFF 2-5cm
%{
coef2 = [-25.628
22.712
0.99417
-5.1029
-0.0013697
-0.27836
];
coef = [1929.2
-1977.3
-6.8074
512.04
0.36865
-1.0458
];
%}
%coef2 = [-94.2	240.99	-4.2396	-148.23	-0.048977	5.3151];
%coef = [9139	-22015	377.57	12897	3.661	-431.36];

%coef = [-936.9022	871.1212	-12.3583	-61.6678	1.2089	-0.9795];
%coef2 = [43.9789	-68.8993	6.7795	26.823	0.0135	-3.3405];
      
%coef = [864.19 -1962.2 -5.8802 1048.5 1.5451 -8.3225];
%coef2 = [34.46 -54.882 7.7317 21.597 -0.0025215 -3.9755];
         

MinRST=2.15;
MaxRST=2.46;
MaxHE=20000;
MinHE = 6000;
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

for Thickness=2:5
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
set(gca,'zlim',[0 100]);zlabel('Glandular','fontsize',16);
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
    %X=(-b+Delta.^0.5)/2/a;
    X=(-b+realsqrt(Delta))/2/a; %realsqrt(X) %Delta.^0.5
