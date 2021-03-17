function  phantomless_thickness() %thickness = model_volume
  global Analysis Image thickness_mapreal Info
   
% LASTN = maxNumCompThreads('automatic')
   Analysis.resolution_cm =  Analysis.Filmresolution/10;
   breast_area = Analysis.Surface*Analysis.resolution_cm*Analysis.resolution_cm;
   if ~isempty(strfind(Info.targetmaterial,'TUNGSTEN'))    %MOFF  and Mayo set                       
           model_volume = -52.93647 + 1.411405*breast_area + 5.695201*Info.paddle_type + 0.516916*Info.thickness_dicom*breast_area*0.1;
        elseif ~isempty(strfind(Info.targetmaterial,'MOLYBDENUM'))  %SFMR set
           vol_member = Info.thickness_dicom*breast_area*0.1; %breast area in cm pixel number*0.014*0.014
           vol2_member = vol_member*vol_member;
           model_volume = -53.14202 + 1.109783*breast_area + 0.5328*Info.force + 0.602106*vol_member + 0.000001675*vol2_member;
   else
          model_volume= [];
   end
%     model_volume = 769.4582;
%     roimodel_volume = 1.1032*model_volume + 9.2845;
%     roimodel_volume =884.6526;
    
%    model_volume = A*thickness_dicom*breast_area + B*breast_area + C;
   
     sz = size(Image.OriginalImage); % 1407 1408 
    Analysis.xmax_pixels = sz(2);
    Analysis.ymax_pixels = sz(1);
    Analysis.tx = 0.75*Analysis.xmax_pixels*Analysis.resolution_cm;    % tx /0.014); % 
    Analysis.ty = 0.25*Analysis.ymax_pixels*Analysis.resolution_cm;    % ty  /0.014);
    
     thick_0 = Info.thickness_dicom*0.1 -1 ; %- 1.2;
%     thick_0 = 4.5;
    periph_Xgrad = periphery_gradient();
    xdir_angle =  -0.0639* periph_Xgrad - 0.4605;
    if xdir_angle > 5
        xdir_angle = 5;
    end
%      xdir_angle = 1;
%        periph_Xgrad = periphery_gradient();
%        a_coef = 1;
%        b_coef = 0;
%        xdir_angle = a_coef*periph_Xgrad + b_coef;
       
%        for i = 1:2  
      tic
           [thickness,feval] = find_thickness(thick_0,model_volume,xdir_angle)
           thick_0 = thickness
%        end
      t1 = toc
    calc_volume = volume_calculation(thickness,xdir_angle)
    vol_diff = model_volume - calc_volume
    
    resultsthick =  cell(1,7);
    resultsthick{1,   1   } = acq_id;
    resultsthick{1,   2   } = model_volume;
    resultsthick{1,   3   } = Analysis.breast_volume;
    resultsthick{1,   4   } = Analysis.calc_thickness;
    resultsthick{1,   5   } = Analysis.thickness;
    resultsthick{1,   6   } = Analysis.y_angle;
    resultsthick{1,   7   } = Analysis.xdir_angle;
    
    write_3CtoExcel_thick(resultsthick);
    
    a = 1;
    
end

