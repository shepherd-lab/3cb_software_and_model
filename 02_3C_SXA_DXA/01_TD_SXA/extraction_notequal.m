function array = extraction_notequal(big, small)
big2 = duplicate_removal(big);
small2 =  small; %   duplicate_removal(small);
sbig = size(big2)
ssmall = size(small2)
    emp=  zeros(0,1);
    ln = max(size(small2));
      for i=1:ln 
        index = find(uint16(small2(i))==uint16(big2));
        if isempty(index) % ==  emp
           ;                  %array = [array big(index)];  
        else
            %current(index)  = [];
              big2(index) = 0;       
        end
    %    ln = length(big2);
    %     i = i + 1;  
     end  
  
    array = big2(big2>0);