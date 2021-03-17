function bbReconParams = bbZ2_3Dreconstruction(coord)
   % filename='P:\Vidar Images\test\StepCalibrate4cm5050Do not know-1.tif'; 
    %global xf1 yf1 BBSPLOT Mammo pixelCm %Xph
    global Image figuretodraw Result params Info Error Analysis num_machine MachineParams flag
    %Mammo=imread(filename);
    %clear Phantom xf yf
    %pixelCm=150/2.54;
%      flag.small_swapped = true;
    room_num = Info.centerlistactivated;
    Error.StepPhantomReconstruction = false;
    Error.Correction = false;
    Error.SXAbbRecon = false;

%      if Info.DigitizerId == 3
%         k  = 0.015;
%     elseif Info.DigitizerId == 1
%        k  = 0.0169; 
%     elseif Info.DigitizerId == 4  
%         k  = 0.014;
%     elseif Info.DigitizerId == 5 | Info.DigitizerId == 6
%        k  = 0.02;
%      end
     if Info.DigitizerId == 1
        k  = 0.0169;
     else
        k = Analysis.Filmresolution/10;
     end
     
%      if info.centerlistactivated == 75
%          k = 0.01;
%      end    
    %k  = 0.0169; 
    sz = size(Image.OriginalImage); % 1407 1408 
    xmax_pixels = sz(2);
    ymax_pixels = sz(1);
    %h = figure;imagesc(Mammo);colormap(gray);
    %x0_shift = -31;
    %y0_shift = 10;
   % num_machine = 1; %our machine is Number 8
   %{
          MachineParams.x0_shift = cell2mat(param_list(2));
          MachineParams.y0_shift = cell2mat(param_list(3));
          MachineParams.source_height = cell2mat(param_list(4));
          MachineParams.bucky_distance = cell2mat(param_list(7));
          MachineParams.dark_counts = cell2mat(param_list(6));
          MachineParams.linear_coef = cell2mat(param_list(8));
          MachineParams.rx_correction = cell2mat(param_list(9));
          MachineParams.ry_correction = cell2mat(param_list(10)); 
   %}
   
   if Info.Database == false % for room 116 machine
%         if num_machine == 8  
%           Info.centerlistactivated = 116;
%         else
%           Info.centerlistactivated = num_machine;
%         end
           num_machine = Info.centerlistactivated;
            %for CB room 116 
          %Analysis.resolution = 0.014;
          %Analysis.Filmresolution = 0.14;
          if Analysis.PhantomID == 9 | Analysis.PhantomID == 8
             RetrieveInDatabase('MACHINEPARAMETERS');
              if flag.small_paddle == true             %Image.columns < 1350  %small paddle
                params_temp = [MachineParams.thicknessSmall_corr,MachineParams.rxSmall_corr,MachineParams.rySmall_corr];
                MachineParams.bucky_distance = params_temp(1);
                MachineParams.rx_correction = params_temp(2);
                MachineParams.ry_correction = params_temp(3); 
            else
                params_temp = [MachineParams.thicknessBig_corr,MachineParams.rxBig_corr,MachineParams.ryBig_corr];
                MachineParams.bucky_distance = params_temp(1);
                MachineParams.rx_correction = params_temp(2);
                MachineParams.ry_correction =  params_temp(3);
            end
          end
   end
       
       
        x0_shift = -MachineParams.x0_shift;
        y0_shift = -MachineParams.y0_shift;
        s = MachineParams.source_height;
       
        %{
        x0_shift = 0;
        y0_shift = 0;
        s = 65;
        %}
        %h_bucky = MachineParams.bucky_distance;
        b = 1;
            
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
   % x0_shift = -31;
   % y0_shift = 10;
   % s=66.3;
   % h_bucky = 
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
       if Analysis.PhantomID == 8
           %xph_txt =  'Z2phantomXphroom8.txt'
           xph_txt = 'Z2phantomXph2.txt'; %for phantom N8
           % xph_txt =  'Z2phantomXphroom4.txt'
       elseif Analysis.PhantomID == 9
          % if room_num == 1 | room_num == 2 | room_num == 3 | room_num == 4 %| room_num == 116
          %phantom for large paddle used for small paddle
              if flag.small_paddle == true %xmax_pixels < 1350
                  if flag.small_swapped==false
                   xph1_4txt = 'Z4phantomXph_small_001.txt';  %for phantom N9 xph_txt = 'Z4phantomXph_small_001.txt';meAll
                   xph5_7txt = 'Z4phantomXph_small_008.txt';
                  else
                   xph1_4txt = 'Z4phantomXph_big_001.txt'; 
                   xph5_7txt = 'Z4phantomXph_big_014.txt';
                  end
                   
              else
                 if flag.large_swapped==false
                   xph1_4txt = 'Z4phantomXph_big_001.txt'; 
                   xph5_7txt = 'Z4phantomXph_big_014.txt';                   
                 else
                   xph1_4txt = 'Z4phantomXph_small_001.txt';  %for phantom N9 xph_txt = 'Z4phantomXph_small_001.txt';meAll
                   xph5_7txt = 'Z4phantomXph_small_008.txt';
                 end                        
               end       
       end
       
       Xph1_4 = load(xph1_4txt); 
       Xph5_7 = load(xph5_7txt); 
       Xph_1 = Xph1_4(index,:);
       Xph_2 = Xph5_7(index,:);
       
       [x0_1,feval_1, Xim_calc_1] = bbs_fitting(Xph_1,Xim,s);
       [x0_2,feval_2, Xim_calc_2] = bbs_fitting(Xph_2,Xim,s);
       
       if feval_1 < feval_2
           x0 = x0_1;
           feval = feval_1;
           Xim_calc = Xim_calc_1;
           Analysis.BBcoord_set = 1;
       else
           x0 = x0_2;
           feval = feval_2;
           Xim_calc = Xim_calc_2;
           Analysis.BBcoord_set = 2;
       end
       if Info.Database == true
           if  strcmp(Analysis.film_identifier(1:3),'uvm')  %for uvm only new set of phantoms
               x0 = x0_2;
               feval = feval_2;
               Xim_calc = Xim_calc_2;
               Analysis.BBcoord_set = 2;
           end
       end
        fv = feval
        
        if fv >= 0.04
             Error.StepPhantomReconstruction = true;
        end
        params = [x0, feval]' ;
        %Modification by Song, 03/16/11
        %Check the 3D reconstruction error, if error larger than the
        %threshold, stop density calculation
        errorThreshold = 0.04;
        if params(end) >= errorThreshold
            Error.SXAbbRecon = true;
            error('SXA BB 3D reconstruction error is larger than the threshold!');
        end
        %end of modification

        figure(figuretodraw);
        redraw;
        plot(Xim_calc(:,1)/k-x0_shift, ymax_pixels/2+y0_shift - Xim_calc(:,2)/k,'*r');
        roi9stepsZETA2_projection(Xim_calc,index);
        bbReconParams = [x0, feval]' 
      