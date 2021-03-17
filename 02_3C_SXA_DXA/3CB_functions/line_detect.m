function [lines_desc_comb, lines_asc_comb ]= line_detect(BW)

se1 = strel('disk',1); se2 = strel('disk',2);
closeBW = imdilate(BW,se1); 
openBW = imerode(closeBW,se1); 

PSF = fspecial('gaussian',2); 
BW = imfilter(BW,PSF,'symmetric','conv');


[H,theta,rho] = hough(BW,'RhoResolution',1.5,'Theta',[43:0.1:47,-47:0.1:-43]); %,'RhoResolution',0.5,'Theta',-50:0.01:-40
% % figure, imshow(imadjust(mat2gray(H)),[],'XData',theta,'YData',rho,...
% %         'InitialMagnification','fit');
% % xlabel('\theta (degrees)'), ylabel('\rho');
% % axis on, axis normal, hold on;
% % colormap(hot)
P = houghpeaks(H,300,'threshold',ceil(0.3*max(H(:))));
% % x = theta(P(:,2));
% % y = rho(P(:,1));
% % plot(x,y,'s','color','black');
lines = [];
lines = houghlines(BW,theta,rho,P,'FillGap',30,'MinLength',600);
% figure, imshow(BW), hold on
max_len = 0;
kd = 0;
ka = 0;
clear lines_desc;
clear lines_asc;
clear lines_desc_sort;
clear lines_asc_sort

for k = 1:length(lines)
%    xy = [lines(k).point1; lines(k).point2];
%    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
   if lines(k).theta > 0
       kd = kd + 1;
       lines(k).b = lines(k).point1(1) + lines(k).point1(2);
       lines_asc(kd) = lines(k);
     else
       ka = ka + 1;
       lines(k).b = lines(k).point1(2) - lines(k).point1(1); 
       lines_desc(ka) = lines(k);    
   end

end

ln = length(lines)

    
[lines_desc_sort index1] = sortStruct(lines_desc,'b', -1);
[lines_asc_sort index2] = sortStruct(lines_asc,'b', -1);


lines_asc_comb = line_combine(lines_asc_sort,BW);
len_asc = size(lines_asc_comb);


lines_desc_comb = line_combine(lines_desc_sort,BW);
len_desc = size(lines_desc_comb);

% figure;imagesc(BW);colormap(gray);hold on;
% for k = 1:len_asc
%    xy = [lines_asc_comb(k).point1; lines_asc_comb(k).point2];
%    plot(xy(:,1),xy(:,2),'LineWidth',1.5,'Color','blue');
%    a = 1;
% end
% 
% for k = 1:len_desc
%    xy = [lines_desc_comb(k).point1; lines_desc_comb(k).point2];
%    plot(xy(:,1),xy(:,2),'LineWidth',1.5,'Color','red'); 
%    a = 1;
% end
%  hold on;






a = 1;




end

