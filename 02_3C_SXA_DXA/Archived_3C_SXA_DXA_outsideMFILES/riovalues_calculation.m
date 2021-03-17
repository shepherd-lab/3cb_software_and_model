function [roi_valuescorr,roi_centroids] = riovalues_calculation(image) %Xim_calc, x0_shift,y0_shift,index,k, Xcm, Ycm, film_small
    global    stepdata Database %Image
     %figure(figuretodraw);
     Xim_calc = stepdata.Xim_calc;
     x0_shift = stepdata.x0_shift;
     y0_shift = stepdata.y0_shift;
     index = stepdata.index;
     k = stepdata.k;
     Xcm = stepdata.Xcm;
     Ycm = stepdata.Ycm;
     film_small = stepdata.film_small
     %redraw;
     
    
    ln = length(Xim_calc(:,1));
    paddle_shift = 0;
    sz = size(image); % 1407 1408 
     xmax_pixels = sz(2);
     ymax_pixels = sz(1);
     y0source_pixels = ymax_pixels/2 + paddle_shift / k;
     %{
     plot(Xim_calc(:,1)/k-x0_shift, ymax_pixels/2+y0_shift - Xim_calc(:,2)/k,'*r');
     for i = 1:ln
          text(Xim_calc(i,1)/k-x0_shift, ymax_pixels/2+y0_shift - Xim_calc(i,2)/k-15,num2str(index(i)),'Color', 'g'); 
     end
     %}
    %plot(tx0/k-x0_shift, ymax_pixels/2+y0_shift - ty0/k,'*b');
    roi_len = length(Xcm(:,1));
   % b1 = get(gca,'ColorOrder');
    %b2 = get(gca,'ColorOrder');
    %b = [b1;b2];
    
  %  b(8,:) = b(1,:);
  %  b(9,:) = b(1,:); 
    %{
    for i = 1:roi_len 
        plot([Xcm(i,:),Xcm(i,1)]/k-x0_shift,y0source_pixels+y0_shift-[Ycm(i,:),Ycm(i,1)]/k, 'Color',b(i,:)); hold on;
    end
    %}
    %   redraw;
     xm = strmatch('mammo_Marsden', Database.Name, 'exact');
     if film_small == true
            ycrop = 520;
            xcrop = 690;
     else
         if xm > 0
            ycrop = 500;
            xcrop = 900; 
         else
            ycrop = 500;
            xcrop = 1100;
         end
     end
         
        X = Xcm/k - xcrop-x0_shift;
        Y = y0source_pixels+y0_shift-Ycm/k;
        sz = size(image);
        %I = uint8(Image.image(1:ycrop,xcrop:end)/126000*255);
        I = image(1:ycrop,xcrop:end);
        szi = size(I);
        xm = szi(2);
        ym = szi(1);
        xc = [1,xm, xm, 1];
        yc = [1, 1, ym, ym];
        allroi_mask = (1 - roipoly(I,xc,yc));
        imroi_rest = allroi_mask;
        
        scrsz = get(0,'ScreenSize');
        imroi_bottom = roipoly(I,X(end,:),Y(end,:));
        
        tcolor(1,1,1:3) = [1, 0.5, 1];
        edgecolor = [0, 1, 0];
        transparency = 0.5;
        color_list = 'ymcrgbymc';
        x = [xcrop,xmax_pixels, xmax_pixels, xcrop];
        y = [1, 1, ycrop, ycrop];
         se3 = strel('disk',8);
       %%%%%%%%%%%%%%% from rio_plot %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
             count = 2;
       while  count > 0
                   
         for i = 1:roi_len-1
            Xrest = X;
            Yrest = Y;
            Xrest(i,:) = [];
            Yrest(i,:) = [];
            Xcurrent = X(i,:);
            Ycurrent = Y(i,:);
            imroi_current = roipoly(I,Xcurrent,Ycurrent);
            %roi_area = polyarea(I,Xcurrent,Ycurrent);
            imroi_rest = (1 - roipoly(I,xc,yc));;
            for  j = 1:roi_len-2
              imroi_image = roipoly(I,Xrest(j,:),Yrest(j,:));
              imroi_rest = imroi_rest + imroi_image;
            end
            %{
             figure;
            imagesc(imroi_current);colormap(gray);
             figure;
            imagesc(imroi_rest);colormap(gray);
             figure;
            imagesc(imroi_bottom);colormap(gray);
            %}
            bw =   immultiply((imroi_current-imroi_rest).*((imroi_current-imroi_rest)>0),imroi_bottom);
            %figure;
            roi_mask = imerode(bw, se3); 
            %roi_mask = bw;
            %imagesc(roi_mask);colormap(gray);hold on;
            %patch(x,y,'r','FaceAlpha',transparency);
            allroi_mask = allroi_mask + roi_mask;
            Lst = bwlabel(roi_mask);
           
            props_centr = regionprops(Lst,'Centroid');
            props_area = regionprops(Lst,'Area');
            szp = size(props_centr);
            for j = 1:length(props_area)
              props_all(j,:) = [props_centr(j).Centroid,props_area(j).Area];
            end
            props1 = sortrows(props_all,3);
            props = props1(end,:);
             
            if isempty(props)|props(3)< 50
                roi_centroids(i,1:2) = [0,0];
                roi_valuescorr(i) =  [-1];   
            else
                roi_centroids(i,1:2) = props(1:2);
                roi_area(i,3) = props(3);
                roi_valuescorr(i) =  nansum(nansum(I.*roi_mask))/sum(sum(roi_mask));
            end
        end
           roi_missed = find(roi_valuescorr == -1);
           if ~isempty(roi_missed)
               se3 = strel('disk',1);
               count = count -1;
               flag_missed = true;  
           else
               count = count -2;
           end          
       end   
         
        roi_centroids(:,1) = roi_centroids(:,1) + xcrop; 
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   original %%%%%%%%%%%%%%%%%%%%%% 
      %{ 
       for i = 1:roi_len-1
            Xrest = X;
            Yrest = Y;
            Xrest(i,:) = [];
            Yrest(i,:) = [];
            Xcurrent = X(i,:);
            Ycurrent = Y(i,:);
            imroi_current = roipoly(I,Xcurrent,Ycurrent);
            %roi_area = polyarea(I,Xcurrent,Ycurrent);
            imroi_rest = (1 - roipoly(I,xc,yc));;
            for  j = 1:roi_len-2
              imroi_image = roipoly(I,Xrest(j,:),Yrest(j,:));
              imroi_rest = imroi_rest + imroi_image;
            end
            %{
             figure;
            imagesc(imroi_current);colormap(gray);
             figure;
            imagesc(imroi_rest);colormap(gray);
             figure;
            imagesc(imroi_bottom);colormap(gray);
            %}
            bw =   immultiply((imroi_current-imroi_rest).*((imroi_current-imroi_rest)>0),imroi_bottom);
            % figure;
            roi_mask = imerode(bw, se3); 
            %imagesc(roi_mask);colormap(gray);hold on;
            %patch(x,y,'r','FaceAlpha',transparency);
            allroi_mask = allroi_mask + roi_mask;
            Lst = bwlabel(roi_mask);
           
            props = regionprops(Lst,'Centroid');
            roi_centroids(i,1:2) = props.Centroid;
            roi_valuescorr(i) =  nansum(nansum(I.*roi_mask))/sum(sum(roi_mask));
        end
     %}   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       
        % se3 = strel('disk',2);
    
        
        
        
        
        
        
        
        %figure;
         %imagesc(allroi_mask);colormap(gray);
        rv = roi_valuescorr'
       %{ 
        h_init = figure;
        Imax = max(max(I));
        Imin = min(min(I));
        %SBlack = uint8(zeros(ym,xm,3));
        %Sred = SBlack;
        %Sred(:,:,1) = 255;
        %allroi_mask = Sred.*allroi_mask;
        %figure;
        %imshow(I); hold on;
        %imshow(allroi_mask); 
                
        imwithmask = uint8(255*(I-Imin)/(Imax-Imin)) - uint8(255*allroi_mask);
        %imwithmask = Sred;
        imagesc(imwithmask); colormap(gray);  hold on;% title('Now, you can select the first set of coordinates');hold on;
        set(h_init,'Position',[1 scrsz(4)*7/8 scrsz(3)*7/8 scrsz(4)*7/8]);
        plot(Xim_calc(:,1)/k-x0_shift-xcrop, ymax_pixels/2+y0_shift - Xim_calc(:,2)/k,'*r');  
        for i = 1:ln
          text(Xim_calc(i,1)/k-x0_shift-xcrop, ymax_pixels/2+y0_shift - Xim_calc(i,2)/k-15,num2str(index(i)),'Color', 'g'); 
        end
        
         hold on;
           ;
    for i = 1:roi_len-1 
        plot([Xcm(i,:),Xcm(i,1)]/k-x0_shift-xcrop,y0source_pixels+y0_shift-[Ycm(i,:),Ycm(i,1)]/k, 'Color',b(i,:)); hold on;
        text(roi_centroids(i,1),roi_centroids(i,2),num2str(i),'Color', 'r'); 
    end
    %}
   