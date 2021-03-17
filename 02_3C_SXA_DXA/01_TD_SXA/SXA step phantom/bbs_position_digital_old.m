function [sort_coord] = bbs_position_digital()
    global Image figuretodraw coord Info Analysis Error flag
    
    kGE = 0.71;
    if Info.DigitizerId >= 5 & Info.DigitizerId <= 7
        crop_coef = kGE;
    else
        crop_coef = 1;
    end
        
    x_width = 690*crop_coef;
    y_height = 650*crop_coef;
    machine = Info.centerlistactivated;
    sz_image = size(Image.image);
    
    if Analysis.second_phantom == false
        rot_image = Image.image(1:y_height,x_width:end);
        rot_angle = 31.8;%rot_image2
        ycoord_shift = 0;
    else
        rot_image = Image.image(end-y_height:end,x_width:end);
        rot_angle =  -31.8;
        ycoord_shift = sz_image(1)-y_height;
    end
    
    rot_image = funcclim(rot_image,0,60000);
    %figure; imagesc(rot_image); colormap(gray);
    bkgr = background_phantomdigital(rot_image);
    %Analysis.BackGroundThreshold = bkgr;
    % Mask0=~(WindowFiltration2D(Image.OriginalImage==0,5)~=0);
    % Analysis.BackGround = Image.image>Analysis.BackGroundThreshold;
    % Analysis.BackGround=(WindowFiltration2D(Analysis.BackGround,3)>0); 
    
    ph_image = rot_image - bkgr ; %- 5000
    max_image = max(max(ph_image))
    a1 = uint8(ph_image/max_image*255); %12600
    %imwrite(rot_image2,'C:\Documents and Settings\smalkov\My Documents\Programs\SXAVersion6.2\phan3_init.tif', 'tif');
   % a = imread('phan3_init.tif', 'tif');
    conn1 = [0 1 0; 0 1 0; 0 1 0];
    %conn1 = conndef(2,'minimal');
    a1 = imclearborder(a1);
    %figure; imagesc(a1); colormap(gray);
   % h_init = figure;
 %   imagesc(a1); colormap(gray);
    sza = size(a1);
    %figure;imagesc(a1); colormap(gray); 
    %commented for GE machine
    %a1(1:round(100*crop_coef),sza(2)-round(10*crop_coef):sza(2)) = round(200*crop_coef);
    
     %figure;imagesc(a1); colormap(gray); 
     x_limit =  1350*crop_coef;
    if sz_image(2) > x_limit
       a1 = imclearborder(a1);
    end
    %figure;imagesc(a1); colormap(gray); 
  %  
   
    a = zeros(sza(1)+50, sza(2)+50);
   
    a(51:end, 1:sza(2)) = a1;
    %figure;
    %imagesc(a); colormap(gray); hold on;
    a(1:50, :) = a1(sza(1),sza(2)); 
    a(:,sza(2)+1:end ) = a1(sza(1),sza(2)); 
    %mrows = sza(1)+50;
    %ncols = sza(2)+50;
    %a = imresize(a1,[mrows ncols],'bilinear');
         
   %figure;
   %imagesc(a); colormap(gray); hold on;
   if sz_image(2) < x_limit
     b = imclearborder(a);
   else
     b = a;
   end
    % b = a;
   % clear a;
  %figure; imagesc(b); colormap(gray); hold off;
   
    J = imrotate(b,-rot_angle,'bilinear','crop'); %,'crop'28.85 -33,'crop'
    sza = size(b)
    szJ = size(J)
   % figure;imagesc(J); colormap(gray); 
   % 
    
   % rot_image2 = uint8(J/126000*255);
       
   %figure;
   %imagesc(J); colormap(gray); hold on;
  %  J_init = imrotate(J,28,'bilinear','crop'); 
   % figure;
   % imagesc(J_init); colormap(gray); hold on;
    
  %  h_init = figure;
  %  imagesc(J); colormap(gray); hold on;
    
    se5 = strel('disk', 9);
    %se3 = strel('rectangle',[10 9]);%working
    se3 = strel('disk',5);
    %se3 = strel('rectangle',[9 5]);
    %se4 = strel('rectangle',[6 10]);
    %b = imclose(J, se2);
    se2 = strel('rectangle', [20 40]);
    se22 = strel('rectangle', [40 20]);
     se21 = strel('rectangle', [200 100]);
     se_1 = round(60*crop_coef);
     se_2 = round(65*crop_coef);
    se = strel('rectangle',[se_1 se_2]);
    J_open = imopen(J,se); 
    
    %figure;imagesc(J_open); colormap(gray);
    % hold on;
    
    Z = imsubtract(J,J_open);
    %figure;
    %imagesc(Z); colormap(gray); hold on;
    
   % Z = imclearborder(Z);
   % figure;
   % imagesc(Z); colormap(gray); hold off;
   
    se2_1 = round(20*crop_coef);
    se2_2 = round(40*crop_coef);
    se = strel('rectangle',[se2_1 se2_2]);
    
    im_Z = imopen(Z,se2);
    
   %figure;
   %imagesc(im_Z); colormap(gray); hold on;
    Zs1 = imsubtract(Z,im_Z);
    
  %figure;imagesc(Zs1); colormap(gray);
  % hold on;
  %{  
    im_Z = imopen(Zs1,se22);
    Zs0 = imsubtract(Zs1,im_Z);
    
     im_Z2 = imopen(Zs0,se21);
    Zs2 = imsubtract(Zs0,im_Z2);
    
    Zs1 = imadjust(Zs2);
    figure;
    imagesc(Zs1); colormap(gray); hold on;
   %}
    %figure;
    %imagesc(Zs1); colormap(gray); hold on;
    
    %se2 = strel('rectangle',[20 40]);
    %Z_open = imopen(Z,se); 
    %level = graythresh(Zs1)
    
    bw = Zs1>0.3*max(max(Zs1));
    mm = max(max(Zs1))
    %bw = im2bw(Zs1,0.7);
       
    %figure;imagesc(bw); colormap(gray); 
     se3_1 = round(7*crop_coef);
     se3 = strel('disk',se3_1);
     
     bw2 = imerode(bw, se3);
   
     %bw2 = imerode(bw, se3);
     %figure;imagesc(bw2); colormap(gray);
    %  hold on;
     %bw = imdilate(bw2, se3);
     %figure;
     %imagesc(bw); colormap(gray); hold on;
     bw_init = imrotate(bw2,rot_angle,'bilinear','crop'); 
     szbw_init = size(bw_init)
     
    %figure;imagesc(bw_init); colormap(gray);
    % imagesc(bw_init); colormap(gray); hold on;
     %conn1 = conndef(2,'minimal');
    
    %{ 
     L1 = bwlabel(bw_init);
    stats1 = regionprops(L1,'all');
     st = stats1(1).Centroid
     h = figure;
     imagesc(bw_init); colormap(gray); hold on;
    %}
    
    %figure;
    %imagesc(bw2); colormap(gray); hold off;
  %  BW = imread('text.png');
   %{   
    bw2 = imdilate(bw_init, se3);
    bw3 = imclearborder(bw2);
    figure;
    imagesc(bw3); colormap(gray); hold off;
  %}  
    
   sz_bw = size(bw_init);
   xmax = sz_bw(2);
   ymax = sz_bw(1);
   sz_origimage = size(Image.image);
   xmax_orig = sz_origimage(2);
   if flag.small_paddle == false %xmax_orig > 1350
        c = [xmax-150, xmax, xmax];
        r = [1, 1, 150];
        BW_mask = 1-roipoly(bw,c,r);
        %figure;
        %imagesc(BW_mask); colormap(gray)
        bw_init = bw_init.*BW_mask;
   end
   
   se_3 = strel('disk',3);
   bw2 = imdilate(bw_init, se_3);
   %figure; imagesc(bw2); colormap(gray);
  % se_3n = strel('disk',4);
   bw_init = imerode(bw2, se_3);
   
   %figure; imagesc(bw_init); colormap(gray);
   % 
    
    L = bwlabel(bw_init);
    stats2 = regionprops(L,'all');
    ln = length(stats2)
    %figure(h_init); hold on;
  % axes;
    
    for i=1:ln
    % plot( stats2(i).Centroid(1),stats2(i).Centroid(2)-50 ,'.r','MarkerSize',7); hold on;
     %text(stats2(i).Centroid(1),stats2(i).Centroid(2)-70,num2str(i),'Color', 'y'); 
     xy_centroids(i,1:2) = [stats2(i).Centroid(1)+x_width,stats2(i).Centroid(2)-50];
    end
   % xy_centroids(1:ln,1:2) = [stats2(1:ln).Centroid(1)+x_width,stats2(1:ln).Centroid(2)-50]; 
    coord = xy_centroids;
    
    %%%%% corrected for 10th coord due to corner 09.25.12 SM
    [ymx,ind_y] = min(coord(:,2));
    [xmn,ind_x] =  max(coord(:,1));
    if (ln == 10) & (ind_y == ind_x)
        coord(ind_y,:) =[];
        ln = 9;
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      if ln > 5 & ln < 10  %len
        sort_coord = bbs_sortingZ2(coord,machine,Analysis.second_phantom, rot_angle )
        ln = length(sort_coord(:,1));
        sort_coord(:,2) = sort_coord(:,2) + ycoord_shift;
      else  
         sort_coord = coord;
         sort_coord(:,3) = (1:ln)';
         a = 'manual regime'
         Error.StepPhantomBBsFailure = true;
         stop;
      end
         hold on;
         figure(figuretodraw);
         redraw;
         plot(sort_coord(:,1), sort_coord(:,2),'.r','MarkerSize',7);
         hold on;

         for i=1:ln
             text(sort_coord(i,1),sort_coord(i,2)-20,num2str(sort_coord(i, 3)),'Color', 'y'); 
         end
          ;
   % save('coord_BBs6.txt', 'sort_coord', '-ascii');
    a = 1;
    
    %{
    sort_coord = bbs_sorting(coord)
     hold on;
     figure(figuretodraw);
     redraw;
     plot(sort_coord(:,1), sort_coord(:,2),'.r','MarkerSize',7);
     hold on;
      for i=1:ln
         text(sort_coord(i,1),sort_coord(i,2)-20,num2str(i),'Color', 'y'); 
      end
    
     figure(h_init); hold on;
    % axes; 
    for i=1:ln
     plot( sort_coord(i,1)-x_width,sort_coord(i,2),'.r','MarkerSize',7); hold on;
     text(sort_coord(i,1)-x_width,sort_coord(i,2)+30,num2str(i),'Color', 'y'); 
    % text(-70,num2str(i),'Color', 'y'); 
    % xy_centroids(i,1:2) = [stats2(i).Centroid(1)+x_width,stats2(i).Centroid(2)-50];
    
    end
    z_column = zeros(ln, 1);
    sort_coord(:,3) = z_column;
    %}
    %D = 'C:\Documents and Settings\smalkov\My Documents\SeleniaImages\Selenia_room116\1June\txt_files\';
    %file_name = [D,'2216078488.729.3326646739.47raw.txt']; 
   
   % D = 'C:\Documents and Settings\smalkov\My Documents\SeleniaImages\Selenia_room116\6June_thicknessangle\txt_files\';
   % file_name = [D,'2216078488.738.3327080834.155raw.txt'];
    
   
    