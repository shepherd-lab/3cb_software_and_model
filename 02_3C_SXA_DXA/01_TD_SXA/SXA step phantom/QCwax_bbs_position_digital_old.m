function [BBcoord] = QCwax_bbs_position_digital()
    global Image figuretodraw coord Info Analysis Error ROI Database bb_boxes line_boxes gen3 flag %h_init 
    
     
       kGE = 0.71;
     
%        kGE = 0.85;
    if Info.DigitizerId == 5 | Info.DigitizerId == 6 | Info.DigitizerId == 7 
        crop_coef = kGE;
    else
        crop_coef = 1;
    end
    
     [rows, cols] = size(Image.image);
%         
%     x_width = 690*crop_coef;
%     y_height = 650*crop_coef;
%     machine = Info.centerlistactivated;
%     sz_image = size(Image.image);
%     
%     if Analysis.second_phantom == false
%         rot_image = Image.image(1:y_height,x_width:end);
%         rot_angle = 31.8;%rot_image2
%         ycoord_shift = 0;
%     else
%         rot_image = Image.image(end-y_height:end,x_width:end);
%         rot_angle =  -31.8;
%         ycoord_shift = sz_image(1)-y_height;
%     end
    imsz = size(Image.image);
    if imsz(1) <1800 
        flag.small_paddle = true;
    else
        flag.small_paddle = false;
    end    
    x = [500 500]*crop_coef;
    y = [1 imsz(1)];
    im_profileV = improfile(Image.image,x,y);
%     figure;plot(im_profileV);
    
    index_bkgrV = find(im_profileV > Analysis.BackGroundThreshold);
    index_bkgrV = find(im_profileV > ((max(im_profileV)-min(im_profileV))/6 + min(im_profileV))); %Analysis.BackGroundThreshold);
    
    ROI.ymin = round(min(index_bkgrV(index_bkgrV>10))-20*crop_coef); %was 50
    if ROI.ymin < 0 %JW 6/4/2010 ROI.ymin in some cases negative, will fail at line 39
        ROI.ymin = 1;
    end
    ROI.ymax = round(min([max(index_bkgrV)+20*crop_coef , imsz(1)])); %was 50 
    ROI.xmin = 1;
    ROI.rows = round(ROI.ymax-ROI.ymin);
   
    %ROI.columns =  (gen3_xmax -  gen3_xmin + 50;
    x = [1 imsz(2)];
    y_middle = round((ROI.ymax - ROI.ymin)/2);
    y = [y_middle y_middle];
    %im_profileH = improfile(ROI.image,x,y); %Image.image Image.image
    im_profileH = improfile(Image.image,x,y+ROI.ymin);
     %figure;imagesc(ROI.image);colormap(gray);
   %figure;plot(im_profileH);
    
    index_bkgrH = find(im_profileH > ((max(im_profileH)-min(im_profileH))/6 + min(im_profileH))); %Analysis.BackGroundThreshold);
    index_bkgrH_1step = max(find(im_profileH > ((max(im_profileH)-min(im_profileH))*0.9+ min(im_profileH )))); 
    maxH = max(index_bkgrH);
    
    if Info.DigitizerId == 5 | Info.DigitizerId == 6 | Info.DigitizerId == 7 
        maxH = maxH*kGE;
        if maxH < (750*kGE)
            maxH = 3*maxH/2
        end
    else
        if maxH < 750
            maxH = 3*maxH/2
        end
    end
    
    
    ROI.xmax =round(maxH +100*crop_coef); %max(index_bkgrH)
    columns2 = ROI.xmax-ROI.xmin;
    ROI.columns = min([columns2, imsz(2)]);
   %re;plot(im_profileH);colormap(gray);
