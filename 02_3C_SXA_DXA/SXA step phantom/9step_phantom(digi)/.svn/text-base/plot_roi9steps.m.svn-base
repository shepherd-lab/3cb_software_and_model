function plot_roi9steps(rx, ry, rz, tx, ty, tz,x0_shift, y0_shift)
% Phantom at height 6cm with 1.43 degree angle
global Database Info Image Analysis ctrl Threshold f0 figuretodraw bb flag_digital roi_xsize roi_ysize
%{
    acquisitionkeyList=cell2mat(funcSelectInTable('retrieveAcq','Choose an acquisition',0,'Cancel'));
    %filename='P:\Vidar Images\test\bbs10.tif';
    index = 1;
    Info.AcquisitionKey = acquisitionkeyList(index);
        %Database.Step=2;    
    RetrieveInDatabase('ACQUISITION'); 
%}
flag_digital = true;

%rx=-2.5;ry=-3.5; rz = -33.2;
%tz = 7.9; paddle_shift =-0.5;

%dist_coef = 0.85; % paddle height
 % z angle

%size_x = 0.9;
roi_xsize = 0.75; roi_ysize = 0.75; dist_coef = 1.28 ;paddle_shift =0;

if flag_digital == true
  k = 0.014; % for selenia
else
  k = 0.015; %for CPMC 
end
  %digital machine
%paddle_shift = 0; %cm, negative is shift to right
s=65;  % selenia s = 65;
%rotation and translation parameters
sz = size(Image.OriginalImage); % 1407 1408 
xmax_pixels = sz(2);
ymax_pixels = sz(1);
ymax_cm = ymax_pixels * k;
y0source_pixels = ymax_pixels/2 + paddle_shift / k; 
%{
[x_edge2,y_edge2,film_small] = plot_edge(dist_coef, rz);

x_edge = x_edge2 * k ;
y_edge = y_edge2 * k ;  
diag_film = sqrt(x_edge^2+((ymax_pixels/2- y_edge2)*k)^2);
tz6cm = 6;
diag_paddle6cm = diag_film * (1- tz6cm/s)

plot(x_edge2,y_edge2,'.','MarkerSize',5,'color','y');
plot([1 x_edge2 ],[y0source_pixels y_edge2],'Linewidth',1,'color','b'); hold on;
diag_paddle_0 = diag_paddle6cm + roi_xsize*3 + 1;
tx0paddle_cm = diag_paddle_0 * cos(-rz * pi / 180);
ty0paddle_cm = diag_paddle_0 * sin(-rz * pi / 180);

dial_film_0 = diag_paddle_0/(1- tz/s);

%dx_film = (0.75*3 + 1)/(1- tz/s);   % %2.7566 
%dy_film = (0.75*3 + 1)/(1- tz/s);  % * sin(32 * 6.28 / 360)  % 1.7215

%dx = dx_film * cos(rz * 6.28 / 360)
%dy = dy_film * sin(rz * 6.28 / 360)
tx0film_cm = dial_film_0 * cos(-rz * 6.28 / 360);
ty0film_cm = ymax_cm/2 - dial_film_0 * sin(-rz * 6.28 / 360);
%tx= (x_edge + dx);
tx0_film = round(tx0film_cm/k);
%ty= (y_edge - dy);
ty0_film = round(ty0film_cm/k);
plot(tx0_film,ty0_film,'.','MarkerSize',10,'color','y'); hold on;
%plot([x_edge/k tx0_film],[y_edge/k ty0_film],'Linewidth',2,'color','r');
%Mammo=imread(filename);
%figure;imagesc(Mammo);colormap(gray);
%
ROI9step_calculation(film_small);
%pixelCm=150/2.54;
tx = tx0paddle_cm;
ty = ty0paddle_cm + paddle_shift;
%ty = ty0paddle_cm;
%tx = 10;
%ty = 5;

%}

