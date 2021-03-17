function out = duplicate_removal(data)
    index_array = 0;
    ln = max(size(data));
    %current = big;
    i = 1;
    while i <= ln 
        index = find(data==data(i));
        if length(index) > 1
          % index_array = [index_array   index(2:end)];                          %array = [array big(index)];  
           data(index(2:end)) = [];
        end
           ln = length(data);
           i = i + 1;   
    end
    out = data;