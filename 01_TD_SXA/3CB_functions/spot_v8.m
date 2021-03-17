function spot_v8()
  flag.Pectoral_MLOView = false;
        root_dir = '\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\Moffitt\';
        mat_thick = ['LE',Info. ViewPosition(1:2),'raw_Mat.mat'];
        lehe_fnames.mat_thickness = [root_dir,Info.PatientID(1:7),'\png_files\',mat_thick];
        load(lehe_fnames.mat_thickness);
%         Load_thicknessFLIPROIauto(lehe_fnames.mat_thickness);
        thickness_mapproj = thickness_map;
        thickness_mapreal = thickness_map;
        BreastMask = circle_spotpaddle;
        Analysis.rx = 0;
        Analysis.ry = 0;
         CallBack=get(ctrl.Density,'callback');  %press on Density button
         eval(CallBack); %call Computedensity
               
        [fileNameDensity, fileNameThickness] = genFileNameDenThk(Info.fname, Info.Version);
        
        Analysis.FileNameThickness = fileNameThickness;
        
        Analysis.FileNameThickness2 = [Analysis.FileNameThickness(1:end-4),'SXA.png'];
        imwrite(uint16(Analysis.SXAthickness_mapproj*1000), Analysis.FileNameThickness2, 'png');
        %%%%%%%%%%%%% 3C Study  %%%%%%%%%%%%%
        fNameThick = [Info.fname(1:end-4), '_Thickness', Info.fname(end-3:end)];
        szim = size(Image.OriginalImage);
        thickness_map = zeros(szim);
        thickness_map(ROI.ymin+1:ROI.ymin+ROI.rows,ROI.xmin+1:ROI.xmin+ROI.columns)   = thickness_mapproj*1000;
        imwrite(uint16(thickness_map), Analysis.FileNameThickness, 'png');

end

