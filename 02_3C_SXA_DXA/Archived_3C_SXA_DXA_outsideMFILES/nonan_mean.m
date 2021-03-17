function nonN_mean = nonan_mean(matrix_nan)
    index = isnan(matrix_nan);
    nan_index = find(index == 1);
    matrix_nan(nan_index) = [];
    nonN_mean = mean(matrix_nan);
