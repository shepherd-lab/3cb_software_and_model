function nonN_sum = nonan_sum(matrix_nan)
    index = isnan(matrix_nan);
    nan_index = find(index == 1);
    matrix_nan(nan_index) = 0;
    nonN_sum = sum(matrix_nan);