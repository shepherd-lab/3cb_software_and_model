function saveMat3C()
global  ROI Image   
%using calibration form 
%  patient_ID = 'B2056'; %20101223
  patient_ID = 'B2064';  %20110114
 pname = '\\researchstg\aaStudies\Breast Studies\Stiffness_mammo\Results\DXA\';
 NIP = [];
 fname = [patient_ID,'_slices_','.mat'];
 fname_results = [pname,fname];
 density_mask = Image.thickness > 0.2;
 density = Image.material.*density_mask;
 thickness = Image.thickness.*density_mask;
 NIP.density = density(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1);
 NIP.thickness = thickness(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1);
 NIP.density = medfilt2(NIP.density, [3 3]);
 NIP.thickness = medfilt2(NIP.thickness, [3 3]);
 NIP.density =  funcclim(NIP.density,-5,135);
 NIP.thickness =  funcclim(NIP.thickness,0,2);
 figure;imagesc(NIP.density);colormap(gray);
 figure;imagesc(NIP.thickness);colormap(gray);
 save(fname_results,'NIP','-append'); % 
 
 a = 1;
