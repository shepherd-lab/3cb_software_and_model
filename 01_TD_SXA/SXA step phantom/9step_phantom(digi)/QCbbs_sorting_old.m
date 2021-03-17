function sort_coord = bbs_sortingZ2(coord ) %coord
    global Analysis ROI figuretodraw Image
  
            b = coord;
           
            mid_X = round(ROI.columns/2); mid_X=500; %JW
            mid_Y = round(ROI.rows/2);
            quarter_X = round(ROI.columns/4); quarter_X=250; %JW
            
            gr1_index = find(b(:,1)> quarter_X & b(:,1) < mid_X & b(:,2) < mid_Y );
            gr2_index = find(b(:,1)> mid_X & b(:,1) < mid_X+quarter_X& b(:,2) < mid_Y );
            gr3_index = find(b(:,1)> quarter_X & b(:,1) < mid_X & b(:,2) > mid_Y );
            gr4_index = find(b(:,1)> mid_X & b(:,1) < mid_X+quarter_X& b(:,2) > mid_Y );
            
            group_1 = b(gr1_index,:);
            group_2 = b(gr2_index,:);
            group_3 = b(gr3_index,:);
            group_4 = b(gr4_index,:);
            
            mean_gr1 = mean(group_1);
            mean_gr2 = mean(group_2);
            mean_gr3 = mean(group_3);
            mean_gr4 = mean(group_4);
            delta_x =  mean_gr2(1) - mean_gr1(1);
            Analysis.xmin = mean_gr1(1)-delta_x; %ROI location cropped to size of just density steps (no bookends);
            Analysis.xmax = mean_gr2(1)+delta_x-30;
            Analysis.ymin = mean_gr1(2)+ 100 + ROI.ymin; 
            Analysis.ymax = mean_gr3(2)- 100 + ROI.ymin;
            
            
            Line1.x1 = coord(gr1_index(1),1);
            Line1.x2 = coord(gr1_index(2),1);
            Line1.y1 = coord(gr1_index(1),2)+ROI.ymin;
            Line1.y2 = coord(gr1_index(2),2)+ROI.ymin;

            delta1 = (Line1.y2 - Line1.y1)/(Line1.x1 - Line1.x2);
            Line1.x0 = 1;
            Line1.y0 = (Line1.x2-1) * delta1 + Line1.y2;
            figure(figuretodraw); hold on; 
            plot([Line1.x0 Line1.x2],[Line1.y0 Line1.y2],'Linewidth',1,'color','b');hold on;

            Line2.x1 = coord(gr2_index(1),1);
            Line2.x2 = coord(gr2_index(2),1);
            Line2.y1 = coord(gr2_index(1),2)+ROI.ymin;
            Line2.y2 = coord(gr2_index(2),2)+ROI.ymin;

            delta2 = (Line2.y2 - Line2.y1)/(Line2.x1 - Line2.x2);
            Line2.x0 = 1;
            Line2.y0 = (Line2.x2-1) * delta2 + Line2.y2;
            figure(figuretodraw); hold on; plot([Line2.x0 Line2.x2],[Line2.y0 Line2.y2],'Linewidth',1,'color','b');

            Line3.x1 = coord(gr3_index(1),1);
            Line3.x2 = coord(gr3_index(2),1);
            Line3.y1 = coord(gr3_index(1),2)+ROI.ymin;
            Line3.y2 = coord(gr3_index(2),2)+ROI.ymin;

            delta3 = (Line3.y2 - Line3.y1)/(Line3.x1 - Line3.x2);
            Line3.x0 = 1;
            Line3.y0 = (Line3.x2-1) * delta3 + Line3.y2;
            figure(figuretodraw); hold on; plot([Line3.x0 Line3.x2],[Line3.y0 Line3.y2],'Linewidth',1,'color','b');
            %}
            Line4.x1 = coord(gr4_index(1),1);
            Line4.x2 = coord(gr4_index(2),1);
            Line4.y1 = coord(gr4_index(1),2)+ROI.ymin;
            Line4.y2 = coord(gr4_index(2),2)+ROI.ymin;
            
            delta4 = (Line4.y2 - Line4.y1)/(Line4.x1 - Line4.x2);
            Line4.x0 = 1;
            Line4.y0 = (Line4.x2-1) * delta4 + Line4.y2;
            figure(figuretodraw); hold on; plot([Line4.x0 Line4.x2],[Line4.y0 Line4.y2],'Linewidth',1,'color','b');hold on;
            
            
            
            I12=funcComputeIntersection(Line1,Line2);
            I13=funcComputeIntersection(Line1,Line3);
            I14=funcComputeIntersection(Line1,Line4);
            I23=funcComputeIntersection(Line2,Line3);
            I24=funcComputeIntersection(Line2,Line4);
            I34=funcComputeIntersection(Line3,Line4);
            
            point_0 = [ I12;I13;I14;I23;I24;I34];
            mean_0 = mean(point_0)
            %plot(point_0(:,1),point_0(:,2),'.r','MarkerSize',5);
            plot(mean_0(1),mean_0(2),'.r','MarkerSize',7);
            xim_0 = mean_0(1);
            yim_0 = mean_0(2);
            sz_image = size(Image.image);
            Analysis.x0cm_diff = xim_0*Analysis.Filmresolution*0.1;
            Analysis.y0cm_diff = (sz_image(1)/2 - yim_0)*Analysis.Filmresolution*0.1;
            x0 = xim_0;
            y0 = yim_0;
            sort_coord = [xim_0 yim_0];
            ;
          
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
    ;
    
     
   
    
    