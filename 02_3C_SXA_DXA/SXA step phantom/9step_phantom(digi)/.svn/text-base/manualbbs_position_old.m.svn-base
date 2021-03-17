function [X, Y] = manualbbs_position()
    global Image ctrl
    rot_image = Image.image(1:460,690:end);
    rot_image2 = uint8(Image.image(1:460,690:end)/126000*255);
    imwrite(rot_image2,'C:\Documents and Settings\smalkov\My Documents\Programs\SXAVersion6.2\phan3_init.tif', 'tif');
    a = imread('phan3_init.tif', 'tif');
    %conn1 = [0 1 0; 0 1 0; 0 1 0];
    %conn1 = conndef(2,'minimal');
   % im_a = imclearborder(a);
    scrsz = get(0,'ScreenSize');
      
    h_init = figure;
    imagesc(a); colormap(gray); title('Now, you can select the first set of coordinates');hold on;
     set(h_init,'Position',[1 scrsz(4)*7/8 scrsz(3)*7/8 scrsz(4)*7/8]);
    %set(ctrl.text_zone,'String','Now, you can select the first set of coordinates');   
    m = 8;
    [x1,y1] = ginput(m);
    a1 = [x1,y1]
    title('Now, you can select the second set of coordinates');hold on; 
   % set(ctrl.text_zone,'String','Now, you can select the first set of coordinates');  
     [x2,y2] = ginput(m);
     a2 = [x2,y2]
     title('Now, you can select the third set of coordinates');hold on;
     %set(ctrl.text_zone,'String','Now, you can select the first set of coordinates');  
     [x3,y3] = ginput(m);
     a3 = [x3,y3]
      %set(ctrl.text_zone,'String','OK!');
     title('Finished, OK');hold on;
      A = (a1 + a2 + a3)/3
     da1 = a1 - A
     da2 = a2 - A
     da3 = a3 - A