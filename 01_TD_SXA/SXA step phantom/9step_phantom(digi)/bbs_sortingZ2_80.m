function sort_coord = bbs_sortingZ2(coord,machine,second, ph_angle ) %coord
    global Analysis
    crop_coef = 0.71;
    a = coord;
    b = a(:,1);
    b = b -690*crop_coef;
    a(:,1) = b;
            
    angle = - ph_angle;  %31.8;
    rot_mat = [cos(angle*pi/180),sin(angle*pi/180);-sin(angle*pi/180),cos(angle*pi/180)];
    a(:,2) = -a(:,2);
    b = a*rot_mat;
    len = length(b(:,2));
    b(:,3) = 1:len;
    %b1 = sortrows(b,1);
   % b1g = sortrows(b1,2);
   %figure;plot(b(:,1),b(:,2),'*');
   
   if machine ~=8 %(machine == 4 | machine == 9 |machine == 13 | machine == 1 |len == 9)  
     if Analysis.PhantomID == 9 & len == 8
            middle = (max(b(:,2))+ min(b(:,2)))/2;
           % gr1 = b(b(:,2)<middle+70*crop_coef,:);  gr1 - upper
            gr1 = b(b(:,2)<middle+70*crop_coef & b(:,1)<(max(b(:,1))-(max(b(:,1))-min(b(:,1)))*0.21),:);   %   -80*crop_coef),:); %change 100 for 80 for GE machine
            temp_gr1 = sortrows(gr1,1);
            sz1 = size(temp_gr1);
            %group1 = temp_gr1(1:3,:);
            %gr2 - bottom
            gr2 = b(b(:,2)>middle+70*crop_coef & b(:,1)<(max(b(:,1))-80*crop_coef),:);
            %changed for missing bb N4
             temp_gr2 = sortrows(gr2,1);
            sz2 = size(temp_gr2);
            if sz1(1) == 2
                group2 = temp_gr2(1:3,:);
                index2 = [3;1;2];
                index(1:3,:) =[index2, group2(:,3)]; 

                gr3 = b(b(:,1)>group2(3,1)+20*crop_coef,:);
                temp_gr3 = sortrows(gr3,2);
                group3 = temp_gr3(1:3,:);

                index3 = [9;7;8]; 
                index(4:6,:) =[index3, group3(:,3)];
                group1 = temp_gr1(1:2,:);
                
               
                diff2_12d2 =  (group2(1,1) +  group2(2,1))/2;
                diff2_23d2 =  (group2(2,1) +  group2(3,1))/2;
