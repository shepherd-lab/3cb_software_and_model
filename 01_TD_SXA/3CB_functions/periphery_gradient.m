function  periph_Xgrad = periphery_gradient()              
        global Info Analysis Image Outline BreastMask  FD ROI  figuretodraw  thickness_mapproj    
             
        dynamic=65536;
        sz = size(ROI.image);
        BreastMask = imresize(BreastMask,sz);
        CurrentImage=Image.image(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1).*BreastMask;
        UnderSamplingFactor=1;
        BreastFraction=1;               
        
        bins=[0:1000]*(dynamic-Analysis.BackGroundThreshold)/1000;
        FlatImage=reshape(CurrentImage,prod(size(CurrentImage)),1);
        Histc = histc(FlatImage,bins);
        clear FlatImage; % save memmory
        Histc(1)=0;   %erase background from calculation
        Histp=cumsum(Histc);
        Histp=Histp/Histp(end);
        FractalCurrentImage=CurrentImage;
                   j=1;
        fractal_mask_1=zeros(size(BreastMask));
        for  FractalThreshold=[0.05 0.2]   %0.1 0.15 0.2               
            [~,thresholdindex]=max(Histp>FractalThreshold);
            threshold=bins(thresholdindex);
            image = (FractalCurrentImage>threshold);
            indexFractalThreshold=j;
            fractal_mask_1(:,:,indexFractalThreshold) = BreastMask.*~image;
%             fractal_mask=image;
            clear image; 
            clear fractal_mask  % save memmory            
            j=j+1;           
         end
        
%          Analysis.midpoint =
          fractal_diffmask =  fractal_mask_1(:,:,2).*(~fractal_mask_1(:,:,1));
%          fractal_diffmask =  fractal_mask_1(:,:,2);
         SE20 =  strel('disk',20);
         temp_mask = imdilate(fractal_diffmask,SE20);
         fractal_diffmask = imerode(temp_mask,SE20);
         sz_mask = size(fractal_diffmask);
         fractal_diffmask(:,1:sz_mask(2)/8) = 0;
         fractal_diffmask(:,end-sz_mask(2)/3:end) = 0;
%         figure;imagesc(fractal_diffmask);colormap(gray);  
          H = fspecial('disk',11);
       current_image = imfilter(FractalCurrentImage,H,'replicate');
       FractalCurrentImage = funcGradientGauss(current_image,11);
         FractalCurrentImage = FractalCurrentImage.*fractal_diffmask;
%           figure;imagesc(FractalCurrentImage);colormap(gray);  
          [FX,FY] = gradient(FractalCurrentImage);
%           ind_nozero = find(FractalCurrentImage>0);
%           atten = FractalCurrentImage(ind_nozero);
%           thick = thickness_mapproj(ind_nozero);
%           ind_thick0 = find(thick==0);
%            thick(ind_thick0) = [];
%            atten(ind_thick0) = [];
             FX_vect = FX(FX~=0);
%              FY_vect = FY(FY~=0);
             
        [sorted_FX_vect,pos]= sort(FX_vect);
        % 99 percentile Intensity of ROI image
        prc = prctile(sorted_FX_vect,[30 70]); %-5
        prc20 = prc(1);
        prc80= prc(2); 
        ind = (FX_vect < prc20 | FX_vect > prc80);
        FX_vect(ind) = [];  
             
             mean_fx = mean(FX_vect)
%              mean_fy = mean(FY_vect)
     periph_Xgrad = mean_fx;
             
             
        a = 1;