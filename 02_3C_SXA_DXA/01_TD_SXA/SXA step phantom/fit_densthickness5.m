function fit_params = fit_densthickness(xdata,ydata)

% --- Create fit options"
fit_opts = fitoptions('method','NonlinearLeastSquares','Lower',[4.5  -Inf  -Inf 0.8  -Inf ],'Upper',[5.5 Inf Inf 2.0 Inf ]);
params_init = [5 0.6350892647467 0.5393506964969 0.9 0.8419739405571 ];
set(fit_opts,'Startpoint',params_init);
fit_type = fittype('a + (e-a) / (1 + exp((x - b)/c))^d' ,...
     'dependent',{'y'},'independent',{'x'},...
     'coefficients',{'a', 'b', 'c', 'd', 'e'});

% Fit this model using new data
fit_params = fit(xdata,ydata,fit_type ,fit_opts);


