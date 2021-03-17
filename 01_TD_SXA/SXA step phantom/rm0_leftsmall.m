function [sort_coord] = rm1_bbspos_leftsmall()
    global Image figuretodraw coord Info Analysis Error%h_init
    machine = Info.centerlistactivated;
    rot_image = Image.image;
    bkgr = background_phantomdigital(rot_image);
    res = 0.014;
    ph_image = rot_image - bkgr;
    max_image = max(max(ph_image))
    a1 = uint8(ph_image/max_image*255); %12600
    conn1 = [0 1 0; 0 1 0; 0 1 0];
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
    bw = Zs1>0.2*max(max(Zs1));
    mm = max(max(Zs1))
    %bw = im2bw(Zs1,0.7);
       
   %figure;
    %imagesc(bw); colormap(gray); hold on;
     se3 = strel('disk',3);
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
  
    Line1.x1 = coord(1,1);
    Line1.x2 = coord(3,1);
    Line1.y1 = coord(1,2);
    Line1.y2 = coord(3,2);
  
     delta1 = (Line1.y2 - Line1.y1)/(Line1.x1 - Line1.x2);
     Line1.x0 = 1;
     Line1.y0 = (Line1.x2-1) * delta1 + Line1.y2;
     figure(figuretodraw); hold on; plot([Line1.x0 Line1.x2],[Line1.y0 Line1.y2],'Linewidth',1,'color','b');hold on;
         
     Line2.x1 = coord(5,1);
     Line2.x2 = coord(7,1);
     Line2.y1 = coord(5,2);
     Line2.y2 = coord(7,2);
        
     delta2 = (Line2.y2 - Line2.y1)/(Line2.x1 - Line2.x2);
     Line2.x0 = 1;
     Line2.y0 = (Line2.x2-1) * delta2 + Line2.y2;
     figure(figuretodraw); hold on; plot([Line2.x0 Line2.x2],[Line2.y0 Line2.y2],'Linewidth',1,'color','b');
          
     Line3.x1 = coord(9,1);
     Line3.x2 = coord(11,1);
     Line3.y1 = coord(9,2);
     Line3.y2 = coord(11,2);
          
     delta3 = (Line3.y2 - Line3.y1)/(Line3.x1 - Line3.x2);
     Line3.x0 = 1;
     Line3.y0 = (Line3.x2-1) * delta3 + Line3.y2;
     figure(figuretodraw); hold on; plot([Line3.x0 Line3.x2],[Line3.y0 Line3.y2],'Linewidth',1,'color','b');
     %}
    Line4.x1 = coord(13,1);
    Line4.x2 = coord(18,1);
    Line4.y1 = coord(13,2);
    Line4.y2 = coord(18,2);
         
     delta4 = (Line4.y2 - Line4.y1)/(Line4.x1 - Line4.x2);
     Line4.x0 = 1;
     Line4.y0 = (Line4.x2-1) * delta4 + Line4.y2;
     figure(figuretodraw); hold on; plot([Line4.x0 Line4.x2],[Line4.y0 Line4.y2],'Linewidth',1,'color','b');
     
     Line5.x1 = coord(15,1);
     Line5.x2 = coord(20,1);
     Line5.y1 = coord(15,2);
     Line5.y2 = coord(20,2);
          
     delta5 = (Line5.y2 - Line5.y1)/(Line5.x1 - Line5.x2);
     Line5.x0 = 1;
     Line5.y0 = (Line5.x2-1) * delta5 + Line5.y2;
     figure(figuretodraw); hold on; plot([Line5.x0 Line5.x2],[Line5.y0 Line5.y2],'Linewidth',1,'color','b');
    
     Line6.x1 = coord(16,1);
     Line6.x2 = coord(21,1);
     Line6.y1 = coord(16,2);
     Line6.y2 = coord(21,2);
         
     delta6 = (Line6.y2 - Line6.y1)/(Line6.x1 - Line6.x2);
     Line6.x0 = 1;
     Line6.y0 = (Line6.x2-1) * delta6 + Line6.y2;
     figure(figuretodraw); hold on; plot([Line6.x0 Line6.x2],[Line6.y0 Line6.y2],'Linewidth',1,'color','b');
     
     Line7.x1 = coord(17,1);
     Line7.x2 = coord(22,1);
     Line7.y1 = coord(17,2);
     Line7.y2 = coord(22,2);
         
     delta7 = (Line7.y2 - Line7.y1)/(Line7.x1 - Line7.x2);
     Line7.x0 = 1;
     Line7.y0 = (Line7.x2-1) * delta7 + Line7.y2;
     figure(figuretodraw); hold on; plot([Line7.x0 Line7.x2],[Line7.y0 Line7.y2],'Linewidth',1,'color','b');
     %
     Line8.x1 = coord(14,1);
     Line8.x2 = coord(19,1);
     Line8.y1 = coord(14,2);
     Line8.y2 = coord(19,2);
          
     delta8 = (Line8.y2 - Line8.y1)/(Line8.x1 - Line8.x2);
     Line8.x0 = 1;
     Line8.y0 = (Line8.x2-1) * delta8 + Line8.y2;
     figure(figuretodraw); hold on; plot([Line8.x0 Line8.x2],[Line8.y0 Line8.y2],'Linewidth',1,'color','b');
     %}
     Line9.x1 = coord(10,1);
     Line9.x2 = coord(12,1);
     Line9.y1 = coord(10,2);
     Line9.y2 = coord(12,2);
          
     delta9 = (Line9.y2 - Line9.y1)/(Line9.x1 - Line9.x2);
     Line9.x0 = 1;
     Line9.y0 = (Line9.x2-1) * delta9 + Line9.y2;
     figure(figuretodraw); hold on; plot([Line9.x0 Line9.x2],[Line9.y0 Line9.y2],'Linewidth',1,'color','b');
     
     %
     Line10.x1 = coord(6,1);
     Line10.x2 = coord(8,1);
     Line10.y1 = coord(6,2);
     Line10.y2 = coord(8,2);     
     
     delta10 = (Line10.y2 - Line10.y1)/(Line10.x1 - Line10.x2);
     Line10.x0 = 1;
     Line10.y0 = (Line10.x2-Line10.x0) * delta10 + Line10.y2;
     figure(figuretodraw); hold on; plot([Line10.x0 Line10.x2],[Line10.y0 Line10.y2],'Linewidth',1,'color','b');
     %
     Line11.x1 = coord(2,1);
     Line11.x2 = coord(4,1);
     Line11.y1 = coord(2,2);
     Line11.y2 = coord(4,2);
          
     delta11 = (Line11.y2 - Line11.y1)/(Line11.x1 - Line11.x2);
     Line11.x0 = 1;
     Line11.y0 = (Line11.x2-Line11.x0) * delta11 + Line11.y2;
     figure(figuretodraw); hold on; plot([Line11.x0 Line11.x2],[Line11.y0 Line11.y2],'Linewidth',1,'color','b');
        
    
     I12=funcComputeIntersection(Line1,Line2);
     I13=funcComputeIntersection(Line1,Line3);
     I14=funcComputeIntersection(Line1,Line4);
     I15=funcComputeIntersection(Line1,Line5);
     I16=funcComputeIntersection(Line1,Line6);
     I17=funcComputeIntersection(Line1,Line7);
     I18=funcComputeIntersection(Line1,Line8);
     I19=funcComputeIntersection(Line1,Line9);
     I110=funcComputeIntersection(Line1,Line10);
     I111=funcComputeIntersection(Line1,Line11);
     I23=funcComputeIntersection(Line2,Line3);
     I24=funcComputeIntersection(Line2,Line4);
     I25=funcComputeIntersection(Line2,Line5);
     I26=funcComputeIntersection(Line2,Line6);
     I27=funcComputeIntersection(Line2,Line7);
     I28=funcComputeIntersection(Line2,Line8);
     I29=funcComputeIntersection(Line2,Line9);
     I210=funcComputeIntersection(Line2,Line10);
     I211=funcComputeIntersection(Line2,Line11);
     I34=funcComputeIntersection(Line3,Line4);
     I35=funcComputeIntersection(Line3,Line5);
     I36=funcComputeIntersection(Line3,Line6);
     I37=funcComputeIntersection(Line3,Line7);
     I38=funcComputeIntersection(Line3,Line8);
     I39=funcComputeIntersection(Line3,Line9);
     I310=funcComputeIntersection(Line3,Line10);
     I311=funcComputeIntersection(Line3,Line11);
     I45=funcComputeIntersection(Line4,Line5);
     I46=funcComputeIntersection(Line4,Line6);
     I47=funcComputeIntersection(Line4,Line7);
     I48=funcComputeIntersection(Line4,Line8);
     I49=funcComputeIntersection(Line4,Line9);
     I410=funcComputeIntersection(Line4,Line10);
     I411=funcComputeIntersection(Line4,Line11);
     I56=funcComputeIntersection(Line5,Line6);
     I57=funcComputeIntersection(Line5,Line7);
     I58=funcComputeIntersection(Line5,Line8);
     I59=funcComputeIntersection(Line5,Line9);
     I510=funcComputeIntersection(Line5,Line10);
     I511=funcComputeIntersection(Line5,Line11);
     I67=funcComputeIntersection(Line6,Line7);
     I68=funcComputeIntersection(Line6,Line8);
     I69=funcComputeIntersection(Line6,Line9);
     I610=funcComputeIntersection(Line6,Line10);
     I611=funcComputeIntersection(Line6,Line11);
     I78=funcComputeIntersection(Line7,Line8);
     I79=funcComputeIntersection(Line7,Line9);
     I710=funcComputeIntersection(Line7,Line10);
     I711=funcComputeIntersection(Line7,Line11);
     I89=funcComputeIntersection(Line8,Line9);
     I810=funcComputeIntersection(Line8,Line10);
     I811=funcComputeIntersection(Line8,Line11);
    I910=funcComputeIntersection(Line9,Line10);
    I911=funcComputeIntersection(Line9,Line11);
    I911=funcComputeIntersection(Line9,Line11);
    I1011=funcComputeIntersection(Line10,Line11);
   
     point_0 = [ I12;I13;I14;I15;I16;I17;I18;I19;I110;I111;I23;I24;I25;I26;I27;I28;I29;I210;I211;I34;I35;I36;I37;I38;I39;I310;I311;I45;I46;I47;I48;I49;I410;I411;I56;I57;I58;I59;I510;I511;I67;I68;I69;I610;I611;I79;I710;I711;I78;I89;I810;I811;I910;I911;I1011];
     mean_0 = mean(point_0)
     %plot(point_0(:,1),point_0(:,2),'.r','MarkerSize',5);
     plot(mean_0(1),mean_0(2),'.r','MarkerSize',7);
     ;
     xy_block = [   1,	0,	0;...
                    2,	0,	4.01;...
                    3,	0,	8.1;...
                    4,	0,	12.25;...
                    5,	4.47,	12.67;...
                    6,	8.82,	12.7;...
                    7,	13.12,	12.72;...
                    8,	17.85,	12.25;...
                    9,	17.85,	8.1;...
                    10,	17.85,	4.01;...
                    11,	17.85,	0];
     
     
     xim_0 = mean_0(1);
     yim_0 = mean_0(2);
     x0 = xim_0;
     y0 = yim_0;
     
     xim_11 = coord(1,1);  Line1.x1
     xim_1 = coord(3,1);
     yim_11 = coord(1,2);
     yim_1 = coord(3,2);
     
     xim_1 = Line1.x1;
     yim_1 = Line1.y1;
     xim_2 = Line2.x1;
     yim_2 = Line2.y1;
     xim_3 = Line3.x1;
     yim_3 = Line3.y1;
     xim_4 = Line4.x1;
     yim_4 = Line4.y1;
     xim_5 = Line5.x1;
     yim_5 = Line5.y1;
     xim_6 = Line6.x1;
     yim_6 = Line6.y1;
     xim_7 = Line7.x1;
     yim_7 = Line7.y1;
     xim_8 = Line8.x1;
     yim_8 = Line8.y1;
     xim_9 = Line9.x1;
     yim_9 = Line9.y1;
     xim_10 = Line10.x1;
     yim_10 = Line10.y1;
     xim_11 = Line11.x1;
     yim_11 = Line11.y1;
          
     d11_1 = sqrt((xim_11-xim_1)^2 + (yim_11-yim_1)^2)*res;
     
     x_1 = xy_block(1,2);
     x_11 = xy_block(11,2);
     
     k_image = (x_11 - x_1) / d11_1;
     d1 = sqrt((xim_1-xim_0)^2 + (yim_1-yim_0)^2)*res;
     d2 = sqrt((xim_2-xim_0)^2 + (yim_2-yim_0)^2)*res;
     d3 = sqrt((xim_3-xim_0)^2 + (yim_3-yim_0)^2)*res;
     d4 = sqrt((xim_4-xim_0)^2 + (yim_4-yim_0)^2)*res;
     d5 = sqrt((xim_5-xim_0)^2 + (yim_5-yim_0)^2)*res;
     d6 = sqrt((xim_6-xim_0)^2 + (yim_6-yim_0)^2)*res;
     d7 = sqrt((xim_7-xim_0)^2 + (yim_7-yim_0)^2)*res;
     d8 = sqrt((xim_8-xim_0)^2 + (yim_8-yim_0)^2)*res;
     d9 = sqrt((xim_9-xim_0)^2 + (yim_9-yim_0)^2)*res;
     d10 = sqrt((xim_10-xim_0)^2 + (yim_10-yim_0)^2)*res;
     d11 = sqrt((xim_11-xim_0)^2 + (yim_11-yim_0)^2)*res;
     
     x5_1 = k_image * d1;
     x5_2 = k_image * d2;
     x5_3 = k_image * d3;
     x5_4 = k_image * d4;
     x5_5 = k_image * d5;
     x5_6 = k_image * d6;
     x5_7 = k_image * d7;
     x5_8 = k_image * d8;
     x5_9 = k_image * d9;
     x5_10 = k_image * d10;
     x5_11 = k_image * d11;
          
     x3_1 = 4.62;
     x3_2 = 4.62;
     x3_3 = 4.62;
     x3_4 = 4.62;
     x3_5 = 4.62;
     x3_6 = 4.62;
     x3_7 = 4.62;
     x3_8 = 4.62;
     x3_9 = 4.62;
     x3_10 = 4.62;
     x3_11 = 4.62;
          
    x1_1 = sqrt((Line1.x1-Line1.x2)^2 + (Line1.y1-Line1.y2)^2)*res;
    x2_1 = sqrt((Line1.x2-x0)^2 + (Line1.y2-y0)^2)*res;
    x4_1 = sqrt((Line1.x1-x0)^2 + (Line1.y1-y0)^2)*res - x5_1;
    B_1 = x2_1 / (x1_1 + x4_1);
    A_1 = (x5_1 + x4_1) / x4_1;
    S_1 = B_1 * x3_1 / (1 - B_1/A_1);
    h_1 = S_1 / A_1;
 
     x1_2 = sqrt((Line2.x1-Line2.x2)^2 + (Line2.y1-Line2.y2)^2)*res;
     x2_2 = sqrt((Line2.x2-x0)^2 + (Line2.y2-y0)^2)*res;
     x4_2 = sqrt((Line2.x1-x0)^2 + (Line2.y1-y0)^2)*res - x5_2;
     B_2 = x2_2 / (x1_2 + x4_2);
     A_2 = (x5_2 + x4_2) / x4_2;
     S_2 = B_2 * x3_2 / (1 - B_2/A_2);
     h_2 = S_2 / A_2; 
     
     x1_3 = sqrt((Line3.x1-Line3.x2)^2 + (Line3.y1-Line3.y2)^2)*res;
     x2_3 = sqrt((Line3.x2-x0)^2 + (Line3.y2-y0)^2)*res;
     x4_3 = sqrt((Line3.x1-x0)^2 + (Line3.y1-y0)^2)*res - x5_3;
     B_3 = x2_3 / (x1_3 + x4_3);
     A_3 = (x5_3 + x4_3) / x4_3;
     S_3 = B_3 * x3_3 / (1 - B_3/A_3);
     h_3 = S_3 / A_3;
    
     x1_4 = sqrt((Line4.x1-Line4.x2)^2 + (Line4.y1-Line4.y2)^2)*res;
     x2_4 = sqrt((Line4.x2-x0)^2 + (Line4.y2-y0)^2)*res;
     x4_4 = sqrt((Line4.x1-x0)^2 + (Line4.y1-y0)^2)*res - x5_4;
     B_4 = x2_4 / (x1_4 + x4_4);
     A_4 = (x5_4 + x4_4) / x4_4;
     S_4 = B_4 * x3_4 / (1 - B_4/A_4);
     h_4 = S_4 / A_4;
     
     x1_5 = sqrt((Line5.x1-Line5.x2)^2 + (Line5.y1-Line5.y2)^2)*res;
     x2_5 = sqrt((Line5.x2-x0)^2 + (Line5.y2-y0)^2)*res;
     x4_5 = sqrt((Line5.x1-x0)^2 + (Line5.y1-y0)^2)*res - x5_5;
     B_5 = x2_5 / (x1_5 + x4_5);
     A_5 = (x5_5 + x4_5) / x4_5;
     S_5 = B_5 * x3_5 / (1 - B_5/A_5);
     h_5 = S_5 / A_5;
     
      x1_6 = sqrt((Line6.x1-Line6.x2)^2 + (Line6.y1-Line6.y2)^2)*res;
     x2_6 = sqrt((Line6.x2-x0)^2 + (Line6.y2-y0)^2)*res;
     x4_6 = sqrt((Line6.x1-x0)^2 + (Line6.y1-y0)^2)*res - x5_6;
     B_6 = x2_6 / (x1_6 + x4_6);
     A_6 = (x5_6 + x4_6) / x4_6;
     S_6 = B_6 * x3_6 / (1 - B_6/A_6);
     h_6 = S_6 / A_6;
     
      x1_7 = sqrt((Line7.x1-Line7.x2)^2 + (Line7.y1-Line7.y2)^2)*res;
     x2_7 = sqrt((Line7.x2-x0)^2 + (Line7.y2-y0)^2)*res;
     x4_7 = sqrt((Line7.x1-x0)^2 + (Line7.y1-y0)^2)*res - x5_7;
     B_7 = x2_7 / (x1_7 + x4_7);
     A_7 = (x5_7 + x4_7) / x4_7;
     S_7 = B_7 * x3_7 / (1 - B_7/A_7);
     h_7 = S_7 / A_7;
     
    x1_8 = sqrt((Line8.x1-Line8.x2)^2 + (Line8.y1-Line8.y2)^2)*res;
     x2_8 = sqrt((Line8.x2-x0)^2 + (Line8.y2-y0)^2)*res;
     x4_8 = sqrt((Line8.x1-x0)^2 + (Line8.y1-y0)^2)*res - x5_8;
     B_8 = x2_8 / (x1_8 + x4_8);
     A_8 = (x5_8 + x4_8) / x4_8;
     S_8 = B_8 * x3_8 / (1 - B_8/A_8);
     h_8 = S_8 / A_8;
     
     x1_9 = sqrt((Line9.x1-Line9.x2)^2 + (Line9.y1-Line9.y2)^2)*res;
     x2_9 = sqrt((Line9.x2-x0)^2 + (Line9.y2-y0)^2)*res;
     x4_9 = sqrt((Line9.x1-x0)^2 + (Line9.y1-y0)^2)*res - x5_9;
     B_9 = x2_9 / (x1_9 + x4_9);
     A_9 = (x5_9 + x4_9) / x4_9;
     S_9 = B_9 * x3_9 / (1 - B_9/A_9);
     h_9 = S_9 / A_9;
     
      x1_10 = sqrt((Line10.x1-Line10.x2)^2 + (Line10.y1-Line10.y2)^2)*res;
     x2_10 = sqrt((Line10.x2-x0)^2 + (Line10.y2-y0)^2)*res;
     x4_10 = sqrt((Line10.x1-x0)^2 + (Line10.y1-y0)^2)*res - x5_10;
     B_10 = x2_10 / (x1_10 + x4_10);
     A_10 = (x5_10 + x4_10) / x4_10;
     S_10 = B_10 * x3_10 / (1 - B_10/A_10);
     h_10 = S_10 / A_10;
     
     x1_11 = sqrt((Line11.x1-Line11.x2)^2 + (Line11.y1-Line11.y2)^2)*res;
     x2_11 = sqrt((Line11.x2-x0)^2 + (Line11.y2-y0)^2)*res;
     x4_11 = sqrt((Line11.x1-x0)^2 + (Line11.y1-y0)^2)*res - x5_11;
     B_11 = x2_11 / (x1_11 + x4_11);
     A_11 = (x5_11 + x4_11) / x4_11;
     S_11 = B_11 * x3_11 / (1 - B_11/A_11);
     h_11 = S_11 / A_11;
     
     
     S = [S_1 S_2 S_3 S_4 S_5 S_6 S_7 S_8 S_9 S_10 S_11]' %S_1 S_2 S_3 S_11 S_12 S_13
     h = [h_1 h_2 h_3 h_4 h_5 h_6 h_7 h_8 h_9 h_10 h_11]'-0.21 %h_1 h_2 h_3 h_11 h_12 h_13
     
   