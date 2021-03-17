function QClines_sorting(coord_lines ) %coord
    global Analysis ROI figuretodraw  gen3
  
            %b = coord_lines;
            sz_coord = size(coord_lines);
            len = sz_coord(2);
            
            for i = 1:len
                j = 2*i-1;
                b(j,1:2) =  [coord_lines(1,i).point1(1),coord_lines(1,i).point1(2)] ;
                b(j+1,1:2) =  [coord_lines(1,i).point2(1),coord_lines(1,i).point2(2)] ;
            end    
            coord = b;    
% % %             mid_X = round(ROI.columns/2);
% % %             mid_Y = round(ROI.rows/2);
% % %             quarter_X = round(ROI.columns/4);
            mid_X = round(gen3.columns/2) + gen3.xmin;
            mid_Y = round(gen3.rows/2)+ gen3.ymin;
            quarter_X = round(gen3.columns/4)+gen3.xmin;

            gr1_index = find(b(:,1)< quarter_X & b(:,2) < mid_Y );
            gr2_index = find(b(:,1)> quarter_X & b(:,1) < mid_X+quarter_X & b(:,2) < mid_Y );
            gr3_index = find(b(:,1)> mid_X+quarter_X & b(:,2) < mid_Y );
            gr4_index = find(b(:,1)< quarter_X & b(:,2) > mid_Y );
            gr5_index = find(b(:,1)> quarter_X & b(:,1) < mid_X+quarter_X& b(:,2) > mid_Y );
            gr6_index = find(b(:,1)> mid_X+quarter_X & b(:,2) > mid_Y );
            
            gr1_mean = mean(b(gr1_index,:)); Analysis.x_1 = round(gr1_mean(1)); Analysis.y_1 = round(gr1_mean(2));
            gr2_mean = mean(b(gr2_index,:)); Analysis.x_2 = round(gr2_mean(1)); Analysis.y_2 = round(gr2_mean(2));
            gr3_mean = mean(b(gr3_index,:)); Analysis.x_3 = round(gr3_mean(1)); Analysis.y_3 = round(gr3_mean(2));
            gr4_mean = mean(b(gr4_index,:)); Analysis.x_4 = round(gr4_mean(1)); Analysis.y_4 = round(gr4_mean(2));
            gr5_mean = mean(b(gr5_index,:)); Analysis.x_5 = round(gr5_mean(1)); Analysis.y_5 = round(gr5_mean(2));
            gr6_mean = mean(b(gr6_index,:)); Analysis.x_6 = round(gr6_mean(1)); Analysis.y_6 = round(gr6_mean(2));
            %Analysis.thicknessWax1 = thickness_ROI(y_corner,x_corner);
            if isnan(Analysis.x_1)
                Analysis.x_1 = 1;
            end
            if isnan(Analysis.y_1)
                Analysis.y_1 = Analysis.y_2;
            end  
             if isnan(Analysis.x_4)
                Analysis.x_4 = 1;
            end
            if isnan(Analysis.y_4)
                Analysis.y_4 = Analysis.y_5;
            end        
            
            
            figure(figuretodraw); hold on; 
%original code by Serghei, assuming ROI.xmin = 1
%             plot(gr1_mean(1),gr1_mean(2)+ROI.ymin,'*b');hold on;text(gr1_mean(1),gr1_mean(2)+ROI.ymin-50,num2str(1),'Color', 'y');hold on;
%             plot(gr2_mean(1),gr2_mean(2)+ROI.ymin,'*b');hold on;text(gr2_mean(1),gr2_mean(2)+ROI.ymin-50,num2str(2),'Color', 'y');hold on;
%             plot(gr3_mean(1),gr3_mean(2)+ROI.ymin,'*b');hold on;text(gr3_mean(1),gr3_mean(2)+ROI.ymin-50,num2str(3),'Color', 'y');hold on;
%             plot(gr4_mean(1),gr4_mean(2)+ROI.ymin,'*b');hold on;text(gr4_mean(1),gr4_mean(2)+ROI.ymin-50,num2str(4),'Color', 'y');hold on;
%             plot(gr5_mean(1),gr5_mean(2)+ROI.ymin,'*b');hold on;text(gr5_mean(1),gr5_mean(2)+ROI.ymin-50,num2str(5),'Color', 'y');hold on;
%             plot(gr6_mean(1),gr6_mean(2)+ROI.ymin,'*b');hold on;text(gr6_mean(1),gr6_mean(2)+ROI.ymin-50,num2str(6),'Color', 'y');hold on;
%end of original

%Modified code by Song, 02-10-11, ROI.xmin can be any number
            plot(gr1_mean(1) + ROI.xmin - 1, gr1_mean(2) + ROI.ymin -1, '*b');
            text(gr1_mean(1) + ROI.xmin - 1, gr1_mean(2) + ROI.ymin - 50, num2str(1),'Color', 'y');
            plot(gr2_mean(1) + ROI.xmin - 1, gr2_mean(2) + ROI.ymin - 1 , '*b');
            text(gr2_mean(1) + ROI.xmin - 1, gr2_mean(2) + ROI.ymin - 50, num2str(2),'Color', 'y');
            plot(gr3_mean(1) + ROI.xmin - 1, gr3_mean(2) + ROI.ymin - 1, '*b');
            text(gr3_mean(1) + ROI.xmin - 1, gr3_mean(2) + ROI.ymin - 50, num2str(3), 'Color', 'y');
            plot(gr4_mean(1) + ROI.xmin - 1, gr4_mean(2) + ROI.ymin - 1, '*b');
            text(gr4_mean(1) + ROI.xmin - 1, gr4_mean(2) + ROI.ymin - 50, num2str(4), 'Color', 'y');
            plot(gr5_mean(1) + ROI.xmin - 1, gr5_mean(2) + ROI.ymin - 1, '*b');
            text(gr5_mean(1) + ROI.xmin - 1, gr5_mean(2) + ROI.ymin - 50, num2str(5), 'Color', 'y');
            plot(gr6_mean(1) + ROI.xmin - 1, gr6_mean(2) + ROI.ymin, '*b');
            text(gr6_mean(1) + ROI.xmin - 1, gr6_mean(2) + ROI.ymin - 50, num2str(6), 'Color', 'y');
%End of change
           % text(stats2(i).Centroid(1),stats2(i).Centroid(2)-70,num2str(i),'Color', 'y'); 
            
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
%             %}
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
%             Analysis.y0cm_diff = (sz_image(2)/2 - yim_0)*Analysis.Filmresolution*0.1;
%             x0 = xim_0;
%             y0 = yim_0;
%             sort_coord = [xim_0 yim_0];
%             ;
%           
%             %temp_gr1 = sortrows(group_1,2);
%             

    
     
   
    
    