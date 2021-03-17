function roi8stepsZETA2_projection(Xim_calc,index)
% Phantom at height 6cm with 1.43 degree angle
global Database Info Image Analysis ctrl Threshold f0 figuretodraw bb flag_digital roi_xsize roi_ysize xleft middle stepdata flag
global   params roi_values MachineParams%Phantom
%params = [rx0, ry0, rz0, tz0,tx0, ty0, feval,x0_shift, y0_shift,s];

   kGE = 0.71;
    if Info.DigitizerId >= 5 & Info.DigitizerId <= 7
        crop_coef = kGE;
    else
        crop_coef = 1;
    end
    
 sz = size(Image.OriginalImage); % 1407 1408 
 xmax_pixels = sz(2);
rx = params(1);
ry = params(2); 
rz = params(3);
tz = params(4);
tx = params(5);
ty = params(6);

x0_shift = -MachineParams.x0_shift; 
y0_shift = -MachineParams.y0_shift;
s = MachineParams.source_height;
%MachineParams.bucky_distance = 2;
h_bucky = MachineParams.bucky_distance;

 %{
    machine_params = [...	
       37.9	    1.4	    66.45680682	 2.23 1  ;... %as in database 
    	30.15	-6.225	66.48454545	 2.15 1  ;...
    	78.775	-0.575	66.48322727	 2.14 1.001  ;...
    	62.8	19.5	66.23490909	 1.61 1.007  ;...
    	19.95	-1.8	66.20925	 2.35 1.005  ;...
    	56.6	10.55	66.20770455	 2.35 1  ;...
    	23.825	-2.9	65.97568182	 2.35  1.007 ;...
        32.25   -7.13   66.51488409	 2.08 1.007];
    
     x0_shift = -machine_params(num_machine,1);
     y0_shift = -machine_params(num_machine,2);
     s =  machine_params(num_machine,3);;
     h_bucky = machine_params(num_machine,4);
     %}
Analysis.params = params;
Analysis.rx = params(1);
Analysis.ry = params(2);
%Analysis.ph_thickness = params(4)-1.6;
Analysis.ph_thickness = (params(4)-h_bucky);  % / MachineParams.linear_coef;
Analysis.error_3DReconstruction = params(7);
%flag_digital = false;
%%%%%%

%film_small = true;
 %film_small = flag.small_paddle;
sz = size(Image.OriginalImage); % 1407 1408 
 xmax_pixels = sz(2);
 ymax_pixels = sz(1);
 if flag.small_paddle == false %xmax_pixels > 1350
    film_small = false;
 else
    film_small = true; 
 end
 
 paddle_shift = 0;
 
% if Info.DigitizerId == 4 % flag_digital == true
%   k = 0.014; % for selenia
% elseif Info.DigitizerId == 1
%   k = 0.0169; 
% elseif Info.DigitizerId == 5 | Info.DigitizerId == 6
%   k = 0.02; 
% else
%   k = 0.015; %0.0169for Vidar and  0.015 forCPMC 
% end

 if Info.DigitizerId == 1
        k  = 0.0169;
 else
        k = Analysis.Filmresolution/10;
        if Info.centerlistactivated == 75
            k = 0.01;    %Analysis.Filmresolution/10/2;
        end    
 end
%s=65;  % selenia s = 65;
 y0source_pixels = ymax_pixels/2 + paddle_shift / k; 
 if  Analysis.PhantomID == 8 
     if Info.centerlistactivated == 4
        load('Z2phantomROIroom4.mat'); %
     elseif Info.centerlistactivated == 8
        load('Z2phantomROIroom8.mat');
     else
         load('Z2phantomROIroom89.mat');
     end
 else  % Z4 tapered
     if flag.small_paddle == true %xmax_pixels < 1350 
          load('Z4phantomROI_small.mat');         
     else
          load('Z4phantomROI_big.mat');       
     end
   
     if flag.small_paddle == true %xmax_pixels < 1350
         if flag.small_swapped==false
             load('Z4phantomROI_small.mat');
         else
             load('Z4phantomROI_big.mat');
         end
     else
         if flag.large_swapped==false
             load('Z4phantomROI_big.mat');
         else
             load('Z4phantomROI_small.mat');
         end
     end
     
     
     
 end
ln = length(Xim_calc(:,1));
%ry = ry - 1.4;
%rx = rx - 0.6;
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
if Analysis.second_phantom == false
    [roi_values,roi_centroids] = riobbs_plot();
    Analysis.roi_values = roi_values;
    Analysis.roi_centroids = roi_centroids;
else
    %roi_values = riobbs_plot();
    riobbs_plot_second();
end
