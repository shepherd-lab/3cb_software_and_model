function params = phantomBBS_3Dreconstruction(coord)
    global Image figuretodraw Result params Info Error Analysis %num_bbs num_thickness
    Error.StepPhantomReconstruction = false;
    Error.Correction = false;
    
    num_bbs = 9;
    num_thickness = 3;
    
    coord = load('coord_BBs1.txt');
    
    coord(num_bbs*1+1:2*num_bbs,:) = load('coord_BBs2.txt');
    coord(num_bbs*2+1:3*num_bbs,:) = load('coord_BBs3.txt');
    %coord(num_bbs*3+1:4*num_bbs,:) = load('coord_BBs4.txt');
    %coord(num_bbs*4+1:5*num_bbs,:) = load('coord_BBs5.txt');
    %coord(num_bbs*5+1:6*num_bbs,:) = load('coord_BBs6.txt');
    
    if Info.DigitizerId == 3
        k  = 0.015;
    elseif Info.DigitizerId == 1
       k  = 0.0169; 
    elseif Info.DigitizerId == 4  
        k  = 0.014;
    end
    
    sz = size(Image.OriginalImage); % 1407 1408 
    xmax_pixels = sz(2);
    ymax_pixels = sz(1);
    x0_shift = -31; %31
    y0_shift = 10; %10
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
       Xph = load(xph_txt);
       Xphinit = Xph;
       %Xph  = repmat(Xph2, num_thickness, 1)
         
       sz = size(Xph);
       len = sz(1);
       s=66.3;
       %initial parameters for phantom N8
       rx0=0.03526;
       ry0=0.227; 
       rz0=-29.8876;
       tx0 =12.297;
       ty0 = 6.2825;
             
       tz1 = 2.2252; %bucky level
       tz2 = 3.3507;	 %bucky level + acryl(1.19cm)			
       tz3 = 5.3826; %bucky level + acryl(1.19cm) + 2cm 
       tz4 = 7.3503; %bucky level + acryl(1.19cm) + 4cm 
       tz5 = 9.3689; %bucky level + acryl(1.19cm) + 6cm 
       tz6 = 11.3505; %bucky level + acryl(1.19cm) + 8cm 
       tz = [tz1,tz2,tz3,tz4,tz5,tz6]; 
       R0 =  rotation_matrix(rx0, ry0, rz0); 
       tz0 = tz3;
       %{
       for k = 1:num_thickness
          Xim_calc((k-1)*num_bbs+1:k*num_bbs,:) = bbProjector(Xph((k-1)*num_bbs+1:k*num_bbs,:),tx0,ty0,tz(k),R0,s); 
       end
      %}
       xp = [tx0, ty0,num_bbs,num_thickness];
       Xph_zcoord = [Xph(1,3),Xph(4,3),Xph(9,3)];
       
       Xph_vect = reshape(Xph, 1, num_bbs*3);
       Xph_vect([2*num_bbs + 1, 2*num_bbs + 4, 2*num_bbs + 9]) = [];
      % Xph_vect(2*num_bbs + 4) = [];
      % Xph_vect(2*num_bbs + 9) = [];
       
       [y,feval] = findL0_BBs(Xph_vect,Xim,xp,R0,tz,Xph_zcoord,s);
       
       for i = 1:20  
           [y,feval] = findL0_BBs(Xph_vect,Xim,xp,R0,tz,Xph_zcoord,s);  
           Xph_vect = y;
       end
        fv = feval
        if fv >= 0.1
            Error.StepPhantomReconstruction = true;
        end
         temp = Xph_vect(2*num_bbs+1:end); 
         Xph_vect(2*num_bbs+1) = Xph_zcoord(1);
         Xph_vect(2*num_bbs+2:length(Xph_vect)+1) =  temp;
         
         temp = Xph_vect(2*num_bbs+4:end); 
         Xph_vect(2*num_bbs+4) = Xph_zcoord(2);
         Xph_vect(2*num_bbs+5:length(Xph_vect)+1) =  temp; 
         
         temp = Xph_vect(2*num_bbs+9:end); 
         Xph_vect(2*num_bbs+9) = Xph_zcoord(3);
         
         % Xph_vect(2*num_bbs+5:length(Xph_vect)+1) =  temp;  
         Xph = reshape(Xph_vect(1:3*num_bbs), num_bbs,3);
         params =  Xph
        
        figure(figuretodraw);
        redraw;
        [Xim_calc]=bbProjector(Xph,tx0,ty0,tz0,R0,s); 
        
        plot(Xim_calc(:,1)/k-x0_shift, ymax_pixels/2+y0_shift - Xim_calc(:,2)/k,'*r');
        roi9stepsZETA2_projection(Xim_calc,index);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      
       
      
           
           
           
           
           
           
           
           
           
    