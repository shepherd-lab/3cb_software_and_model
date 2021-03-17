function out_flag = duplicatecell_search(data)
    index_array = 0;      %matrix
    ln = size(data);
     
    for i=1:ln(1)
        fd = strfind(data(:,3),data{i,3});
        fdm = cell2mat(fd);
        len_fdm = max(size(fdm));
        if len_fdm > 1
            out_flag = true;
            return;
        end
    end
    out_flag = false;
    