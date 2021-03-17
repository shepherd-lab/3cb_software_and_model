function  ROI9step_calculation(film_small)
    global  bb Info flag_digital roi_xsize roi_ysize
    %angle = 14.72 * 360 / 6.24;
    if flag_digital == true
        if film_small == true
           ph_angle = 17.0;% 15;
        else
           ph_angle = 20.87;  %15; %20.2; 
        end    
  
    else
        if film_small == true
           ph_angle = 17.63;
        else
           ph_angle = 20.87; 
        end   
    end
    step = 0.725;
    
    %step = 0.7;
       %roi_xsize = 1.1;
    %roi_ysize = 1.2;
    d1 = 1.2*tan(ph_angle*pi/180);
    dd = 3*step*tan(ph_angle*pi/180);
    y05 = roi_ysize * 0.5;
    y15 = roi_ysize * 1.5;
    %x10 = roi_xsize = 0.75;
    step_height = 1.2:step:8*step;
    %step_height = 1.2:0.7:6.8;
    
    %low height row
    bb1(1).x = -d1;                     bb1(1).y = y15;   bb1(1).z = 1.2;
    bb1(2).x = -(d1+roi_xsize);         bb1(2).y = y15;   bb1(2).z = 1.2;
    bb1(3).x = -(d1+roi_xsize);         bb1(3).y = y05;   bb1(3).z = 1.2;
    bb1(4).x = -d1;                     bb1(4).y = y05;   bb1(4).z = 1.2;
    
    bb2(1).x = bb1(2).x-dd;             bb2(1).y = y15;  bb2(1).z = 1.2 + 3*step;
    bb2(2).x = bb1(2).x-dd-roi_xsize;   bb2(2).y = y15;  bb2(2).z = 1.2 + 3*step;
    bb2(3).x = bb1(2).x-dd-roi_xsize;   bb2(3).y = y05;  bb2(3).z = 1.2 + 3*step;
    bb2(4).x = bb1(2).x-dd;             bb2(4).y = y05;  bb2(4).z = 1.2 + 3*step;
    
    bb3(1).x = bb2(2).x-dd;             bb3(1).y = y15;     bb3(1).z = 1.2 + 6*step;
    bb3(2).x = bb2(2).x-dd-roi_xsize;   bb3(2).y = y15;     bb3(2).z = 1.2 + 6*step;
    bb3(3).x = bb2(2).x-dd-roi_xsize;   bb3(3).y = y05;     bb3(3).z = 1.2 + 6*step;
    bb3(4).x = bb2(2).x-dd;             bb3(4).y = y05;     bb3(4).z = 1.2 + 6*step;
       
    bb4(1).x = -(d1+ 2*dd/3);              bb4(1).y = y05;     bb4(1).z = 1.2 + 2*step;
    bb4(2).x = -(d1+ 2*dd/3+roi_xsize);    bb4(2).y = y05;     bb4(2).z = 1.2 + 2*step;
    bb4(3).x = -(d1+ 2*dd/3+roi_xsize);    bb4(3).y = -y05;    bb4(3).z = 1.2 + 2*step;
    bb4(4).x = -(d1+ 2*dd/3);              bb4(4).y = -y05;    bb4(4).z = 1.2 + 2*step;
    
    bb5(1).x = bb4(2).x-dd;             bb5(1).y = y05;     bb5(1).z = 1.2 + 5*step;
    bb5(2).x = bb4(2).x-dd-roi_xsize;   bb5(2).y = y05;     bb5(2).z = 1.2 + 5*step;
    bb5(3).x = bb4(2).x-dd-roi_xsize;   bb5(3).y = -y05;    bb5(3).z = 1.2 + 5*step;
    bb5(4).x = bb4(2).x-dd;             bb5(4).y = -y05;    bb5(4).z = 1.2 + 5*step;
    
    bb6(1).x = bb5(2).x-dd;             bb6(1).y = y05;     bb6(1).z = 1.2 + 8*step;
    bb6(2).x = bb5(2).x-dd-roi_xsize;   bb6(2).y = y05;     bb6(2).z = 1.2 + 8*step;
    bb6(3).x = bb5(2).x-dd-roi_xsize;   bb6(3).y = -y05;    bb6(3).z = 1.2 + 8*step;
    bb6(4).x = bb5(2).x-dd;             bb6(4).y = -y05;    bb6(4).z = 1.2 + 8*step;
    
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
    
    bb0(1).x = 0;                  bb0(1).y = (1.5*roi_ysize);           bb0(1).z = 0;
    bb0(2).x = -(3*roi_xsize);     bb0(2).y = (1.5*roi_ysize);           bb0(2).z = 0;
    bb0(3).x = -(3*roi_xsize);     bb0(3).y = -(1.5*roi_ysize);          bb0(3).z = 0;
    bb0(4).x = 0;                  bb0(4).y = -(1.5*roi_ysize);          bb0(4).z = 0;   
    
    bbB(1).x = 0;                    bbB(1).y = (1.5*roi_ysize)+0.4;           bbB(1).z = 0;
    bbB(2).x = -(3*roi_xsize)-1;     bbB(2).y = (1.5*roi_ysize)+0.4;           bbB(2).z = 0;
    bbB(3).x = -(3*roi_xsize)-1;     bbB(3).y = -(1.5*roi_ysize)-0.4;          bbB(3).z = 0;
    bbB(4).x = 0;                    bbB(4).y = -(1.5*roi_ysize)-0.4;          bbB(4).z = 0;   

    
    bb.bb1 = bb1;
    bb.bb2 = bb2;
    bb.bb3 = bb3;
    bb.bb4 = bb4;
    bb.bb5 = bb5;
    bb.bb6 = bb6;
    bb.bb7 = bb7;
    bb.bb8 = bb8;
    bb.bb9 = bb9;
    bb.bb0 = bb0;
    bb.bbB = bbB;
     
    bb.bbpos.x = zeros(2,1);
    bb.bbpos.y = zeros(2,1);
    bb.bbpos.z = zeros(2,1);
   % bbs position for 26 April phantom
    %{
    bb.bbpos1.x = bb3(2).x+(0.5*roi_xsize)+0.32+0.06;    bb.bbpos1.y = 1.5*roi_ysize+0.59;        bb.bbpos1.z = 1.2 + 6*step-0.15;
    bb.bbpos2.x = bb2(2).x+(0.5*roi_xsize)+0.15;    bb.bbpos2.y = 1.5*roi_ysize+0.45+0.15;        bb.bbpos2.z = 1.2 + 3*step-0.15;
    bb.bbpos3.x = bb3(2).x+dd+0.35;                 bb.bbpos3.y = 1.5*roi_ysize+0.55+0.28;        bb.bbpos3.z = 0.865;
    %x???;
    bb.bbpos4.x = bb9(4).x-(0.5*roi_xsize)+0.32-0.06+0.03;    bb.bbpos4.y = -1.5*roi_ysize-0.45-0.14-0.03;       bb.bbpos4.z = 1.2 + 7*step-0.15;
    bb.bbpos5.x = bb8(4).x-(0.5*roi_xsize)+0.15;    bb.bbpos5.y = -1.5*roi_ysize-0.45-0.15;       bb.bbpos5.z = 1.2 + 4*step-0.15;
    bb.bbpos6.x = bb3(2).x+dd+0.35+0.14;                 bb.bbpos6.y = -(1.5*roi_ysize+0.55)-0.28+0.08;     bb.bbpos6.z = 0.865;
    %x???;
    bb.bbpos7.x = bb4(1).x+0.22;                    bb.bbpos7.y = 0;                         bb.bbpos7.z = 1.2 + 2*step - 0.15;
    bb.bbpos8.x = bb1(1).x+0.22;                    bb.bbpos8.y = roi_ysize+0.06;                 bb.bbpos8.z = 1.2 - 0.15;
    bb.bbpos9.x = bb7(1).x+0.22;                    bb.bbpos9.y = -roi_ysize;                bb.bbpos9.z = 1.2 + step-0.15;
   %}
   
    bb.bbpos1.x = bb3(2).x+(0.5*roi_xsize)+0.32+0.06;    bb.bbpos1.y = 1.5*roi_ysize+0.59;        bb.bbpos1.z = 1.2 + 6*step-0.15;
    bb.bbpos2.x = bb2(2).x+(0.5*roi_xsize)+0.15;    bb.bbpos2.y = 1.5*roi_ysize+0.45+0.15;        bb.bbpos2.z = 1.2 + 3*step-0.15;
    bb.bbpos3.x = bb3(2).x+dd+0.35;                 bb.bbpos3.y = 1.5*roi_ysize+0.55+0.28;        bb.bbpos3.z = 0.865;
    %x???;
    bb.bbpos4.x = bb9(4).x-(0.5*roi_xsize)+0.32-0.06+0.03;    bb.bbpos4.y = -1.5*roi_ysize-0.45-0.14-0.03;       bb.bbpos4.z = 1.2 + 7*step-0.15;
    bb.bbpos5.x = bb8(4).x-(0.5*roi_xsize)+0.15;    bb.bbpos5.y = -1.5*roi_ysize-0.45-0.15;       bb.bbpos5.z = 1.2 + 4*step-0.15;
    bb.bbpos6.x = bb3(2).x+dd+0.35+0.14;                 bb.bbpos6.y = -(1.5*roi_ysize+0.55)-0.28+0.08;     bb.bbpos6.z = 0.865;
    %x???;
    bb.bbpos7.x = bb4(1).x+0.22;                    bb.bbpos7.y = 0;                         bb.bbpos7.z = 1.2 + 2*step - 0.15;
    bb.bbpos8.x = bb1(1).x+0.22;                    bb.bbpos8.y = roi_ysize+0.06;                 bb.bbpos8.z = 1.2 - 0.15;
    bb.bbpos9.x = bb7(1).x+0.22;                    bb.bbpos9.y = -roi_ysize;                bb.bbpos9.z = 1.2 + step-0.15;
   
   
   
    bbposition_matrix = [ bb.bbpos1.x,  bb.bbpos1.y, bb.bbpos1.z ;
                          bb.bbpos2.x,  bb.bbpos2.y, bb.bbpos2.z ; 
                          bb.bbpos3.x,  bb.bbpos3.y, bb.bbpos3.z ;
                          bb.bbpos4.x,  bb.bbpos4.y, bb.bbpos4.z ;
                          bb.bbpos5.x,  bb.bbpos5.y, bb.bbpos5.z ;
                          bb.bbpos6.x,  bb.bbpos6.y, bb.bbpos6.z ;
                          bb.bbpos7.x,  bb.bbpos7.y, bb.bbpos7.z ;
                          bb.bbpos8.x,  bb.bbpos8.y, bb.bbpos8.z ;
                          bb.bbpos9.x,  bb.bbpos9.y, bb.bbpos9.z ];
     D = 'C:\Documents and Settings\smalkov\My Documents\Programs\SXAVersion6.2\SXA step phantom\9step_phantom\';
     file_name = [D, 'digitalphantom_position_new.txt'];
    % save(file_name, 'bbposition_matrix_new','-ascii');
 %{
    bb.bbpos1.x = bb3(2).x+(0.5*roi_xsize);    bb.bbpos1.y = 1.5*roi_ysize+0.45;        bb.bbpos1.z = 1 + 6*step;
    bb.bbpos2.x = bb2(2).x+(0.5*roi_xsize);    bb.bbpos2.y = 1.5*roi_ysize+0.45;        bb.bbpos2.z = 1 + 3*step;
    bb.bbpos3.x = bb3(2).x+dd;                 bb.bbpos3.y = 1.5*roi_ysize+0.55;        bb.bbpos3.z = 0.865;
    %x???;
    bb.bbpos4.x = bb9(4).x-(0.5*roi_xsize);    bb.bbpos4.y = -1.5*roi_ysize-0.45;       bb.bbpos4.z = 1 + 7*step;
    bb.bbpos5.x = bb8(4).x-(0.5*roi_xsize);    bb.bbpos5.y = -1.5*roi_ysize-0.45;       bb.bbpos5.z = 1 + 4*step;
    bb.bbpos6.x = bb3(2).x+dd;                 bb.bbpos6.y = -(1.5*roi_ysize+0.55);     bb.bbpos6.z = 0.865;
    %x???;
    bb.bbpos7.x = bb4(1).x;                    bb.bbpos7.y = 0;                         bb.bbpos7.z = 1.2 + 2*step;
    bb.bbpos8.x = 0;                           bb.bbpos8.y = roi_ysize;                 bb.bbpos8.z = 0;
    bb.bbpos9.x = 0;                           bb.bbpos9.y = -roi_ysize;                bb.bbpos9.z = 0;
  %}
    
    
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
   