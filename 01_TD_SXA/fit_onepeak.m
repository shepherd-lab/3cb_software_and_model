function fit_onepeak(xx,yy)
%FIT_ONEPEAK    Create plot of datasets and fits
%   FIT_ONEPEAK(XX,YY)
%   Creates a plot, similar to the plot in the main curve fitting
%   window, using the data that you provide as input.  You can
%   apply this function to the same data you used with cftool
%   or with different data.  You may want to edit the function to
%   customize the code and this help message.
%
%   Number of datasets:  1
%   Number of fits:  1

 
% Data from dataset "yy vs. xx":
%    X = xx:
%    Y = yy:
%    Unweighted
%
% This function was automatically generated on 15-Nov-2005 09:00:23

% Set up figure to receive datasets and fits
f_ = clf;
figure(f_);
legh_ = []; legt_ = {};   % handles and text for legend
xlim_ = [Inf -Inf];       % limits of x axis
ax_ = subplot(1,1,1);
set(ax_,'Box','on');
axes(ax_); hold on;

 
% --- Plot data originally in dataset "yy vs. xx"
xx = xx(:);
yy = yy(:);
h_ = line(xx,yy,'Parent',ax_,'Color',[0.333333 0 0.666667],...
     'LineStyle','none', 'LineWidth',1,...
     'Marker','.', 'MarkerSize',12);
xlim_(1) = min(xlim_(1),min(xx));
xlim_(2) = max(xlim_(2),max(xx));
legh_(end+1) = h_;
legt_{end+1} = 'yy vs. xx';

% Nudge axis limits beyond data limits
if all(isfinite(xlim_))
   xlim_ = xlim_ + [-1 1] * 0.01 * diff(xlim_);
   set(ax_,'XLim',xlim_)
end


% --- Create fit "fit 1"
fo_ = fitoptions('method','NonlinearLeastSquares','Lower',[-Inf  -Inf 0 ]);
st_ = [1751 201 9.735779315897 ];
set(fo_,'Startpoint',st_);
ft_ = fittype('gauss1' );

% Fit this model using new data
cf_ = fit(xx,yy,ft_ ,fo_);

% Or use coefficients from the original fit:
if 0
   cv_ = {971.5703319655, 200.901085847, 21.49745667635};
   cf_ = cfit(ft_,cv_{:});
end

% Plot this fit
h_ = plot(cf_,'fit',0.95);
legend off;  % turn off legend from plot method call
set(h_(1),'Color',[1 0 0],...
     'LineStyle','-', 'LineWidth',2,...
     'Marker','none', 'MarkerSize',6);
legh_(end+1) = h_(1);
legt_{end+1} = 'fit 1';

hold off;
legend(ax_,legh_, legt_);
