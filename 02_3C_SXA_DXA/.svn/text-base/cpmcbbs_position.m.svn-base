function [X, Y] = bbs_position()
    global Image
    rot_image = Image.image(1:420,690:end);
    rot_image2 = uint8(Image.image(1:420,690:end)/126000*255);
    imwrite(rot_image2,'C:\Documents and Settings\smalkov\My Documents\Programs\SXAVersion6.2\phan3_init.tif', 'tif');
    a = imread('phan3_init.tif', 'tif');
    conn1 = [0 1 0; 0 1 0; 0 1 0];
    %conn1 = conndef(2,'minimal');
   % im_a = imclearborder(a);
    h_init = figure;
    imagesc(a); colormap(gray);
  
    J = imrotate(a,-31.8,'bilinear'); %,'crop'28.85 -33,'crop'
    figure;
    imagesc(J); colormap(gray); 
      
   % rot_image2 = uint8(J/126000*255);
       
  % figure;
  % imagesc(J); colormap(gray); hold on;
  %  J_init = imrotate(J,28,'bilinear','crop'); 
   % figure;
   % imagesc(J_init); colormap(gray); hold on;
    
  %  h_init = figure;
  %  imagesc(J); colormap(gray); hold on;
    
    se5 = strel('disk', 9);
    se3 = strel('rectangle',[10 9]);%working
    %se3 = strel('rectangle',[9 5]);
    %se4 = strel('rectangle',[6 10]);
    %b = imclose(J, se2);
    se2 = strel('rectangle', [20 40]);
    se22 = strel('rectangle', [40 20]);
     se21 = strel('rectangle', [200 100]);
    se = strel('rectangle',[60 65]);
    J_open = imopen(J,se); 
    Z = imsubtract(J,J_open);
    %figure;
    %imagesc(Z); colormap(gray); hold on;
    
    im_Z = imopen(Z,se2);
    
    %figure;
    %imagesc(im_Z); colormap(gray); hold on;
    Zs1 = imsubtract(Z,im_Z);
    
    im_Z = imopen(Zs1,se22);
    Zs0 = imsubtract(Zs1,im_Z);
    
     im_Z2 = imopen(Zs0,se21);
    Zs2 = imsubtract(Zs0,im_Z2);
    
    Zs1 = imadjust(Zs2);
    figure;
    imagesc(Zs1); colormap(gray); hold on;
   
    
    
    %se2 = strel('rectangle',[20 40]);
    %Z_open = imopen(Z,se); 
    
    bw = im2bw(Zs1,0.4);
       
    figure;
    imagesc(bw); colormap(gray); hold on;
     bw2 = imerode(bw, se3);
     bw_init = imrotate(bw2,31.8,'bilinear','crop'); 
     figure;
     imagesc(bw_init); colormap(gray); hold on;
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
      
    bw2 = imdilate(bw_init, se3);
    bw3 = imclearborder(bw2);
    figure;
    imagesc(bw3); colormap(gray); hold off;
    
    L = bwlabel(bw3);
    stats2 = regionprops(L,'all');
    ln = length(stats2)
    figure(h_init); hold on;
  % axes;
     for i=1:ln
     plot( stats2(i).Centroid(1),stats2(i).Centroid(2) ,'.r','MarkerSize',7); hold on;
     end
     hold off;
     figure(h_init); hold on;
  % axes;
     X = zeros(ln,1);
     Y = zeros(ln,1);
     for i=1:ln
     plot( stats2(i).Centroid(1),stats2(i).Centroid(2) ,'.b','MarkerSize',7); hold on;
     X(i) = stats2(i).Centroid(1);
     Y(i) = stats2(i).Centroid(2);
     end
     
     % B = bwboundaries(stats2(2).Image)
    % B = cell2mat(B);
    % X = B(:,1);
    % Y = B(:,2);
    % a = fitellipse(X,Y);
    % figure;
    % imagesc(stats2(2).Image); colormap(gray); hold on;
    % plot(X,Y, '-b', 'LineWidth',4);
     %figure;
    %imagesc(bw3); colormap(gray); hold on;
    
    %bw4 = imerode(bw3, se4);
    %bw5 = imdilate(bw4, se5);
    %figure;
    %imagesc(bw5); colormap(gray); hold on;
    
   % im_Zs = imopen(Zs,se3);
   % figure;
   % imagesc(Zs); colormap(gray); hold on;
   % figure;
   % imagesc(im_Zs); colormap(gray); hold on;
    %Zs = imsubtract(Z,Z_open);
    %figure;
    %imagesc(Zs); colormap(gray); hold on;
  %  imagesc(bw_open); colormap(gray);
    %se2 = strel('disk', 8);
    %J = imclose(Z,se2);
    %d = imopen(Z, se2);
    %bw = im2bw(Z,0.15);
    %bw2 = imopen(bw,se2);
    %se3 = strel('rectangle',[5 20]);
    %bw_open = imopen(bw,se2);
    %figure;
   %imagesc(bw_open); colormap(gray);
    