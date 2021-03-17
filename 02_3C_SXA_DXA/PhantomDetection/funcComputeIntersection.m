%compute the intersection of two line 
%line = structure line.x1 line.x2 line.y1 line.y2
%Lionel HERVE
%10-24-03

function I=funcComputeIntersection(Line1,Line2)

k=[Line1.x2-Line1.x1 -Line2.x2+Line2.x1;Line1.y2-Line1.y1 -Line2.y2+Line2.y1]^(-1)*[Line2.x1-Line1.x1;Line2.y1-Line1.y1];
I(1)=Line1.x1+k(1).*(Line1.x2-Line1.x1);
I(2)=Line1.y1+k(1).*(Line1.y2-Line1.y1);
