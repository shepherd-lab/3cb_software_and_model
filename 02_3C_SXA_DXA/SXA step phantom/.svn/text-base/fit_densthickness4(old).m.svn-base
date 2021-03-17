function fit_params = fit_densthickness4(xdata,ydata)

global maxFatValue minFatValue maxLeanValue minLeanValue a b c d

% --- Create fit options"
% fit_opts = fitoptions('method','NonlinearLeastSquares','Lower',[61000 -Inf -Inf -Inf ],'Upper',[61500 Inf Inf Inf ]);
% params_init = [5 0.6350892647467 0.5393506964969 0.9  ];
fit_opts = fitoptions('method','NonlinearLeastSquares','Lower',[60000 -Inf -Inf 8000],'Upper',[62000 Inf Inf 10000]);
params_init = [61000 0.6350892647467 0.5393506964969 9000];

set(fit_opts,'Startpoint',params_init);
fit_type = fittype('a + (d-a) / (1 + exp((x - b)/c))' ,...
    'dependent',{'y'},'independent',{'x'},...
    'coefficients',{'a', 'b', 'c', 'd'});

% Fit this model using new data
fit_params = fit(xdata,ydata,fit_type ,fit_opts);