function plot_3dpattern()
     
     x = [0.6 1 2 3 4 5 6 7 8];
     y = [24	25	26	27	28	29	30	31	32	33];
     Z = [1.166	1.155	1.135	1.141	1.072	1.042	1.029	1.014	0	0;
          1.051	1.041	1.032	1.024	1.029	1.021	1.016	1.012	1.013	1.032;
          1.005	1.005	1.005	1.005	1.006	1.008	1.009	1.01	1.007	1.009;
          0.999	1	1.001	1.002	1.001	1.002	1.004	1.006	1.002	1.004;
          1.001	1	0.999	1	1.007	1.006	1.005	1.004	1	0.998;
          0     0	0	1.029	1.027	1.023	1.02	1.016	1.012	1.009;
          0     0	0	1.063	1.058	1.052	1.046	1.04	1.042	1.042;
          0     0	0	0	0	0	0	1.085	1.08	1.075;
          0     0	0	0	0	0	0	1.131	1.124	1.118];

     [X,Y] = meshgrid(x,y);
     %figure;surf(X,Y,thickness_mapreal(1:2:end,1:2:end),'FaceColor','red','EdgeColor','none')
     figure;surf(X,Y,Z'); colormap(gray);
     zlim([0.9 1.2]);
     
     figure;surfl(X,Y,thickness_mapreal(1:3:end,1:3:end));%colormap(gray); %camlight left; lighting phong
     %figure;plot3(X,Y,thickness_mapreal);
     %surfl(x,y,z);
     camlight left
     shading interp
     colormap(gray); ;
     y = (1:3:ROI.rows)*0.014;
     [X,Y] = meshgrid(x,y);
     %figure;surf(X,Y,thickness_mapreal(1:2:end,1:2:end),'FaceColor','red','EdgeColor','none')
    
     figure;surfl(X,Y,thickness_mapreal(1:3:end,1:3:end));%colormap(gray); %camlight left; lighting phong
     %figure;plot3(X,Y,thickness_mapreal);
     %surfl(x,y,z);
     camlight left
     shading interp
     colormap(gray);
     
    % figure; plot(h24,kle25,'k*-',h24,kle24,'ko-',h24,kle26,'ks-',h27,kle27,'kx-',h27,kle28,'k+-',h27,kle29,'k-.',h27,kle30,'kh-',h31,kle31,'kd-',h31,kle32,'kp-',h31,kle33,'kv-');grid on;
    %plot(h24,kl25,'k*-',h24,kl24,'ko-',h24,kl26,'ks-',h27,kl27,'kx-',h27,kl28,'k+-',h27,kl29,'k-.',h27,kl30,'kh-',h31,kl31,'kd-',h31,kl32,'kp-',h31,kl33,'kv-');grid on;
    %date1s = num2str(date1);
    %{
    x1 = datenum(str2num(date1s(:,1:4)),str2num(date1s(:,5:6)),str2num(date1s(:,7:8)));
    date2s = num2str(date2);
    date2s = num2str(date2);
    date3s = num2str(date3);
    date4s = num2str(date4);
    date5s = num2str(date5);
    date6s = num2str(date6);
    date7s = num2str(date7);
    x2 = datenum(str2num(date2s(:,1:4)),str2num(date2s(:,5:6)),str2num(date2s(:,7:8)));
    hold on;
    figure;plot(x2, dens2, 'b.');datetick('x',2,'keepticks');
    figure;plot(x2, dens2, 'b*');datetick('x',2,'keepticks');
    hold on;plot(x2, dens2, 'b*');datetick('x',2,'keepticks');
    x3 = datenum(str2num(date3s(:,1:4)),str2num(date3s(:,5:6)),str2num(date3s(:,7:8)));
    x4 = datenum(str2num(date4s(:,1:4)),str2num(date4s(:,5:6)),str2num(date4s(:,7:8)));
    x5 = datenum(str2num(date5s(:,1:4)),str2num(date5s(:,5:6)),str2num(date5s(:,7:8)));
    x6 = datenum(str2num(date6s(:,1:4)),str2num(date6s(:,5:6)),str2num(date6s(:,7:8)));
    x7 = datenum(str2num(date7s(:,1:4)),str2num(date7s(:,5:6)),str2num(date7s(:,7:8)));
    hold on;plot(x3, dens3, 'bo');datetick('x',2,'keepticks');
    hold on;plot(x4, dens4, 'bx');datetick('x',2,'keepticks');
    hold on;plot(x5, dens5, 'bs');datetick('x',2,'keepticks');
    hold on;plot(x6, dens6, 'b+');datetick('x',2,'keepticks');
    hold on;plot(x7, dens7, 'bd');datetick('x',2,'keepticks');
    grid on;
    legend('1 - .', '2 - *', '3 - o','4 - x', '5 - "square"','6 - +', '7 - "diamond"');
    %}
    
    %{
    kV = [24, 25, 26,27, 28, 29, 30, 31, 32, 33,34];
counts = [6315.074, 7588.739, 9074.182 ,10504.13, 12415.06, 14237.83, 16142.65, 18685.01, 17046.57, 18920.65, 20879.08];
figure;
plot(kV, counts, 'bo');
xlim([0 22000]);
plot(kV, counts, 'bo');
ylim([0 22000]);
plot(kV, counts, '-bo');
kV2 = [24, 25, 26,27, 28, 29, 30, 31, 32, 33,34, 39];
count2 = [6315.074, 7588.739, 9074.182 ,10504.13, 12415.06, 14237.83, 16142.65, 18685.01, 17046.57, 18920.65, 20879.08,33974.3];
figure;
plot(kV2, counts2, '-bo');
plot(kV2, count2, '-bo');
grid on;
figure;
plot(kV, counts, 'bo');
plot(kV, counts, '-bo');
plot(kV(1:end-3), countskV(1:end-3), '-bo');
plot(kV(1:end-3), counts(1:end-3), '-bo');
plot(kV(1:end-3), counts(1:end-3), 'bo');
figure;
plot(kV(end-2:end), counts(end-2:end), 'bo');
hold on;
plot(kV(end-2:end), counts(end-2:end), 'bo');
kv1 = [24,25,26,27,28,29,30,31];
kv2 = [32, 33, 34];
figure;
plot(kV(1:end-3), counts(1:end-3), '-bo');hold on;
y1 = 84.52*kv1-2902*kv2+27300;
y1 = 84.52*kv1.^2-2902*kv1+27300;
plot(kV(1:end-3), y1, '-b');hold on;
plot(kV(1:end-3), counts(1:end-3), 'bo');hold on;
hold on;
figure;
plot(kV(1:end-3), counts(1:end-3), 'bo');hold on;
plot(kV(1:end-3), y1, '-b');hold on;
y2 = 42.18*kv2.^2-867.3*kv2+1613;
plot(kV(end-2:end), counts(end-2:end), 'bo');
plot(kV(end-3:end), y2((end-3:end), 'b-');
plot(kV(end-3:end), y2(end-3:end), 'b-');
y2 = 42.18*kV.^2-867.3*kV+1613;
plot(kV(end-3:end), y2(end-3:end), 'b-');
hold on;
grid on;
%}
