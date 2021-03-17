% Initial version.
%
%
%

global DEBUG film maxFatValue minFatValue maxLeanValue minLeanValue
DEBUG=1;  % plot a lot of stuffs if debug==1

fatThickness = [1 3 5 7];
leanThickness = [2 4 6 8];

display('1. 0cm')
display('2. 1cmFat')
display('3. 2cmFat')
display('4. 3cmFat')
display('5. 4cmFat')
display('6. 5cmFat')
display('7. 6cmFat')
display('8. 7cmFat')
display('9. 2cm5050')
display('10. 4cm5050')
display('11. 6cm5050')
display('12. 2cmGland')
display('13. 4cmGland')
display('14. 6cmGland-1')
display('15. 6cmGland-2')
display('16. Rachel')

film=input('which film? ')

if film==1
    fatValues = [42269.3156 49071.0114 61173.8027 61338.6958];
    fatStdDev = [400.0877 88.1512 19.7027 18.2170];
    leanValues = [59835.0598 61346.4371 61372.1801 61374.5708];
    leanStdDev = [109.8412 15.3033 13.6732 17.9202];
elseif film==2
    fatValues = [41797.7446 58974.1006 61154.7201 61321.4228];
    fatStdDev = [344.3242 98.3758 29.6561 20.4322];
    leanValues = [59847.3474 61341.7279 61366.8282 61375.3145];
    leanStdDev = [119.8352 18.3509 17.9381 14.8719];
elseif film==3
    fatValues = [31059.8158 56058.5673 60863.8798 61239.7549];
    fatStdDev = [431.6917 144.9171 53.3788 29.8630];
    leanValues = [57760.9263 61270.1254 61346.3818 61328.2317];
    leanStdDev = [235.4339 25.9028 22.2258 25.1617];
elseif film==4
    fatValues = [17224.2842 47345.2757 59559.5571 60955.1765];
    fatStdDev = [573.5353 233.9623 130.0115 78.5236];
    leanValues = [50636.1766 61014.2584 61316.0124 61284.0310];
    leanStdDev = [453.2006 81.1449 30.5200 42.4209];
elseif film==5
    fatValues = [12233.5294 28416.1948 53685.1900 59463.6786];
    fatStdDev = [1090.3827 368.7004 475.4090 370.5380];
    leanValues = [34480.9430 59775.5800 61131.5639 61017.0423];
    leanStdDev = [918.1035 338.1785 108.0938 142.5874];
elseif film==6
    fatValues = [11214.5747 15496.2922 43413.8795 55271.1127];
    fatStdDev = [1260.0348 672.9687 831.3123 1020.6590];
    leanValues = [20051.5728 56023.1179 60548.8468 60201.9952];
    leanStdDev = [532.3515 945.7705 380.8835 514.0590];
elseif film==7
    fatValues = [10172.3336 10950.5182 26359.2606 45376.6747];
    fatStdDev = [1442.0630 1270.8722 912.2421 2054.6454];
    leanValues = [12914.1535 47481.5197 58481.2098 57199.7508];
    leanStdDev = [1004.5772 1391.8195 1148.1422 1369.3140];
elseif film==8
    fatValues = [9999.3711 9964.0131 13323.9783 29083.1052];
    fatStdDev = [1463.7466 1475.0117 1068.9712 2175.5470];
    leanValues = [11014.9040 31266.1904 52093.9073 49354.6464];
    leanStdDev = [1239.1146 1923.6883 2139.4690 2795.1725];
elseif film==9
    fatValues = [22334.2363 52218.7330 60432.1750 61168.9003];
    fatStdDev = [520.4158 259.5669 93.7908 40.8492];
    leanValues = [54623.2743 61186.9287 61359.7624 61339.1571];
    leanStdDev = [271.4390 34.1829 18.9885 23.1708];
elseif film==10
    fatValues = [11140.2080 14370.4324 41156.6354 54474.1250];
    fatStdDev = [1261.7085 779.9930 982.6603 1036.0324];
    leanValues = [18472.6050 55410.6377 60530.3527 60301.1135];
    leanStdDev = [610.1635 686.9916 327.5317 470.6675];