% % %     if Info.StudyID == 'UVM-Selenia                   '
% % %         ROI.columns = 1000; %JW, originally 1200
% % %     else
% % %         ROI.columns = 1200;
% % %     end
    
    
     ROI.image=Image.image(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1);
     % figure;imagesc(ROI.image);colormap(gray);
    x_shift = 310*crop_coef - index_bkgrH_1step;
    gen3.xmin = min(index_bkgrH) - ROI.xmin;
    gen3.xmax = maxH  - ROI.xmin; % max(index_bkgrH)
    gen3.ymin = min(index_bkgrV) - ROI.ymin;
    gen3.ymax = max(index_bkgrV-ROI.ymin);
    step_width = round((gen3.xmax - gen3.xmin)/3);
    gen3.columns = (gen3.xmax - gen3.xmin);
    gen3.rows = (gen3.ymax - gen3.ymin);
    %ROI.xmin = gen3_xmin - 50;
    bwidth = 120*crop_coef;
    bbs_width = 170*crop_coef;
    bheight = 180*crop_coef;
    bheight2 = 130*crop_coef;
        
    if min( index_bkgrH)<= 3
        startx_small = -x_shift+25*crop_coef;%37;
        startx_big = - x_shift+35*crop_coef;%30;
        bbstart_small = - x_shift -23*crop_coef; %-60;
        bbstart_big = - x_shift -30*crop_coef; %-60;
    else
        startx_small = 23*crop_coef;
        startx_big = 30*crop_coef;
        bbstart_small = 0;
        bbstart_big = 0;
    end
    
    
    step_sm1 = startx_small; %60;
    step_sm2 = startx_small + 403*crop_coef;%460;
    step_sm3 = startx_small + 837*crop_coef;%860;
    step_big1 = startx_big;%100;
    step_big2 = startx_big+390*crop_coef;%500;
    step_big3 = startx_big+822*crop_coef;%940;
    
    bbstep_1sm = 240*crop_coef+bbstart_small;
    bbstep_2sm = 550*crop_coef+bbstart_small;
    bbstep_1big = 234*crop_coef+bbstart_big;%315;
    bbstep_2big = 547*crop_coef+bbstart_big;%622;
    
    
    if Image.rows < 1800*crop_coef
        step_1 = step_sm1;
        step_2 = step_sm2;
        step_3 = step_sm3;
        bbstep_1 =  bbstep_1sm;
        bbstep_2 = bbstep_2sm;
    else
        step_1 = step_big1;
        step_2 = step_big2;
        step_3 = step_big3;
        bbstep_1 =  bbstep_1big;
        bbstep_2 = bbstep_2big;
    end
    
    x1min = max([gen3.xmin + step_1,0]);
    y1min = 40*crop_coef;
    x1max = x1min + bwidth;
    y1max =  bheight;
    
    x2min = gen3.xmin + step_2; 
    y2min = 40*crop_coef;
    x2max = x2min + bwidth;
    y2max =  bheight;
    
    x3min = gen3.xmin + step_3 + gen3.xmin*0.3;
    y3min = 40*crop_coef;
    x3max = x3min + bwidth-30*crop_coef;
    y3max =  bheight;
    
    x4min = max([gen3.xmin + step_1,0]);%gen3.xmin + step_1;
    y4min = ROI.rows- bheight;
    x4max = x4min + bwidth;
    y4max = ROI.rows;%-40*crop_coef;
    
    x5min = gen3.xmin + step_2;
    y5min = ROI.rows - bheight;
    x5max = x5min + bwidth;
    y5max = ROI.rows;%-40*crop_coef;
    
    x6min = gen3.xmin + step_3 + gen3.xmin*0.3;
    y6min = ROI.rows- bheight;
    x6max = x6min + bwidth-30*crop_coef;
    y6max = ROI.rows;%-40*crop_coef;
    
    line_boxes.x1min = x1min;
    line_boxes.y1min = y1min;
    line_boxes.x1max = x1max;
    line_boxes.y1max = y1max;
    line_boxes.x2min = x2min;
    line_boxes.y2min = y2min;
    line_boxes.x2max = x2max;
    line_boxes.y2max = y2max;
    line_boxes.x3min = x3min;
    line_boxes.y3min = y3min;
    line_boxes.x3max = x3max;
    line_boxes.y3max = y3max;
    line_boxes.x4min = x4min;
    line_boxes.y4min = y4min;
    line_boxes.x4max = x4max;
    line_boxes.y4max = y4max;
    line_boxes.x5min = x5min;
    line_boxes.y5min = y5min;
    line_boxes.x5max = x5max;
    line_boxes.y5max = y5max;
    line_boxes.x6min = x6min;
    line_boxes.y6min = y6min;
    line_boxes.x6max = x6max;
    line_boxes.y6max = y6max;
    
       
    xbb12min = gen3.xmin + bbstep_1;
    ybb12min = 1;
    xbb12max = xbb12min + bbs_width;
    ybb12max =  bheight2;
    
    xbb34min = gen3.xmin + bbstep_2;
    ybb34min = 1;
    xbb34max = xbb34min + bbs_width;
    ybb34max =  bheight2;
    
    xbb78min = gen3.xmin + bbstep_1;
    ybb78min =  ROI.rows- bheight2;
    xbb78max = xbb78min + bbs_width;
    ybb78max =  ROI.rows ;
    
    xbb56min = gen3.xmin + bbstep_2;
    ybb56min =  ROI.rows - bheight2;
    xbb56max = xbb56min + bbs_width;
    ybb56max =  ROI.rows;
        
    bb_boxes.xbb12min = xbb12min;
    bb_boxes.ybb12min = ybb12min;
    bb_boxes.xbb12max = xbb12max;
    bb_boxes.ybb12max = ybb12max;
    bb_boxes.xbb34min = xbb34min;
    bb_boxes.ybb34min = ybb34min;
    bb_boxes.xbb34max = xbb34max;
    bb_boxes.ybb34max = ybb34max;
    bb_boxes.xbb78min =  xbb78min;
    bb_boxes.ybb78min =  ybb78min;
    bb_boxes.xbb78max = xbb78max;
    bb_boxes.ybb78max = ybb78max;
    bb_boxes.xbb56min = xbb56min;
    bb_boxes.ybb56min = ybb56min;
    bb_boxes.xbb56max = xbb56max;
    bb_boxes.ybb56max = ybb56max;
       
   
   % funcBox(ROI.xmin,ROI.ymin,ROI.xmin+ROI.columns,ROI.ymin+ROI.rows,'b',2); 
    funcBox(gen3.xmin,gen3.ymin + ROI.ymin,gen3.xmin+gen3.columns,gen3.ymin+gen3.rows + ROI.ymin,'b',2);
    draweverything;
    % rot_image = funcclim(rot_image,0,60000);
     rot_image = ROI.image;
     wire_mask_temp = logical(zeros(size(rot_image)));
     wire_mask = logical(zeros(size(rot_image)));
      cx = [x1min x1max x1max x1min];
    ry = [y1min y1min y1max y1max];
    wire_mask_temp = roipoly(wire_mask_temp,cx,ry);
    wire_mask = logical(imadd(wire_mask, wire_mask_temp));
     cx = [x2min x2max x2max x2min];
    ry = [y2min y2min y2max y2max];
    wire_mask_temp = roipoly(wire_mask_temp,cx,ry);
    wire_mask = logical(imadd(wire_mask, wire_mask_temp));
     cx = [x3min x3max x3max x3min];
    ry = [y3min y3min y3max y3max];
     wire_mask_temp = roipoly(wire_mask_temp,cx,ry);
   wire_mask = logical(imadd(wire_mask, wire_mask_temp));
       cx = [x4min x4max x4max x4min];
    ry = [y4min y4min y4max y4max];
     wire_mask_temp = roipoly(wire_mask_temp,cx,ry);
     %figure; imagesc(wire_mask_temp); colormap(gray);
    wire_mask = logical(imadd(wire_mask, wire_mask_temp));
       cx = [x5min x5max x5max x5min];
    ry = [y5min y5min y5max y5max];
     wire_mask_temp = roipoly(wire_mask_temp,cx,ry);
   wire_mask = logical(imadd(wire_mask, wire_mask_temp));
       cx = [x6min x6max x6max x6min];
    ry = [y6min y6min y6max y6max];
     wire_mask_temp = roipoly(wire_mask_temp,cx,ry);
    wire_mask = logical(imadd(wire_mask, wire_mask_temp));
    
    bb_mask = logical(zeros(size(rot_image)));
    bb_mask_temp = logical(zeros(size(rot_image)));
    cx = [xbb12min xbb12max xbb12max xbb12min];
    ry = [ ybb12min ybb12min ybb12max ybb12max];
   bb_mask_temp = roipoly(bb_mask_temp,cx,ry);
   bb_mask = logical(imadd(bb_mask, bb_mask_temp));
    cx = [xbb34min xbb34max xbb34max xbb34min];
    ry = [ ybb34min ybb34min ybb34max ybb34max];
    bb_mask_temp = roipoly(bb_mask_temp,cx,ry);
   bb_mask = logical(imadd(bb_mask, bb_mask_temp));
     cx = [xbb56min xbb56max xbb56max xbb56min];
    ry = [ ybb56min ybb56min ybb56max ybb56max];
    bb_mask_temp = roipoly(bb_mask_temp,cx,ry);
   bb_mask = logical(imadd(bb_mask, bb_mask_temp));
     cx = [xbb78min xbb78max xbb78max xbb78min];
    ry = [ ybb78min ybb78min ybb78max ybb78max];
    bb_mask_temp = roipoly(bb_mask_temp,cx,ry);
   bb_mask = logical(imadd(bb_mask, bb_mask_temp));
   
