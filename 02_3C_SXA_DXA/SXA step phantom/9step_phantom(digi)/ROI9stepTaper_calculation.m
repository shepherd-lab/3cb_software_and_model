function  ROI9stepTaper_calculation(film_small)
    global  bb Info flag_digital roi_xsize roi_ysize
    %angle = 14.72 * 360 / 6.24;
    %{
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
    %}
    angle_back = 90 - 70.51; %74.56
    ph_angle = 90 - 69; %73
    angle_front = 90 - 65.26; %69.06
    step = 0.7;
    diff = 6.8 * (tan(angle_back*pi/180) - tan(ph_angle*pi/180));
    roi1_xsize = 1.0 / cos(ph_angle*pi/180) + diff;
    d1 = (1.2 + 7*step) * tan(angle_back*pi/180);
    d2 = (1.2 + 8*step) * tan(angle_back*pi/180);
    d3 = (1.2 + 6*step) * tan(angle_back*pi/180);
    roi2_xsize = 0.9 / cos(ph_angle*pi/180);
    diff2 = 2.6 * (tan(angle_front*pi/180) - tan(ph_angle*pi/180));
    roi3_xsize = 0.991 / cos(ph_angle*pi/180) - diff2;
    
    roi9_ysize = 1.2;
    roi8_ysize = 1.3;
    roi1_ysize = 1; 
    roi2_ysize = 0.8;
    roi3_ysize =0.8;
    %step = 0.7;
       %roi_xsize = 1.1;
    %roi_ysize = 1.2;
    y9_angle = 90 - 87.18;
    y8_angle = 90 - 86.21;
    y7_angle = 90 - 85.23;
    y3_angle = 90 - 86.92;
    y2_angle = 90 - 85.69;
    y1_angle = 90 - 84.56;
    
    d9y = (1.2 + 7*step) * tan(y9_angle*pi/180);
    d8y = (1.2 + 4*step) * tan(y8_angle*pi/180);
    d7y = (1.2 + step) * tan(y7_angle*pi/180);
    d3y = (1.2 + 6*step) * tan(y3_angle*pi/180);
    d2y = (1.2 + 3*step) * tan(y2_angle*pi/180);
    d1y = 1.2 * tan(y1_angle*pi/180);
    
    dd = 3*step*tan(ph_angle*pi/180);
    step_height = 1.2:step:8*step;
    
   % d1 = 1.2*tan(ph_angle*pi/180);
    
    %y05 = roi_ysize * 0.5;
    %y15 = roi_ysize * 1.5;
    %x10 = roi_xsize = 0.75;
   
    %step_height = 1.2:0.7:6.8;
    
    %low height row
    bb9(1).x = -d1;                          bb9(1).y = roi9_ysize;    bb9(1).z = 1.2 + 7*step;
    bb9(2).x = -d1 + roi1_xsize;             bb9(2).y = roi9_ysize;    bb9(2).z = 1.2 + 7*step;
    bb9(3).x = -d1 + roi1_xsize;             bb9(3).y = d9y;                 bb9(3).z = 1.2 + 7*step;
    bb9(4).x = -d1;                          bb9(4).y = d9y;                 bb9(4).z = 1.2 + 7*step;
    
    bb8(1).x = bb9(2).x + dd;                 bb8(1).y = roi8_ysize;   bb8(1).z = 1.2 + 4*step;
    bb8(2).x = bb9(2).x + dd + roi2_xsize ;   bb8(2).y = roi8_ysize;   bb8(2).z = 1.2 + 4*step;
    bb8(3).x = bb9(2).x + dd + roi2_xsize ;   bb8(3).y = d8y;                bb8(3).z = 1.2 + 4*step;
    bb8(4).x = bb9(2).x + dd;;                bb8(4).y = d8y;                bb8(4).z = 1.2 + 4*step;
    
    bb7(1).x = bb8(2).x + dd;                 bb7(1).y = roi8_ysize;   bb7(1).z = 1.2 + step;
    bb7(2).x = bb8(2).x + dd + roi3_xsize;    bb7(2).y = roi8_ysize;   bb7(2).z = 1.2 + step;
    bb7(3).x = bb8(2).x + dd + roi3_xsize;    bb7(3).y = d7y;                bb7(3).z = 1.2 + step;
    bb7(4).x = bb8(2).x + dd;                 bb7(4).y = d7y;                bb7(4).z = 1.2 + step;
    
    bb6(1).x = -d2;                           bb6(1).y = bb9(1).y+roi1_ysize;     bb6(1).z = 1.2 + 8*step;
    bb6(2).x = -d2 + roi1_xsize;              bb6(2).y = bb9(1).y+roi1_ysize;     bb6(2).z = 1.2 + 8*step;
    bb6(3).x = -d2 + roi1_xsize;              bb6(3).y = bb9(1).y;                bb6(3).z = 1.2 + 8*step;
    bb6(4).x = -d2;                           bb6(4).y = bb9(1).y;                bb6(4).z = 1.2 + 8*step;
    
    bb5(1).x = bb6(2).x + dd;                bb5(1).y = bb8(1).y+roi2_ysize;      bb5(1).z = 1.2 + 5*step;
    bb5(2).x = bb6(2).x + dd + roi2_xsize;   bb5(2).y = bb8(1).y+roi2_ysize;      bb5(2).z = 1.2 + 5*step;
    bb5(3).x = bb6(2).x + dd + roi2_xsize;   bb5(3).y = bb8(1).y;                 bb5(3).z = 1.2 + 5*step;
    bb5(4).x = bb6(2).x + dd;                bb5(4).y = bb8(1).y;                 bb5(4).z = 1.2 + 5*step;
    
    bb4(1).x = bb5(2).x  + dd;                   bb4(1).y =  bb7(1).y+roi2_ysize;    bb4(1).z = 1.2 + 2*step;
    bb4(2).x = bb5(2).x + dd + roi3_xsize;    bb4(2).y = bb7(1).y+roi2_ysize;        bb4(2).z = 1.2 + 2*step;
    bb4(3).x = bb5(2).x + dd + roi3_xsize;    bb4(3).y = bb7(1).y;                   bb4(3).z = 1.2 + 2*step;
    bb4(4).x = bb5(2).x + dd;                   bb4(4).y = bb7(1).y;                 bb4(4).z = 1.2 + 2*step;
    
    bb3(1).x = -d3;                           bb3(1).y = bb6(1).y + roi9_ysize - d3y;     bb3(1).z = 1.2 + 6*step;
    bb3(2).x = -d3 + roi1_xsize;              bb3(2).y = bb6(1).y + roi9_ysize - d3y;     bb3(2).z = 1.2 + 6*step;
    bb3(3).x = -d3 + roi1_xsize;              bb3(3).y = bb6(1).y;                        bb3(3).z = 1.2 + 6*step;
    bb3(4).x = -d3;                           bb3(4).y = bb6(1).y;                        bb3(4).z = 1.2 + 6*step;
        
    bb2(1).x = bb3(2).x + dd;                bb2(1).y = bb5(1).y + roi8_ysize - d2y;      bb2(1).z = 1.2 + 3*step;
    bb2(2).x = bb3(2).x + dd + roi2_xsize;   bb2(2).y = bb5(1).y + roi8_ysize - d2y;      bb2(2).z = 1.2 + 3*step;
    bb2(3).x = bb3(2).x + dd + roi2_xsize;   bb2(3).y = bb5(1).y;                  bb2(3).z = 1.2 + 3*step;
    bb2(4).x = bb3(2).x + dd;                bb2(4).y = bb5(1).y;                  bb2(4).z = 1.2 + 3*step;
    
    bb1(1).x = bb2(2).x + dd;                bb1(1).y = bb4(1).y+ roi8_ysize - d1y;       bb1(1).z = 1.2;
    bb1(2).x = bb2(2).x + dd + roi3_xsize;   bb1(2).y = bb4(1).y+ roi8_ysize - d1y;       bb1(2).z = 1.2;
    bb1(3).x = bb2(2).x + dd + roi3_xsize;   bb1(3).y = bb4(1).y;                         bb1(3).z = 1.2;
    bb1(4).x = bb2(2).x + dd;                bb1(4).y = bb4(1).y;                         bb1(4).z = 1.2;
         
    bb0(1).x = 0;                  bb0(1).y = 3.37;           bb0(1).z = 0;
    bb0(2).x = 3.03;               bb0(2).y = 3.37;           bb0(2).z = 0;
    bb0(3).x = 3.03;               bb0(3).y = 0;              bb0(3).z = 0;
    bb0(4).x = 0;                  bb0(4).y = 0;              bb0(4).z = 0;   
   
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
    %bb.bbB = bbB;
     
   % file_txt = 'Z4phantomROI.txt';
    file_mat = 'Z4phantomROI_big.mat';
           rio_matrix = [ bb.bb1.x,  bb.bb1.y, bb.bb1.z ;
                          bb.bb2.x,  bb.bb2.y, bb.bb2.z ; 
                          bb.bb3.x,  bb.bb3.y, bb.bb3.z ;
                          bb.bb4.x,  bb.bb4.y, bb.bb4.z ;
                          bb.bb5.x,  bb.bb5.y, bb.bb5.z ;
                          bb.bb6.x,  bb.bb6.y, bb.bb6.z ;
                          bb.bb7.x,  bb.bb7.y, bb.bb7.z ;
                          bb.bb8.x,  bb.bb8.y, bb.bb8.z ;
                          bb.bb9.x,  bb.bb9.y, bb.bb9.z ;
                          bb.bb0.x,  bb.bb0.y, bb.bb0.z ];
                   
      %save(file_txt, 'rio_matrix','-ascii');
      save(file_mat, 'bb');
    
    
   % bb.bbpos.x = zeros(2,1);
   % bb.bbpos.y = zeros(2,1);
   % bb.bbpos.z = zeros(2,1);
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
   
   
   
    bbposition_matrix = [ bb.bbpos1.x,  bb.bbpos1.y, bb.bbpos1.z ;
                          bb.bbpos2.x,  bb.bbpos2.y, bb.bbpos2.z ; 
                          bb.bbpos3.x,  bb.bbpos3.y, bb.bbpos3.z ;
                          bb.bbpos4.x,  bb.bbpos4.y, bb.bbpos4.z ;
                          bb.bbpos5.x,  bb.bbpos5.y, bb.bbpos5.z ;
                          bb.bbpos6.x,  bb.bbpos6.y, bb.bbpos6.z ;
                          bb.bbpos7.x,  bb.bbpos7.y, bb.bbpos7.z ;
                          bb.bbpos8.x,  bb.bbpos8.y, bb.bbpos8.z ;
                          bb.bbpos9.x,  bb.bbpos9.y, bb.bbpos9.z ];
      %}                
    % D = 'C:\Documents and Settings\smalkov\My Documents\Programs\SXAVersion6.2\SXA step phantom\9step_phantom\';
    % file_name = [D, 'digitalphantom_position_new.txt'];
     
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
    
    bbs_coord = load('C:\Documents and Settings\smalkov\My Documents\Programs\SXAVersion6.3_Oct13\SXA step phantom\Z4phantomXph_small.txt');
    figure;
    %plot([xf_a,xf_a(1)],maxy/2-[yf_a,yf_a(1)])
    %
    plot([bb.bb1(1).x, bb.bb1(2).x, bb.bb1(3).x, bb.bb1(4).x,bb.bb1(1).x ],[bb.bb1(1).y, bb.bb1(2).y, bb.bb1(3).y, bb.bb1(4).y,bb.bb1(1).y]); hold on;
    plot([bb.bb2(1).x, bb.bb2(2).x, bb.bb2(3).x, bb.bb2(4).x,bb.bb2(1).x ],[bb.bb2(1).y, bb.bb2(2).y, bb.bb2(3).y, bb.bb2(4).y,bb.bb2(1).y]); hold on;
    plot([bb.bb3(1).x, bb.bb3(2).x, bb.bb3(3).x, bb.bb3(4).x,bb.bb3(1).x ],[bb.bb3(1).y, bb.bb3(2).y, bb.bb3(3).y, bb.bb3(4).y,bb.bb3(1).y]); hold on;
    plot([bb.bb4(1).x, bb.bb4(2).x, bb.bb4(3).x, bb.bb4(4).x,bb.bb4(1).x ],[bb.bb4(1).y, bb.bb4(2).y, bb.bb4(3).y, bb.bb4(4).y,bb.bb4(1).y]); hold on;
    plot([bb.bb5(1).x, bb.bb5(2).x, bb.bb5(3).x, bb.bb5(4).x,bb.bb5(1).x ],[bb.bb5(1).y, bb.bb5(2).y, bb.bb5(3).y, bb.bb5(4).y,bb.bb5(1).y]); hold on;
    plot([bb.bb6(1).x, bb.bb6(2).x, bb.bb6(3).x, bb.bb6(4).x,bb.bb6(1).x ],[bb.bb6(1).y, bb.bb6(2).y, bb.bb6(3).y, bb.bb6(4).y,bb.bb6(1).y]); hold on;
    plot([bb.bb7(1).x, bb.bb7(2).x, bb.bb7(3).x, bb.bb7(4).x,bb.bb7(1).x ],[bb.bb7(1).y, bb.bb7(2).y, bb.bb7(3).y, bb.bb7(4).y,bb.bb7(1).y]); hold on;
    plot([bb.bb8(1).x, bb.bb8(2).x, bb.bb8(3).x, bb.bb8(4).x,bb.bb8(1).x ],[bb.bb8(1).y, bb.bb8(2).y, bb.bb8(3).y, bb.bb8(4).y,bb.bb8(1).y]); hold on;
    plot([bb.bb9(1).x, bb.bb9(2).x, bb.bb9(3).x, bb.bb9(4).x,bb.bb9(1).x ],[bb.bb9(1).y, bb.bb9(2).y, bb.bb9(3).y, bb.bb9(4).y,bb.bb9(1).y]); hold on;
    plot([bb.bb0(1).x, bb.bb0(2).x, bb.bb0(3).x, bb.bb0(4).x,bb.bb0(1).x ],[bb.bb0(1).y, bb.bb0(2).y, bb.bb0(3).y, bb.bb0(4).y,bb.bb0(1).y],'-r' ); hold on;
    %}
    plot(bbs_coord(:,1),bbs_coord(:,2) ,'*r');
   
   a = 2;
   