function  ROI9step_calculation()
    global  bb
    %angle = 14.72 * 360 / 6.24;
    angle = 15;
    roi_xsize = 0.81;
    roi_ysize = 0.81;
    d1 = 1.2*tan(angle*pi/180);
    dd = 3*0.725*tan(angle*pi/180);
    y05 = roi_ysize * 0.5;
    y15 = roi_ysize * 1.5;
    %x10 = roi_xsize = 0.75;
    step = 0.725;
    step_height = 1.2:0.725:7;
    
    %low height row
    bb1(1).x = -d1;                     bb1(1).y = y15;   bb1(1).z = 1.2;
    bb1(2).x = -(d1+roi_xsize);         bb1(2).y = y15;   bb1(2).z = 1.2;
    bb1(3).x = -(d1+roi_xsize);         bb1(3).y = y05;   bb1(3).z = 1.2;
    bb1(4).x = -d1;                     bb1(4).y = y05;   bb1(4).z = 1.2;
    
    bb2(1).x = bb1(2).x-dd;             bb2(1).y = y15;  bb2(1).z = 1.2 + 3*step;
    bb2(2).x = bb1(2).x-dd-roi_xsize;   bb2(2).y = y15;  bb2(2).z = 1.2 + 3*step;
    bb2(3).x = bb1(2).x-dd-roi_xsize;   bb2(3).y = y05;  bb2(3).z = 1.2 + 3*step;
    bb2(4).x = bb1(2).x-dd;             bb2(4).y = y05;  bb2(4).z = 1.2 + 3*step;
    
    bb3(1).x = bb2(2).x-dd;             bb3(1).y = y15; bb3(1).z = 1.2 + 6*step;
    bb3(2).x = bb2(2).x-dd-roi_xsize;   bb3(2).y = y15; bb3(2).z = 1.2 + 6*step;
    bb3(3).x = bb2(2).x-dd-roi_xsize;   bb3(3).y = y05; bb3(3).z = 1.2 + 6*step;
    bb3(4).x = bb2(2).x-dd;             bb3(4).y = y05; bb3(4).z = 1.2 + 6*step;
       
    bb4(1).x = -(d1+ 2*dd/3);              bb4(1).y = y05;     bb4(1).z = 1.2 + 2*step;
    bb4(2).x = -(d1+ 2*dd/3+roi_xsize);    bb4(2).y = y05;     bb4(2).z = 1.2 + 2*step;
    bb4(3).x = -(d1+ 2*dd/3+roi_xsize);    bb4(3).y = -y05;    bb4(3).z = 1.2 + 2*step;
    bb4(4).x = -(d1+ 2*dd/3);              bb4(4).y = -y05;    bb4(4).z = 1.2 + 2*step;
    
    bb5(1).x = bb4(2).x-dd;             bb5(1).y = y05;  bb5(1).z = 1.2 + 5*step;
    bb5(2).x = bb4(2).x-dd-roi_xsize;   bb5(2).y = y05;  bb5(2).z = 1.2 + 5*step;
    bb5(3).x = bb4(2).x-dd-roi_xsize;   bb5(3).y = -y05; bb5(3).z = 1.2 + 5*step;
    bb5(4).x = bb4(2).x-dd;             bb5(4).y = -y05; bb5(4).z = 1.2 + 5*step;
    
    bb6(1).x = bb5(2).x-dd;             bb6(1).y = y05;  bb6(1).z = 1.2 + 8*step;
    bb6(2).x = bb5(2).x-dd-roi_xsize;   bb6(2).y = y05;  bb6(2).z = 1.2 + 8*step;
    bb6(3).x = bb5(2).x-dd-roi_xsize;   bb6(3).y = -y05; bb6(3).z = 1.2 + 8*step;
    bb6(4).x = bb5(2).x-dd;             bb6(4).y = -y05; bb6(4).z = 1.2 + 8*step;
    
    bb7(1).x = -(d1+ dd/3);              bb7(1).y = -y05;     bb7(1).z = 1.2 + step;
    bb7(2).x = -(d1+ dd/3+roi_xsize);    bb7(2).y = -y05;     bb7(2).z = 1.2 + step;
    bb7(3).x = -(d1+ dd/3+roi_xsize);    bb7(3).y = -y15;     bb7(3).z = 1.2 + step;
    bb7(4).x = -(d1+ dd/3);              bb7(4).y = -y15;     bb7(4).z = 1.2 + step;
    
    bb8(1).x = bb7(2).x-dd;             bb8(1).y = -y05;  bb8(1).z = 1.2 + 4*step;
    bb8(2).x = bb7(2).x-dd-roi_xsize;   bb8(2).y = -y05;  bb8(2).z = 1.2 + 4*step;
    bb8(3).x = bb7(2).x-dd-roi_xsize;   bb8(3).y = -y15;  bb8(3).z = 1.2 + 4*step;
    bb8(4).x = bb7(2).x-dd;             bb8(4).y = -y15;  bb8(4).z = 1.2 + 4*step;
    
    bb9(1).x = bb8(2).x-dd;             bb9(1).y = -y05;     bb9(1).z = 1.2 + 7*step;
    bb9(2).x = bb8(2).x-dd-roi_xsize;   bb9(2).y = -y05;     bb9(2).z = 1.2 + 7*step;
    bb9(3).x = bb8(2).x-dd-roi_xsize;   bb9(3).y = -y15;     bb9(3).z = 1.2 + 7*step;
    bb9(4).x = bb8(2).x-dd;             bb9(4).y = -y15;     bb9(4).z = 1.2 + 7*step;
    bb.bb1 = bb1;
    bb.bb2 = bb2;
    bb.bb3 = bb3;
    bb.bb4 = bb4;
    bb.bb5 = bb5;
    bb.bb6 = bb6;
    bb.bb7 = bb7;
    bb.bb8 = bb8;
    bb.bb9 = bb9;
     
    bb.bbpos.x = zeros(2,1);
    bb.bbpos.y = zeros(2,1);
    bb.bbpos.z = zeros(2,1);
    bb.bbpos1.x = -3.35;    bb.bbpos1.y = 1.5;   bb.bbpos1.z = 1 + 6*step;
    bb.bbpos2.x = -2.35;    bb.bbpos2.y = 1.5;   bb.bbpos2.z = 1 + 3*step;
    bb.bbpos.x(1) = -3.35;    bb.bbpos.y(1) = 1.5;   bb.bbpos.z(1) = 1 + 6*step;
    bb.bbpos.x(2) = -2.35;    bb.bbpos.y(2) = 1.5;   bb.bbpos.z(2) = 1 + 3*step;
    %figure;
    %plot([xf_a,xf_a(1)],maxy/2-[yf_a,yf_a(1)])
    %{
    plot([bb.bb1(1).x, bb.bb1(2).x, bb.bb1(3).x, bb.bb1(4).x,bb.bb1(1).x ],[bb.bb1(1).y, bb.bb1(2).y, bb.bb1(3).y, bb.bb1(4).y,bb.bb1(1).y]); hold on;
    plot([bb.bb2(1).x, bb.bb2(2).x, bb.bb2(3).x, bb.bb2(4).x,bb.bb2(1).x ],[bb.bb2(1).y, bb.bb2(2).y, bb.bb2(3).y, bb.bb2(4).y,bb.bb2(1).y]); hold on;
    plot([bb.bb3(1).x, bb.bb3(2).x, bb.bb3(3).x, bb.bb3(4).x,bb.bb3(1).x ],[bb.bb3(1).y, bb.bb3(2).y, bb.bb3(3).y, bb.bb3(4).y,bb.bb3(1).y]); hold on;
    plot([bb.bb4(1).x, bb.bb4(2).x, bb.bb4(3).x, bb.bb4(4).x,bb.bb4(1).x ],[bb.bb4(1).y, bb.bb4(2).y, bb.bb4(3).y, bb.bb4(4).y,bb.bb4(1).y]); hold on;
    plot([bb.bb5(1).x, bb.bb5(2).x, bb.bb5(3).x, bb.bb5(4).x,bb.bb5(1).x ],[bb.bb5(1).y, bb.bb5(2).y, bb.bb5(3).y, bb.bb5(4).y,bb.bb5(1).y]); hold on;
    plot([bb.bb6(1).x, bb.bb6(2).x, bb.bb6(3).x, bb.bb6(4).x,bb.bb6(1).x ],[bb.bb6(1).y, bb.bb6(2).y, bb.bb6(3).y, bb.bb6(4).y,bb.bb6(1).y]); hold on;
    plot([bb.bb7(1).x, bb.bb7(2).x, bb.bb7(3).x, bb.bb7(4).x,bb.bb7(1).x ],[bb.bb7(1).y, bb.bb7(2).y, bb.bb7(3).y, bb.bb7(4).y,bb.bb7(1).y]); hold on;
    plot([bb.bb8(1).x, bb.bb8(2).x, bb.bb8(3).x, bb.bb8(4).x,bb.bb8(1).x ],[bb.bb8(1).y, bb.bb8(2).y, bb.bb8(3).y, bb.bb8(4).y,bb.bb8(1).y]); hold on;
    plot([bb.bb9(1).x, bb.bb9(2).x, bb.bb9(3).x, bb.bb9(4).x,bb.bb9(1).x ],[bb.bb9(1).y, bb.bb9(2).y, bb.bb9(3).y, bb.bb9(4).y,bb.bb9(1).y]);
   %}
   a = 2;
   