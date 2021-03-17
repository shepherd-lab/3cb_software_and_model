% Initial version.
%  
%
%
global  DEBUG
DEBUG=1;  %plot a lot of stuffs if debug==1

fatThickness = [1 3 5 7];
fatValues = [42269.3156 49071.0114 61173.8027 61338.6958];

fat_function = fit(fatThickness',fatValues','poly2');

%Using fat function
grayvalue  = fat_function(7.5);


leanThickness = [2 4 6 8];
leanValues = [59835.0598 61346.4371 61372.1801 61374.5708];

lean_function = fit(leanThickness',leanValues','poly2');
%Using fat function
grayvalue  = lean_function(7.5);


