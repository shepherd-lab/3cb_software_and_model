Data=[...
20	0	1290.4	1107.82;...
20	50	1383.97	1175.02;...
20	100	1493.64	1255.66;...
10	0	661.27	562.63;...
10	50	712.51	596.53;...
10	100	769.52	635.4;...
2	0	134.61	113.4;...
2	50	145.68	119.9;...
2	100	158.6	127.42;...
20	0	1297.41	1114.65;...
20	50	1394.15	1184.4;...
20	100	1495.94	1258.47;...
10	0	661.65	562.64;...
10	50	712.99	596.64;...
10	100	770.2	636.15;...
2	0	134.53	113.01;...
2	50	145.68	120.14;...
2	100	158.84	127.86;...
20	0	1296.58	1114.05;...
20	50	1390.98	1180.99;...
20	100	1492.92	1255.97;...
10	0	661.83	562.92;...
10	50	713.48	597.18;...
10	100	770.54	636.17;...
2	0	134.41	112.97;...
2	50	145.81	119.46;...
2	100	158.88	127.67;...
20	0	1297.96	1114.33;...
20	50	1389.73	1178.92;...
20	100	1489.47	1252.46;...
10	0	661.61	562.1;...
10	50	712.67	595.62;...
10	100	770.1	634.66;...
2	0	134.07	112.49;...
2	50	145.62	119.72;...
2	100	158.33	127.36;...
4	100	314.51	255.23;...
4	70	299.72	246.04;...
4	60	296.15	243.6;...
4	0	269.7286	227.1665;...
4	30	282.1283	234.8062;...
4	45	287.2842	237.0921;...
4	50	291.544	240.9334;...
4	60	296.1629	243.76;...
4	70	299.7416	245.7598;...
4	100	314.7683	255.3946;...
10	0	663.16	562.8738;...
10	30	691.4089	581.5866;...
10	45	700.8934	586.1755;...
10	50	711.1162	594.822;...
10	60	723.4101	602.9695;...
10	70	732.4463	608.9829;...
10	100	766.8028	632.1528;...
10	0	662.9469	563.1329;...
10	30	691.0501	581.5419;...
10	45	701.0984	586.5847;...
10	50	711.0263	594.5139;...
10	60	722.567	602.1497;...
10	70	732.1752	608.0907;...
10	100	766.5599	632.036;...
10	0	663.9778	563.8745;...
10	30	692.4361	582.3191;...
10	45	701.8235	586.9731;...
10	50	712.6236	595.5714;...
10	60	724.215	603.3529;...
10	70	733.541	609.3955;...
10	100	767.428	632.7646;...
10	0	664.4179	563.9901;...
10	30	691.975	581.876;...
10	45	702.1747	587.9392;...
10	50	712.2774	595.8566;...
10	60	724.1662	603.9443;...
10	70	733.2063	609.6664;...
10	100	766.3381	631.5729;...
10	0	664.6331	564.2257;...
10	30	692.8468	582.7028;...
10	45	702.1324	587.7264;...
10	50	712.4789	595.3455;...
10	60	724.5846	604.1453;...
10	70	731.0217	607.3975;...
10	100	767.4988	632.7177;...
10	0	664.3356	564.2598;...
10	30	692.5745	582.3026;...
10	45	702.2252	587.4942;...
10	50	712.5184	595.6554;...
10	60	724.5188	604.3632;...
10	70	733.07	610.084;...
10	100	767.2902	632.5314];

Data(:,3)=Data(:,3)/1000;
Data(:,4)=Data(:,4)/1000;
Data(:,3)=Data(:,3)./Data(:,4);
B=[Data(:,1) Data(:,2)];
A=[ones(size(Data,1),1) Data(:,3) Data(:,4) Data(:,3).^2 Data(:,4).^2 Data(:,3).*Data(:,4)];
X=A\B

