%PA calibration global background
%2	100	1258.357143	944.5017007;...
%mmax = 40000 for kVp=39,  [5 5] median filter 
%{
7	0	36160.49232	21013.34142
7	30	39746.96918	22354.33213
7	45	41326.19488	22911.49707
7	50	41938.4649	23231.00611
7	60	43265.05737	23898.29803
7	70	44353.08588	24560.16588
7	100	47726.03615	26379.25916
1	0	6352.955724	4035.070949
1	30	6917.448937	4359.488318
1	45	7366.397204	4533.088908
1	50	7567.398312	4571.420213
1	60	7910.710878	4695.550582
1	70	8124.750596	4796.286037
1	100	9050.970673	5234.338295
2	0	12021.52388	7331.371452
2	30	13706.27797	7930.447949
2	45	14527.63391	8208.788911
2	50	14869.64935	8335.017656
2	60	15509.27432	8598.312425
2	70	16013.68853	8822.960004
2	100	17819.24959	9550.117013
%}
Data=[...
3	0	17166.48365	10059.26422
3	30	19446.59652	10852.83497
3	45	20540.24928	11218.81161
3	50	20982.02437	11415.57967
3	60	21855.47121	11781.67862
3	70	22556.29061	12083.06386
3	100	24944.0283	13054.91256
4	0	22479.73753	12972.67431
4	30	25277.52814	13929.10274
4	45	26578.71179	14357.92856
4	50	27117.1356	14571.89216
4	60	28171.98334	15029.08029
4	70	29009.7703	15412.82853
4	100	31770.52194	16654.16937
5	0	27107.09738	15550.85337
5	30	30236.0919	16655.28127
5	45	31652.92946	17145.42394
5	50	32252.08424	17403.157
5	60	33462.52262	17925.67639
5	70	34409.16356	18410.54698
5	100	37525.52869	19831.46212
6	0	31957.70607	18343.45562
6	30	35382.11002	19552.62739
6	45	36919.74075	20074.33107
6	50	37549.80193	20387.85973
6	60	38834.70261	20991.50157
6	70	39865.94169	21583.77952
6	100	43163.39273	23250.39622
];

Data(:,3)=Data(:,3)/1000;
%temp = Data(:,3);
Data(:,4)=Data(:,4)/1000;
Data(:,3)=Data(:,3)./Data(:,4);
%Data(:,4) = temp;
B=[Data(:,1) Data(:,2)];
A=[ones(size(Data,1),1) Data(:,3) Data(:,4) Data(:,3).^2 Data(:,4).^2 Data(:,3).*Data(:,4)  ];%Data(:,3).^3 Data(:,4).^3
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