[xf_1,yf_1]=projectionsimulation(bb.bb1,tx,ty,tz,rx,ry,rz,s);
[xf_2,yf_2]=projectionsimulation(bb.bb2,tx,ty,tz,rx,ry,rz,s);
[xf_3,yf_3]=projectionsimulation(bb.bb3,tx,ty,tz,rx,ry,rz,s);
[xf_4,yf_4]=projectionsimulation(bb.bb4,tx,ty,tz,rx,ry,rz,s);
[xf_5,yf_5]=projectionsimulation(bb.bb5,tx,ty,tz,rx,ry,rz,s);
[xf_6,yf_6]=projectionsimulation(bb.bb6,tx,ty,tz,rx,ry,rz,s);
[xf_7,yf_7]=projectionsimulation(bb.bb7,tx,ty,tz,rx,ry,rz,s);
[xf_8,yf_8]=projectionsimulation(bb.bb8,tx,ty,tz,rx,ry,rz,s);
[xf_9,yf_9]=projectionsimulation(bb.bb9,tx,ty,tz,rx,ry,rz,s);
[xf_0,yf_0]=projectionsimulation(bb.bb0,tx,ty,tz,rx,ry,rz,s);
[xf_B,yf_B]=projectionsimulation(bb.bbB,tx,ty,tz,rx,ry,rz,s);

[xp_1,yp_1]=projectionsimulation(bb.bbpos1,tx,ty,tz,rx,ry,rz,s);
[xp_2,yp_2]=projectionsimulation(bb.bbpos2,tx,ty,tz,rx,ry,rz,s);
[xp_3,yp_3]=projectionsimulation(bb.bbpos3,tx,ty,tz,rx,ry,rz,s);
[xp_4,yp_4]=projectionsimulation(bb.bbpos4,tx,ty,tz,rx,ry,rz,s);
[xp_5,yp_5]=projectionsimulation(bb.bbpos5,tx,ty,tz,rx,ry,rz,s);
[xp_6,yp_6]=projectionsimulation(bb.bbpos6,tx,ty,tz,rx,ry,rz,s);
[xp_7,yp_7]=projectionsimulation(bb.bbpos7,tx,ty,tz,rx,ry,rz,s);
[xp_8,yp_8]=projectionsimulation(bb.bbpos8,tx,ty,tz,rx,ry,rz,s);
[xp_9,yp_9]=projectionsimulation(bb.bbpos9,tx,ty,tz,rx,ry,rz,s);

hold on;
figure(figuretodraw);

plot([xf_1,xf_1(1)]/k-x0_shift,y0source_pixels+y0_shift-[yf_1,yf_1(1)]/k, 'r')
hold on;
plot([xf_2,xf_2(1)]/k-x0_shift,y0source_pixels+y0_shift-[yf_2,yf_2(1)]/k, 'b')
hold on;
plot([xf_3,xf_3(1)]/k-x0_shift,y0source_pixels+y0_shift-[yf_3,yf_3(1)]/k,'m')
hold on;
plot([xf_4,xf_4(1)]/k-x0_shift,y0source_pixels+y0_shift-[yf_4,yf_4(1)]/k,'b' )
hold on;
plot([xf_5,xf_5(1)]/k-x0_shift,y0source_pixels+y0_shift-[yf_5,yf_5(1)]/k,'r') 
hold on;
plot([xf_6,xf_6(1)]/k-x0_shift,y0source_pixels+y0_shift-[yf_6,yf_6(1)]/k,'b')
hold on;
plot([xf_7,xf_7(1)]/k-x0_shift,y0source_pixels+y0_shift-[yf_7,yf_7(1)]/k,'r')
hold on;
plot([xf_8,xf_8(1)]/k-x0_shift,y0source_pixels+y0_shift-[yf_8,yf_8(1)]/k,'b')
hold on;
plot([xf_9,xf_9(1)]/k-x0_shift,y0source_pixels+y0_shift-[yf_9,yf_9(1)]/k,'m') 
hold on;
plot([xf_0,xf_0(1)]/k-x0_shift,y0source_pixels+y0_shift-[yf_0,yf_0(1)]/k,'g') 
hold on;
%plot([xf_B,xf_B(1)]/k,y0source_pixels-[yf_B,yf_B(1)]/k,'g') 
%hold on;
plot(xp_1/k-x0_shift, y0source_pixels+y0_shift - yp_1/k,'*y');
hold on;
plot(xp_2/k-x0_shift, y0source_pixels+y0_shift - yp_2/k,'*y');
hold on;
plot(xp_3/k-x0_shift, y0source_pixels+y0_shift - yp_3/k,'*y');
hold on;
plot(xp_4/k-x0_shift, y0source_pixels+y0_shift - yp_4/k,'*y');
hold on;
plot(xp_5/k-x0_shift, y0source_pixels+y0_shift - yp_5/k,'*y');
hold on;
plot(xp_6/k-x0_shift, y0source_pixels+y0_shift - yp_6/k,'*y');
hold on;
plot(xp_7/k-x0_shift, y0source_pixels+y0_shift - yp_7/k,'*y');
hold on;
plot(xp_8/k-x0_shift, y0source_pixels+y0_shift - yp_8/k,'*y');
hold on;
plot(xp_9/k-x0_shift, y0source_pixels+y0_shift - yp_9/k,'*y');
hold on;

