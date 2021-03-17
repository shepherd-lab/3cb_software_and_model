function fitDensCorr(machId)

SQLstatement = ['SELECT * ', ...
                'FROM DensityCorrGen3 ', ...
                'WHERE machine_id = ', num2str(machId),' ', ...
                'AND acquisition_id = 20799617'];
entryRead = mxDatabase('mammo_cpmc', SQLstatement);

entryInfo = entryRead(:, 1:5);
[rows cols] = size(entryRead);
for i = 1:rows
    corrMat = reshape(cell2mat(entryRead(i, 6:cols)), 3, 9)';
%     params0 = [0.1 -0.6 0.02 -0.05 0.0005 -0.0001];
%     [params sumSqr] = mySurfFit(corrMat, params0);
    
    densMat = [corrMat(:, 1:2), round(corrMat(:, 2)+corrMat(:, 3))];
%     % for Model 1
%     params0_M1 = [1 -0.03 0.8 0.005 0.005 0.001];
%     [params sumSqr] = mySurfFit(densMat, params0_M1);
    
%     %for Model 2
%     params0_M2 = [0.1 0.4 0.02 -0.05 0.0005 -0.0001];
%     [params sumSqr] = mySurfFit(densMat, params0_M2);

    %for Model 3
    params0_M3 = [1 1 0.0005 -0.05 0.0005];
    [params sumSqr] = mySurfFit(densMat, params0_M3);
    
    %calculate fitting error
    nData = size(densMat, 1);
    nParams = length(params);
    rootMSE = sqrt(sumSqr/(nData - nParams));
    dataMean = mean(densMat(:, 3));
    CV = rootMSE/dataMean*100;
    
    SSerr = sumSqr;
    SStot = sum((densMat(:, 3)-dataMean).^2);
    rSquared = 1 - SSerr/SStot;
    
%     %for debug, plot the fitted surface
%     if i == 1
%         h = figure;
%     else
%         figure(h);
%     end
% %small range plot
% %     x = zeros(3, 3);
% %     y = zeros(3, 3);
% %     z = zeros(3, 3);
% %     for ii = 1:3
% %         for jj = 1:3
% %             x(ii, jj) = densMat(3*(ii-1)+jj, 1);
% %             y(ii, jj) = densMat(3*(ii-1)+jj, 2);
% %             z(ii, jj) = applyCorr(x(ii, jj), y(ii, jj), params);
% %         end
% %     end
% 
% %large range plot
%     [x, y] = meshgrid(0:0.5:6, -50:20:150);
%     z = applyCorr(x, y, params);
%     
%     mesh(x, y, z); alpha(.4);
%     hold on;
%     scatter3(densMat(:, 1), densMat(:, 2), densMat(:, 3), '.', 'SizeData', 72^1.4);
%     hold off;
    
    SQLstatement = ['INSERT INTO DensityFitParams VALUES (', ...
                    num2str(entryInfo{i, 1}), ', ', num2str(entryInfo{i, 2}), ', ', ...
                    num2str(entryInfo{i, 3}), ', ', strtrim(entryInfo{i, 4}), ', ', ...
                    '''', strtrim(entryInfo{i, 5}), ''', ', num2str(params(1)), ', ', ...
                    num2str(params(2)), ', ', num2str(params(3)), ', ', ...
                    num2str(params(4)), ', ', num2str(params(5)), ', ', ...
                    num2str(rootMSE), ', ', num2str(dataMean), ', ', ...
                    num2str(CV), ', ', num2str(rSquared), ')'];
	mxDatabase('mammo_cpmc', SQLstatement);
    
    if mod(i, 50) == 0
        sprintf('i = %d', i)
    end
end

%%
function [params sumSqr]= mySurfFit(data, params0)

sumSqr = @(p) calcSumSqr(data, p);

options = optimset('MaxFunEvals', 1e+8, 'TolFun', 1e-12);
[params sumSqr] = fminsearch(sumSqr, params0, options);

%%
function chiSqr = calcSumSqr(data, p)

x = data(:, 1);
y = data(:, 2);
z = data(:, 3);

zFit = applyCorr(x, y, p);
chiSqr = sum((z - zFit).^2);

%%
function densOut = applyCorr(thick, density, p)

x = thick;
y = density;

%Model 1
% densOut = p(1) + p(2)*x + p(3)*y + p(4)*x.^2 + p(5)*x.*y + p(6)*y.^2;

%Model 2
% densOut = p(1) + p(2)*y + p(3)*y.^2 + p(4)*x.*y + p(5)*x.*y.^2 + p(6)*y.^3;

%Model 3
densOut = p(1) + p(2)*y + p(3)*y.^2 + p(4)*x.*y + p(5)*x.*y.^2;
