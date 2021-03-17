function test_densthickness
    xdata =  [ 1  2 3 4  5  ]';
    ydata = [  1  1.1 3 5 5]'; 
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
   
    fit_params = fit_densthickness(xdata, ydata);
  %  plot(xdata, ydata,'ro');
    hold on;
    h_ = line(xdata,ydata,'Parent',ax,'Color',[0 0 0],...
     'LineStyle','none', 'LineWidth',1,...
     'Marker','.', 'MarkerSize',12);  
    plot(fit_params,'fit',0.95);
       
    h = legend('real','fit',2);