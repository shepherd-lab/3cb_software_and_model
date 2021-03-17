function sort_coord = bbs_sortingZ2(coord) %coord
    %global coord
    a = coord;
    b = a(:,1);
    b = b -690;
    a(:,1) = b;
    angle = -31.8;
    rot_mat = [cos(angle*pi/180),sin(angle*pi/180);-sin(angle*pi/180),cos(angle*pi/180)];
    a(:,2) = -a(:,2);
    b = a*rot_mat;
    len = length(b(:,2));
    b(:,3) = 1:len;
    %b1 = sortrows(b,1);
   % b1g = sortrows(b1,2);
    middle = (max(b(:,2))+ min(b(:,2)))/2;
    gr1 = b(b(:,2)>middle+80,:);
    if length(gr1(:,1)) >3
      temp_gr1 = sortrows(gr1,2);  
      tgr1 = temp_gr1(end-2:end,:);
      group1 = sortrows(tgr1,1);
      coord(temp_gr1(1:end-3,3),:) = [];
    else
      group1 = sortrows(gr1,1);
    end   
    gr2 = b(b(:,2)<middle-80,:);
    if length(gr2(:,1)) >3
      temp_gr2 = sortrows(gr2,2);  
      tgr2 = temp_gr2(1:3,:);
      group2 = sortrows(tgr2,1);
      coord(temp_gr2(4:end,3),:) = [];
    else
      group2 = sortrows(gr2,1);
    end  
          
    gr3 =  b(b(:,2)>=middle-80&b(:,2)<=middle+80,:);
    if ~isempty(gr3)
        group3 = sortrows(gr3,1);
    else
        group3 = gr3;
    end
    len = length(group1(:,1))+length(group2(:,1))+length(group3(:,1));
    index = zeros(len,2);
    if len == 8
       index1 = [1;2;3]; 
       index(1:3,:) =[index1, group1(:,3)]; 
       index2 = [5;6;7];
       index(4:6,:) =[index2, group2(:,3)]; 
       index3 = [9;10];
       index(7:8,:) =[index3, group3(:,3)]; 
    elseif len == 7
       index1 = [1;2;3]; 
       index(1:3,:) =[index1, group1(:,3)]; 
       index2 = [5;6;7];
       index(4:6,:) =[index2, group2(:,3)]; 
       index3 = [10];
       index(7,:) =[index3, group3(:,3)]; 
    elseif len == 6
        if isempty(group3)            %length(group3(:,2)==0    
           index1 = [1;2;3]; 
           index(1:3,:) =[index1, group1(:,3)]; 
           index2 = [5;6;7];
           index(4:6,:) =[index2, group2(:,3)]; 
        else
           
            if length(group1(:,2))==2 
              index1 = [1;2]; 
              index(1:2,:) =[index1, group1(:,3)]; 
              index2 = [5;6;7];
              index(3:5,:) =[index2, group2(:,3)]; 
              index3 = [10];
              index(6,:) =[index3, group3(:,3)]; 
            else
               index1 = [1;2;3]; 
              index(1:3,:) =[index1, group1(:,3)]; 
              index2 = [5;6];
              index(4:5,:) =[index2, group2(:,3)]; 
              index3 = [10];
              index(6,:) =[index3, group3(:,3)];  
            end
        end
    end    
    index_out = sortrows(index, 2);    
    ans = zeros(len,3);
    ans(:, 1:2) = coord;
    ans(:,3) = index_out(:,1);
    sort_coord = sortrows(ans, 3);
   
    %output = sortrows(ans,3);
    %sort_coord = output(:,1:2);    
    ;
    
     
   
    
    