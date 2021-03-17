   
    [xf_1,yf_1]=projectionsimulation(bb.bb1,tx,ty,tz,rx,ry,rz,s);
    [xf_2,yf_2]=projectionsimulation(bb.bb2,tx,ty,tz,rx,ry,rz,s);
    [xf_3,yf_3]=projectionsimulation(bb.bb3,tx,ty,tz,rx,ry,rz,s);
    [xf_4,yf_4]=projectionsimulation(bb.bb4,tx,ty,tz,rx,ry,rz,s);
    [xf_5,yf_5]=projectionsimulation(bb.bb5,tx,ty,tz,rx,ry,rz,s);
    [xf_6,yf_6]=projectionsimulation(bb.bb6,tx,ty,tz,rx,ry,rz,s);
    [xf_7,yf_7]=projectionsimulation(bb.bb7,tx,ty,tz,rx,ry,rz,s);
    [xf_8,yf_8]=projectionsimulation(bb.bb8,tx,ty,tz,rx,ry,rz,s);
    [xf_9,yf_9]=projectionsimulation(bb.bb9,tx,ty,tz,rx,ry,rz,s);

    [xp_1,yp_1]=projectionsimulation(bb.bbpos1,tx,ty,tz,rx,ry,rz,s);
    [xp_2,yp_2]=projectionsimulation(bb.bbpos2,tx,ty,tz,rx,ry,rz,s);

    [xp,yp]=Projector2(bb.bbpos.x,bb.bbpos.y,bb.bbpos.z,tx,ty,tz,rx,ry,rz,s);

    hold on;
    figure(figuretodraw);


    plot([xf_1,xf_1(1)]/k,y0source_pixels-[yf_1,yf_1(1)]/k, 'r')
    hold on;
    plot([xf_2,xf_2(1)]/k,y0source_pixels-[yf_2,yf_2(1)]/k, 'b')
    hold on;
    plot([xf_3,xf_3(1)]/k,y0source_pixels-[yf_3,yf_3(1)]/k,'m')
    hold on;
    plot([xf_4,xf_4(1)]/k,y0source_pixels-[yf_4,yf_4(1)]/k,'b' )
    hold on;
    plot([xf_5,xf_5(1)]/k,y0source_pixels-[yf_5,yf_5(1)]/k,'r') 
    hold on;
    plot([xf_6,xf_6(1)]/k,y0source_pixels-[yf_6,yf_6(1)]/k,'b')
    hold on;
    plot([xf_7,xf_7(1)]/k,y0source_pixels-[yf_7,yf_7(1)]/k,'g')
    hold on;
    plot([xf_8,xf_8(1)]/k,y0source_pixels-[yf_8,yf_8(1)]/k,'b')
    hold on;
    plot([xf_9,xf_9(1)]/k,y0source_pixels-[yf_9,yf_9(1)]/k,'m') 
    hold on;
    plot(xp/k, y0source_pixels - yp/k,'*r');
    set(ctrl.text_zone,'String',['Paddle  position:', num2str(diag_paddle6cm), ' cm']);
    %plot([xf_i,xf_i(1),xf_i(2),xf_i(5)]*pixelCm,size(Mammo,1)/2-[yf_i,yf_i(1),yf_i(2),yf_i(5)]*pixelCm)
    figure;
    plot([xf_1,xf_1(1)]/k,[yf_1,yf_1(1)]/k, 'r')
    hold on;
    plot([xf_2,xf_2(1)]/k,[yf_2,yf_2(1)]/k, 'b')
    hold on;
    plot([xf_3,xf_3(1)]/k,[yf_3,yf_3(1)]/k,'m')
    hold on;
    plot([xf_4,xf_4(1)]/k,[yf_4,yf_4(1)]/k, 'b')
    hold on;
    plot([xf_5,xf_5(1)]/k,[yf_5,yf_5(1)]/k, 'r')
    hold on;
    plot([xf_6,xf_6(1)]/k,[yf_6,yf_6(1)]/k,'b')
    hold on;
    plot([xf_7,xf_7(1)]/k,[yf_7,yf_7(1)]/k,'g')
    hold on;
    plot([xf_8,xf_8(1)]/k,[yf_8,yf_8(1)]/k,'b')
    hold on;
    plot([xf_9,xf_9(1)]/k,[yf_9,yf_9(1)]/k,'m')
    hold on;
    plot(xp/k,  yp/k,'*r'); 