% % %    
% % %     figure; imagesc(wire_mask); colormap(gray);
% % % figure; imagesc(bb_mask); colormap(gray);
% % % %     
     %figure; imagesc(rot_image); colormap(gray);
    bkgr = background_phantomdigital(rot_image);
    %Analysis.BackGroundThreshold = bkgr;
    % Mask0=~(WindowFiltration2D(Image.OriginalImage==0,5)~=0);
    % Analysis.BackGround = Image.image>Analysis.BackGroundThreshold;
    % Analysis.BackGround=(WindowFiltration2D(Analysis.BackGround,3)>0); 
    
    ph_image = rot_image - bkgr;
    max_image = max(max(ph_image))
    a1 = uint8(ph_image/max_image*255); %12600
    %imwrite(rot_image2,'C:\Documents and Settings\smalkov\My Documents\Programs\SXAVersion6.2\phan3_init.tif', 'tif');
   % a = imread('phan3_init.tif', 'tif');
    conn1 = [0 1 0; 0 1 0; 0 1 0];
    %conn1 = conndef(2,'minimal');
   % im_a = imclearborder(a);
    h_phant = figure('Tag','GEN3');imagesc(a1); colormap(gray); hold on;
    funcBox(gen3.xmin,gen3.ymin,gen3.xmin+gen3.columns,gen3.ymin+gen3.rows,'b',2); hold off;
    sza = size(a1);
    %figure;imagesc(a1); colormap(gray); 
    %commented for GE machine
    %a1(1:round(100*crop_coef),sza(2)-round(10*crop_coef):sza(2)) = round(200*crop_coef);
