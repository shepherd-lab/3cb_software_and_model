function [sort_coord] = bbs_position_digital()
    global Image figuretodraw coord Info Analysis Error%h_init
    machine = Info.centerlistactivated;
    %rot_image = Image.image(1:550,690:end); %rot_image2
    rot_image = Image.image;
    bkgr = background_phantomdigital(rot_image);
    %Analysis.BackGroundThreshold = bkgr;
    % Mask0=~(WindowFiltration2D(Image.OriginalImage==0,5)~=0);
    % Analysis.BackGround = Image.image>Analysis.BackGroundThreshold;
    % Analysis.BackGround=(WindowFiltration2D(Analysis.BackGround,3)>0); 
    res = 0.014;
    ph_image = rot_image - bkgr;
    max_image = max(max(ph_image))
    a1 = uint8(ph_image/max_image*255); %12600
    %imwrite(rot_image2,'C:\Documents and Settings\smalkov\My Documents\Programs\SXAVersion6.2\phan3_init.tif', 'tif');
   % a = imread('phan3_init.tif', 'tif');
    conn1 = [0 1 0; 0 1 0; 0 1 0];
    %conn1 = conndef(2,'minimal');
   % im_a = imclearborder(a);
   % h_init = figure;
 %   imagesc(a1); colormap(gray);
   %{
   za = size(a1)
    a = zeros(sza(1)+50, sza(2)+50);
    %figure;
    %imagesc(a); colormap(gray); hold on;
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
   
    b = imclearborder(a);
   % b = a;
   % clear a;
    %figure;
    %imagesc(b); colormap(gray); hold off;
   
    J = imrotate(b,-31.8,'bilinear','crop'); %,'crop'28.85 -33,'crop'
    sza = size(b)
    szJ = size(J)
   % figure;
   % imagesc(J); colormap(gray); 
    
   % rot_image2 = uint8(J/126000*255);
       
  % figure;
  % imagesc(J); colormap(gray); hold on;
  %  J_init = imrotate(J,28,'bilinear','crop'); 
   % figure;
   % imagesc(J_init); colormap(gray); hold on;
    
  %  h_init = figure;
  %  imagesc(J); colormap(gray); hold on;
    %}
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
    J_open = imopen(a1,se); 
    
    %figure;
    %imagesc(J_open); colormap(gray); hold on;
    
    Z = imsubtract(a1,J_open);
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
       
   %figure;
    %imagesc(bw); colormap(gray); hold on;
     se3 = strel('disk',7);
     bw2 = imerode(bw, se3);
   
     %bw2 = imerode(bw, se3);
     %figure;
     %imagesc(bw2); colormap(gray); hold on;
     %bw = imdilate(bw2, se3);
     %figure;
     %imagesc(bw); colormap(gray); hold on;
     bw_init = bw2; 
     szbw_init = size(bw_init)
     %figure;
     %imagesc(bw_init); colormap(gray); hold on;
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
   %  figure;
   % imagesc(bw_init); colormap(gray);
    L = bwlabel(bw_init);
    stats2 = regionprops(L,'all');
    ln = length(stats2)
    %figure(h_init); hold on;
  % axes;
    
    for i=1:ln
    % plot( stats2(i).Centroid(1),stats2(i).Centroid(2)-50 ,'.r','MarkerSize',7); hold on;
     %text(stats2(i).Centroid(1),stats2(i).Centroid(2)-70,num2str(i),'Color', 'y'); 
     xy_centroids(i,1:2) = [stats2(i).Centroid(1),stats2(i).Centroid(2)];
    end
   % xy_centroids(1:ln,1:2) = [stats2(1:ln).Centroid(1)+690,stats2(1:ln).Centroid(2)-50]; 
    coord = xy_centroids
    sort_coord = coord;
    %{
      if ln > 5 & ln < 10  %len
        sort_coord = bbs_sortingZ2(coord,machine)
        ln = length(sort_coord(:,1));
      else  
         sort_coord = coord;
         sort_coord(:,3) = (1:ln)';
         a = 'manual regime'
         Error.StepPhantomBBsFailure = true;
         stop;
      end
      %}
         hold on;
         figure(figuretodraw);
         redraw;
         plot(sort_coord(:,1), sort_coord(:,2),'.r','MarkerSize',5);
         hold on;

         for i=1:ln
             text(sort_coord(i,1),sort_coord(i,2)-20,num2str(i),'Color', 'y'); 
         end
          ;
  
    %%
    x0 = 0;
    y0 = 1032.4;
     x5_1 = 13.02;
     x5_3 = 20.49;
     x5_4 = 17.91;
     x5_5 = 16.94;
     x5_6 = 17.84;
     x5_7 = 20.38;
     x5_9 = 12.83;
     
     x3_1 = 4.19;
     x3_3 = 4.19;
     x3_4 = 4.19;
     x3_5 = 4.19;
     x3_6 = 4.19;
     x3_7 = 4.19;
     x3_9 = 4.19;
   
    
    Line1.x1 = coord(10,1);
    Line1.x2 = coord(13,1);
    Line1.y1 = coord(10,2);
    Line1.y2 = coord(13,2);
    x1_1 = sqrt((Line1.x1-Line1.x2)^2 + (Line1.y1-Line1.y2)^2)*res;
    x2_1 = sqrt((Line1.x2-x0)^2 + (Line1.y2-y0)^2)*res;
    x4_1 = sqrt((Line1.x1-x0)^2 + (Line1.y1-y0)^2)*res - x5_1;
    B_1 = x2_1 / (x1_1 + x4_1);
    A_1 = (x5_1 + x4_1) / x4_1;
    S_1 = B_1 * x3_1 / (1 - B_1/A_1);
    h_1 = S_1 / A_1;
    
     delta1 = (Line1.y2 - Line1.y1)/(Line1.x1 - Line1.x2);
     Line1.x0 = 1;
     Line1.y0 = (Line1.x2-1) * delta1 + Line1.y2;
     figure(figuretodraw); hold on; plot([Line1.x0 Line1.x2],[Line1.y0 Line1.y2],'Linewidth',1,'color','b');hold on;
    
     %
    Line2.x1 = coord(15,1);
    Line2.x2 = coord(17,1);
    Line2.y1 = coord(15,2);
    Line2.y2 = coord(17,2);
     delta2 = (Line2.y2 - Line2.y1)/(Line2.x1 - Line2.x2);
     Line2.x0 = 1;
     Line2.y0 = (Line2.x2-1) * delta2 + Line2.y2;
     figure(figuretodraw); hold on; plot([Line2.x0 Line2.x2],[Line2.y0 Line2.y2],'Linewidth',1,'color','b');
     %}
     
     Line3.x1 = coord(20,1);
    Line3.x2 = coord(27,1);
    Line3.y1 = coord(20,2);
    Line3.y2 = coord(27,2);
     x1_3 = sqrt((Line3.x1-Line3.x2)^2 + (Line3.y1-Line3.y2)^2)*res;
     x2_3 = sqrt((Line3.x2-x0)^2 + (Line3.y2-y0)^2)*res;
     x4_3 = sqrt((Line3.x1-x0)^2 + (Line3.y1-y0)^2)*res - x5_3;
     B_3 = x2_3 / (x1_3 + x4_3);
     A_3 = (x5_3 + x4_3) / x4_3;
     S_3 = B_3 * x3_3 / (1 - B_3/A_3);
     h_3 = S_3 / A_3;
     
     delta3 = (Line3.y2 - Line3.y1)/(Line3.x1 - Line3.x2);
     Line3.x0 = 1;
     Line3.y0 = (Line3.x2-1) * delta3 + Line3.y2;
     figure(figuretodraw); hold on; plot([Line3.x0 Line3.x2],[Line3.y0 Line3.y2],'Linewidth',1,'color','b');
     
    Line4.x1 = coord(21,1);
    Line4.x2 = coord(26,1);
    Line4.y1 = coord(21,2);
    Line4.y2 = coord(26,2);
     x1_4 = sqrt((Line4.x1-Line4.x2)^2 + (Line4.y1-Line4.y2)^2)*res;
     x2_4 = sqrt((Line4.x2-x0)^2 + (Line4.y2-y0)^2)*res;
     x4_4 = sqrt((Line4.x1-x0)^2 + (Line4.y1-y0)^2)*res - x5_4;
     B_4 = x2_4 / (x1_4 + x4_4);
     A_4 = (x5_4 + x4_4) / x4_4;
     S_4 = B_4 * x3_4 / (1 - B_4/A_4);
     h_4 = S_4 / A_4;
     
     delta4 = (Line4.y2 - Line4.y1)/(Line4.x1 - Line4.x2);
     Line4.x0 = 1;
     Line4.y0 = (Line4.x2-1) * delta4 + Line4.y2;
     figure(figuretodraw); hold on; plot([Line4.x0 Line4.x2],[Line4.y0 Line4.y2],'Linewidth',1,'color','b');
     
     Line5.x1 = coord(18,1);
     Line5.x2 = coord(25,1);
     Line5.y1 = coord(18,2);
     Line5.y2 = coord(25,2);
     x1_5 = sqrt((Line5.x1-Line5.x2)^2 + (Line5.y1-Line5.y2)^2)*res;
     x2_5 = sqrt((Line5.x2-x0)^2 + (Line5.y2-y0)^2)*res;
     x4_5 = sqrt((Line5.x1-x0)^2 + (Line5.y1-y0)^2)*res - x5_5;
     B_5 = x2_5 / (x1_5 + x4_5);
     A_5 = (x5_5 + x4_5) / x4_5;
     S_5 = B_5 * x3_5 / (1 - B_5/A_5);
     h_5 = S_5 / A_5;
     
     delta5 = (Line5.y2 - Line5.y1)/(Line5.x1 - Line5.x2);
     Line5.x0 = 1;
     Line5.y0 = (Line5.x2-1) * delta5 + Line5.y2;
     figure(figuretodraw); hold on; plot([Line5.x0 Line5.x2],[Line5.y0 Line5.y2],'Linewidth',1,'color','b');
    
     Line6.x1 = coord(22,1);
     Line6.x2 = coord(24,1);
     Line6.y1 = coord(22,2);
     Line6.y2 = coord(24,2);
     x1_6 = sqrt((Line6.x1-Line6.x2)^2 + (Line6.y1-Line6.y2)^2)*res;
     x2_6 = sqrt((Line6.x2-x0)^2 + (Line6.y2-y0)^2)*res;
     x4_6 = sqrt((Line6.x1-x0)^2 + (Line6.y1-y0)^2)*res - x5_6;
     B_6 = x2_6 / (x1_6 + x4_6);
     A_6 = (x5_6 + x4_6) / x4_6;
     S_6 = B_6 * x3_6 / (1 - B_6/A_6);
     h_6 = S_6 / A_6;
     
     delta6 = (Line6.y2 - Line6.y1)/(Line6.x1 - Line6.x2);
     Line6.x0 = 1;
     Line6.y0 = (Line6.x2-1) * delta6 + Line6.y2;
     figure(figuretodraw); hold on; plot([Line6.x0 Line6.x2],[Line6.y0 Line6.y2],'Linewidth',1,'color','b');
     
     Line7.x1 = coord(19,1);
     Line7.x2 = coord(23,1);
     Line7.y1 = coord(19,2);
     Line7.y2 = coord(23,2);
     x1_7 = sqrt((Line7.x1-Line7.x2)^2 + (Line7.y1-Line7.y2)^2)*res;
     x2_7 = sqrt((Line7.x2-x0)^2 + (Line7.y2-y0)^2)*res;
     x4_7 = sqrt((Line7.x1-x0)^2 + (Line7.y1-y0)^2)*res - x5_7;
     B_7 = x2_7 / (x1_7 + x4_7);
     A_7 = (x5_7 + x4_7) / x4_7;
     S_7 = B_7 * x3_7 / (1 - B_7/A_7);
     h_7 = S_7 / A_7;
     
     delta7 = (Line7.y2 - Line7.y1)/(Line7.x1 - Line7.x2);
     Line7.x0 = 1;
     Line7.y0 = (Line7.x2-1) * delta7 + Line7.y2;
     figure(figuretodraw); hold on; plot([Line7.x0 Line7.x2],[Line7.y0 Line7.y2],'Linewidth',1,'color','b');
     %
     Line8.x1 = coord(14,1);
     Line8.x2 = coord(16,1);
     Line8.y1 = coord(14,2);
     Line8.y2 = coord(16,2);
     delta8 = (Line8.y2 - Line8.y1)/(Line8.x1 - Line8.x2);
     Line8.x0 = 1;
     Line8.y0 = (Line8.x2-1) * delta8 + Line8.y2;
     figure(figuretodraw); hold on; plot([Line8.x0 Line8.x2],[Line8.y0 Line8.y2],'Linewidth',1,'color','b');
     %}
     Line9.x1 = coord(11,1);
     Line9.x2 = coord(12,1);
     Line9.y1 = coord(11,2);
     Line9.y2 = coord(12,2);
     x1_9 = sqrt((Line9.x1-Line9.x2)^2 + (Line9.y1-Line9.y2)^2)*res;
     x2_9 = sqrt((Line9.x2-x0)^2 + (Line9.y2-y0)^2)*res;
     x4_9 = sqrt((Line9.x1-x0)^2 + (Line9.y1-y0)^2)*res - x5_9;
     B_9 = x2_9 / (x1_9 + x4_9);
     A_9 = (x5_9 + x4_9) / x4_9;
     S_9 = B_9 * x3_9 / (1 - B_9/A_9);
     h_9 = S_9 / A_9;
     
     delta9 = (Line9.y2 - Line9.y1)/(Line9.x1 - Line9.x2);
     Line9.x0 = 1;
     Line9.y0 = (Line9.x2-1) * delta9 + Line9.y2;
     figure(figuretodraw); hold on; plot([Line9.x0 Line9.x2],[Line9.y0 Line9.y2],'Linewidth',1,'color','b');
     
     S = [S_1 S_3 S_4 S_5 S_6 S_7 S_9]'
     h = [h_1 h_3 h_4 h_5 h_6 h_7 h_9]'-0.12
     I13=funcComputeIntersection(Line1,Line3);
     I14=funcComputeIntersection(Line1,Line4);
     I15=funcComputeIntersection(Line1,Line5);
     I16=funcComputeIntersection(Line1,Line6);
     I17=funcComputeIntersection(Line1,Line7);
     I19=funcComputeIntersection(Line1,Line9);
     I34=funcComputeIntersection(Line3,Line4);
     I35=funcComputeIntersection(Line3,Line5);
     I36=funcComputeIntersection(Line3,Line6);
     I37=funcComputeIntersection(Line3,Line7);
     I39=funcComputeIntersection(Line3,Line9);
     I45=funcComputeIntersection(Line4,Line5);
     I46=funcComputeIntersection(Line4,Line6);
     I47=funcComputeIntersection(Line4,Line7);
     I49=funcComputeIntersection(Line4,Line9);
     I56=funcComputeIntersection(Line5,Line6);
     I57=funcComputeIntersection(Line5,Line7);
     I59=funcComputeIntersection(Line5,Line9);
     I67=funcComputeIntersection(Line6,Line7);
     I69=funcComputeIntersection(Line6,Line9);
     I79=funcComputeIntersection(Line7,Line9);
     
     point_0 = [I13;I14;I15;I16;I17;I19;I34;I35;I36;I37;I39;I46;I47;I49;I56;I57;I59;I67;I69;I79];
     mean_0 = mean(point_0)
     %plot(point_0(:,1),point_0(:,2),'.r','MarkerSize',5);
     plot(mean_0(1)+5,mean_0(2),'.r','MarkerSize',7);
     ;
    
     
     
 
     
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
    
   
    