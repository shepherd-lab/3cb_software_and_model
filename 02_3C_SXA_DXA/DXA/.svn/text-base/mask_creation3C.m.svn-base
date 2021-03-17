function mask_creation3C()
    global ROI Image Tmask3C
    
%     Tmask3C = zeros(2047,1663);
    y_26cm = ROI.ymin + (ROI.ymax-ROI.ymin)/3;
    y_64cm = y_26cm + (ROI.ymax-ROI.ymin)/3;
    col2cm = [ROI.xmin  ROI.xmax  ROI.xmax ROI.xmin];
    row2cm = [ROI.ymin ROI.ymin y_26cm y_26cm];
    mask2cm = roipoly(Image.image,col2cm,row2cm)*2.08;
    
    col6cm = [ROI.xmin  ROI.xmax  ROI.xmax ROI.xmin];
    row6cm = [y_26cm y_26cm y_64cm y_64cm];
    mask6cm = roipoly(Image.image,col6cm,row6cm)*6.08;
    
    col4cm = [ROI.xmin  ROI.xmax  ROI.xmax ROI.xmin];
    row4cm = [y_64cm y_64cm ROI.ymax ROI.ymax];
    mask4cm = roipoly(Image.image,col4cm,row4cm)*4.08;
    
    Tmask3C = imadd(mask2cm,mask6cm);
    Tmask3C = imadd(Tmask3C,mask4cm);
    figure;imagesc(Tmask3C);colormap(gray);
    a = 1;
    
    
    