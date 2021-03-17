function bb3D_reconstruction()
    %filename='P:\Vidar Images\test\StepCalibrate4cm5050Do not know-1.tif'; 
    global xf1 yf1 BBSPLOT Mammo pixelCm %Xph
   % Mammo=imread(filename);
    clear Phantom xf yf
    pixelCm=150/2.54;
    
    %figure;imagesc(Mammo);colormap(gray);
    %{
    Phantom(1).mx=734.6511;Phantom(1).my=101.0292;
    Phantom(2).mx=807.687;Phantom(2).my=66.2847;
    Phantom(3).mx=882.6223;Phantom(3).my=37.6715;
    Phantom(4).mx=747.4281;Phantom(4).my=110.4818;
    Phantom(5).mx=879.3417;Phantom(5).my=367.2336;
    Phantom(6).mx=948.7518;Phantom(6).my=322.2701;
    Phantom(7).mx=1012.8093;Phantom(7).my=272.4526;
    Phantom(8).mx=876.9245;Phantom(8).my=346.7956;
    Phantom(9).mx=772.2914;Phantom(10).my=249.7153;
    Phantom(10).mx=989.1547;Phantom(9).my=134.2409;
    
    Phantom(1).x=-4.55;Phantom(1).y=2.08026;Phantom(1).z=6.42874;
    Phantom(2).x=-3.18008;Phantom(2).y=2.0701;Phantom(2).z=4.70662;
    Phantom(3).x=-0.76708;Phantom(3).y=2.02184;Phantom(3).z=0.32512;
    Phantom(4).x=-3.13182;Phantom(4).y=2.08534;Phantom(4).z=0.26162;
    Phantom(5).x=-4.55;Phantom(5).y=-2.0574;Phantom(5).z=6.42366;
    Phantom(6).x=-3.1115;Phantom(6).y=-2.05994;Phantom(6).z=4.70662;
    Phantom(7).x=-0.68326;Phantom(7).y=-2.0701;Phantom(7).z=0.2921;
    Phantom(8).x=-3.05308;Phantom(8).y=-2.05486;Phantom(8).z=0.2921;
    Phantom(9).x=-5.73278;Phantom(9).y=0.03048;Phantom(9).z=7.24662;
    Phantom(10).x=0;Phantom(10).y=-0.03302;Phantom(10).z=0.30734;
    %}
    
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
      for i = 1:40 
       R0 =  rotation_matrix(rx, ry, rz); 
       [Xim_calc]=bbProjector(Xph,tx0,ty0,tz0,R0,s); 
       %[d, Xim, transform] = bbprocrustes(Xim, Xph);
           du = sum(Xim(:,1) - Xim_calc(:,1))/sz(1);
           dv = sum(Xim(:,2) - Xim_calc(:,2))/sz(1);
          % tx = tx0 - du * tz0/s;
          % ty = ty0 - dv * tz0/s;
           Q = Xim(:,1:2) - Xim_calc(:,1:2);
           L0 = trace(Q*Q');
         step_size = 10;
        
          Sign1 = 1;
          rz1 = rz + step_size*Sign;
           R1 =  rotation_matrix(rx, ry, rz1); 
          [Xim_calc]=bbProjector(Xph,tx0,ty0,tz0,R1,s); 
       %[d, Xim, transform] = bbprocrustes(Xim, Xph);
           du1 = sum(Xim(:,1) - Xim_calc(:,1))/sz(1);
           dv1 = sum(Xim(:,2) - Xim_calc(:,2))/sz(1);
           tx1 = tx0 - du * tz0/s;
           ty1 = ty0 - dv * tz0/s;
           Q1 = Xim(:,1:2) - Xim_calc(:,1:2);
           L1 = trace(Q1*Q1');
          
           Sign2 = -1;
           rz2 = rz + step_size*Sign;
           R2 =  rotation_matrix(rx, ry, rz2); 
          [Xim_calc]=bbProjector(Xph,tx0,ty0,tz0,R2,s); 
       %[d, Xim, transform] = bbprocrustes(Xim, Xph);
           du2 = sum(Xim(:,1) - Xim_calc(:,1))/sz(1);
           dv2 = sum(Xim(:,2) - Xim_calc(:,2))/sz(1);
           tx2 = tx0 - du * tz0/s;
           ty2 = ty0 - dv * tz0/s;
           Q2 = Xim(:,1:2) - Xim_calc(:,1:2);
           L1 = trace(Q2*Q2');
           
           if L1 < L2
               Sign = Sign1;
               Q = Q2;
           else
               Sign = Sign2;
           end
           
           step
           
           
           
        [xf1,yf1]=projectionsimulation(Phantom,tx+StepSize,ty,tz,rx,ry,rz,s);
        merit1=merit(Phantom,pixelCm*xf1,size(Mammo,1)/2 + ya -pixelCm*yf1);
        if merit1>merit0
            Sign=-1;
            [xf1,yf1]=projectionsimulation(Phantom,tx+Sign*StepSize,ty,tz,rx,ry,rz,s);
            merit1=merit(Phantom,pixelCm*xf1,size(Mammo,1)/2 + ya-pixelCm*yf1);
        else
            Sign=1;
        end

        while merit1<merit0
            tx=tx+Sign*StepSize;
            merit0=merit1;
            [xf1,yf1]=projectionsimulation(Phantom,tx+Sign*StepSize,ty,tz,rx,ry,rz,s);
            merit1=merit(Phantom,pixelCm*xf1,size(Mammo,1)/2 + ya-pixelCm*yf1);
    %         pause(StepSize);
        end 
         
           
           
           
           
           
                   
               [R0,bscale] = procrustes_scalerotation(Xim_calc,Xph);
               [Xim_calc]=bbProjector(Xph,tx,ty,tz,R0,s)
               tx0 = tx;
               ty0 = ty;
               tz0 = tz;
       end
           
    
       
    
           
           
           
           
           
           
           
           
           
           
           
           
    