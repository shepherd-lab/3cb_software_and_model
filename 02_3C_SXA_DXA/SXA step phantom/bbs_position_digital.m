function [sort_coord] = bbs_position_digital()
    global Image figuretodraw coord Info Analysis Error %h_init
   
    y_height = 650;
    yk = 100;
    xk = 100;
    machine = Info.centerlistactivated;
    sz_image = size(Image.image);
    
    if Analysis.second_phantom == false
        rot_image = Image.image(1:y_height,690:end);
        rot_angle = 31.8;%rot_image2
        ycoord_shift = 0;
    else
        rot_image = Image.image(end-y_height:end,690:end);
        rot_angle =  -31.8;
        ycoord_shift = sz_image(1)-y_height;
    end
    
%     figure; imagesc(Image.image); colormap(gray);
%     figure; imagesc(rot_image); colormap(gray);
    rot_image = funcclim(rot_image,0,60000);
%     figure; imagesc(rot_image); colormap(gray);
    bkgr = background_phantomdigital(rot_image);
    %Analysis.BackGroundThreshold = bkgr;
    % Mask0=~(WindowFiltration2D(Image.OriginalImage==0,5)~=0);
    % Analysis.BackGround = Image.image>Analysis.BackGroundThreshold;
    % Analysis.BackGround=(WindowFiltration2D(Analysis.BackGround,3)>0); 
    
    ph_image = rot_image - bkgr;
    max_image = max(max(ph_image))
    a1 = uint8(ph_image/max_image*255); %12600
     conn1 = [0 1 0; 0 1 0; 0 1 0];
     sza = size(a1);
    %figure;imagesc(a1); colormap(gray); 
%     a1(1:100,sza(2)-10:sza(2)) = 200;  commented SM 080615
     %figure;imagesc(a1); colormap(gray); 
    if sz_image(2) > 1350
        a1(1:100,sza(2)-2:sza(2)) = 200;
       a1 = imclearborder(a1);
    end
% %       figure;imagesc(a1); colormap(gray); 
  %  
   
    a = zeros(sza(1)+xk, sza(2)+yk);
   
    a(xk+1:end, 1:sza(2)) = a1;
    %figure;
    %imagesc(a); colormap(gray); hold on;
    a(1:xk, :) = a1(sza(1),sza(2)); 
    a(:,sza(2)+1:end ) = a1(sza(1),sza(2)); 
    %mrows = sza(1)+50;
    %ncols = sza(2)+50;
    %a = imresize(a1,[mrows ncols],'bilinear');
         
   %figure;
   %imagesc(a); colormap(gray); hold on;
   if sz_image(2) < 1350
     b = imclearborder(a);
   else
     b = a;
   end
    % b = a;
   % clear a;
%  figure; imagesc(b); colormap(gray); hold off;
   
    J = imrotate(b,-rot_angle,'bilinear','crop'); %,'crop'28.85 -33,'crop'
    sza = size(b)
    szJ = size(J)
%     figure; imagesc(J); colormap(gray); 
    
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
    se = strel('rectangle',[60 65]);
    J_open = imopen(J,se); 
    
    %figure;
    %imagesc(J_open); colormap(gray); hold on;
    
    Z = imsubtract(J,J_open);
    %figure;
    %imagesc(Z); colormap(gray); hold on;
    
   % Z = imclearborder(Z);
   % figure;
   % imagesc(Z); colormap(gray); hold off;
    
    im_Z = imopen(Z,se2);
    
   %figure;
   %imagesc(im_Z); colormap(gray); hold on;
    Zs1 = imsubtract(Z,im_Z);
    
  %figure;
  %imagesc(Zs1); colormap(gray); hold on;
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
       
  % figure;
  %  imagesc(bw); colormap(gray); hold on;
     se3 = strel('disk',7);
     se1 = strel('disk',1);
     bw2 = imerode(bw, se3);
     bw2 = imdilate(bw2, se1);
% %      figure;imagesc(bw2); colormap(gray); hold on;
     bw_init = imrotate(bw2,rot_angle,'bilinear','crop'); 
     szbw_init = size(bw_init)
       
   sz_bw = size(bw_init);
   xmax = sz_bw(2);
   ymax = sz_bw(1);
   sz_origimage = size(Image.image);
   xmax_orig = sz_origimage(2);
   if xmax_orig > 1350
        c = [xmax-150, xmax, xmax];
        r = [1, 1, 150];
        BW_mask = 1-roipoly(bw,c,r);
        %figure;
        %imagesc(BW_mask); colormap(gray)
        bw_init = bw_init.*BW_mask;
   end
