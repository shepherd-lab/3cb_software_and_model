function fit_params = fit_densthickParn(xdata,ydata)

% --- Create fit options"
fit_opts = fitoptions('method','NonlinearLeastSquares','Lower',[123500  -Inf  -Inf 3 12000 ],'Upper',[124200 Inf Inf Inf 13200 ]);
params_init = [123000 10 10 1 13000 ];
set(fit_opts,'Startpoint',params_init);
fit_type = fittype('a + (e-a) / (1 + exp((x - b)/c))^d' ,...
     'dependent',{'y'},'independent',{'x'},...
     'coefficients',{'a', 'b', 'c', 'd', 'e'});

% Fit this model using new data
fit_params = fit(xdata,ydata,fit_type ,fit_opts);


