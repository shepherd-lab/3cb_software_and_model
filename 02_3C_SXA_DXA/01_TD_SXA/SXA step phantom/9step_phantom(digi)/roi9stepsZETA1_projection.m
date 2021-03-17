function roi8stepsZETA1_projection(Xim_calc,index)
% Phantom at height 6cm with 1.43 degree angle
global Database Info Image Analysis ctrl Threshold f0 figuretodraw bb flag_digital roi_xsize roi_ysize xleft middle stepdata
global params roi_values roi_centroids params 
%params = [rx0, ry0, rz0, tz0,tx0, ty0, feval,x0_shift, y0_shift,s];
rx = params(1);
ry = params(2); 
rz = params(3);
tz = params(4);
tx = params(5);
ty = params(6);
x0_shift = params(8); 
y0_shift = params(9);
s = params(10);
Analysis.params = params;
Analysis.rx = params(1);
Analysis.ry = params(2);
Analysis.ph_thickness = params(4)-1.43;

flag_digital = false;
film_small = true;
 sz = size(Image.OriginalImage); % 1407 1408 
 xmax_pixels = sz(2);
 ymax_pixels = sz(1);
 paddle_shift = 0;
 
% if flag_digital == true
%   k = 0.014; % for selenia
% else
%   k = 0.015; %0.0169for Vidar and  0.015 forCPMC 
% end
 if Info.DigitizerId == 1
        k  = 0.0169;
 else
        k = Analysis.Filmresolution/10;
 end

%s=65;  % selenia s = 65;
 y0source_pixels = ymax_pixels/2 + paddle_shift / k; 
load('Z1phantomROI.mat');
ln = length(Xim_calc(:,1));

[xf_1,yf_1]=projectionsimulation(bb.bb1,tx,ty,tz,rx,ry,rz,s);
[xf_2,yf_2]=projectionsimulation(bb.bb2,tx,ty,tz,rx,ry,rz,s);
[xf_3,yf_3]=projectionsimulation(bb.bb3,tx,ty,tz,rx,ry,rz,s);
[xf_4,yf_4]=projectionsimulation(bb.bb4,tx,ty,tz,rx,ry,rz,s);
[xf_5,yf_5]=projectionsimulation(bb.bb5,tx,ty,tz,rx,ry,rz,s);
[xf_6,yf_6]=projectionsimulation(bb.bb6,tx,ty,tz,rx,ry,rz,s);
[xf_7,yf_7]=projectionsimulation(bb.bb7,tx,ty,tz,rx,ry,rz,s);
[xf_8,yf_8]=projectionsimulation(bb.bb8,tx,ty,tz,rx,ry,rz,s);
[xf_0,yf_0]=projectionsimulation(bb.bb0,tx,ty,tz,rx,ry,rz,s);
 
Xcm = [xf_1; xf_2;xf_3;xf_4;xf_5;xf_6;xf_7;xf_8;xf_0];
Ycm = [yf_1; yf_2;yf_3;yf_4;yf_5;yf_6;yf_7;yf_8;yf_0];
%Xim_calc, x0_shift,y0_shift,index,k, Xcm, Ycm, film_small
stepdata.Xim_calc = Xim_calc;
stepdata.x0_shift = x0_shift;
stepdata.y0_shift = y0_shift;
stepdata.index = index;
stepdata.k = k;
stepdata.Xcm = Xcm;
stepdata.Ycm = Ycm;
stepdata.film_small = film_small;

