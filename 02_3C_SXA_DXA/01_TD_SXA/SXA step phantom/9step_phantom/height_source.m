function height_source()
    global figuretodraw Image
    
    sz = size(Image.image)
    Line1.x1 =73.24 ; Line1.x2 =69.26 ; Line1.y1 =142.6 ; Line1.y2 =181.2 ;
    Line2.x1 = 1192; Line2.x2 =1131 ; Line2.y1 =154.4 ; Line2.y2 =192.6 ;
    Line3.x1 = 1124; Line3.x2 =1184 ; Line3.y1 = 1590; Line3.y2 = 1628;
    Line4.x1 = 63.77; Line4.x2 = 61.07; Line4.y1 = 1619; Line4.y2 =1581 ;
    %{
    Line1.x1 = 97.24; Line1.x2 = 93.3; Line1.y1 = 152.1; Line1.y2 = 189.6;
    Line2.x1 = 1217; Line2.x2 = 1156; Line2.y1 = 160.6; Line2.y2 = 198;
    Line3.x1 = 1211; Line3.x2 = 1152; Line3.y1 = 1632; Line3.y2 = 1594;
    Line4.x1 = 92.32; Line4.x2 = 88.67; Line4.y1 = 1627; Line4.y2 = 1589;
    %}
    figure(figuretodraw); hold on;
    k = 50;
    [Line1.x3,Line1.y3] = long_linedown(Line1, k);
    [Line2.x3,Line2.y3] = long_linedown(Line2, k); 
    [Line3.x3,Line3.y3] = long_lineup(Line3, k);
    [Line4.x3,Line4.y3] = long_lineup(Line4, k);  
    figure(figuretodraw);
    plot([Line1.x1 Line1.x3],[Line1.y1 Line1.y3],'Linewidth',1,'color','b');
    plot([Line2.x1 Line2.x3],[Line2.y1 Line2.y3],'Linewidth',1,'color','b');
    plot([Line3.x1 Line3.x3],[Line3.y1 Line3.y3],'Linewidth',1,'color','b');
    plot([Line4.x1 Line4.x3],[Line4.y1 Line4.y3],'Linewidth',1,'color','b'); 
    
    I12=funcComputeIntersection(Line1,Line2)
    I13=funcComputeIntersection(Line1,Line3)
    I14=funcComputeIntersection(Line1,Line4)
    I23=funcComputeIntersection(Line2,Line3)
    I24=funcComputeIntersection(Line2,Line4)
    I34=funcComputeIntersection(Line3,Line4)
    
    x0 = mean([I12(1), I13(1), I14(1), I23(1), I24(1), I34(1)])
    y0 = mean([I12(2), I13(2), I14(2), I23(2), I24(2), I34(2)])
    plot(x0,y0,'*r'); 
   
    %line4
    %{
    d = 4.61 * 2.54; 
    x5 = sqrt(d^2+1.25^2);%           21.75; %17.5 + 1.15; 
    x3 = 1.25 * 2.54;  % mean([1.248,1.256,1.285,1.255]) * 2.54;
    x1 = sqrt((Line4.x2-Line4.x1)^2+(Line4.y2-Line4.y1)^2)* 0.0169;
    x4 = sqrt((Line4.x2-x0)^2+(Line4.y2-y0)^2)*0.0169 - x5;
    x2 = sqrt((Line4.x1-x0)^2+(Line4.y1-y0)^2)*0.0169; 
    %}
    
     %{
    x5 = 21.95; %17.5 + 1.15;
    x3 = 1.25 * 2.54;  % mean([1.248,1.256,1.285,1.255]) * 2.54;
    x1 = sqrt((Line3.x2-Line3.x1)^2+(Line3.y2-Line3.y1)^2)* 0.0169;
    x4 = sqrt((Line3.x2-x0)^2+(Line3.y2-y0)^2)*0.0169 - x5;
    x2 = sqrt((Line3.x1-x0)^2+(Line3.y1-y0)^2)*0.0169; 
    %}
    
    %%%Line1
   %{
    d = 4.42 * 2.54; 
    x5 = sqrt(d^2+1.25^2);%           21.75; %17.5 + 1.15; 
    x3 = 1.283 * 2.54;  % mean([1.248,1.256,1.285,1.255]) * 2.54;
    x1 = sqrt((Line1.x2-Line1.x1)^2+(Line1.y2-Line1.y1)^2)* 0.0169;
    x4 = sqrt((Line1.x2-x0)^2+(Line1.y2-y0)^2)*0.0169 - x5;
    x2 = sqrt((Line1.x1-x0)^2+(Line1.y1-y0)^2)*0.0169; 
    %}
    
     %
    d = 4.42 * 2.54; 
    x5 = sqrt(d^2+1.25^2);%           21.75; %17.5 + 1.15; 
    x3 = 1.283 * 2.54;  % mean([1.248,1.256,1.285,1.255]) * 2.54;
    x1 = sqrt((Line1.x2-Line1.x1)^2+(Line1.y2-Line1.y1)^2)* 0.0169;
    x4 = sqrt((Line1.x2-x0)^2+(Line1.y2-y0)^2)*0.0169 - x5;
    x2 = sqrt((Line1.x1-x0)^2+(Line1.y1-y0)^2)*0.0169; 
    %
    
    A = (x5+x4) / x4;
    B = x2/(x1+x4);
    S = B*x3 / (1 - B/A);
    h = S/A - 0.156 *2.54;
    ;
    
    %Line1
   
    