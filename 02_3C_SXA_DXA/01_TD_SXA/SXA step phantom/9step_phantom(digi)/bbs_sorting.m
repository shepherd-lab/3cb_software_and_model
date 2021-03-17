function sort_coord = bbs_sorting(coord) %coord
    global coord
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
    b1 = sortrows(b,1);
   % b1g = sortrows(b1,2);
    gr1 = b1(end-2:end, :);
    group1 = sortrows(gr1,2);
    
    b2 = b1(1:end-3, :);
    b2g = sortrows(b2,2);
    gr2 = b2g(end-2:end, :);
    group2 = sortrows(gr2,1);
    gr3 = b2g(1:3, :);
    group3 = sortrows(gr3,1);
    index = zeros(9,2);
    index1 = [9;7;8];
    index(1:3,:) =[index1, group1(:,3)]; 
    %group1(:,3) = index1;
    index2 = [3;1;2];
    index(4:6,:) =[index2, group2(:,3)]; 
   % group2(:,3) = index2;
    index3 = [6;4;5];
    %group3(:,3) = index3;
    index(7:9,:) =[index3, group3(:,3)]; 
    index_out = sortrows(index, 2);
    ans = zeros(len,3);
    ans(:, 1:2) = coord;
    ans(:,3) = index_out(:,1);
    output = sortrows(ans,3);
    sort_coord = output(:,1:2);
   
    
    