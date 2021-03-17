function fresult = gauss_fit(xx,yy)
    % --- Create fit "fit 1"
    %General model Gauss1:
     % f(x) =  a1*exp(-((x-b1)/c1)^2)
     % initial coefficients
       %a1 =      700
       %b1 =      200
            %c1 =      25  
   ftype = fittype('gauss2'); 
   opts = fitoptions('gauss2');
   opts.Lower = [0 100 8 0 150 0]; 
   opts.Upper = [Inf 230 40 Inf 250 30]; 
   opts.TolFun = 0.0001;
   %opts.Algorithm = 'Levenberg-Marquardt';
%Fit the data using the new constraints. gfit = fit(x,gdata,ftype,opts)   
   % fo_ = fitoptions('method','NonlinearLeastSquares','Lower',[-Inf  100 8 -Inf  150 0 ],'Upper',[Inf  230 40 Inf  250 30  ]);
    st_ = [700 175 25 1000 225 5];
    set(opts,'Startpoint',st_);
    %ft_ = fittype('gauss2' );
    op = opts
    fresult = fit(xx,yy,ftype,opts)
    % Fit this model using new data
    %fresult = fit(xx,yy,ftype ,opts);
     