Result=A*X;
figure;plot(Result(:,2),'o');hold on;
plot(Data(:,2),'x');

(sum((Data(:,2)-Result(:,2)).^2)./size(Data,1)).^0.5




%Calibration Lateral
Data=[...
20	0	1329.5659	1134.1894	1.172260912;...
20	50	1422.25	1199.5569	1.185646133;...
20	100	1521.7149	1270.6081	1.197627262;...
10	0	680.4523	574.0193	1.185417111;...
10	50	731.2064	606.5335	1.2055499;...
10	100	789.4467	645.9098	1.222224373;...
2	0	142.127	117.8285	1.206219208;...
2	50	157.3961	128.2996	1.226785586;...
2	100	173.7272	138.6578	1.252920499;...
10	0	680.3723	573.9267	1.185468981;...
10	30	707.5712	590.6308	1.197992384;...
10	45	718.2702	596.5127	1.20411552;...
10	50	729.6529	605.2987	1.205442701;...
10	60	738.7513	610.7091	1.209661523;...
10	70	748.0833	616.456	1.21352262;...
10	100	783.8084	641.1526	1.222498981;...
4	0	276.9257	232.045	1.193413778;...
4	30	289.7943	239.5159	1.209916753;...
4	45	295.156	242.5309	1.216983073;...
4	50	299.4143	245.7338	1.218449802;...
4	60	304.0715	248.3959	1.224140576;...
4	70	307.8237	250.7435	1.227643787;...
4	100	323.1615	259.7673	1.244042264;...
20	0	1314.0676	1120.7086	1.172532806;...
20	50	1405.8593	1185.4309	1.185947911;...
20	100	1505.7759	1257.3961	1.197535049;...
10	0	678.6569	572.5033	1.185420067;...
10	50	731.1275	606.363	1.205758762;...
10	100	788.9962	645.3872	1.222516034;...
2	0	140.7283	116.8158	1.204702617;...
2	50	155.1532	126.4995	1.226512358;...
2	100	170.7343	136.1461	1.254052081;...
20	0	1325.4159	1130.515	1.172400101;...
20	50	1420.1283	1197.3303	1.186078979;...
20	100	1522.2876	1273.2192	1.19562099;...
10	0	671.9644	566.4475	1.18627834;...
10	50	724.8323	601.0388	1.205965904;...
10	100	783.3164	640.4241	1.223121366;...
%2	0	135.3918	111.458	1.214733801;...
%2	50	147.5397	118.7455	1.242486663;...
%2	100	160.852	126.6267	1.270285019;...
10	0	663.7218	559.3228	1.186652502;...
10	30	683.0468	569.8236	1.198698685;...
10	45	709.3569	588.8411	1.204666081;...
10	50	707.6946	587.1715	1.205260473;...
10	60	727.1194	601.4983	1.208846974;...
10	70	737.5381	608.7013	1.211658493;...
10	100	780.3448	638.9151	1.221359145;...
4	0	271.6901	226.7195	1.198353472;...
4	30	284.7815	234.0175	1.216923948;...
4	45	289.9175	236.9289	1.223647685;...
4	50	294.2952	240.5586	1.223382577;...
4	60	298.9166	243.1994	1.229100894;...
4	70	303.3387	246.2171	1.231996884;...
4	100	319.164	255.8756	1.247340505;...
];


Data(:,3)=Data(:,3)/1000;
Data(:,4)=Data(:,4)/1000;
Data(:,3)=Data(:,3)./Data(:,4);
B=[Data(:,1) Data(:,2)];
A=[ones(size(Data,1),1) Data(:,3) Data(:,4) Data(:,3).^2 Data(:,4).^2 Data(:,3).*Data(:,4)];
X=A\B;

Result=A*X;
figure;plot(Result(:,2),'o');hold on;
plot(Data(:,2),'x');

(sum((Data(:,2)-Result(:,2)).^2)./size(Data,1)).^0.5