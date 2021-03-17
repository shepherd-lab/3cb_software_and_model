function [X, Y] = manualbbs_position()
    global Image ctrl
    x_cut = 600;
    sz = size(Image.image)
    %rot_image = Image.image(1:460,500:end);
    rot_image2 = uint8(Image.image(1:460,x_cut:end)/126000*255);
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
    m = 9;
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
     sz = size(A);
     A(:,1) = A(:,1) + x_cut;
     A(:,3) = zeros(sz(1), 1);
     D = 'C:\Documents and Settings\smalkov\My Documents\SeleniaImages\26April\with_phantom';
     file_name = [D, '1.2.840.113681.2211300624.767.3322825116.18.dcmrawpng.txt'];
     %D = 'C:\Documents and Settings\smalkov\My Documents\Programs\SXAVersion6.2\SXA step phantom\9step_phantom\';
     %file_name = [D, 'Calibrations7cm0degreesL1RCC-4-24-2006.txt'];
     %file_name = [D, 'StepCalibrate7cm5050.txt'];
     save(file_name,'A', '-ascii');
     