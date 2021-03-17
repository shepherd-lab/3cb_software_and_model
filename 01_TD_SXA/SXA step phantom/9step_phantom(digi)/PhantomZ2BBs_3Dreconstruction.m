function params = bbZ2_3Dreconstruction(coord)
    global Image figuretodraw Result params Info Error Analysis num_bbs num_thickness
    Error.StepPhantomReconstruction = false;
    Error.Correction = false;
    
%      if Info.DigitizerId == 3
%         k  = 0.015;
%     elseif Info.DigitizerId == 1
%        k  = 0.0169; 
%     elseif Info.DigitizerId == 4  
%         k  = 0.014;
%     elseif Info.DigitizerId == 5 | Info.DigitizerId == 6 
%         k  = 0.02;    
%      end
    
     if Info.DigitizerId == 1
        k  = 0.0169;
     else
        k = Analysis.Filmresolution/10;
     end
    sz = size(Image.OriginalImage); % 1407 1408 
    xmax_pixels = sz(2);
    ymax_pixels = sz(1);
    x0_shift = -31;
    y0_shift = 10;
      Xim_temp = coord(:,1:2); % at least for three thicknesses
      xim_len = length(coord(:,1));
      Xim_temp(:, 3) = zeros(xim_len, 1);
      index = coord(:,3);
    Xim_temp(:,2) = (ymax_pixels/2+y0_shift) - Xim_temp(:,2);
    
    Xim_temp(:,1) = Xim_temp(:,1) + x0_shift; %
    
    Xim = Xim_temp * k; clear Xim_temp;
    
       if Analysis.PhantomID == 8
            xph_txt = 'Z2phantomXph2.txt'; %for phantom N8
       else
            xph_txt = 'Z4phantomXph_small.txt';  %for phantom N9
       end
       Xph2 = load(xph_txt); 
       Xph = Xph2(index,:); % initial guess of the phantom (x,y,z)
       sz = size(Xph);
       len = sz(1);
       s=66.3;
       %initial parameters for phantom N8
       rx0=0.03526;
       ry0=0.227; 
       rz0=-29.8876;
       tx0 =12.297;
       ty0 = 6.2825;
       
       tz1 = 2.2252;
       tz2 = 3.3507				
       tz3 = 5.3826;
       tz4 = 7.3503;
       tz5 = 9.3689;
       tz1 = 11.3505;
       
       R0 =  rotation_matrix(rx0, ry0, rz0); 
       num_bbs = 9;
       num_thickness = 4;
       %(
       for k = 1:num_thickness
          Xim_calc((k-1)*num_bbs+1:k*num_bbs,:) = bbProjector(Xph((k-1)*num_bbs+1:k*num_bbs,:),tx0,ty0,tz(k),R0,s); 
       end
      %}
       xp = [R0, tz, tx0, ty0,num_bbs,num_thickness];
       [y,feval] = findL0_BBs(Xph0,Xim,xp,s);
       
       for i = 1:10  
           [y,feval] = findL0_BBs(Xph0,Xim,xp,s);  
           Xph0 = y;
       end
        fv = feval
        if fv >= 0.1
            Error.StepPhantomReconstruction = true;
        end
        params =  Xph0
        figure(figuretodraw);
        redraw;
        plot(Xim_calc(:,1)/k-x0_shift, ymax_pixels/2+y0_shift - Xim_calc(:,2)/k,'*r');
        roi9stepsZETA2_projection(Xim_calc,index);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      
       
      
           
           
           
           
           
           
           
           
           
    