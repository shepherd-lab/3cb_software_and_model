function optim_3C()
global Info L01
%This function optimizes 4 bovine compositions and two parameters of LE and  HE corrections  to match two Cadaver breast results: calculated and Anresco.  
Info.type3C = 'QUADRATIC';
%%
%initial values of parameters to fit from the following equatinos:
% water = (a1*t_mus + a2*t_fat)/10;
% lipid = (b1*t_mus + b2*t_fat)/10;
% protein = T - water - lipid;
% where t_mus - thickness of fat, t_fat - thickness of fat
%and k = (t_mus*k1 + t_fat*k2)./(t_mus + t_fat);
% a1 = 0.81;
% a2 = 0.13;
% b1 = 0.012;
% b2 = 0.855;
 a1 = 0.71;
 a2 = 0.119;
 b1 = 0.0444;
 b2 = 0.865;
k1 = 1;
k2 = 1;

%%
% known compositions, 
  %cadaver breast compositions (kVp = 27) calculated using bovine phantom calibration
 %dense breast (muscle) MT1
 br.HE1 = 9623.6/1000;
 br.RST1 = 2.4276;
 br.T1 = 2.7178;
 %fatty breast 63337R
 br.HE2 = 7390.6/1000;
 br.RST2 = 2.1193;
 br.T2 = 2.9218;
 %known Anresco compositions in %
%  anr.water1 = 73.49;
%  anr.lipid1 = 13.53
%  anr.protein1 = 12.1;
%  anr.water2 = 8.81;
%  anr.lipid2 = 90.79;
%  anr.protein2 = 0.4;
anr = [73.49,8.81;13.53,90.79;12.1,0.4]; % Anresco results for two breast samples
%
% %   
% %  out_br =brcomp_calc(br, coef, coef2)
%% start optimization
 x0 = [a1,a2,b1,b2,k1,k2]';
 
 init = x0
 lambda = 0;
 L01 = [];
 
%          for i = 1:2  
           [y,feval] = find_corr(x0, br, anr, lambda) 
           x0 = y
%         end
 figure;plot(L01);
a = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

%%
function [y,feval] = find_corr(x0, br, anr, lambda)        
%x0 = [a1 a2 b1 b2 k1 k2]; parameters to optimize
%known_values = [br anr lambda];
  
options = optimset('Display','iter','MaxIter',250 ) %'TolFun',1e-16, 'TolX',1e-16,
[y,feval,exitflag,output] = fminsearch(@cost_function, x0, options); %, options
      % %    %options = optimset('Display','iter','TolFun',1e-8)