% % %     crop_coef = 1;
     %figure;imagesc(a1); colormap(gray); 
%      x_limit =  1350*crop_coef;
%     if sz_image(2) > x_limit
%        a1 = imclearborder(a1);
%     end
    %figure;imagesc(a1); colormap(gray); 
  %  
   
%     a = zeros(sza(1)+50, sza(2)+50);
%    
%     a(51:end, 1:sza(2)) = a1;
%     %figure;
%     %imagesc(a); colormap(gray); hold on;
%     a(1:50, :) = a1(sza(1),sza(2)); 
%     a(:,sza(2)+1:end ) = a1(sza(1),sza(2)); 
    %mrows = sza(1)+50;
    %ncols = sza(2)+50;
    %a = imresize(a1,[mrows ncols],'bilinear');
         
   %figure;
   %imagesc(a); colormap(gray); hold on;
%    if sz_image(2) < x_limit
%      b = imclearborder(a);
%    else
%      b = a;
%    end
    % b = a;
   % clear a;
  %figure; imagesc(b); colormap(gray); hold off;
   
    %J = imrotate(b,-rot_angle,'bilinear','crop'); %,'crop'28.85 -33,'crop'
    J = rot_image;
    J=a1;
%   sza = size(b)
    szJ = size(J)
    %figure;imagesc(J); colormap(gray); 
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
    se2 = strel('rectangle', round([20 40]*crop_coef));
    se22 = strel('rectangle', [40 20]);
    se21 = strel('rectangle', round([100 300]*crop_coef));
    se_1 = round(60*crop_coef);
    se_2 = round(65*crop_coef);
    se = strel('rectangle',[se_1 se_2]);
    J_open = imopen(J,se21); 
    
 %%figure;imagesc(J_open); colormap(gray);
    % hold on;
    
    %Z = imsubtract(J,J_open); %JW replaced with following line
    Z=J; %use original image instead of difference image
    
    %figure;imagesc(Z); colormap(gray); hold on;
    
   % Z = imclearborder(Z);
   % figure;
   % imagesc(Z); colormap(gray); hold off;
   
    se2_1 = round(20*crop_coef);
    se2_2 = round(40*crop_coef);
    se = strel('rectangle',[se2_1 se2_2]);
    
    im_Z = imopen(Z,se2);
    