%    figure;imagesc(bw_init); colormap(gray);
    L = bwlabel(bw_init);
    stats2 = regionprops(L,'all');
    ln = length(stats2)
   nrel = 6;
   
    while (ln < 8 & nrel > 1)
        se3 = strel('disk',nrel);
        se1 = strel('disk',1)
     bw2 = imerode(bw, se3);
     bw2 = imdilate(bw2, se1);
     se31 = strel('rect',[1 4]);
     bw2 = imerode(bw2, se31);
% %      figure;imagesc(bw2); colormap(gray); hold on;
     bw_init = imrotate(bw2,rot_angle,'bilinear','crop'); 
     szbw_init = size(bw_init)
%        bw_init(1:250,:)=0;
   sz_bw = size(bw_init);
   xmax = sz_bw(2);
   ymax = sz_bw(1);
   sz_origimage = size(Image.image);
   xmax_orig = sz_origimage(2);
   if xmax_orig > 1350
        c = [xmax-150, xmax, xmax];
        r = [1, 1, 150];
        BW_mask = 1-roipoly(bw,c,r);
        %figure;
        %imagesc(BW_mask); colormap(gray)
        bw_init = bw_init.*BW_mask;
   end
  
    L = bwlabel(bw_init);
    stats2 = regionprops(L,'all');
    ln = length(stats2)
    nrel = nrel-1;
    end
% %     
     
    
    nrel2 = 1;
      while ln> 9
             se3 = strel('disk',nrel2);
             
%      bw2 = imdilate(bw, se3);
     bw2 = imerode(bw, se3);
%      figure;imagesc(bw2); colormap(gray); hold on;
    
     bw_init = imrotate(bw2,rot_angle,'bilinear','crop'); 
     szbw_init = size(bw_init)
       
   sz_bw = size(bw_init);
   xmax = sz_bw(2);
   ymax = sz_bw(1);
   sz_origimage = size(Image.image);
   xmax_orig = sz_origimage(2);
   if xmax_orig > 1350
        c = [xmax-150, xmax, xmax];
        r = [1, 1, 150];
        BW_mask = 1-roipoly(bw,c,r);
        %figure;
        %imagesc(BW_mask); colormap(gray)
        bw_init = bw_init.*BW_mask;
   end
     
    L = bwlabel(bw_init);
    stats2 = regionprops(L,'all');
    ln = length(stats2)
    nrel2 = nrel2+1;
   
      end
    
     se3 = strel('disk',3);   
     se2 = strel('disk',2); 
     se4 = strel('disk',4);
     
      bw_init = imdilate( bw_init, se3);
     bw_init = imerode( bw_init, se2);
     L = bwlabel(bw_init);
    stats2 = regionprops(L,'all');
%     stats2(6).Centroid(1:2) = [318,538];  
    ln = length(stats2)
    nrel2 = nrel2+1;
    
     
    %figure(h_init); hold on;
  % axes;
    
    for i=1:ln
    % plot( stats2(i).Centroid(1),stats2(i).Centroid(2)-50 ,'.r','MarkerSize',7); hold on;
     %text(stats2(i).Centroid(1),stats2(i).Centroid(2)-70,num2str(i),'Color', 'y'); 
     xy_centroids(i,1:2) = [stats2(i).Centroid(1)+690,stats2(i).Centroid(2)-yk];
    end
   % xy_centroids(1:ln,1:2) = [stats2(1:ln).Centroid(1)+690,stats2(1:ln).Centroid(2)-50]; 
    coord = xy_centroids
    
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
     plot( sort_coord(i,1)-690,sort_coord(i,2),'.r','MarkerSize',7); hold on;
     text(sort_coord(i,1)-690,sort_coord(i,2)+30,num2str(i),'Color', 'y'); 
    % text(-70,num2str(i),'Color', 'y'); 
    % xy_centroids(i,1:2) = [stats2(i).Centroid(1)+690,stats2(i).Centroid(2)-50];
    
    end
    z_column = zeros(ln, 1);
    sort_coord(:,3) = z_column;
    %}
    %D = 'C:\Documents and Settings\smalkov\My Documents\SeleniaImages\Selenia_room116\1June\txt_files\';
    %file_name = [D,'2216078488.729.3326646739.47raw.txt']; 
   
   % D = 'C:\Documents and Settings\smalkov\My Documents\SeleniaImages\Selenia_room116\6June_thicknessangle\txt_files\';
   % file_name = [D,'2216078488.738.3327080834.155raw.txt'];
    
   
    