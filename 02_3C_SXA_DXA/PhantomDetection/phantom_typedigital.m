function type = phantom_typedigital()
global Image Correction Error Analysis
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
   current_image = Image.OriginalImage;
   %figure; imagesc(current_image); colormap(gray);
   
    [y, x] = size(current_image);
    %rect = [xmin ymin width height];
    %rect = [x-600 1 570 600]; %[y/2 0 3*y/8 x/2] 570
    
     if x <1350
         ycrop = 520;
         xcrop = 590; % 690 for other
     else
         ycrop = 650;
         xcrop = 1000;
     end
    
    if Analysis.second_phantom == false
        rect = [x-xcrop 1 xcrop ycrop];
    else
        rect = [x-xcrop y-ycrop xcrop ycrop];
    end
         
    %{
    if Analysis.second_phantom == false
        rect = [x-500 1 500 600];
    else
        rect = [x-500 y-600 500 600];
    end
    %}
    
    
    ExtractedImage=imcrop(current_image,rect);
    % ExtractedImage = current_image(1:ycrop,xcrop:end);
    sz = size(ExtractedImage);
   % figure; imagesc(ExtractedImage); colormap(gray);
   % J = imrotate(ExtractedImage,-28,'bilinear','crop'); %,'crop'28.85 -33,'crop'
    % szJ = size(J)
  % figure;
  %  imagesc(ExtractedImage); colormap(gray); 
    % figure;
    %imagesc(ExtractedImage); colormap(gray);
    imax = max(max(current_image));
    imin = min(min(ExtractedImage(ExtractedImage>1)));
    H = fspecial('disk',5);
    ExtractedImage = imfilter(ExtractedImage,H,'replicate');
   % LEsm = funcGradientGauss(LE1,5);
    imin = min(min(ExtractedImage(ExtractedImage>1)));
    zero_index = find(ExtractedImage>1);
   % figure;
   % imagesc(ExtractedImage); colormap(gray);
    %imin = min(min(LEsm(20:end, 1:end-50)));
    histogram=histc(reshape(ExtractedImage(zero_index),1,length(zero_index)),imin:imax);
    %histogram=histc(reshape(ExtractedImage,1,sz(1)*sz(2)),imin:imax);
    %figure;
    %bar(histogram);
    [C,I]=max(histogram(1:round(size(histogram,2)/2)));
    Ibkg = I;% + imin;
    ExtractedImageNorm = uint8((ExtractedImage-Ibkg) /(imax-Ibkg)*255);
    
   % figure;imagesc(ExtractedImageNorm); colormap(gray); 
    %
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
    normmax = uint8((imax-Ibkg)/256);
    bw = ExtractedImageNorm>0.2*normmax;
    %figure;imagesc(bw); colormap(gray); 
    area = sz(1)*sz(2);
   % a = bw(50:end, end-30:end-20);
   % figure;
   % imagesc(a); colormap(gray); 
   % x = find(a == 0);
   % c = [0 250 300 300 0 ];
   % r = [300 300 400 600 600 ];
    c = [0 350 0];
    r = [0 sz(1) sz(1) ];
    
    BW_mask = 1-roipoly(bw,c,r);
    
    bw_final = bw.*BW_mask;
    total = sum(sum(bw_final));
    percent1 = total/ area*100;
    %figure;imagesc(bw_final); colormap(gray);
    %
    
    %bw_final = imclearborder(bw_final); %comment for phantom calibration and for phantom Z4
  
    total = sum(sum(bw_final));
   percent2 = total/ area*100;
   %(Ibkg == 1 | Ibkg == 0) 
   if percent1 >3 & percent2 < 1     
       type = 'BAD'; 
       Error.StepPhantomFailure = true;
       Error.StepPhantomPosition = true;
   elseif percent2 >= 3 %for digital images only, for analog = 4 
       type = 'STEP'
   else
        type = 'NO';
        Error.StepPhantomFailure = true;
   end
   
   type = 'STEP';
   %{
   if percent < 4 &(Ibkg == 1 | Ibkg == 0)       
       type = 'NO';
   elseif percent < 4
       type = 'BAD'; 
   elseif percent >= 4
        type = 'STEP'
   end
   %}        
   tp = type
   ;
       
       
    
    
    