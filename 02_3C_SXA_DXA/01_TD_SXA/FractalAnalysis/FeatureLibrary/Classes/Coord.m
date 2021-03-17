classdef Coord
%Coordinate system class
   properties
       x = NaN;
       y = NaN;
   end

   methods
       function obj = Coord(x, y)
           obj.x = x;
           obj.y = y;
       end
       
       function disp(obj)
           disp(['coord.x = ', num2str(obj.x)]);
           disp(['coord.x = ', num2str(obj.x)]);
       end
       
       function vec = convertToVec(this)
           %convert the  coord representation to a row vector
           vec = [this.x, this.y];
       end
   end
end 
