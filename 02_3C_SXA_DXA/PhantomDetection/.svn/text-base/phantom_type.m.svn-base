function type = phantom_type(current_image)
global Image Correction
    %% Right edge of the search box for the phantom = right edge of the image
    %maxX=size(Image.image,2);

    %% maximum value for the bottom of the phantom (to accelerate edge function)
   % maxY=500;
    %{
    ExtractedImage=+(Image.OriginalImage(1:maxY,round(size(Image.OriginalImage,2)/4):round(3*size(Image.OriginalImage,2)/4)));
    ExtractedImage=(ExtractedImage<Correction.SaturatedThreshold)&(ExtractedImage~=0);
    figure;
    imagesc(ExtractedImage); colormap(gray); 
    %}
    [y, x] = size(current_image);
    %rect = [xmin ymin width height];
    rect = [x-600 10 570 600]; %[y/2 0 3*y/8 x/2]
    ExtractedImage=imcrop(current_image,rect);
    sz = size(ExtractedImage);
    
   % J = imrotate(ExtractedImage,-28,'bilinear','crop'); %,'crop'28.85 -33,'crop'
    % szJ = size(J)
    %figure;
    %imagesc(J); colormap(gray); 
    % figure;
    %imagesc(ExtractedImage); colormap(gray);
    imax = max(max(ExtractedImage));
    imin = min(min(ExtractedImage(ExtractedImage~=0)));
    H = fspecial('disk',5);
    LE1 = imfilter(ExtractedImage,H,'replicate');
    LEsm = funcGradientGauss(LE1,5);
    %figure;
    %imagesc(LEsm); colormap(gray);
    imin = min(min(LEsm(20:end, 1:end-50)));
    histogram=histc(reshape(LEsm,1,sz(1)*sz(2)),imin:imax);
    % figure;
    %  bar(histogram);
    [C,I]=max(histogram(1:round(size(histogram,2)/2)));
    Ibkg = I + imin;
    ExtractedImageNorm = uint8((ExtractedImage-Ibkg) /imax*255);
    %figure;
    %imagesc(ExtractedImageNorm); colormap(gray); 
   % se = strel('rectangle',[60 60]);
   % J_open = imopen(ExtractedImageNorm,se); 
    
    %figure;
    %imagesc(J_open); colormap(gray); hold on;
    
    %Z = imsubtract(ExtractedImageNorm,J_open);
    %figure;
    %imagesc(Z); colormap(gray); hold on;
    %bw2 =J_open >0.1*max(max(J_open));
    %
    %figure;
    %imagesc(bw2); colormap(gray); hold on;
    %total2 = sum(sum(bw2))
    %percent2 = total2/ area*100
    bw = ExtractedImageNorm>0.4*max(max(ExtractedImageNorm));
    area = sz(1)*sz(2);
    a = bw(50:end, end-30:end-20);
    %figure;
    %imagesc(a); colormap(gray); 
    x = find(a == 0);
    c = [0 250 300 300 0 ];
    r = [300 300 400 600 600 ];
    BW_mask = 1-roipoly(bw,c,r);
   % figure;
    % imagesc(BW_mask); colormap(gray)
    bw_final = bw.*BW_mask;
    
   %figure;
   %imagesc(bw_final); colormap(gray); 
   % area = polyarea(bw);
   if isempty(x)
       total = sum(sum(bw_final))-1500 - sz(1)* 40;
   else
       total = sum(sum(bw_final))-3000;
   end
   %total = sum(sum(bw))-3000
   
   percent = total/ area*100;
   
   line_counts = find(bw_final(10,:));
   counts = length(line_counts);
   if percent < 1.2
       type = 'NO';
   elseif percent >= 1.2 & percent < 2.5
       if counts > 100
           type = 'WEDGE';
       else
           type = 'NO';
       end
   elseif percent >= 2.5 & percent <= 10
       type = 'WEDGE';
   elseif percent > 10 
       if counts > 100
           type = 'WEDGE';
       else
           type = 'STEP';
       end
   end
   tp = type
   ;
       
       
    
    
    