function gamma_fit(xdata, ydataFat, ydataLean)
   % xdata =                             % [ 0 22.8 26.2 31.2 38 49.5 80]';
    %ydataFat = [10000  15220 20300 30760 44640 56700 61622]'; 
    %ydataLean = [8500 13200 18460 29550 45000 55760 61622]';
    %f1 = figure;
    f1 = clf;
    figure(f1);
    %ax = axis(f1);
    ax = subplot(1,1,1);
    set(ax,'Box','on');
    axes(ax); hold on;
    % Nudge axis limits beyond data limits
    xlim_ = [Inf -Inf];       % limits of x axis
    xlim_(1) = min(xlim_(1),min(xdata));
    xlim_(2) = max(xlim_(2),max(xdata));
    if all(isfinite(xlim_))
       xlim_ = xlim_ + [-1 1] * 0.01 * diff(xlim_);
       set(ax,'XLim',xlim_)
    end
   
    fit_paramsFat = fit_densthickParn(xdata, ydataFat)
    fit_paramsLean = fit_densthickParn(xdata, ydataLean)
    %  plot(xdata, ydata,'ro');
    hold on;
    h_ = line(xdata,ydataLean,'Parent',ax,'Color',[0 0 0],...
     'LineStyle','none', 'LineWidth',1,...
     'Marker','.', 'MarkerSize',12);  
   h_1 = line(xdata,ydataFat,'Parent',ax,'Color',[0 1 0],...
     'LineStyle','none', 'LineWidth',1,...
     'Marker','.', 'MarkerSize',12);  
    
     plot(fit_paramsLean,'fit',0.95);
     ylim('auto');
     hold on;
     plot(fit_paramsFat,'fit',0.95); 
     ylim('auto');
    h = legend('real','fit',2);