%  figure;imagesc(im_Z); colormap(gray);
    Zs1 = imsubtract(Z,im_Z);
    
%     se53 = strel('rectangle', round([40 300]*crop_coef));
%     im_Ztemp = imopen(Zs1,se53);
%   figure;imagesc(im_Ztemp); colormap(gray);
%    Zs1 = imsubtract(Zs1,im_Ztemp);
    
    
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
    maxz = max(max(Zs1))*0.03; %changed to 0.03 for GE
    bw = Zs1>0.02*max(max(Zs1));
    mm = max(max(Zs1))
    %bw = im2bw(Zs1,0.7);
       
  %imagesc(bw); colormap(gray); 
     se3_1 =  round( 7*crop_coef);%round(7*crop_coef);
     se3 = strel('disk',se3_1);
     BB_image = imerode(bw, se3);
     BB_image2 = imdilate(BB_image, se3);
%   figure;imagesc(BB_image); colormap(gray);
     se3_line = strel('rectangle', round([3 3]*crop_coef));
     %se3 = strel('disk',se3_1);
     bw2 = imerode(bw, se3_line);
     se4 = strel('rectangle', round([20 6]*crop_coef));
     J_open = imopen(bw2,se4); 
     %J_open(:,1:5)=0; %JW remove first 10 columns where lines detected at rear of bookends;
    
%  figure;imagesc(J_open); colormap(gray);
     se3_line = strel('rectangle', round([3 3]*crop_coef));
    % se3_line = strel('disk',  3);
     bw3 = imerode(J_open, se3_line);
     
     %bw3 = edge(uint8(bw3),'sobel');
       %;imagesc(J_open); colormap(gray);
%        figure;imagesc(wire_mask); colormap(gray);
     J_open = J_open.*double(wire_mask);
     %figure;imagesc(J_open); colormap(gray);    
     line_detection(uint8(J_open));
     
%      roi_bkgr.ymin = Analysis.y_3 + round((Analysis.y_6 - Analysis.y_3)/5);
%      roi_bkgr.xmin = Analysis.x_3 + 80*crop_coef;
%      roi_bkgr.columns = round(100*crop_coef);
%      roi_bkgr.rows = round(3*(Analysis.y_6 - Analysis.y_3)/5);
%      figure(figuretodraw);
%      
%      roi_xmax2 =  roi_bkgr.xmin+roi_bkgr.columns+ROI.xmin;
%      roi_xmax = min([roi_xmax2, Image.columns]);
%      
%      if flag.small_paddle
%      funcBox(roi_bkgr.xmin+ROI.xmin,roi_bkgr.ymin+ROI.ymin,roi_xmax ,roi_bkgr.ymin+roi_bkgr.rows+ROI.ymin,'r',3); hold on;  
%      bkgr_mean =mean(mean(Image.image(roi_bkgr.ymin+ROI.ymin:roi_bkgr.ymin+ROI.ymin+roi_bkgr.rows-1,roi_bkgr.xmin+ROI.xmin:roi_xmax-1)));
%      else 
%      funcBox(roi_bkgr.xmin+ROI.xmin,roi_bkgr.ymin+ROI.ymin,roi_xmax ,roi_bkgr.ymin+roi_bkgr.rows+ROI.ymin,'r',3); hold on;  %roi_xmax+400
%      bkgr_mean =mean(mean(Image.image(roi_bkgr.ymin+ROI.ymin:roi_bkgr.ymin+ROI.ymin+roi_bkgr.rows-1,roi_bkgr.xmin+ROI.xmin:roi_xmax-1)));
%      end;
%      
% % % %      background=imopen(Image.image,strel('disk',10));
% % % %      figure;imshow(background);hold on
% % % %      I2=Image.image-background;
% % % %      figure;imshow(I2);hold on
% % % %      I3=imadjust(I2);
% % % %      figure;imshow(I3);hold on
% % % %      figure,surf(double(background(1:400:end,1:400:end))), zlim([0 255]);
% % % %      set(gca,'ydir','reverse');
% % % %      figure(figuretodraw);
%      
%      Analysis.Ibkg = bkgr_mean;
%      
     
     
     
    % Image.image = Image.image - bkgr_mean;
         
      %figure;imagesc(bw3); colormap(gray);
    % bw3 = edge(bw3); %,'canny',[ ],2.1
    % theta = 85:0.3:95;  %Radon transform
