  inner_x = [3,4,	3,	4,4	,3	,2,	1 ];
  inner_y = [3,4,	2,	4,3	,3	,2,	1];
  
  inner_x = [3,4,	3,	4,4	,3	,2,	1 ];
  inner_y = [3,4,	2,	4,3	,3	,2,	1];
  
  jx = [1,	1,	1,	1,	4,	1,	1,	1,	1,	3,	1,	1,	1,	2,	1	,1	,1	,1 ];
  iy = [1,	1,	2,	1,	1,	3,	1,	1,	1,	1,	1,	1,	4,	1,	1	,1	,1	,1 ];
  thickness_mapreal = zeros(4,4);
  distbw = ones(4,4)*3;
  for i= 1:length(jx) 
         in_distance = (inner_x-jx(i)).^2 + (inner_y-iy(i)).^2;
         min_distance = min(in_distance);
         index = find(in_distance == min_distance);
         thickness_mapreal(iy(i),jx(i)) = (distbw(inner_y(index(1)),inner_x(index(1)))^2 - min_distance)*0.996; 
  end  
     
  a =1;