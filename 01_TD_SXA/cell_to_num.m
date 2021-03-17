function num_data = cell_to_num(cell_data)
    sz_cell = size(cell_data);
    for i = 1:sz_cell(2)
        for k = 1:sz_cell(1)
            num_data(k,i) = cell_data{k,i};
        end
    end