function [x0,feval, Xim_calc] = bbs_fitting(Xph,Xim,s)
           sz = size(Xph);
           len = sz(1);
           rx0=0; ry0=0; rz0=28;
           tx0 = mean(Xim(:,1)) - mean(Xph(:,1));
           ty0 = mean(Xim(:,2)) - mean(Xph(:,2));
           tz0 = mean(Xph(:,3)) - mean(Xim(:,3));
           R0 =  rotation_matrix(rx0, ry0, rz0); 

           [Xim_calc]=bbProjector(Xph,tx0,ty0,tz0,R0,s); 
           x0 = [rx0, ry0, rz0, tz0, tx0, ty0];
           for i = 1:10  
               [y,feval] = findL0all(x0, Xim, Xph,s);  
               rx0 = y(1);
               ry0 = y(2);
               rz0 = y(3);
               tz0 = y(4);
               tx0 = y(5);
               ty0 = y(6);
               R0 =  rotation_matrix(rx0, ry0, rz0); 
               [Xim_calc]=bbProjector(Xph,tx0,ty0,tz0,R0,s); 
               du = sum(Xim(:,1) - Xim_calc(:,1))/sz(1);
               dv = sum(Xim(:,2) - Xim_calc(:,2))/sz(1);
               tx0 = tx0 - du * tz0/s;
               ty0 = ty0 - dv * tz0/s;
               x0 = [rx0, ry0, rz0, tz0,tx0, ty0];
           end