function roi9stepsUK_projection(Xim_calc,index)
% Phantom at height 6cm with 1.43 degree angle
global Database Info Image Analysis ctrl Threshold f0 figuretodraw bb flag_digital roi_xsize roi_ysize xleft middle stepdata
global params  roi_values 
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
Analysis.error_3DReconstruction = params(7);
%flag_digital = false;

film_small = true;
 sz = size(Image.OriginalImage); % 1407 1408 
 if sz(1) < 1500
     film_small = true;
 else     
     film_small = false;
 end
 
 xmax_pixels = sz(2);
 ymax_pixels = sz(1);
 paddle_shift = 0;
%  if Info.DigitizerId == 3
%         k  = 0.015;
%  elseif Info.DigitizerId == 1
%        k  = 0.0169; 
%  elseif Info.DigitizerId == 4  
%         k  = 0.014;
%  end

 if Info.DigitizerId == 1
        k  = 0.0169;
  else
        k = Analysis.Filmresolution/10;
 end
 %k  = 0.0169;

%s=65;  % selenia s = 65;
 y0source_pixels = ymax_pixels/2 + paddle_shift / k; 
 
 if film_small == true
     load('Z2phantomROI_UKsmall.mat');
 else
     load('Z2phantomROI_UKbig.mat');
 end
 
ln = length(Xim_calc(:,1));

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
 
Xcm = [xf_1;xf_2;xf_3;xf_4;xf_5;xf_6;xf_7;xf_8;xf_9;xf_0];
Ycm = [yf_1;yf_2;yf_3;yf_4;yf_5;yf_6;yf_7;yf_8;yf_9;yf_0];

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

