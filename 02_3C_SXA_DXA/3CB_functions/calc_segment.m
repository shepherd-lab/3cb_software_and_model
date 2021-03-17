function mask_calc  = calc_segment(pres_image, atten_image, lesion_ROI)
  se = strel('disk',20);
  temproi = pres_image.*lesion_ROI;
  tophatFiltered = imtophat(pres_image,se);
  %contrastAdjusted = imadjust(tophatFiltered);
  hh = cumsum(tophatFiltered)
  
%  figure;histogram(tophatFiltered ,'Normalization','cdf');

 figure;histogram(tophatFiltered );
[f,z]=hist(CharPoly,1000000);
% Make pdf by normalizing counts
% Divide by the total counts and the bin width to make area under curve 1.
fNorm = f/(sum(f)*(z(2)-z(1))); 
% cdf is no cumulative sum
fCDF = cumsum(fNorm);
bar(z,fCDF) % display
  
  figure;imagesc(contrastAdjusted);colormap(gray);
  a = 1;
     
  

end

% % % 
% % %    temproi = atten_image.*lesion_ROI;
% % %         Rmin = 5;
% % %         Rmax = 65;
% % %         
% % %         % % % Image.OrginalWithoutPhantom = zeros(size(Image.image));
% % %         % % % Image.OrginalWithoutPhantom(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1) = temproi;
% % % %         try
% % %             [centersBright, radiiBright, metricBright] = imfindcircles(temproi,[Rmin Rmax], ...
% % %                 'ObjectPolarity','bright','Sensitivity',0.85,'EdgeThreshold',0.1);
% % %         
% % %             k=1;
% % %         
% % %             if ~size(centersBright)==0
% % %                 Info.classification=true;
% % %                 p = zeros(size(lesion_ROI));
% % %                 Add= im2bw(p);
% % %         %         figure;imagesc(temproi);colormap(gray)
% % %                 hBright=viscircles(centersBright, radiiBright,'LineStyle','--');
% % %                 for k = 1:length(metricBright)
% % %                     [iy ix]=size(lesion_ROI);
% % %                     cx=centersBright(k,1);
% % %                     cy=centersBright(k,2);
% % %                     r=radiiBright(k);
% % %                     [x,y]=meshgrid(-(cx-1):(ix-cx),-(cy-1):(iy-cy));
% % %                     classification=((x.^2+y.^2)<=r^2);
% % %                     Add= im2bw(Add);
% % %                     Add = imadd(classification, Add);
% % %                     %      figure;imagesc(Add);colormap(gray)
% % %                 end
% % %         
% % %                 classification_Maks=Add;
% % %                 clear Add;
% % %         
% % %               mask_calc=lesion_ROI.*(~classification_Maks); % Remove Classification from density
% % %         
% % %             else
% % %                 Info.classification=false;
% % %                 mask_calc=lesion_ROI;
% % %         
% % %             end;
% % % %         catch
% % % %             lasterr
% % % %         end
