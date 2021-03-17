function create_3Ctemplate()
     global ctrl Image
    
     global ROI Image Tmask3C
   Tmask3C = zeros(size(Image.image));
%     Tmask3C = zeros(2047,1663);
%{
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
   %}  
     
    roi_thickness = [4, 4, 4.317, 4.486,4.661,4.959];
     
    for i=1:6
            set(ctrl.text_zone,'String',['Drag ',num2str(i),' box on phantom area']);
            k = waitforbuttonpress;
            point1 = get(gca,'CurrentPoint');    % button down detected
            finalRect = rbbox;                   % return figure units
            point2 = get(gca,'CurrentPoint');    % button up detected
            point1 = point1(1,1:2);              % extract x and y
            point2 = point2(1,1:2);
            p1 = round(min(point1,point2));             % calculate locations
            offset = round(abs(point1-point2));         % and dimensions
            x_coord(i,1:2) = [p1(1) p1(1)+offset(1)];
            y_coord(i,1:2) = [p1(2) p1(2)+offset(2)];
             funcBox(x_coord(i,1),y_coord(i,1),x_coord(i,2),y_coord(i,2),'blue'); 
            x_rect = [x_coord(i,1) x_coord(i,2) x_coord(i,2) x_coord(i,1)];
            y_rect = [y_coord(i,1) y_coord(i,1) y_coord(i,2) y_coord(i,2)];
            mask = roipoly(Image.image,x_rect,y_rect)*roi_thickness(i);
            Tmask3C = imadd(Tmask3C,mask);
         
    end
%       file_name='\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\AL_SeleniaData\templates\20081211_20-30_3C.txt'
%          save(file_name,'coord', '-ascii');
    figure;imagesc(Tmask3C);colormap(gray);
      a=1;
      
      
       