% %    %options = optimset('Display', 'on'); % Turn off Display
   
    function L0 = cost_function(x) % Compute square of errors between calculated and Anresco.
        global L01  % to plot for each iteration
       a1 = x(1);
       a2 = x(2);
       b1 = x(3);
       b2 = x(4);
       k1 = x(5);
       k2 = x(6);
     
       x
       [HE,R,T,water,lipid,k] = bvcomp_calc(a1, a2, b1, b2, k1, k2);
       [coef, coef2] = coeff_calc(HE, R, T, water, lipid, lambda);
        out_br =brcomp_calc(br, coef, coef2)
        anr
       Q = out_br - anr
       stdQ= std2(Q)
       errQ = mean(mean(abs(Q)))
       L0 = trace(Q*Q');  
       L01 = [L01;L0];
       a = 1;
    end
end


%%
function [HE,R,T,water,lipid,k] = bvcomp_calc(a1, a2, b1, b2, k1, k2)
% bovine 15 ROI phantom:[ water, lipid, total, LE, HE, t_muscle, t_fat]
bovine_data = [
 0      60.5	60.5	34813	16440	2.117576679     7.9     51.73
0       40.3	40.27	24244	11334	2.139008511     5.2     34.43
0       20.1	20.13	13284	5873	2.261921587     2.6     17.21
13      47.5	60.5	39433	18019	2.188490058     16.7	40.78
14.8	25.5	40.27	29721	13039	2.279375178     15.3	21.96
7       13.1	20.13	16570	6980	2.373916519     7.4     11.32
31      29.5	60.5	46579	20381	2.285418913     28.9	25.58
21.4	18.9	40.27	32082	13856	2.31547104      19.8	16.38
9.7     10.4	20.13	17172	7231	2.374618676     9.2     9.05
60.5	0       60.5	55643	23120	2.406681992     49      0.73
40.3	0       40.27	39106	15968	2.4489959       32.6	0.48
20.1	0       20.13	23156	9120	2.538994168     16.3	0.24
36.9	23.6	60.5	47667	20383	2.338555976     32.9	20.66
26      14.2	40.27	35470	14779	2.400065093     22.9	12.48
13.3	6.8     20.13	18706	7504	2.492758046     11.7	5.96
];

t_mus = bovine_data(:,1);
t_fat = bovine_data(:,2);
T = bovine_data(:,3)/10;
water = (a1*t_mus + a2*t_fat)/10;
lipid = (b1*t_mus + b2*t_fat)/10;
protein = T - water - lipid;
k = (t_mus*k1 + t_fat*k2)./(t_mus + t_fat);
LE = k.*bovine_data(:,4)/1000;
HE = k.*bovine_data(:,5)/1000;
R = LE./HE;
a  = 1;
end

%%
function [coeff, coeff2] = coeff_calc(HE, R, T, water, lipid, lambda)
%calibration coefficient calculation
global Info
if strfind(Info.type3C,'QUADRATIC')
        A=[ones(size(HE,1),1) HE R T HE.^2 R.^2 T.^2 HE.*R HE.*T T.*R ];
    elseif  strfind(Info.type3C,'LINEAR')  
         A=[ones(size(HE,1),1) HE R T ];
    else  %'CUBIC'
        A=[ones(size(HE,1),1) HE R T HE.^2 R.^2 T.^2 HE.*R HE.*T T.*R HE.^3 R.^3 T.^3];  
end
ds = size(A);
d = ds(2);
B = [water, lipid];
% lambda = 0;  % 2 - regularization coefficient, when lambda = 0 it is linear regression for solving A*X=B
X(:,1) = (A'*A+lambda*eye(d)) \ A'*B(:,1);
X(:,2) = (A'*A+lambda*eye(d)) \ A'*B(:,2);
coeff = X(:,1);
coeff2 = X(:,2);
end


%%
function [out_br] =brcomp_calc(br, coef, coef2)
%two cadaver breast processing in percentage scale to compare with Anresco
 global Info
if strfind(Info.type3C,'QUADRATIC')
    water1=  coef(1) + coef(2)*br.HE1 + coef(3)*br.RST1 + br.T1*coef(4) + coef(5)*br.HE1.^2 + coef(6)*br.RST1.^2 + br.T1.^2*coef(7) + coef(8)*(br.HE1.*br.RST1) + coef(9)*br.T1.*br.HE1 + coef(10)*br.T1.*br.RST1 ;
    lipid1= coef2(1) + coef2(2)*br.HE1 + coef2(3)*br.RST1 + br.T1*coef2(4) + coef2(5)*br.HE1.^2 + coef2(6)*br.RST1.^2 + br.T1.^2*coef2(7) + coef2(8)*(br.HE1.*br.RST1) + coef2(9)*br.T1.*br.HE1 + coef2(10)*br.T1.*br.RST1 ;
    water2=  coef(1) + coef(2)*br.HE2 + coef(3)*br.RST2 + br.T2*coef(4) + coef(5)*br.HE2.^2 + coef(6)*br.RST2.^2 + br.T2.^2*coef(7) + coef(8)*(br.HE2.*br.RST2) + coef(9)*br.T2.*br.HE2 + coef(10)*br.T2.*br.RST2 ;
    lipid2= coef2(1) + coef2(2)*br.HE2 + coef2(3)*br.RST2 + br.T2*coef2(4) + coef2(5)*br.HE2.^2 + coef2(6)*br.RST2.^2 + br.T2.^2*coef2(7) + coef2(8)*(br.HE2.*br.RST2) + coef2(9)*br.T2.*br.HE2 + coef2(10)*br.T2.*br.RST2 ;

elseif strfind(Info.type3C,'LINEAR')
    water1=  coef(1) + coef(2)*br.HE1 + coef(3)*br.RST1 + br.T1*coef(4) ;
    lipid1= coef2(1) + coef2(2)*br.HE1 + coef2(3)*br.RST1 + br.T1*coef2(4) ;
    water2=  coef(1) + coef(2)*br.HE2 + coef(3)*br.RST2 + br.T2*coef(4) ;
    lipid2= coef2(1) + coef2(2)*br.HE2 + coef2(3)*br.RST2 + br.T2*coef2(4) ;
end

protein1= br.T1 - water1 - lipid1;
protein2= br.T2 - water2 - lipid2;
prc_water1 = water1/br.T1*100;
prc_lipid1 = lipid1/br.T1*100;
prc_protein1 = protein1/br.T1*100;
prc_water2 = water2/br.T2*100;
prc_lipid2 = lipid2/br.T2*100;
prc_protein2 = protein2/br.T2*100;

out_br = [prc_water1, prc_water2; prc_lipid1, prc_lipid2; prc_protein1, prc_protein2];
end


%%
