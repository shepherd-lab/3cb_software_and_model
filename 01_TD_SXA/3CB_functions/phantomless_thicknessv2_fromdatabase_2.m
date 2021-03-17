function  phantomless_thickness() %thickness = model_volume
  global Analysis Image thickness_mapreal Info ROI
  
    Database.Name = 'mammo_CPMC';
    [FileName,PathName] = uigetfile('\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\Results\Thickness_estimation\*.txt','Select the acquisition list txt-file ');
    acqs_filename = [PathName,FileName];     %'\'
    FileName_list =  FileName;
    acqs_filename = [PathName,'\',FileName];
    ACQIDList = textread(acqs_filename,'%u');
    sz1 = size(ACQIDList);
    len = sz1(1);
    key = 0;
     count = 0;
     count2=0;
    for index=1000:len
           try
        index2 = index   
    Info.AcquisitionKey = ACQIDList(index) 
%     Info.AcquisitionKey =  1000500227;
% %       SQLStatement = ['SELECT *  FROM [mammo_CPMC].[dbo].[DICOMinfo], [mammo_CPMC].[dbo].[acquisition]  where DICOMinfo.DICOM_ID = acquisition.DICOM_ID and acquisition_id = ',num2str(ACQIDList(index))];    
% %        a1=mxDatabase(Database.Name,SQLStatement)
%       mag_factor = cell2mat(a1(57));

     key = Info.AcquisitionKey
    
    RetrieveInDatabase('ACQUISITION');   
     %%%%%%%%%%%%%% conversion %%%%%%%%%%%%%%%
     h1 = findobj('tag','hInit')
         if ~isempty(h1)
             for k = 1:length(h1)
                 delete(h1(k));
             end
         end
        
        h2 = findobj('tag','h_slope')
         if ~isempty(h2)
             for n = 1:length(h2)
                 delete(h2(n));
             end
         end
    ROIDetection('ROOT'); 
    SkinDetection('FROMGUI');
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
    xdir_angle2 =  -0.0639* periph_Xgrad - 0.4605;
    if xdir_angle2 > 5
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
   
    resolution_cm = Analysis.Filmresolution/10;
    radius = 30;
    im_size = size(thickness_mapreal);
    center_xy = [0.4*ROI.columns,0.5*ROI.rows];
    circleroi = double(circle_roi(center_xy, radius,im_size));
    model_volume = sum(sum(thickness_mapreal))*resolution_cm^2;
    circleroi(circleroi==0) = NaN;
    thickness_circle = thickness_mapreal.*circleroi;
    thick_circlevect = thickness_circle(~isnan(thickness_circle));
    calc_thickness = mean(thick_circlevect);
    
    thickness_mapreal = [];
    thickness_circle = [];
    
    PhantomDetection;
    Periphery_calculation;
    
    
    SXA_volume = sum(sum(thickness_mapreal))*resolution_cm^2;
    thickness_circle = thickness_mapreal.*circleroi;
    thick_circlevect = thickness_circle(~isnan(thickness_circle));
    SXA_thickness = mean(thick_circlevect);

    
    resultsthick =  cell(1,8);
    resultsthick{1,   1   } = Info.AcquisitionKey;
    resultsthick{1,   2   } = model_volume;
    resultsthick{1,   3   } = SXA_volume;
    resultsthick{1,   4   } = calc_thickness;
    resultsthick{1,   5   } = SXA_thickness;
    resultsthick{1,   6   } = Analysis.Y_angle;
    resultsthick{1,   7   } = xdir_angle2;
    resultsthick{1,   8   } = vol_diff;
    
    write_3CtoExcel_thick(resultsthick);
           catch
           end
    end  
    a = 1;
    
end