%      theta = -4:0.2:4;
%     [Line61,Line6] =funcRadonDetectTwoMax1(bw3,theta,0,'last');
%     Line6_diff = abs(Line6.x - Line61.x);
%     Line6=funcComputeLine(size(bw3),Line6);
%     Line61=funcComputeLine(size(bw3),Line61);
%      h6 = figure;imagesc(bw3); colormap(gray); title('Edge detection, Line 6')
%     %h6 = figure;imagesc(tempimage); colormap(gray); title('Edge detection, Line 6')
%     figure(h6); hold on;
%     plot([Line6.x1 Line6.x2],[Line6.y1 Line6.y2],'Linewidth',1,'color','b');
%     hold on; 
%     plot([Line61.x1 Line61.x2],[Line61.y1 Line61.y2],'Linewidth',1,'color','r');
%      %bw2 = imerode(bw, se3);
%      %figure;imagesc(bw2); colormap(gray);
%     %  hold on;
%      %bw = imdilate(bw2, se3);
%      %figure;
%      %imagesc(bw); colormap(gray); hold on;
%     %init = imrotate(bw2,rot_angle,'bilinear','crop'); 
%      bw_init = bw2;
%      szbw_init = size(bw_init)
%      
%    figure;imagesc(bw_init); colormap(gray);
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
    
   sz_bw = size(BB_image);
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
        BB_image = BB_image.*BW_mask;
   end

   % 
% %     figure; imagesc(BB_image); colormap(gray);
    BB_image = BB_image.*bb_mask;
  % figure; imagesc(BB_image); colormap(gray);
    L = bwlabel(BB_image);
    stats2 = regionprops(L,'all');
    ln = length(stats2)
    figure(h_phant); hold on;
  % axes;
    
    for i=1:ln
        plot( stats2(i).Centroid(1),stats2(i).Centroid(2),'.r','MarkerSize',7); hold on;
        text(stats2(i).Centroid(1),stats2(i).Centroid(2)-70,num2str(i),'Color', 'y');
        xy_centroids(i,1:2) = [stats2(i).Centroid(1),stats2(i).Centroid(2)];
    end
%   centroids(1:ln,1:2) = [stats2(1:ln).Centroid(1)+x_width,stats2(1:ln).Centroid(2)-50]; 
  hold on;

 Rmin = 4;
  Rmax = 30;
  [centersBright1, radiiBright1, metricBright1] = imfindcircles(Zs1,[Rmin Rmax], ...
                'ObjectPolarity','bright','Sensitivity',0.85,'EdgeThreshold',0.1)
      
    for i = 1: length(14)
        plot(centersBright1(i,1),centersBright1(i,2),'*magenta');
    end    
     
   [centersBright2, radiiBright2, metricBright2] = imfindcircles(BB_image2,[Rmin Rmax], ...
                'ObjectPolarity','bright','Sensitivity',0.85,'EdgeThreshold',0.1);        

% coord = xy_centroids;
coord = centersBright1;
% sort_coord = GEN3_bbs_sorting(coord );

if size(coord, 1) < 14  %switch to manual selection if BB number < 14
                        %more than 14 BBs may be detected and wrong
                        %detections will be removed by 'findRealBBs( )
    close(h_phant);
    BBcoord = [];
    origDiff = [];
else
     BBcoord_PR = findRealBbs(coord);    %BBcoord on the Phantom Region coord
     BBcoord = toFilmMidCoord(BBcoord_PR, ROI.xmin, ROI.ymin, rows);
    coord = coord(1:14,:)
    BBcoord = toFilmMidCoord(coord, ROI.xmin, ROI.ymin, rows);
%     origDiff = QCbbs_sorting(coord);
end
a = 1;

%%
function filmMidCoord = toFilmMidCoord(PRcoord, ROIxmin, ROIymin, filmRows)

x_shift = ROIxmin - 1;      %ROI w.r.t. mid-point
mid_y = filmRows/2;
y_shift = (ROIymin - 1) - mid_y;

filmMidCoord(:, 1) = PRcoord(:, 1) + x_shift;
filmMidCoord(:, 2) = PRcoord(:, 2) + y_shift;


