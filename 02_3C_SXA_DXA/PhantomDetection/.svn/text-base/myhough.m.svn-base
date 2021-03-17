function [HT, rstep] = myhough( image, RHOQ, THETAQ )
%MYHOUGH Summary of this function goes here
%  image - intensity image
%  RHOQ - quantization level of rho
%  THETAQ - quantization level of theta

[X, Y] = size(image);
rstep = (X + Y) / (RHOQ);
tstep = pi / THETAQ;
HT = zeros(RHOQ,THETAQ);
[xs, ys] = find(image);
N = size(xs);
for a=1:N
        x = xs(a);
        y = ys(a);
        v = double(image(x,y));
        %origin at center and matlab starts at 1 not 0
        xc = x - 1 - X/2;
        yc = y - 1 - Y/2;
        t = 0;        
        for i=1:THETAQ            
            %to avoid dotted cos lines, i find where (in rho)
            %the curve enters and exists each scanline
            %in theta, and fill in all rho between the two)
            r1 = sin(t)*yc + cos(t)*xc;                        
            rint1 = double(int32(r1 / rstep));            
            rint1 = rint1 + RHOQ / 2;
            t = t + tstep;
            r2 = sin(t)*yc + cos(t)*xc;                           
            rint2 = double(int32(r2 / rstep));            
            rint2 = rint2 + RHOQ / 2;
            if (rint2 < rint1)
                temp = rint1;
                rint1 = rint2;
                rint2 = temp;
            end
            for (k = rint1:rint2)                
                HT(k,i) = HT(k,i) + v;
            end
        end
end

        
   