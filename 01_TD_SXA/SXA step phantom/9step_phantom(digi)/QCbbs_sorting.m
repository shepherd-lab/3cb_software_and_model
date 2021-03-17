function origDiff = QCbbs_sorting(coord) %coord

%the function returns the origin displacement from the image mid-point
%in terms of pixels

global Analysis ROI figuretodraw Image

groups = groupingPairs(coord);

%re-assign the middle four groups to group 1 to 4
group1_coord = groups(1).coord;
group2_coord = groups(2).coord;
group3_coord = groups(3).coord;
group4_coord = groups(4).coord;

%calculate the center of each group
mean_gr1 = mean(group1_coord);
mean_gr2 = mean(group2_coord);
mean_gr3 = mean(group3_coord);

delta_x =  mean_gr2(1) - mean_gr1(1);

%create x- and y-shift values for converting coordinate from ROI to film
xShift = ROI.xmin - 1;
yShift = ROI.ymin - 1;

%crop a smaller ROI to the size of just density steps (no bookends);
Analysis.xmin = mean_gr1(1) - delta_x + xShift;
Analysis.xmax = mean_gr2(1) + delta_x - 30 + xShift;
Analysis.ymin = mean_gr1(2) + 100 + yShift; 
Analysis.ymax = mean_gr3(2) - 100 + yShift;


Line1.x1 = group1_coord(1, 1) + xShift; %coord(gr1_index(1), 1);
Line1.x2 = group1_coord(2, 1) + xShift; %coord(gr1_index(2), 1);
Line1.y1 = group1_coord(1, 2) + yShift; %coord(gr1_index(1), 2) + ROI.ymin;
Line1.y2 = group1_coord(2, 2) + yShift; %coord(gr1_index(2), 2) + ROI.ymin;

slope1 = (Line1.y2 - Line1.y1)/(Line1.x1 - Line1.x2);
Line1.x0 = 1;
Line1.y0 = (Line1.x2 - Line1.x0) * slope1 + Line1.y2;
figure(figuretodraw);
plot([Line1.x0 Line1.x2], [Line1.y0 Line1.y2], 'Linewidth', 1, 'color', 'b');
hold on;

Line2.x1 = group2_coord(1, 1) + xShift; %coord(gr2_index(1),1);
Line2.x2 = group2_coord(2, 1) + xShift; %coord(gr2_index(2),1);
Line2.y1 = group2_coord(1, 2) + yShift; %coord(gr2_index(1),2)+ROI.ymin;
Line2.y2 = group2_coord(2, 2) + yShift; %coord(gr2_index(2),2)+ROI.ymin;

slope2 = (Line2.y2 - Line2.y1)/(Line2.x1 - Line2.x2);
Line2.x0 = 1;
Line2.y0 = (Line2.x2 - Line2.x0) * slope2 + Line2.y2;
plot([Line2.x0 Line2.x2], [Line2.y0 Line2.y2], 'Linewidth', 1, 'color', 'b');

Line3.x1 = group3_coord(1, 1) + xShift; %coord(gr3_index(1),1);
Line3.x2 = group3_coord(2, 1) + xShift; %coord(gr3_index(2),1);
Line3.y1 = group3_coord(1, 2) + yShift; %coord(gr3_index(1),2)+ROI.ymin;
Line3.y2 = group3_coord(2, 2) + yShift; %coord(gr3_index(2),2)+ROI.ymin;

slope3 = (Line3.y2 - Line3.y1)/(Line3.x1 - Line3.x2);
Line3.x0 = 1;
Line3.y0 = (Line3.x2 - Line3.x0) * slope3 + Line3.y2;
plot([Line3.x0 Line3.x2], [Line3.y0 Line3.y2], 'Linewidth', 1, 'color', 'b');

Line4.x1 = group4_coord(1, 1) + xShift; %coord(gr4_index(1),1);
Line4.x2 = group4_coord(2, 1) + xShift; %coord(gr4_index(2),1);
Line4.y1 = group4_coord(1, 2) + yShift; %coord(gr4_index(1),2)+ROI.ymin;
Line4.y2 = group4_coord(2, 2) + yShift; %coord(gr4_index(2),2)+ROI.ymin;

slope4 = (Line4.y2 - Line4.y1)/(Line4.x1 - Line4.x2);
Line4.x0 = 1;
Line4.y0 = (Line4.x2 - Line4.x0) * slope4 + Line4.y2;
plot([Line4.x0 Line4.x2], [Line4.y0 Line4.y2], 'Linewidth', 1, 'color', 'b');



I12=funcComputeIntersection(Line1, Line2);
I13=funcComputeIntersection(Line1, Line3);
I14=funcComputeIntersection(Line1, Line4);
I23=funcComputeIntersection(Line2, Line3);
I24=funcComputeIntersection(Line2, Line4);
I34=funcComputeIntersection(Line3, Line4);

point_0 = [I12; I13; I14; I23; I24; I34];
mean_0 = mean(point_0);