%by Song: function counting bbs only and ordering them

  %  BBcoord = findRealBbs(coord);


% This part of code is used for viewing the BB finding results
% h_LabelBB = figure('Tag','Labeling_BBs'); imagesc(a1); colormap(gray);
% hold on;
% for BBidx = 1:14
%     plot(BBcoord(BBidx, 1), BBcoord(BBidx, 2), '.r', 'MarkerSize', 7);
%     text(BBcoord(BBidx, 1), BBcoord(BBidx, 2) - 70, num2str(BBidx), 'Color', 'y');
% end
% pause;
% close(h_LabelBB);
% asdfghkl;   %this will generate error, so stop following analysis and database writing

%JW 6/3/10 added to record bb locations in SQL table
% % % [QCGen3BBlocations_id]=cell2mat(mxDatabase(Database.Name,['SELECT MAX(QCGen3BBlocations_id) AS x FROM dbo.QCGen3BBlocationsNew'],1));
% % % BBcoordSQL{1}=num2str(QCGen3BBlocations_id+1);
% % % BBcoordSQL{2}=num2str(Info.AcquisitionKey);
% % % BBcoordSQL{3}=num2str(BBcoord(1,1));
% % % BBcoordSQL{4}=num2str(BBcoord(1,2));
% % % BBcoordSQL{5}=num2str(BBcoord(2,1));
% % % BBcoordSQL{6}=num2str(BBcoord(2,2));
% % % BBcoordSQL{7}=num2str(BBcoord(3,1));
% % % BBcoordSQL{8}=num2str(BBcoord(3,2));
% % % BBcoordSQL{9}=num2str(BBcoord(4,1));
% % % BBcoordSQL{10}=num2str(BBcoord(4,2));
% % % BBcoordSQL{11}=num2str(BBcoord(5,1));
% % % BBcoordSQL{12}=num2str(BBcoord(5,2));
% % % BBcoordSQL{13}=num2str(BBcoord(6,1));
% % % BBcoordSQL{14}=num2str(BBcoord(6,2));
% % % BBcoordSQL{15}=num2str(BBcoord(7,1));
% % % BBcoordSQL{16}=num2str(BBcoord(7,2));
% % % BBcoordSQL{17}=num2str(BBcoord(8,1));
% % % BBcoordSQL{18}=num2str(BBcoord(8,2));
% % % BBcoordSQL{19}=num2str(BBcoord(9,1));
% % % BBcoordSQL{20}=num2str(BBcoord(9,2));
% % % BBcoordSQL{21}=num2str(BBcoord(10,1));
% % % BBcoordSQL{22}=num2str(BBcoord(10,2));
% % % BBcoordSQL{23}=num2str(BBcoord(11,1));
% % % BBcoordSQL{24}=num2str(BBcoord(11,2));
% % % BBcoordSQL{25}=num2str(BBcoord(12,1));
% % % BBcoordSQL{26}=num2str(BBcoord(12,2));
% % % BBcoordSQL{27}=num2str(BBcoord(13,1));
% % % BBcoordSQL{28}=num2str(BBcoord(13,2));
% % % BBcoordSQL{29}=num2str(BBcoord(14,1));
% % % BBcoordSQL{30}=num2str(BBcoord(14,2));
%[key,error]=funcAddInDatabase(Database,'QCGen3BBlocationsNew',BBcoordSQL);
%asdfjkl;
      
%       if ln > 5 & ln < 10  %len
%         sort_coord = bbs_sortingZ2(coord,machine,Analysis.second_phantom, rot_angle )
%         ln = length(sort_coord(:,1));
%         sort_coord(:,2) = sort_coord(:,2) + ycoord_shift;
%       else  
%          sort_coord = coord;
%          sort_coord(:,3) = (1:ln)';
%          a = 'manual regime'
%          Error.StepPhantomBBsFailure = true;
%          stop;
%       end
%          hold on;
%          figure(figuretodraw);
%          redraw;
%          plot(sort_coord(:,1), sort_coord(:,2),'.r','MarkerSize',7);
%          hold on;
% 
%          for i=1:ln
%              text(sort_coord(i,1),sort_coord(i,2)-20,num2str(sort_coord(i, 3)),'Color', 'y'); 
%          end
          ;
   % save('coord_BBs6.txt', 'sort_coord', '-ascii');
%    center_coord = QCbbs_sorting(coord);
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
    
   
    