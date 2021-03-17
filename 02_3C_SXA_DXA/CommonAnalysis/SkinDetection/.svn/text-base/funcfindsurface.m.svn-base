function Surface=funcfindsurface(line)

%compute the breast area
  [C,I]=max(line.x);
  Surface=0;
  for index=1:I
       miny=line.y(index);
       maxy=line.y(size(line.x,2)-index+1);
       Surface=Surface+abs(maxy-miny+1);
   end    