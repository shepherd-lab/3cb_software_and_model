function [sort_coord] = bbs_position_analog()
    global Image figuretodraw coord Info Database Error
    rot_image = Image.image(1:550,690:end); %rot_image2
       
    bkgr = background_phantomdigital(rot_image);
    ph_image = rot_image - bkgr;
    max_image = max(max(ph_image))
    a1 = uint8(ph_image/max_image*255); %12600
    sza = size(a1)
    a = zeros(sza(1)+50, sza(2)+50);
    figure;
    imagesc(a); colormap(gray); hold on;
    a(51:end, 1:sza(2)) = a1;
    figure;
    imagesc(a); colormap(gray); hold on;
    a(1:50, :) = a1(sza(1),sza(2)); 
    a(:,sza(2)+1:end ) = a1(sza(1),sza(2)); 
          
   figure;
   imagesc(a); colormap(gray); hold on;
   
    b = imclearborder(a);
    clear a;
    figure;
    imagesc(b); colormap(gray); hold off;
   
    J = imrotate(b,-33,'bilinear','crop'); %,'crop'28.85 -33,'crop'-31.8
    sza = size(b)
    szJ = size(J)
    figure;
    imagesc(J); colormap(gray); 
     
   %se3 = strel('rectangle',[10 9]);%working
    se3 = strel('disk',5);
    %se3 = strel('rectangle',[9 5]);
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
    
          thresh = 0.25;
        bw = Zs1>thresh*max(max(Zs1));
        se3 = strel('disk',7);
        bw2 = imerode(bw, se3);
        Lst = bwlabel(bw2);
        stats3 = regionprops(Lst,'all');
        len = length(stats3);
   %if len > 5    
       while len > 8
            thresh = thresh+0.05;
            bw = Zs1>thresh*max(max(Zs1));
            bw2 = imerode(bw, se3);
            Lst = bwlabel(bw2);
            stats3 = regionprops(Lst,'all');
            len = length(stats3);
       end     

        mm = max(max(Zs1))
        %bw = im2bw(Zs1,0.7);

       figure;
        imagesc(bw); colormap(gray); hold on;
         se3 = strel('disk',5); %  for UK - 5, for CPMC - 7
         bw2 = imerode(bw, se3);
        %figure;
        % imagesc(bw2); colormap(gray); hold on;

        % bw = imdilate(bw2, se3);
        % figure;
        % imagesc(bw); colormap(gray); hold on;

         bw_init = imrotate(bw2,33,'bilinear','crop'); %31.8
         szbw_init = size(bw_init)
         figure;
         imagesc(bw_init); colormap(gray); hold on;
         %conn1 = conndef(2,'minimal');
        %figure;
        %imagesc(bw2); colormap(gray); hold off;
      %  BW = imread('text.png');
       %{   
        bw2 = imdilate(bw_init, se3);
        bw3 = imclearborder(bw2);
        figure;
        imagesc(bw3); colormap(gray); hold off;
      %}  
       %figure;
       %imagesc(bw_init); colormap(gray); 
        L = bwlabel(bw_init);
        stats2 = regionprops(L,'all');
        ln = length(stats2)

        %figure(h_init); hold on;
      % axes;

        for i=1:ln
        %plot( stats2(i).Centroid(1),stats2(i).Centroid(2)-50 ,'.r','MarkerSize',7); hold on;
        %text(stats2(i).Centroid(1),stats2(i).Centroid(2)-70,num2str(i),'Color', 'y'); 
         xy_centroids(i,1:2) = [stats2(i).Centroid(1)+690,stats2(i).Centroid(2)-50];
        end
       % xy_centroids(1:ln,1:2) = [stats2(1:ln).Centroid(1)+690,stats2(1:ln).Centroid(2)-50]; 
        coord = xy_centroids
      if ln > 5   %len
       %xm = strmatch('UKMarsden', Info.StudyID, 'exact');
        xm = strmatch('mammo_Marsden', Database.Name, 'exact');
       if xm > 0  
           sort_coord = bbs_sortingZ2(coord, xm)
       else
           sort_coord = bbs_sortingZ1(coord)
       end
        ln = length(sort_coord(:,1));
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
          
        %{
        figure(h_init); hold on;
        for i=1:ln
         plot( sort_coord(i,1)-690,sort_coord(i,2),'.r','MarkerSize',7); hold on;
         text(sort_coord(i,1)-690,sort_coord(i,2)+30,num2str(i),'Color', 'y'); 
        end
        %}
        %z_column = zeros(ln, 1);
        %sort_coord(:,3) = z_column;
        %D = 'C:\Documents and Settings\smalkov\My Documents\SeleniaImages\Selenia_room116\1June\txt_files\';
        %file_name = [D,'2216078488.729.3326646739.47raw.txt']; 

       % D = 'C:\Documents and Settings\smalkov\My Documents\SeleniaImages\Selenia_room116\6June_thicknessangle\txt_files\';
       % file_name = [D,'2216078488.738.3327080834.155raw.txt'];
  