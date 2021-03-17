function params = bbUK_3Dreconstruction(coord)
   % filename='P:\Vidar Images\test\StepCalibrate4cm5050Do not know-1.tif'; 
    %global xf1 yf1 BBSPLOT Mammo pixelCm %Xph
    global Image figuretodraw Result params Info
    %Mammo=imread(filename);
    %clear Phantom xf yf
    %pixelCm=150/2.54;
    if Info.DigitizerId == 3
        k  = 0.015;
    elseif Info.DigitizerId == 1
       k  = 0.0169; 
    elseif Info.DigitizerId == 4  
        k  = 0.014;
    end
    
   %  k  = 0.0169; 
    sz = size(Image.OriginalImage); % 1407 1408 
    xmax_pixels = sz(2);
    ymax_pixels = sz(1);
    %h = figure;imagesc(Mammo);colormap(gray);
    x0_shift = -25;
    y0_shift = 0;
   
     %D = 'C:\Documents and Settings\smalkov\My Documents\Programs\SXAVersion6.2\SXA step phantom\9step_phantom\';
      %file_name = [D, 'StepCalibrate7cm5050.txt'];
    % D = 'C:\Documents and Settings\smalkov\My Documents\SeleniaImages\26April\with_phantom';
     %file_name = [D, '1.2.840.113681.2211300624.767.3322825116.101.dcmrawpng.txt'];
     %file_name = [D, '1.2.840.113681.2211300639.2608.3322767109.248.dcmrawpng.txt'];
    % file_name = [D, '1.2.840.113681.2211300624.2640.3322767867.218.dcmrawpng.txt'];
    % D = 'C:\Documents and Settings\smalkov\My Documents\SeleniaImages\Selenia_room116\15May\txt_files\';
     %file_name = [D,'2216078488.713.3325174331.47z.txt'];
    % D = 'C:\Documents and Settings\smalkov\My Documents\SeleniaImages\Selenia_room116\6June_thicknessangle\txt_files\';
    % file_name = [D,'2216078488.738.3327080834.155raw.txt']; 
    
    % D = 'C:\Documents and Settings\smalkov\My Documents\Programs\SXAVersion6.2\SXA step phantom\';     
     % file_txt = [D, 'Z1phantomROI.txt'];
     %Xim_temp = load(file_txt);
      Xim_temp = coord(:,1:2);
      xim_len = length(coord(:,1));
      Xim_temp(:, 3) = zeros(xim_len, 1);
      index = coord(:,3);
      %Calbratedstep 7cm Fat  
    %{
    Xim_temp = [...
            785.6412,	73.3893,0;
            858.707,	37.854,0;
            929.3487,	12.3917,0;
            787.1995,	87.9392,0;
            937.4863,	354.3139,0;
            1006.7429,	308.9854,0;
           % 1047.4312,	273.7299,0;
            924.3276,	336.9659,0;
            827.3683,	229.2409,0;
            1041.5444,	114.2409,0];
     %}
  %Calbratedstep 4cm 50/50
        %{  
    Xim_temp =[734.6511, 101.0292, 0;
               807.687, 66.2847, 0;
               882.6223, 37.6715, 0;
               747.4281, 110.4818, 0;
               879.3417, 367.2336, 0;
               948.7518, 322.2701, 0;
               1012.8093, 272.4526 , 0;
               876.9245, 346.7956, 0;
               772.2914, 249.7153, 0;
               989.1547, 134.2409, 0];
       %}    
    Xim_temp(:,2) = (ymax_pixels/2+y0_shift) - Xim_temp(:,2);
    
    Xim_temp(:,1) = Xim_temp(:,1) + x0_shift; %
    
    Xim = Xim_temp * k; clear Xim_temp;
     %direct system of coordinates    
       %{
      Xph = [-4.7066, 2.08028, 6.495; %-4.55, 2.08026, 6.42874;
           -3.18008, 2.0701, 4.70662;
           -0.76708, 2.02184, 0.32512;
           -3.13182, 2.08534, 0.26162;
           -4.762, -2.166, 6.459;     %-4.55, -2.0574, 6.42366;
           -3.1115, -2.05994, 4.70662;  
          % -0.68326, -2.0701, 0.2921;
           -3.05308, -2.05486, 0.2921;
           -5.456, 0.03048, 7.2517;  %-5.73278, 0.03048, 7.24662;
             0, -0.03302, 0.30734];
         %}
     %direct system of coordinates,CPMC phantom, second measurement 
        %D = 'C:\Documents and Settings\smalkov\My Documents\Programs\'; 
        %xph_txt = [D, 'Z1phantomXph.txt'];
     if sz(1) < 1500   
        xph_txt = 'ZUKphantomXph.txt';
     else
         xph_txt = 'ZUKphantomXph_big.txt';
         %xph_txt = 'ZUKphantomXph.txt';
     end
        
       % xroi_txt = 'Z1phantomROI.txt';
        Xph2 = load(xph_txt); 
        %XROI = load(xroi_txt);
      %{  
        Xph2 = [ -4.66852,	2.03708,	6.42874;
                -3.07594,	2.08788,	4.70662;
               -0.76708,	2.02184,	0.32512;
                -3.13182,	2.08534,	0.26162;
                -4.6609,	-2.10566,	6.42366;
                -3.048,	    -2.10566,	4.70662;
                -0.68326,	-2.0701,	0.2921;
                -3.05308,	-2.05486,	0.2921;
                -5.35686,	0.00762,	7.24662;
                0.02032,	-0,	        0.30734];
      %}      
          Xph = Xph2(index,:);
    ;
     %reverse system of coordinates,CPMC phantom 
      %{    
        Xph = [ 4.66852,	-2.03708,	6.42874;
                3.07594,	-2.08788,	4.70662;
               0.76708,	-2.02184,	0.32512;
                3.13182,	-2.08534,	0.26162;
                4.6609,	2.10566,	6.42366;
                3.048,	2.10566,	4.70662;
                0.68326,	2.0701,	0.2921;
                3.05308,	2.05486,	0.2921;
                5.35686,	-0.00762,	7.24662;
                -0.02032,	0,	0.30734];
     
      % CPMC digital machine 9 step phantom   z-phantom       
     
      Xph = [  -0.70866,	2.98704,	5.21716;
                0.3937,	2.91084,	2.95656;
                -0.5207,	3.1496,	0.112141;
                -1.03886,	-0.50292,	5.96519;
                0.25908,	-0.58928,	3.556;
                -0.5969,	-0.80518,	0.9906;
                1.83388,	1.02108,	2.38252;
                2.3876,	1.88722,	0.42672;
                2.36601,	0.2413,	0.37973];
       %}
     
     
    %{
     %digital machine 9 step phantom   z-phantom - second BB's measurement      
             Xph = [ -0.69342,	2.84734,	5.2324;
            0.42926,	2.83972,	2.9718;
            -0.52578,	3.09372,	0.9906;
            -0.94742,	-0.58166,	5.96392;
            0.31242,	-0.6223,	3.58394;
            -0.50292,	-0.84328,	0.9779;
            1.94564,	1.10744,	2.3749;
            2.4384,	1.92024,	0.42164;
            2.4765,	0.32512,	0.37338];
     %} 
            
      % UK phantom
     %{
       Xph = [-3.92938	0.67056	5.10032
        -2.32918	0.6604	3.048
        -3.35026	0.66548	0.92456
        -4.08432	-3.2131	5.8166
        -2.45364	-3.22834	3.6957
        -3.32486	-3.21564	0.9906
        %-0.65278	-1.31064	2.41554
        -0.0254	-0.28194	0.3683
        -0.0381	-2.29108	0.37084];
     %}
     
     
     % Digital machine phantom
     % D1 = 'C:\Documents and Settings\smalkov\My Documents\Programs\SXAVersion6.2\SXA step phantom\9step_phantom\';
     %file_name = [D1, 'digitalphantom_position.txt'];
     
      % Xph = load(file_name);
       %Xph = Xph1(1:6,:);
        %Xph(2,:) = [];    
      sz = size(Xph);
      % tz=5;
       len = sz(1);
      %tx=(MeanMX-MeanX);
      %ty=(MeanMY-MeanY);
       s=64.6;
       %rx0=180; ry0=180; rz0=-28;
       rx0=0; ry0=0; rz0=-28;
       tx0 = mean(Xim(:,1)) - mean(Xph(:,1));
       ty0 = mean(Xim(:,2)) - mean(Xph(:,2));
       tz0 = mean(Xph(:,3)) - mean(Xim(:,3));
       %tx0 = 12;
       %ty0 = 7;
       %tz0 = 7;
       %for i = 1:40 
       R0 =  rotation_matrix(rx0, ry0, rz0); 
       
       [Xim_calc]=bbProjector(Xph,tx0,ty0,tz0,R0,s); 
       %figure(figuretodraw);
      % plot(Xim_calc(:,1)/k, ymax_pixels/2 - Xim_calc(:,2)/k,'*r');
       %plot(Xim_calc(:,1)/k, ymax_pixels/2 - Xim_calc(:,2)/k,'*r');
       % figure;
       % plot(Xim_calc(:,1)/k, ymax_pixels/2 - Xim_calc(:,2)/k,'*r');
       
       %[d, Xim, transform] = bbprocrustes(Xim, Xph);
       x0 = [rx0, ry0, rz0, tz0, tx0, ty0];
       for i = 1:10  
           [y,feval] = findL0all(x0, Xim, Xph,s);  
           rx0 = y(1);
           ry0 = y(2);
           rz0 = y(3);
           tz0 = y(4);
           tx0 = y(5);
           ty0 = y(6);
           R0 =  rotation_matrix(rx0, ry0, rz0); 
           [Xim_calc]=bbProjector(Xph,tx0,ty0,tz0,R0,s); 
          % figure(figuretodraw);
          % redraw;
          % plot(Xim_calc(:,1)/k-x0_shift, ymax_pixels/2+y0_shift - Xim_calc(:,2)/k,'*r');
           %plot(Xim_calc(:,1)/k, ymax_pixels/2 - Xim_calc(:,2)/k,'*r');
           du = sum(Xim(:,1) - Xim_calc(:,1))/sz(1);
           dv = sum(Xim(:,2) - Xim_calc(:,2))/sz(1);
           tx0 = tx0 - du * tz0/s;
           ty0 = ty0 - dv * tz0/s;
           x0 = [rx0, ry0, rz0, tz0,tx0, ty0];
         end
        fv = feval
        if fv >= 0.1
            Error.StepPhantomReconstruction = true;
           % Error.StepPhantomFailure = true;
        end
        params = [rx0, ry0, rz0, tz0,tx0, ty0, feval,x0_shift, y0_shift,s]' 
        figure(figuretodraw);
        redraw;
        plot(Xim_calc(:,1)/k-x0_shift, ymax_pixels/2+y0_shift - Xim_calc(:,2)/k,'*r');
        roi9stepsUK_projection(Xim_calc,index);
      
           
           
           
           
           
           
           
           
           
           
           
           
    