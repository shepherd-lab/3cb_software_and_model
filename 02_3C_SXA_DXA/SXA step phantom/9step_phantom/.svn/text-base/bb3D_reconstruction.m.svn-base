function bb3D_reconstruction()
    %filename='P:\Vidar Images\test\StepCalibrate4cm5050Do not know-1.tif'; 
    global xf1 yf1 BBSPLOT Mammo pixelCm
   % Mammo=imread(filename);
    clear Phantom xf yf
    pixelCm=150/2.54;
         
    Xim = 0.015 *[734.6511, 101.0292, 0;
               807.687, 66.2847, 0;
               882.6223, 37.6715, 0;
               747.4281, 110.4818, 0;
               879.3417, 367.2336, 0;
               948.7518, 322.2701, 0;
               1012.8093, 272.4526 , 0;
               876.9245, 346.7956, 0;
               772.2914, 249.7153, 0;
               989.1547, 134.2409, 0];
    Xph = [-4.55, 2.08026, 6.42874;
           -3.18008, 2.0701, 4.70662;
           -0.76708, 2.02184, 0.32512;
           -3.13182, 2.08534, 0.26162;
           -4.55, -2.0574, 6.42366;
           -3.1115, -2.05994, 4.70662;  
           -0.68326, -2.0701, 0.2921;
           -3.05308, -2.05486, 0.2921;
           -5.73278, 0.03048, 7.24662;
                 0, -0.03302, 0.30734];
       sz = size(Xph);
      % tz=5;

       %tx=(MeanMX-MeanX);
       %ty=(MeanMY-MeanY);
       s=60;
       rx=0; ry=0; rz=-32;
       tx0 = mean(Xim(:,1)) - mean(Xph(:,1));
       ty0 = mean(Xim(:,2)) - mean(Xph(:,2));
       tz0 = mean(Xph(:,3)) - mean(Xim(:,3));
       
       R0 =  find_rotationamtrix(rx, ry, rz); 
       [Xim_calc]=bbProjector(Xph,tx0,ty0,tz0,R0,s); 
       bscale = 1;
       for i = 1:40
           %[d, Xim, transform] = bbprocrustes(Xim, Xph);
           du = sum(Xim(:,1) - Xim_calc(:,1))/sz(1);
           dv = sum(Xim(:,2) - Xim_calc(:,2))/sz(1);
           tx = tx0 - du * tz0/s;
           ty = ty0 - dv * tz0/s;
           tz = 5;%tz0 *(1+ bscale);
           [R0,bscale] = procrustes_scalerotation(Xim_calc,Xph);
           [Xim_calc]=bbProjector(Xph,tx,ty,tz,R0,s)
           tx0 = tx;
           ty0 = ty;
           tz0 = tz;
       end
           
    
       
    
           
           
           
           
           
           
           
           
           
           
           
           
    