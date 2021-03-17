function sort_coord = bbs_sortingUK(coord,machine) %coord
    %global coord
    a = coord;
    b = a(:,1);
    b = b -590;
    a(:,1) = b;
    angle = -31;
    rot_mat = [cos(angle*pi/180),sin(angle*pi/180);-sin(angle*pi/180),cos(angle*pi/180)];
    a(:,2) = -a(:,2);
    b = a*rot_mat;
    len = length(b(:,2));
    b(:,3) = 1:len;
    %b1 = sortrows(b,1);
   % b1g = sortrows(b1,2);
   if (machine == 4 | machine == 9 |machine == 13 | machine == 1 |len == 9)  
        middle = (max(b(:,2))+ min(b(:,2)))/2;
        gr1 = b(b(:,2)<middle+70,:);
        temp_gr1 = sortrows(gr1,1);
        group1 = temp_gr1(1:3,:);

        gr2 = b(b(:,1)>group1(3,1)+10,:);
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
        gr3 = b(b(:,2)>middle+70,:);
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
   
    %output = sortrows(ans,3);
    %sort_coord = output(:,1:2);    
    ;
    
     
   
    
    