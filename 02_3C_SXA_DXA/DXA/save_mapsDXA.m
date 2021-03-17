function save_mapsDXA()
global Image ROI BreastMask
    res = 0.014;
    
    ShowDXAImage_aurelie('THICKNESS');
    thickness=Image.thickness(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1).*BreastMask;
    thickness=thickness.*BreastMask;
    thickness = medfilt2(thickness); 
    thickness=funcclim(thickness,0,3);
    mean_thick = mean(mean(thickness));
    breast_mask = thickness>mean_thick;
    thickness=thickness.*breast_mask;
    
    ShowDXAImage_aurelie('MATERIAL');
    material=Image.material(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1).*breast_mask;
    material = medfilt2(material); 
    material=funcclim(material,-5,130);
    attenuation = Image.LE(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1).*breast_mask;     
    file_name = '\\researchstg\aaStudies\Breast Studies\Stiffness_mammo\Results\DXA\B2056.mat';
    breast_density=sum(sum(material.*thickness))/sum(sum(thickness)) 
    breast_volume = sum(sum(thickness*(res)^2)) %in cm3
    save(file_name, 'material','thickness','breast_mask','attenuation','breast_density','breast_volume');
    a = 1;


end