plot(mean_0(1), mean_0(2), '.r', 'MarkerSize', 7);
xim_0 = mean_0(1);
yim_0 = mean_0(2);
sz_image = size(Image.image);
Analysis.x0cm_diff = xim_0 * Analysis.Filmresolution * 0.1;
Analysis.y0cm_diff = (sz_image(1)/2 - yim_0) * Analysis.Filmresolution * 0.1;

origDiff = [xim_0 sz_image(1)/2 - yim_0];


%% Original code by Serghei
%             gr1_index = groups(1).index;
%             gr2_index = groups(2).index;
%             gr3_index = groups(3).index;
%             gr4_index = groups(4).index;
% 
%             group_1 = groups(1).coord;
%             group_2 = groups(2).coord;
%             group_3 = groups(3).coord;
%             group_4 = groups(4).coord;
%             group_4_cmp = coord(gr4_index,:);
% 
%             mean_gr1 = mean(group_1);
%             mean_gr2 = mean(group_2);
%             mean_gr3 = mean(group_3);
%             mean_gr4 = mean(group_4);
%             delta_x =  mean_gr2(1) - mean_gr1(1);
%             Analysis.xmin = mean_gr1(1)-delta_x; %ROI location cropped to size of just density steps (no bookends);
%             Analysis.xmax = mean_gr2(1)+delta_x-30;
%             Analysis.ymin = mean_gr1(2)+ 100 + ROI.ymin; 
%             Analysis.ymax = mean_gr3(2)- 100 + ROI.ymin;
%             
%             Line1.x1 = coord(gr1_index(1),1);
%             Line1.x2 = coord(gr1_index(2),1);
%             Line1.y1 = coord(gr1_index(1),2)+ROI.ymin;
%             Line1.y2 = coord(gr1_index(2),2)+ROI.ymin;
% 
%             delta1 = (Line1.y2 - Line1.y1)/(Line1.x1 - Line1.x2);
%             Line1.x0 = 1;
%             Line1.y0 = (Line1.x2-1) * delta1 + Line1.y2;
%             figure(figuretodraw); hold on; 
%             plot([Line1.x0 Line1.x2],[Line1.y0 Line1.y2],'Linewidth',1,'color','b');hold on;
% 
%             Line2.x1 = coord(gr2_index(1),1);
%             Line2.x2 = coord(gr2_index(2),1);
%             Line2.y1 = coord(gr2_index(1),2)+ROI.ymin;
%             Line2.y2 = coord(gr2_index(2),2)+ROI.ymin;
% 
%             delta2 = (Line2.y2 - Line2.y1)/(Line2.x1 - Line2.x2);
%             Line2.x0 = 1;
%             Line2.y0 = (Line2.x2-1) * delta2 + Line2.y2;
%             figure(figuretodraw); hold on; plot([Line2.x0 Line2.x2],[Line2.y0 Line2.y2],'Linewidth',1,'color','b');
% 
%             Line3.x1 = coord(gr3_index(1),1);
%             Line3.x2 = coord(gr3_index(2),1);
%             Line3.y1 = coord(gr3_index(1),2)+ROI.ymin;
%             Line3.y2 = coord(gr3_index(2),2)+ROI.ymin;
% 
%             delta3 = (Line3.y2 - Line3.y1)/(Line3.x1 - Line3.x2);
%             Line3.x0 = 1;
%             Line3.y0 = (Line3.x2-1) * delta3 + Line3.y2;
%             figure(figuretodraw); hold on; plot([Line3.x0 Line3.x2],[Line3.y0 Line3.y2],'Linewidth',1,'color','b');
%             
%             Line4.x1 = coord(gr4_index(1),1);
%             Line4.x2 = coord(gr4_index(2),1);
%             Line4.y1 = coord(gr4_index(1),2)+ROI.ymin;
%             Line4.y2 = coord(gr4_index(2),2)+ROI.ymin;
%             
%             delta4 = (Line4.y2 - Line4.y1)/(Line4.x1 - Line4.x2);
%             Line4.x0 = 1;
%             Line4.y0 = (Line4.x2-1) * delta4 + Line4.y2;
%             figure(figuretodraw); hold on; plot([Line4.x0 Line4.x2],[Line4.y0 Line4.y2],'Linewidth',1,'color','b');hold on;
%             
%             
%             
%             I12=funcComputeIntersection(Line1,Line2);
%             I13=funcComputeIntersection(Line1,Line3);
%             I14=funcComputeIntersection(Line1,Line4);
%             I23=funcComputeIntersection(Line2,Line3);
%             I24=funcComputeIntersection(Line2,Line4);
%             I34=funcComputeIntersection(Line3,Line4);
%             
%             point_0 = [ I12;I13;I14;I23;I24;I34];
%             mean_0 = mean(point_0)
%             %plot(point_0(:,1),point_0(:,2),'.r','MarkerSize',5);
%             plot(mean_0(1),mean_0(2),'.r','MarkerSize',7);
%             xim_0 = mean_0(1);
%             yim_0 = mean_0(2);
%             sz_image = size(Image.image);
%             Analysis.x0cm_diff = xim_0*Analysis.Filmresolution*0.1;
%             Analysis.y0cm_diff = (sz_image(1)/2 - yim_0)*Analysis.Filmresolution*0.1;
%             %x0 = xim_0;
%             %y0 = yim_0;
%             origDiff = [xim_0 sz_image(1)/2 - yim_0];
%End of original code
%%
          
            %temp_gr1 = sortrows(group_1,2);
            
            
