function 5cmFat(fatThickness,fatValues,leanThickness,leanValues)
%5CMFAT    Create plot of datasets and fits
%   5CMFAT(FATTHICKNESS,FATVALUES,LEANTHICKNESS,LEANVALUES)
%   Creates a plot, similar to the plot in the main curve fitting
%   window, using the data that you provide as input.  You can
%   apply this function to the same data you used with cftool
%   or with different data.  You may want to edit the function to
%   customize the code and this help message.
%
%   Number of datasets:  2
%   Number of fits:  2

 
% Data from dataset "fatValues vs. fatThickness":
%    X = fatThickness:
%    Y = fatValues:
%    Unweighted
 
% Data from dataset "leanValues vs. leanThickness":
%    X = leanThickness:
%    Y = leanValues:
%    Unweighted
%
% This function was automatically generated on 03-May-2005 15:37:12

% Set up figure to receive datasets and fits
f_ = clf;
figure(f_);
set(f_,'Units','Pixels','Position',[437 145 680 484]);
legh_ = []; legt_ = {};   % handles and text for legend
xlim_ = [Inf -Inf];       % limits of x axis
ax_ = axes;
set(ax_,'Units','normalized','OuterPosition',[0 0 1 1]);
set(ax_,'Box','on');
axes(ax_); hold on;

 
% --- Plot data originally in dataset "fatValues vs. fatThickness"
fatThickness = fatThickness(:);
fatValues = fatValues(:);
h_ = line(fatThickness,fatValues,'Parent',ax_,'Color',[0.333333 0 0.666667],...
     'LineStyle','none', 'LineWidth',1,...
     'Marker','.', 'MarkerSize',12);
xlim_(1) = min(xlim_(1),min(fatThickness));
xlim_(2) = max(xlim_(2),max(fatThickness));
legh_(end+1) = h_;
legt_{end+1} = 'fatValues vs. fatThickness';
 
% --- Plot data originally in dataset "leanValues vs. leanThickness"
leanThickness = leanThickness(:);
leanValues = leanValues(:);
h_ = line(leanThickness,leanValues,'Parent',ax_,'Color',[0.333333 0.666667 0],...
     'LineStyle','none', 'LineWidth',1,...
     'Marker','.', 'MarkerSize',12);
xlim_(1) = min(xlim_(1),min(leanThickness));
xlim_(2) = max(xlim_(2),max(leanThickness));
legh_(end+1) = h_;
legt_{end+1} = 'leanValues vs. leanThickness';

% Nudge axis limits beyond data limits
if all(isfinite(xlim_))
   xlim_ = xlim_ + [-1 1] * 0.01 * diff(xlim_);
   set(ax_,'XLim',xlim_)
end


% --- Create fit "fatFit"
fo_ = fitoptions('method','NonlinearLeastSquares','Lower',[60000  -Inf  -Inf 5000 ],'Upper',[65000 Inf Inf 10000 ]);
ok_ = ~(isnan(fatThickness) | isnan(fatValues));
st_ = [62500 0.5910262034395 0.115 7500 ];
set(fo_,'Startpoint',st_);
ft_ = fittype('a + (d-a) / (1 + exp((x - b)/c))' ,...
     'dependent',{'y'},'independent',{'x'},...
     'coefficients',{'a', 'b', 'c', 'd'});

% Fit this model using new data
cf_ = fit(fatThickness(ok_),fatValues(ok_),ft_ ,fo_);

% Or use coefficients from the original fit:
if 0
   cv_ = {60000.00003615, 4.503453516949, 0.8034752977161, 9877.152510603};
   cf_ = cfit(ft_,cv_{:});
end

% Plot this fit
h_ = plot(cf_,'fit',0.95);
legend off;  % turn off legend from plot method call
set(h_(1),'Color',[1 0 0],...
     'LineStyle','-', 'LineWidth',2,...
     'Marker','none', 'MarkerSize',6);
legh_(end+1) = h_(1);
legt_{end+1} = 'fatFit';

% --- Create fit "leanFit"
fo_ = fitoptions('method','NonlinearLeastSquares','Lower',[55000  -Inf  -Inf 5000 ],'Upper',[65000 Inf Inf 10000 ]);
ok_ = ~(isnan(leanThickness) | isnan(leanValues));
st_ = [60000 0.5910262034395 0.115 7500 ];
set(fo_,'Startpoint',st_);
ft_ = fittype('a + (d-a) / (1 + exp((x - b)/c))' ,...
     'dependent',{'y'},'independent',{'x'},...
     'coefficients',{'a', 'b', 'c', 'd'});

% Fit this model using new data
cf_ = fit(leanThickness(ok_),leanValues(ok_),ft_ ,fo_);

% Or use coefficients from the original fit:
if 0
   cv_ = {60427.93661815, 2.743690263063, 0.5346793404831, 9999.998860149};
   cf_ = cfit(ft_,cv_{:});
end

% Plot this fit
h_ = plot(cf_,'fit',0.95);
legend off;  % turn off legend from plot method call
set(h_(1),'Color',[0 0 1],...
     'LineStyle','-', 'LineWidth',2,...
     'Marker','none', 'MarkerSize',6);
legh_(end+1) = h_(1);
legt_{end+1} = 'leanFit';

% Done plotting data and fits.  Now finish up loose ends.
hold off;
h_ = legend(ax_,legh_,legt_); % create and reposition legend
set(h_,'Units','normalized');
t_ = get(h_,'Position');
t_(1:2) = [0.545686,0.119518];
set(h_,'Interpreter','none','Position',t_);
xlabel(ax_,'');               % remove x label
ylabel(ax_,'');               % remove y label