% %                 diff2_12 =  group2(1,1) -  group2(2,1);
% %                 diff1_12 =  group1(1,1) -  group2(2,1);
                
                if  group1(1,1) <  diff2_12d2 
                     index1(1) = 6; 
                     if group1(2,1) > diff2_23d2
                       index1(2) = 5;  
                     else
                        index1(2) = 4; 
                     end
                else
                     index1 = [4;5]; 
                end
                   
                            
                index(7:8,:) =[index1', group1(:,3)]; 
            elseif sz2(1) == 2   
                
                group1 = temp_gr1(1:3,:);
                index1 = [6;4;5];
                index(1:3,:) =[index1, group1(:,3)]; 

                gr3 = b(b(:,1)>group1(3,1)+20*crop_coef,:);
                temp_gr3 = sortrows(gr3,2);
                group3 = temp_gr3(1:3,:);
                index3 = [9;7;8]; 
                index(4:6,:) =[index3, group3(:,3)];
                
                diff1_12d2 =  (group1(1,1) +  group1(2,1))/2;
                diff1_23d2 =  (group1(2,1) +  group1(3,1))/2;
% %                 diff2_12 =  group2(1,1) -  group2(2,1);
% %                 diff1_12 =  group1(1,1) -  group2(2,1);
                group2 = temp_gr2(1:2,:);
                index2 = zeros(2,1);
                if  group2(1,1) <  diff1_12d2 
                     index2(1) = 3; %6; 
                     if group2(2,1) > diff1_23d2
                       index2(2) = 2; %5;  
                     else
                        index2(2) = 1; %4; 
                     end
                else
                     index2 = [1;2]; 
                end
                
%                 group2 = temp_gr2(1:2,:);
%                 index2 = [3;2]; 
                index(7:8,:) =[index2, group2(:,3)]; 
              
                              
                           
            elseif sz2(2) == 3
                group1 = temp_gr1(1:3,:);
                group2 = temp_gr2(1:3,:);
                index1 = [6;4;5]; 
                index(1:3,:) =[index1, group1(:,3)]; 
                index2 = [3;1;2];
                index(4:6,:) =[index2, group2(:,3)]; 

                gr3 = b(b(:,1)>group1(3,1)+20*crop_coef,:);
                temp_gr3 = sortrows(gr3,2);
                group3 = temp_gr3(1:2,:);

                index3 = [7;8]; 
                index(7:8,:) =[index3, group3(:,3)];
            else
                group1 = temp_gr1(1:3,:);
                group2 = temp_gr2(1:2,:);
                index1 = [6;4;5]; 
                index(1:3,:) =[index1, group1(:,3)]; 
                index2 = [3;1];
                index(4:5,:) =[index2, group2(:,3)]; 

                gr3 = b(b(:,1)>group1(3,1)+20*crop_coef,:);
                temp_gr3 = sortrows(gr3,2);
                group3 = temp_gr3(1:3,:);

                index3 = [9;7;8]; 
                index(6:8,:) =[index3, group3(:,3)];
            end
     else    % 8 bbs
       middle = (max(b(:,2))+ min(b(:,2)))/2;
        gr1 = b(b(:,2)<middle+70*crop_coef,:);
        temp_gr1 = sortrows(gr1,1);
        group1 = temp_gr1(1:3,:);

        gr2 = b(b(:,1)>group1(3,1)+10*crop_coef,:);
        if length(gr2(:,1)) >3
          temp_gr2 = sortrows(gr2,2);  
          group2 = temp_gr2(1:3,:);

         % coord(temp_gr2(4:end,3),:) = [];
        else
          group2 = sortrows(gr2,2);
        end 
       index1 = [6;4;5]; 
       index(1:3,:) =[index1, group1(:,3)]; 
       index2 = [9;7;8];
       index(4:6,:) =[index2, group2(:,3)]; 
        gr3 = b(b(:,2)>middle+70*crop_coef,:);
        temp_gr3 = sortrows(gr3,1);
      
     
        if len == 9
           group3 = temp_gr3(1:3,:);
           index3 = [3;1;2];
           index(7:9,:) =[index3, group3(:,3)];
        elseif len == 8 
               group3 = temp_gr3(1:2,:); 
               if (group3(1,1)+group3(2,1))/2  >group1(1,1) & (group3(1,1)+group3(2,1))/2 < group1(2,1)
                  index3 = [3;1];
               else
                  index3 = [1;2]; 
               end

               index(7:8,:) =[index3, group3(:,3)];
      
        end
     end
   elseif machine == 8
        middle = (max(b(:,2))+ min(b(:,2)))/2;
        gr1 = b(b(:,2)<middle+80,:);
        temp_gr1 = sortrows(gr1,1);
        group1 = temp_gr1(1:3,:);
        index1 = [6;4;5]; 
        index(1:3,:) =[index1, group1(:,3)]; 
        
        gr2 =  b(b(:,2)<middle+70 & b(:,2)>middle-70 ,:);
        if length(gr2(:,1)) > 0
          temp_gr2 = sortrows(gr2,2);  
          group2 = temp_gr2(1,:);
          index2 = 7;
          index(4,:) =[index2, group2(:,3)]; 
          n = 5;
        else
           group2 = [];
           n = 4;
        end
        gr3 = b(b(:,2)>middle+70,:);
        group3 = sortrows(gr3,1);
        len3 = length(group3(:,1));
        index3 = [3;1;2];
        index(n:len3+n-1,:) =[index3(1:len3), group3(:,3)]; 
   end    
          
    index_out = sortrows(index, 2);    
    ans = zeros(len,3);
    ans(:, 1:2) = coord;
    ans(:,3) = index_out(:,1);
    sort_coord = sortrows(ans, 3);
    a = 1;
   
    %output = sortrows(ans,3);
    %sort_coord = output(:,1:2);    
    ;
    
     
   
    
    