function draw_phantom()
 global stepdata figuretodraw Image
     figure(figuretodraw);
     Xim_calc = stepdata.Xim_calc;
     x0_shift = stepdata.x0_shift;
     y0_shift = stepdata.y0_shift;
     index = stepdata.index;
     k = stepdata.k;
     Xcm = stepdata.Xcm;
     Ycm = stepdata.Ycm;
     film_small = stepdata.film_small
     %redraw;
     
    ln = length(Xim_calc(:,1)); %number of bbs
    paddle_shift = 0;
    sz = size(Image.OriginalImage); % 1407 1408 
     xmax_pixels = sz(2);
     ymax_pixels = sz(1);
     y0source_pixels = ymax_pixels/2 + paddle_shift / k;
     plot(Xim_calc(:,1)/k-x0_shift, ymax_pixels/2+y0_shift - Xim_calc(:,2)/k,'*r');
     for i = 1:ln
          text(Xim_calc(i,1)/k-x0_shift, ymax_pixels/2+y0_shift - Xim_calc(i,2)/k-15,num2str(index(i)),'Color', 'g'); 
     end
    %plot(tx0/k-x0_shift, ymax_pixels/2+y0_shift - ty0/k,'*b');
    roi_len = length(Xcm(:,1)); % = 10 - 9 ROI + 1 Bottom
    b1 = get(gca,'ColorOrder');
    b2 = get(gca,'ColorOrder');
   
    b = [b1;b2;b1];
    
  %  b(8,:) = b(1,:);
  %  b(9,:) = b(1,:); 
    for i = 1:roi_len 
        plot([Xcm(i,:),Xcm(i,1)]/k-x0_shift,y0source_pixels+y0_shift-[Ycm(i,:),Ycm(i,1)]/k, 'Color',b(i+1,:)); hold on;
    end