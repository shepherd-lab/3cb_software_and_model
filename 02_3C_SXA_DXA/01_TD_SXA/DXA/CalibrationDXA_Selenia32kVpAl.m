%PA calibration global background
%2	100	1258.357143	944.5017007;...
%mmax = 40000 for kVp=39,  [5 5] median filter 
%{
1	0	5468.63793	4030.850544
1	30	6250.976649	4356.588577
1	45	6699.473137	4530.747884
1	50	6896.551107	4570.873339
1	60	7197.806557	4692.849083
1	70	7367.7599	4794.187972
1	100	8226.863877	5231.844456
2	0	10958.83394	7331.270468
2	30	12557.88957	7932.145319
2	45	13341.95517	8211.762851
2	50	13644.7301	8337.351007
2	60	14227.51838	8599.957664
2	70	14687.50828	8823.93565
2	100	16402.4804	9550.666389
3	0	15805.62825	10059.11501
3	30	17949.28374	10852.39945
3	45	18983.59171	11218.35165
3	50	19403.65307	11415.17353
3	60	20217.41588	11781.22099
3	70	20882.67078	12083.70651
3	100	23186.02171	13055.62248
7	0	34315.95451	21013.34142
7	30	37942.02719	22354.33213
7	45	39559.21642	22911.49707
7	50	40225.00041	23231.00611
7	60	41595.6423	23898.29803
7	70	42727.41468	24560.16588
7	100	46293.87412	26379.25916
2	0	10958.83394	7331.270468
2	30	12557.88957	7932.145319
2	45	13341.95517	8211.762851
2	50	13644.7301	8337.351007
2	60	14227.51838	8599.957664
2	70	14687.50828	8823.93565
2	100	16402.4804	9550.666389
3	0	15805.62825	10059.11501
3	30	17949.28374	10852.39945
3	45	18983.59171	11218.35165
3	50	19403.65307	11415.17353
3	60	20217.41588	11781.22099
3	70	20882.67078	12083.70651
3	100	23186.02171	13055.62248
%}
Data=[...
4	0	20985.16336	12977.54988
4	30	23630.39821	13935.25933
4	45	24896.44505	14364.58459
4	50	25417.94162	14579.33761
4	60	26454.48714	15035.85952
4	70	27282.37512	15420.71177
4	100	29986.07423	16661.22959
5	0	25327.61633	15550.85337
5	30	28382.49601	16655.28127
5	45	29816.81019	17145.42394
5	50	30412.84904	17403.157
5	60	31593.36426	17925.67639
5	70	32527.90504	18410.54698
5	100	35731.03456	19831.46212
6	0	30081.91919	18343.45562
6	30	33489.02696	19552.62739
6	45	35071.29105	20074.33107
6	50	35718.80971	20387.85973
6	60	37004.59832	20991.50157
6	70	38081.25911	21583.77952
6	100	41536.93151	23250.39622
];

Data(:,3)=Data(:,3)/1000;
%temp = Data(:,3);
Data(:,4)=Data(:,4)/1000;
Data(:,3)=Data(:,3)./Data(:,4);
%Data(:,4) = temp;
B=[Data(:,1) Data(:,2)];
A=[ones(size(Data,1),1) Data(:,3) Data(:,4) Data(:,3).^2 Data(:,4).^2 Data(:,3).*Data(:,4) ];%Data(:,3).^3 Data(:,4).^3
X=A\B
Result=A*X;
figure;plot(Result(:,2),'o');hold on;
plot(Data(:,2),'rx');

dev_thickness = (sum((Data(:,1)-Result(:,1)).^2)./size(Data,1)).^0.5
dev_density = (sum((Data(:,2)-Result(:,2)).^2)./size(Data,1)).^0.5
x = X;
d = 1;
%dev = (sum((Data(:,2)-Result(:,2)).^2)./size(Data,1)).^0.5

;



