function getBrDenFromDb

[fName, pName] = uigetfile('*.txt', 'Select an acquisition list file');
if ~isequal(fName, 0)
    listIn = textread([pName, fName]);
    n = length(listIn);
    
    dateList = zeros(n, 1);
    density6 = zeros(n, 1);
    volume6 = zeros(n, 1);
    densVol6 = zeros(n, 1);
    density7C1 = zeros(n, 1);
    volume7C1 = zeros(n, 1);
    densVol7C1 = zeros(n, 1);
    density7C2 = zeros(n, 1);
    volume7C2 = zeros(n, 1);
    densVol7C2 = zeros(n, 1);
	density7C3 = zeros(n, 1);
    volume7C3 = zeros(n, 1);
    densVol7C3 = zeros(n, 1);
    
    for i = 1:n
        acqId = listIn(i);
        %get date of each acquisition id
        SQLstatement = ['SELECT date_acquisition ', ...
                        'FROM acquisition ', ...
                        'WHERE acquisition_id = ', num2str(acqId)];
        entryRead = mxDatabase('mammo_cpmc', SQLstatement);
        dateList(i) = str2date(entryRead{1});
        
        %get results of ver6
        SQLstatement = ['SELECT commonanalysis_id ', ...
                        'FROM commonanalysis ', ...
                        'WHERE commonanalysis_id = ', ...
                            '(SELECT max(commonanalysis_id) ' , ...
                            'FROM commonanalysis ', ...
                            'WHERE acquisition_id = ', num2str(acqId), ' ', ...
                            'AND version = ''Version6.5'')'];
        entryRead = mxDatabase('mammo_cpmc', SQLstatement);
        if ~isempty(entryRead)
            comId = entryRead{1};
            SQLstatement = ['SELECT SXAStepResult,  breast_volume ', ...
                            'FROM SXAStepAnalysis ', ...
                            'WHERE commonanalysis_id = ', num2str(comId)];
            entryRead = mxDatabase('mammo_cpmc', SQLstatement);
            if ~isempty(entryRead)
                density6(i) = entryRead{1};
                volume6(i) = entryRead{2};
                densVol6(i) = density6(i) * volume6(i);
            else
                density6(i) = NaN;
                volume6(i) = NaN;
            end
        end

        %get results of ver7.0.C1
        SQLstatement = ['SELECT commonanalysis_id ', ...
                        'FROM commonanalysis ', ...
                        'WHERE commonanalysis_id = ', ...
                            '(SELECT max(commonanalysis_id) ' , ...
                            'FROM commonanalysis ', ...
                            'WHERE acquisition_id = ', num2str(acqId), ' ', ...
                            'AND version = ''Version7.0.C1'')'];
        entryRead = mxDatabase('mammo_cpmc', SQLstatement);
        if ~isempty(entryRead)
            comId = entryRead{1};
            SQLstatement = ['SELECT SXAStepResult,  breast_volume ', ...
                            'FROM SXAStepAnalysis ', ...
                            'WHERE commonanalysis_id = ', num2str(comId)];
            entryRead = mxDatabase('mammo_cpmc', SQLstatement);
            if ~isempty(entryRead)
                density7C1(i) = entryRead{1};
                volume7C1(i) = entryRead{2};
                densVol7C1(i) = density7C1(i) * volume7C1(i);
            else
                density7C1(i) = NaN;
                volume7C1(i) = NaN;
            end
        end
        
        %get results of ver7.0.C2
        SQLstatement = ['SELECT commonanalysis_id ', ...
                        'FROM commonanalysis ', ...
                        'WHERE commonanalysis_id = ', ...
                            '(SELECT max(commonanalysis_id) ' , ...
                            'FROM commonanalysis ', ...
                            'WHERE acquisition_id = ', num2str(acqId), ' ', ...
                            'AND version = ''Version7.0.C2'')'];
        entryRead = mxDatabase('mammo_cpmc', SQLstatement);
        if ~isempty(entryRead)
            comId = entryRead{1};
            SQLstatement = ['SELECT SXAStepResult,  breast_volume ', ...
                            'FROM SXAStepAnalysis ', ...
                            'WHERE commonanalysis_id = ', num2str(comId)];
            entryRead = mxDatabase('mammo_cpmc', SQLstatement);
            density7C2(i) = entryRead{1};
            volume7C2(i) = entryRead{2};
            densVol7C2(i) = density7C2(i) * volume7C2(i);
        else
            density7C2(i) = NaN;
            volume7C2(i) = NaN;
            densVol7C2(i) = NaN;
        end
        
        %get results of ver7.0.C3
        SQLstatement = ['SELECT commonanalysis_id ', ...
                        'FROM commonanalysis ', ...
                        'WHERE commonanalysis_id = ', ...
                            '(SELECT max(commonanalysis_id) ' , ...
                            'FROM commonanalysis ', ...
                            'WHERE acquisition_id = ', num2str(acqId), ' ', ...
                            'AND version = ''Version7.0.C3'')'];
        entryRead = mxDatabase('mammo_cpmc', SQLstatement);
        if ~isempty(entryRead)
            comId = entryRead{1};
            SQLstatement = ['SELECT SXAStepResult,  breast_volume ', ...
                            'FROM SXAStepAnalysis ', ...
                            'WHERE commonanalysis_id = ', num2str(comId)];
            entryRead = mxDatabase('mammo_cpmc', SQLstatement);
            density7C3(i) = entryRead{1};
            volume7C3(i) = entryRead{2};
            densVol7C3(i) = density7C3(i) * volume7C3(i);
        else
            density7C3(i) = NaN;
            volume7C3(i) = NaN;
            densVol7C3(i) = NaN;
        end
        if mod(i, 50) == 0
            sprintf('i = %d', i)
        end
    end
    figure, scatter(dateList, density6, 'b');
    hold on; scatter(dateList, density7C1, 'r');
    scatter(dateList, density7C2, 'g');
    scatter(dateList, density7C3, 'y'); datetick('x', 12); hold off;
    denStd6 = nanstd(density6);
    volStd6 = nanstd(volume6);
    dvStd6 = nanstd(densVol6);
    denStd7C1 = nanstd(density7C1);
    volStd7C1 = nanstd(volume7C1);
    dvStd7C1 = nanstd(densVol7C1);
    denStd7C2 = nanstd(density7C2);
    volStd7C2 = nanstd(volume7C2);
    dvStd7C2 = nanstd(densVol7C2);
    denStd7C3 = nanstd(density7C3);
    volStd7C3 = nanstd(volume7C3);
    dvStd7C3 = nanstd(densVol7C3);

    sprintf(['    \t\tdensity\t\tvolume\t\tdens*vol\n', ...
            'Ver 6\t\t%g\t\t%g\t\t%g\n', ...
            'Ver 7C1\t\t%g\t\t%g\t\t%g\n', ...
            'Ver 7C2\t\t%g\t\t%g\t\t%g\n', ...
            'Ver 7C3\t\t%g\t\t%g\t\t%g'], ...
            denStd6, volStd6, dvStd6, ...
            denStd7C1, volStd7C1, dvStd7C1, ...
            denStd7C2, volStd7C2, dvStd7C2, ...
            denStd7C3, volStd7C3, dvStd7C3)
end

%%
function dateNum = str2date(dateStr)

dateStrNew = [dateStr(5:6), '-', dateStr(7:8), '-', dateStr(1:4)];
dateNum = datenum(dateStrNew);
