function array = extraction(big, small)
    array = 0;
    emp=  zeros(0,1);
    for i = 1:size(small)
        index = find(big==small(i));
        if index ==  emp
            ;
        end
        array = [array big(index)];
    end
    array = array(2:end);