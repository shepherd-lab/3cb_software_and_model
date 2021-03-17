classdef runLenMat
   properties
       matrix = [];
       glevelMin = NaN;
       glevelMax = NaN;
       runLenMax = NaN;
   end

   methods
       function obj = runLenMat(matrix, glevelMin, glevelMax, runLenMax)
           obj.matrix = matrix;
           obj.glevelMin = glevelMin;
           obj.glevelMax = glevelMax;
           obj.runLenMax = runLenMax;
       end
       
       function disp(obj)
           disp(obj.matrix);
           disp(['Minimum gray level: ', num2str(obj.glevelMin)]);
           disp(['Maximum gray level: ', num2str(obj.glevelMax)]);
           disp(['Maximum run length: ', num2str(obj.runLenMax)]);
       end
   end
end 
