function getBrDenFromDb

[fName, pName] = uigetfile('*.txt', 'Select an acquisition list file');
dbstop at 87

if ~isequal(fName, 0)
    listIn = textread([pName, fName]);
    n = length(listIn);
    
%     verList = {'Version7.0.C4', 'Version7.0.C5'};
    verList = {'Version6.5', 'Version7.0.C4'};
    numVers = length(verList);
    dateList = zeros(n, 1);
    density = zeros(n, numVers);
    volume = zeros(n, numVers);
    densVol = zeros(n, numVers);
    comIdList = zeros(n, numVers);
    
    for i = 1:n
        acqId = listIn(i);
        %get date of each acquisition id
        SQLstatement = ['SELECT date_acquisition ', ...
                        'FROM acquisition ', ...
                        'WHERE acquisition_id = ', num2str(acqId)];
        entryRead = mxDatabase('mammo_cpmc', SQLstatement);
        dateList(i) = str2date(entryRead{1});
        
        %get results of each version
        for j = 1:numVers
            ver = verList{j};
            SQLstatement = ['SELECT commonanalysis_id ', ...
                            'FROM commonanalysis ', ...
                            'WHERE commonanalysis_id = ', ...
                                '(SELECT max(commonanalysis_id) ' , ...
                                'FROM commonanalysis ', ...
                                'WHERE acquisition_id = ', num2str(acqId), ' ', ...
                                'AND version = ''', ver, ''')'];
            entryRead = mxDatabase('mammo_cpmc', SQLstatement);
            if ~isempty(entryRead)
                comId = entryRead{1};
                SQLstatement = ['SELECT SXAStepResult,  breast_volume ', ...
                                'FROM SXAStepAnalysis ', ...
                                'WHERE commonanalysis_id = ', num2str(comId)];
                entryRead = mxDatabase('mammo_cpmc', SQLstatement);
                if ~isempty(entryRead)
                    density(i, j) = entryRead{1};
                    volume(i, j) = entryRead{2};
                    densVol(i, j) = density(i, j) * volume(i, j);
                    comIdList(i, j) = comId;
                else
                    density(i, j) = NaN;
                    volume(i, j) = NaN;
                    densVol(i, j) = NaN;
                    comIdList(i, j) = NaN;
                end
            else
                density(i, j) = NaN;
                volume(i, j) = NaN;
                densVol(i, j) = NaN;
                comIdList(i, j) = NaN;
            end
        end

        if mod(i, 50) == 0
            sprintf('i = %d', i)
        end
    end

    colorList = {'b', 'r', 'g', 'y'};
    figure;
    for j = 1:numVers
        scatter(dateList, density(:, j), colorList{j});
        hold on;
    end
    datetick('x', 12); hold off;

    denStd = nanstd(density);
    volStd = nanstd(volume);
    dvStd = nanstd(densVol);
    printStr = 'Std of\t\tdensity\t\tvolume  \t\tdens*vol\n';
    for j = 1:numVers
        verShort = strrep(strrep(verList{j}, 'sion', ''), '.', '');
        printStr = [printStr, ...
                    verShort, '\t\t', num2str(denStd(j)), '\t\t', ...
                    num2str(volStd(j)), '\t\t', num2str(dvStd(j)), '\n']; %#ok<AGROW>
    end
    sprintf(printStr)
end

%%
function dateNum = str2date(dateStr)

dateStrNew = [dateStr(5:6), '-', dateStr(7:8), '-', dateStr(1:4)];
dateNum = datenum(dateStrNew);
