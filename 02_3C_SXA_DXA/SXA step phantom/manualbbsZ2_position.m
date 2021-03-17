function  sort_coord = manualbbsZ1_position()
    global Image ctrl Info h_init Analysis
    x_cut = 600;
    y_cut = 500;
    sz = size(Image.image)
    
     if Analysis.second_phantom == false
        %rot_image = Image.image(1:550,690:end);
        a = uint8(Image.image(1:y_cut,x_cut:end)/126000*255);
        ycoord_shift = 0;
    else
        %rot_image = Image.image(end-550:end,690:end);
        a = uint8(Image.image(end-y_cut:end,x_cut:end)/126000*255);
        ycoord_shift = sz(1)-y_cut;
     end
    
     %a = uint8(Image.image(1:y_cut,x_cut:end)/126000*255);
    
    %rot_image = Image.image(1:460,500:end);
    %rot_image2 = uint8(Image.image(1:y_cut,x_cut:end)/126000*255);
    %imwrite(rot_image2,'C:\Documents and Settings\smalkov\My Documents\Programs\SXAVersion6.2\phan3_init.tif', 'tif');
   % a = imread('phan3_init.tif', 'tif');
   
   %conn1 = [0 1 0; 0 1 0; 0 1 0];
    %conn1 = conndef(2,'minimal');
   % im_a = imclearborder(a);
    scrsz = get(0,'ScreenSize');
    
    h_init = figure;
    imagesc(a); colormap(gray); title('Now, you can select the first set of coordinates');hold on;
     set(h_init,'Position',[1 scrsz(4)*1/8 scrsz(3)*7/8 scrsz(4)*7/8]);
     
     %set(ctrl.text_zone,'String','Now, you can select the first set of coordinates');   
    m = 9;
    [x1,y1] = ginput(m);
    A = [x1,y1]
    
    %{
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
     %}
     
     sz = size(A);
     A(:,1) = A(:,1) + x_cut;
     %A(:,3) = zeros(sz(1), 1);
     A(:,3) = (1:m)';
     sort_coord = A(A(:,1)<=2*x_cut&A(:,2)>0,:);
    sort_coord = A;
    
    sort_coord(:,2) = sort_coord(:,2) + ycoord_shift;
     %D = 'C:\Documents and Settings\smalkov\My Documents\SeleniaImages\26April\with_phantom';
     
      D = 'C:\Documents and Settings\smalkov\My Documents\Programs\';  
      file_name = [D,num2str(Info.AcquisitionKey),'.txt']; 
     % save(file_name,'A', '-ascii');
    % D = 'C:\Documents and Settings\smalkov\My Documents\SeleniaImages\Selenia_room116\15May\txt_files\';
     %file_name = [D,'2216078488.713.3325174331.47z.txt'];
     
     %file_name = [D, '1.2.840.113681.2211300624.767.3322825116..dcmrawpng.txt'];
     %file_name = [D, '1.2.840.113681.2211300624.2640.3322767867.222.dcmrawpng.txt'];
     % file_name = [D, '1.2.840.113681.2211300639.2608.3322767109.248.dcmrawpng.txt'];
     
      %D = 'C:\Documents and Settings\smalkov\My Documents\Programs\SXAVersion6.2\SXA step phantom\9step_phantom\';
     %file_name = [D, 'Calibrations7cm0degreesL1RCC-4-24-2006.txt'];
     %file_name = [D, 'StepCalibrate7cm5050.txt'];
    % for i=1:m
          plot( sort_coord(:,1)-x_cut,sort_coord(:,2) ,'.r','MarkerSize',7); hold on;
         %plot( stats2(i).Centroid(1),stats2(i).Centroid(2)-50 ,'.r','MarkerSize',7); hold on;
       % text(stats2(i).Centroid(1),stats2(i).Centroid(2)-70,num2str(i),'Color', 'y'); 
          
   % end
    
     