%set(ctrl.text_zone,'String',['Paddle  position:', num2str(diag_paddle6cm), ' cm']);
%plot([xf_i,xf_i(1),xf_i(2),xf_i(5)]*pixelCm,size(Mammo,1)/2-[yf_i,yf_i(1),yf_i(2),yf_i(5)]*pixelCm)
 rot_image2 = uint8(Image.image(1:460,690:end)/126000*255);
 %imwrite(rot_image2,'C:\Documents and Settings\smalkov\My Documents\Programs\SXAVersion6.3April24\SXA step phantom\9step_phantom\phan4_init.tif', 'tif');
  %  a = imread('phan4_init.tif', 'tif');
    %conn1 = [0 1 0; 0 1 0; 0 1 0];
    %conn1 = conndef(2,'minimal');
   % im_a = imclearborder(a);
    scrsz = get(0,'ScreenSize');
    h_init = figure;
    set(h_init,'Position',[1 scrsz(4)*7/8 scrsz(3)*7/8 scrsz(4)*7/8]); 
  
    imagesc(rot_image2); colormap(gray);hold on;
figure(h_init);
%plot([xf_1,xf_1(1)]/k-690,y0source_pixels-[yf_1,yf_1(1)]/k, 'r')

%xlim([xmin xmax]); ylim([ymin ymax]);
plot([xf_1,xf_1(1)]/k-690-x0_shift,y0source_pixels+y0_shift-[yf_1,yf_1(1)]/k, 'r')
hold on;
plot([xf_2,xf_2(1)]/k-690-x0_shift,y0source_pixels+y0_shift-[yf_2,yf_2(1)]/k, 'b')
hold on;
plot([xf_3,xf_3(1)]/k-690-x0_shift,y0source_pixels+y0_shift-[yf_3,yf_3(1)]/k,'m')
hold on;
plot([xf_4,xf_4(1)]/k-690-x0_shift,y0source_pixels+y0_shift-[yf_4,yf_4(1)]/k, 'b')
hold on;
plot([xf_5,xf_5(1)]/k-690-x0_shift,y0source_pixels+y0_shift-[yf_5,yf_5(1)]/k, 'r')
hold on;
plot([xf_6,xf_6(1)]/k-690-x0_shift,y0source_pixels+y0_shift-[yf_6,yf_6(1)]/k,'b')
hold on;
plot([xf_7,xf_7(1)]/k-690-x0_shift,y0source_pixels+y0_shift-[yf_7,yf_7(1)]/k,'r')
hold on;
plot([xf_8,xf_8(1)]/k-690-x0_shift,y0source_pixels+y0_shift-[yf_8,yf_8(1)]/k,'b')
hold on;
plot([xf_9,xf_9(1)]/k-690-x0_shift,y0source_pixels+y0_shift-[yf_9,yf_9(1)]/k,'m')
hold on;
plot([xf_0,xf_0(1)]/k-690-x0_shift,y0source_pixels+y0_shift-[yf_0,yf_0(1)]/k,'g')
hold on;
%plot([xf_B,xf_B(1)]/k-690,y0source_pixels-[yf_B,yf_B(1)]/k,'g')
%hold on;
plot(xp_1/k-690-x0_shift,  y0source_pixels+y0_shift-yp_1/k,'*r'); 
hold on;
plot(xp_2/k-690-x0_shift,  y0source_pixels+y0_shift-yp_2/k,'*r'); 
hold on;
plot(xp_3/k-690-x0_shift,  y0source_pixels+y0_shift-yp_3/k,'*r'); 
hold on;
plot(xp_4/k-690-x0_shift,  y0source_pixels+y0_shift-yp_4/k,'*r'); 
hold on;
plot(xp_5/k-690-x0_shift,  y0source_pixels+y0_shift-yp_5/k,'*r'); 
hold on;
plot(xp_6/k-690-x0_shift,  y0source_pixels+y0_shift-yp_6/k,'*r'); 
hold on;
plot(xp_7/k-690-x0_shift,  y0source_pixels+y0_shift-yp_7/k,'*r'); 
hold on;
plot(xp_8/k-690-x0_shift,  y0source_pixels+y0_shift-yp_8/k,'*r'); 
hold on;
plot(xp_9/k-690-x0_shift,  y0source_pixels+y0_shift-yp_9/k,'*r'); 
hold on;
figure(h_init);