elseif film==11
    fatValues = [10025.7261 10091.6686 11017.0506 18349.9882];
    fatStdDev = [1493.9694 1486.9544 1269.3831 1755.4111];
    leanValues = [10345.2173 19763.4728 46008.9460 43494.5729];
    leanStdDev = [1398.8306 1011.4743 2506.8453 3064.3386];
elseif film==12
    fatValues = [16484.6260 45716.0809 59271.7425 60960.6875];
    fatStdDev = [652.2684 249.8432 142.1577 75.2934];
    leanValues = [49686.4842 61012.1805 61346.3024 61329.7615];
    leanStdDev = [468.2507 70.8248 29.0487 27.1890];
elseif film==13
    fatValues = [10942.4061 11401.7451 22029.4680 42382.2240];
    fatStdDev = [1286.8854 1182.4215 972.2067 2264.3059];
    leanValues = [12861.6964 44414.5108 58083.2564 56734.8719];
    leanStdDev = [1034.3869 1224.1735 989.698 1646.5168];
elseif film==14
    fatValues = [9752.5128 9682.7168 9578.1157 10401.6956];
    fatStdDev = [1562.0783 1545.4411 1578.6608 1458.1542];
    leanValues = [9882.1771 10986.4586 26189.8383 30689.9227];
    leanStdDev = [1489.6286 1287.8317 1936.9203 3291.5428];
elseif film==15
    fatValues = [9557.1504 9604.2065 9491.4794 10650.1031];
    fatStdDev = [1623.3361 1545.1813 1587.7750 1405.4261];
    leanValues = [10128.4752 11358.8960 28802.9777 33913.9162];
    leanStdDev = [1415.2232 1214.0338 1763.6409 3259.8719];
elseif film==16
    fatValues = [10360.8498 11195.7689 25872.1508 47740.2232];
    fatStdDev = [1400.4777 1271.4529 1035.8999 2769.0889];
    leanValues = [13501.8663 47812.9963 59191.9765 60320.3727];
    leanStdDev = [948.4370 1295.8014 887.5220 483.1289];
end

% actual step min and max pixel values for curve fitting
maxFatValue = max(fatValues);
minFatValue = min(fatValues);
maxLeanValue = max(leanValues);
minLeanValue = min(leanValues);

% 1cm fat & 8cm gland step pixel values as min & max
% maxFatValue = fatValues(1,4);
% minFatValue = fatValues(1,1);
% maxLeanValue = leanValues(1,4);
% minLeanValue = leanValues(1,1);

figure;plot(fatThickness,fatValues,'.')
hold on;
plot(fatThickness,fatValues+fatStdDev,'+')
plot(fatThickness,fatValues-fatStdDev,'+')
plot(leanThickness,leanValues,'.')
plot(leanThickness,leanValues+leanStdDev,'+')
plot(leanThickness,leanValues-leanStdDev,'+')
legend off;

fat_function = fit_densthickness4(fatThickness',fatValues');
% fatHigh_function = fit_densthickness4(fatThickness',(fatValues+fatStdDev)');
% fatLow_function = fit_densthickness4(fatThickness',(fatValues-fatStdDev)');
lean_function = fit_densthickness4(leanThickness',leanValues');
% leanHigh_function = fit_densthickness4(leanThickness',(leanValues+leanStdDev)');
% leanLow_function = fit_densthickness4(leanThickness',(leanValues-leanStdDev)');
% fat_function = fit(fatThickness',fatValues','poly2');
% lean_function = fit(leanThickness',leanValues','poly2');

plot(fat_function)
% plot(fat_function,'k-',fatThickness',fatValues','b.','predfunc','predobs',0.99);
% plot(fatHigh_function)
% plot(fatLow_function)
plot(lean_function)
% plot(lean_function,'k-',leanThickness',leanValues','b.','predfunc','predobs' ,0.99);
% plot(leanHigh_function)
% plot(leanLow_function)
xlim('auto');
ylim('auto');

% Using fat function
% grayvalue = fat_function(7.5);

% Using fat function
% grayvalue = lean_function(7.5);