%     if 1
%             middle = (max(b(:,2))+ min(b(:,2)))/2;
%             gr1 = b(b(:,2)<middle+70*crop_coef,:);
%             temp_gr1 = sortrows(gr1,1);
%             group1 = temp_gr1(1:3,:);
%             
%             gr2 = b(b(:,2)>middle+70*crop_coef,:);
%             temp_gr2 = sortrows(gr2,1);
%             if temp_gr2 == 3
%                 group2 = temp_gr2(1:3,:);
%                 index1 = [6;4;5]; 
%                 index(1:3,:) =[index1, group1(:,3)]; 
%                 index2 = [3;1;2];
%                 index(4:6,:) =[index2, group2(:,3)]; 
% 
%                 gr3 = b(b(:,1)>group1(3,1)+20*crop_coef,:);
%                 temp_gr3 = sortrows(gr3,2);
%                 group3 = temp_gr3(1:2,:);
% 
%                 index3 = [7;8]; 
%                 index(7:8,:) =[index3, group3(:,3)];
%             else
%                 group2 = temp_gr2(1:2,:);
%                 index1 = [6;4;5]; 
%                 index(1:3,:) =[index1, group1(:,3)]; 
%                 index2 = [3;1];
%                 index(4:5,:) =[index2, group2(:,3)]; 
% 
%                 gr3 = b(b(:,1)>group1(3,1)+20*crop_coef,:);
%                 temp_gr3 = sortrows(gr3,2);
%                 group3 = temp_gr3(1:3,:);
% 
%                 index3 = [9;7;8]; 
%                 index(6:8,:) =[index3, group3(:,3)];
%             end
%      else    
%        middle = (max(b(:,2))+ min(b(:,2)))/2;
%         gr1 = b(b(:,2)<middle+70*crop_coef,:);
%         temp_gr1 = sortrows(gr1,1);
%         group1 = temp_gr1(1:3,:);
% 
%         gr2 = b(b(:,1)>group1(3,1)+10*crop_coef,:);
%         if length(gr2(:,1)) >3
%           temp_gr2 = sortrows(gr2,2);  
%           group2 = temp_gr2(1:3,:);
% 
%          % coord(temp_gr2(4:end,3),:) = [];
%         else
%           group2 = sortrows(gr2,2);
%         end 
%        index1 = [6;4;5]; 
%        index(1:3,:) =[index1, group1(:,3)]; 
%        index2 = [9;7;8];
%        index(4:6,:) =[index2, group2(:,3)]; 
%         gr3 = b(b(:,2)>middle+70*crop_coef,:);
%         temp_gr3 = sortrows(gr3,1);
%       
%      
%         if len == 9
%            group3 = temp_gr3(1:3,:);
%            index3 = [3;1;2];
%            index(7:9,:) =[index3, group3(:,3)];
%         elseif len == 8 
%                group3 = temp_gr3(1:2,:); 
%                if (group3(1,1)+group3(2,1))/2  >group1(1,1) & (group3(1,1)+group3(2,1))/2 < group1(2,1)
%                   index3 = [3;1];
%                else
%                   index3 = [1;2]; 
%                end
% 
%                index(7:8,:) =[index3, group3(:,3)];
%       
%         end
%      end
%    elseif machine == 8
%         middle = (max(b(:,2))+ min(b(:,2)))/2;
%         gr1 = b(b(:,2)<middle+80,:);
%         temp_gr1 = sortrows(gr1,1);
%         group1 = temp_gr1(1:3,:);
%         index1 = [6;4;5]; 
%         index(1:3,:) =[index1, group1(:,3)]; 
%         
%         gr2 =  b(b(:,2)<middle+70 & b(:,2)>middle-70 ,:);
%         if length(gr2(:,1)) > 0
%           temp_gr2 = sortrows(gr2,2);  
%           group2 = temp_gr2(1,:);
%           index2 = 7;
%           index(4,:) =[index2, group2(:,3)]; 
%           n = 5;
%         else
%            group2 = [];
%            n = 4;
%         end
%         gr3 = b(b(:,2)>middle+70,:);
%         group3 = sortrows(gr3,1);
%         len3 = length(group3(:,1));
%         index3 = [3;1;2];
%         index(n:len3+n-1,:) =[index3(1:len3), group3(:,3)]; 
%    end    
%           
%     index_out = sortrows(index, 2);    
%     ans = zeros(len,3);
%     ans(:, 1:2) = coord;
%     ans(:,3) = index_out(:,1);
%     sort_coord = sortrows(ans, 3);
%     a = 1;
   
    %output = sortrows(ans,3);
    %sort_coord = output(:,1:2);    