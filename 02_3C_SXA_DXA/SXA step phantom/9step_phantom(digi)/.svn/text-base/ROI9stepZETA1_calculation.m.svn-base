function  ROI9stepZETA1_calculation()
   % global  bb Info flag_digital roi_xsize roi_ysize xleft middle
    %angle = 14.72 * 360 / 6.24;
    ph_angle = 14.72;%17.0;% 
    roi_xsize = 0.75;
    roi_ysize = 0.75;
    step = 0.9563;
    d1 = 0.96*tan(ph_angle*pi/180);
    dd = 2*step*tan(ph_angle*pi/180);
    dd1 = step*tan(ph_angle*pi/180);
    
    bb1z = 0.96;
    bb2z = 0.96 + step;
    bb3z = 0.96 + 2*step;
    bb4z = 0.96 + 3*step;
    bb5z = 0.96 + 4*step;
    bb6z = 0.96 + 5*step;
    bb7z = 0.96 + 6*step;
    bb8z = 0.96 + 7*step;
       
    bb1(1).x = -d1;                     bb1(1).y = 2*roi_ysize;    bb1(1).z = bb1z ;
    bb1(2).x = -(d1+roi_xsize);         bb1(2).y = 2*roi_ysize;    bb1(2).z = bb1z ;  
    bb1(3).x = -(d1+roi_xsize);         bb1(3).y = roi_ysize;      bb1(3).z = bb1z ; 
    bb1(4).x = -d1;                     bb1(4).y = roi_ysize;      bb1(4).z = bb1z ;      
    
    bb2(1).x = bb1(1).x-dd1;                bb2(1).y = roi_ysize;      bb2(1).z = bb2z;
    bb2(2).x = bb1(2).x-dd1;                bb2(2).y = roi_ysize;      bb2(2).z = bb2z;
    bb2(3).x = bb1(3).x-dd1;                bb2(3).y = 0;              bb2(3).z = bb2z;
    bb2(4).x = bb1(4).x-dd1;                bb2(4).y = 0;              bb2(4).z = bb2z;
    
    bb3(1).x = bb1(2).x-dd;             bb3(1).y = bb1(1).y;       bb3(1).z = bb3z;
    bb3(2).x = bb1(2).x-dd-roi_xsize;   bb3(2).y = bb1(2).y;       bb3(2).z = bb3z;
    bb3(3).x = bb1(2).x-dd-roi_xsize;   bb3(3).y = bb1(3).y;       bb3(3).z = bb3z;
    bb3(4).x = bb1(2).x-dd;             bb3(4).y = bb1(4).y;       bb3(4).z = bb3z;
       
    bb4(1).x = bb2(2).x-dd;             bb4(1).y = bb2(1).y;        bb4(1).z = bb4z;
    bb4(2).x = bb2(2).x-dd-roi_xsize;   bb4(2).y = bb2(2).y;        bb4(2).z = bb4z;
    bb4(3).x = bb2(2).x-dd-roi_xsize;   bb4(3).y = bb2(3).y ;       bb4(3).z = bb4z;
    bb4(4).x = bb2(2).x-dd;             bb4(4).y = bb2(4).y;        bb4(4).z = bb4z ;
    
    bb5(1).x = bb3(2).x-dd;             bb5(1).y = bb3(1).y ;     bb5(1).z = bb5z;
    bb5(2).x = bb3(2).x-dd-roi_xsize;   bb5(2).y = bb3(2).y;      bb5(2).z = bb5z;
    bb5(3).x = bb3(2).x-dd-roi_xsize;   bb5(3).y = bb3(3).y;      bb5(3).z = bb5z;
    bb5(4).x = bb3(2).x-dd;             bb5(4).y = bb3(4).y;      bb5(4).z = bb5z;
    
    bb6(1).x = bb4(2).x-dd;             bb6(1).y = bb4(1).y;      bb6(1).z = bb6z;
    bb6(2).x = bb4(2).x-dd-roi_xsize;   bb6(2).y = bb4(2).y;      bb6(2).z = bb6z;
    bb6(3).x = bb4(2).x-dd-roi_xsize;   bb6(3).y = bb4(3).y;      bb6(3).z = bb6z;
    bb6(4).x = bb4(2).x-dd;             bb6(4).y = bb4(4).y;      bb6(4).z = bb6z;
    
    bb7(1).x = bb5(2).x-dd;             bb7(1).y = bb5(1).y;      bb7(1).z = bb7z; 
    bb7(2).x = bb5(2).x-dd-roi_xsize;   bb7(2).y = bb5(2).y;      bb7(2).z = bb7z;
    bb7(3).x = bb5(2).x-dd-roi_xsize;   bb7(3).y = bb5(3).y;      bb7(3).z = bb7z;
    bb7(4).x = bb5(2).x-dd;             bb7(4).y = bb5(4).y;      bb7(4).z = bb7z;
    
    bb8(1).x = bb6(2).x-dd;             bb8(1).y = bb6(1).y;      bb8(1).z = bb8z;
    bb8(2).x = bb6(2).x-dd-roi_xsize ;  bb8(2).y = bb6(2).y;      bb8(2).z = bb8z;
    bb8(3).x = bb6(2).x-dd-roi_xsize;   bb8(3).y = bb6(3).y;      bb8(3).z = bb8z;
    bb8(4).x = bb6(2).x-dd;             bb8(4).y = bb6(4).y;      bb8(4).z = bb8z;
          
    bb0(1).x = -0.1;                   bb0(1).y = 2*roi_ysize-0.05;    bb0(1).z = 0;
    bb0(2).x = -(4*roi_xsize)+0.2;     bb0(2).y = 2*roi_ysize-0.05;    bb0(2).z = 0;
    bb0(3).x = -(4*roi_xsize)+0.2;     bb0(3).y = 0.05;              bb0(3).z = 0;
    bb0(4).x = -0.1;                   bb0(4).y = 0.05;              bb0(4).z = 0;   
    
    bb.bb1 = bb1;
    bb.bb2 = bb2;
    bb.bb3 = bb3;
    bb.bb4 = bb4;
    bb.bb5 = bb5;
    bb.bb6 = bb6;
    bb.bb7 = bb7;
    bb.bb8 = bb8;
    bb.bb0 = bb0;
    
    %D = 'C:\Documents and Settings\smalkov\My Documents\Programs\SXAVersion6.2\SXA step phantom\';
    file_txt = 'Z1phantomROI.txt';
    file_mat = 'Z1phantomROI.mat';
           rio_matrix = [ bb.bb1.x,  bb.bb1.y, bb.bb1.z ;
                          bb.bb2.x,  bb.bb2.y, bb.bb2.z ; 
                          bb.bb3.x,  bb.bb3.y, bb.bb3.z ;
                          bb.bb4.x,  bb.bb4.y, bb.bb4.z ;
                          bb.bb5.x,  bb.bb5.y, bb.bb5.z ;
                          bb.bb6.x,  bb.bb6.y, bb.bb6.z ;
                          bb.bb7.x,  bb.bb7.y, bb.bb7.z ;
                          bb.bb8.x,  bb.bb8.y, bb.bb8.z ;
                          bb.bb0.x,  bb.bb0.y, bb.bb0.z ];
                   
      %save(file_txt, 'rio_matrix','-ascii');
      save(file_mat, 'bb');
    %{
    figure;
    plot([bb.bb1(1).x, bb.bb1(2).x, bb.bb1(3).x, bb.bb1(4).x,bb.bb1(1).x ],[bb.bb1(1).y, bb.bb1(2).y, bb.bb1(3).y, bb.bb1(4).y,bb.bb1(1).y]); hold on;
    plot([bb.bb2(1).x, bb.bb2(2).x, bb.bb2(3).x, bb.bb2(4).x,bb.bb2(1).x ],[bb.bb2(1).y, bb.bb2(2).y, bb.bb2(3).y, bb.bb2(4).y,bb.bb2(1).y]); hold on;
    plot([bb.bb3(1).x, bb.bb3(2).x, bb.bb3(3).x, bb.bb3(4).x,bb.bb3(1).x ],[bb.bb3(1).y, bb.bb3(2).y, bb.bb3(3).y, bb.bb3(4).y,bb.bb3(1).y]); hold on;
    plot([bb.bb4(1).x, bb.bb4(2).x, bb.bb4(3).x, bb.bb4(4).x,bb.bb4(1).x ],[bb.bb4(1).y, bb.bb4(2).y, bb.bb4(3).y, bb.bb4(4).y,bb.bb4(1).y]); hold on;
    plot([bb.bb5(1).x, bb.bb5(2).x, bb.bb5(3).x, bb.bb5(4).x,bb.bb5(1).x ],[bb.bb5(1).y, bb.bb5(2).y, bb.bb5(3).y, bb.bb5(4).y,bb.bb5(1).y]); hold on;
    plot([bb.bb6(1).x, bb.bb6(2).x, bb.bb6(3).x, bb.bb6(4).x,bb.bb6(1).x ],[bb.bb6(1).y, bb.bb6(2).y, bb.bb6(3).y, bb.bb6(4).y,bb.bb6(1).y]); hold on;
    plot([bb.bb7(1).x, bb.bb7(2).x, bb.bb7(3).x, bb.bb7(4).x,bb.bb7(1).x ],[bb.bb7(1).y, bb.bb7(2).y, bb.bb7(3).y, bb.bb7(4).y,bb.bb7(1).y]); hold on;
    plot([bb.bb8(1).x, bb.bb8(2).x, bb.bb8(3).x, bb.bb8(4).x,bb.bb8(1).x ],[bb.bb8(1).y, bb.bb8(2).y, bb.bb8(3).y, bb.bb8(4).y,bb.bb8(1).y]); hold on;
    plot([bb.bb0(1).x, bb.bb0(2).x, bb.bb0(3).x, bb.bb0(4).x,bb.bb0(1).x ],[bb.bb0(1).y, bb.bb0(2).y, bb.bb0(3).y, bb.bb0(4).y,bb.bb0(1).y],'r');
    %}
    