[roi_values,roi_centroids] = riobbs_plot();
Analysis.roi_values = roi_values;
%{
hold on;
figure(figuretodraw);
%redraw;
plot(Xim_calc(:,1)/k-x0_shift, ymax_pixels/2+y0_shift - Xim_calc(:,2)/k,'*r');
 for i = 1:ln
      text(Xim_calc(i,1)/k-x0_shift, ymax_pixels/2+y0_shift - Xim_calc(i,2)/k-15,num2str(index(i)),'Color', 'g'); 
 end
%plot(tx0/k-x0_shift, ymax_pixels/2+y0_shift - ty0/k,'*b');

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
%plot([xf_9,xf_9(1)]/k,y0source_pixels-[yf_9,yf_9(1)]/k,'m') 
%hold on;
plot([xf_0,xf_0(1)]/k-x0_shift,y0source_pixels+y0_shift-[yf_0,yf_0(1)]/k,'g') 
hold on;

%for i=1:ln
   %text(sort_coord(i,1),sort_coord(i,2)-20,num2str(sort_coord(i, 3)),'Color', 'y'); 
  % text(Xim_calc(:,1)/k-x0_shift, ymax_pixels/2+y0_shift - Xim_calc(:,2)/k,num2str(index(i)),'Color', 'y');
%end

%plot([xf_B,xf_B(1)]/k,y0source_pixels-[yf_B,yf_B(1)]/k,'g') 
%hold on;

%set(ctrl.text_zone,'String',['Paddle  position:', num2str(diag_paddle6cm), ' cm']);

%plot([xf_i,xf_i(1),xf_i(2),xf_i(5)]*pixelCm,size(Mammo,1)/2-[yf_i,yf_i(1),yf_i(2),yf_i(5)]*pixelCm)
  
    %   redraw;
 if film_small == true
        ycrop = 520;
        xcrop = 690;
 else
        ycrop = 500;
        xcrop = 1100;
 end
    
    
    %x_cut = 690;
    %   y_cut = 520;
  
       sz = size(Image.image);
    %rot_image = Image.image(1:460,500:end);
    %rot_image2 = uint8(Image.image(1:y_cut,x_cut:end)/126000*255);
    %imwrite(rot_image2,'C:\Documents and Settings\smalkov\My Documents\Programs\SXAVersion6.2\phan3_init.tif', 'tif');
   % a = imread('phan3_init.tif', 'tif');
      a = uint8(Image.image(1:ycrop,xcrop:end)/126000*255);
   %conn1 = [0 1 0; 0 1 0; 0 1 0];
    %conn1 = conndef(2,'minimal');
   % im_a = imclearborder(a);
    scrsz = get(0,'ScreenSize');
    
    h_init = figure;
    imagesc(a); colormap(gray); hold on;% title('Now, you can select the first set of coordinates');hold on;
     set(h_init,'Position',[1 scrsz(4)*7/8 scrsz(3)*7/8 scrsz(4)*7/8]);
      plot(Xim_calc(:,1)/k-x0_shift-xcrop, ymax_pixels/2+y0_shift - Xim_calc(:,2)/k,'*r');  
     for i = 1:ln
      text(Xim_calc(i,1)/k-x0_shift-xcrop, ymax_pixels/2+y0_shift - Xim_calc(i,2)/k-15,num2str(index(i)),'Color', 'g'); 
     end
     hold on;
       ;
%{
 sz = size(Image.image)
 rot_image2 = uint8(Image.image(1:ycrop,xcrop:xmax_pixels)/126000*255);
 scrsz = get(0,'ScreenSize');
 h_init = figure;
 set(h_init,'Position',[1 scrsz(4)*7/8 scrsz(3)*7/8 scrsz(4)*7/8]); 
 imagesc(rot_image2); colormap(gray);hold on;
%}

%xlim([xmin xmax]); ylim([ymin ymax]);
plot([xf_1,xf_1(1)]/k-x0_shift-xcrop,y0source_pixels+y0_shift-[yf_1,yf_1(1)]/k, 'r')
hold on;
plot([xf_2,xf_2(1)]/k-x0_shift-xcrop,y0source_pixels+y0_shift-[yf_2,yf_2(1)]/k, 'b')
hold on;
plot([xf_3,xf_3(1)]/k-x0_shift-xcrop,y0source_pixels+y0_shift-[yf_3,yf_3(1)]/k,'m')
hold on;
plot([xf_4,xf_4(1)]/k-x0_shift-xcrop,y0source_pixels+y0_shift-[yf_4,yf_4(1)]/k, 'b')
hold on;
plot([xf_5,xf_5(1)]/k-x0_shift-xcrop,y0source_pixels+y0_shift-[yf_5,yf_5(1)]/k, 'r')
hold on;
plot([xf_6,xf_6(1)]/k-x0_shift-xcrop,y0source_pixels+y0_shift-[yf_6,yf_6(1)]/k,'b')
hold on;
plot([xf_7,xf_7(1)]/k-x0_shift-xcrop,y0source_pixels+y0_shift-[yf_7,yf_7(1)]/k,'r')
hold on;
plot([xf_8,xf_8(1)]/k-x0_shift-xcrop,y0source_pixels+y0_shift-[yf_8,yf_8(1)]/k,'b')
hold on;
plot([xf_0,xf_0(1)]/k-x0_shift-xcrop,y0source_pixels+y0_shift-[yf_0,yf_0(1)]/k,'g')
hold on;
%plot([xf_B,xf_B(1)]/k-690,y0source_pixels-[yf_B,yf_B(1)]/k,'g')
%hold on;
%}
