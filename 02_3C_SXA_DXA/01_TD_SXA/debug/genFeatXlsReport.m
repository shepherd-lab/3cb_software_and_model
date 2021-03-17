function genFeatXlsReport(featParam, featResl, errMsg, info, append)
%genFeatXlsReport output the feature results to excel files
%Features from different features families are save in different files

global rootdir xlsLineNum

%default: append = false
if nargin == 4
    append = false;
end

%List the excel files to save feature results
fileName = {'Markovian.xls', ...
            'RunLength.xls', ...
            'Laws.xls', ...
            'Fourier.xls', ...
            'Wavelet.xls'};
nFeatSet = length(fileName);
filePathName = cell(size(fileName));
for i = 1:nFeatSet
    filePathName{i} = [rootdir, 'debug\FeatureReport\', fileName{i}];
end

%Get the number of lines used if append if true
%Clear the excel file content if append if false
if append
    xlsLineNum = getXlsLines(filePathName{1}, 'sheetIndex', 1) + 1;
else
    if xlsLineNum == 1
        for i = 1:length(filePathName)
            clearExcelFile(filePathName{i});
        end
    end
end
lineNum = xlsLineNum;

%Writing results
nGrRed = featParam.numGrRed + 1;
for iGr = 1:nGrRed    %iterate through gray level reductions
    shtName = ['grRed=', num2str(iGr-1)];
    fileIdx = 1;
    if ~isempty(featResl)
%%      Markovian.xls
        [rows, cols, pags] = size(featResl(iGr).Mark);
        lineNum = xlsLineNum;

        %write table titles
        if lineNum == 1
            tableTitle = {'AcqId'};
            for i = 1:rows
                for j = 1:cols
                    for k = 1:pags
                        dir = featParam.Mark.dir(i);
                        dist = featParam.Mark.dist(j);
                        featName = ['Mark ', num2str(dir), '_', ...
                                            num2str(dist), '_', ...
                                            num2str(k)];
                        tableTitle{end+1} = featName;
                    end
                end
            end
            xlswrite(filePathName{fileIdx}, tableTitle, shtName);
            lineNum = lineNum + 1;
        end

        %write results
        tableEntry = {info.AcquisitionKey};
        for i = 1:rows
            for j = 1:cols
                for k = 1:pags
                    tableEntry{end+1} = featResl(iGr).Mark(i, j, k);
                end
            end
        end
        xlswrite(filePathName{fileIdx}, tableEntry, shtName, ['A', num2str(lineNum)]);
        fileIdx = fileIdx + 1;

%%      RunLength.xls
        [rows, cols] = size(featResl(iGr).RL);
        lineNum = xlsLineNum;

        %write table titles
        if lineNum == 1
            tableTitle = {'AcqId'};
            for i = 1:rows
                for j = 1:cols
                    dir = featParam.RL.dir(i);
                    featName = ['RL ', num2str(dir), '_', num2str(j)];
                    tableTitle{end+1} = featName;
                end
            end
            xlswrite(filePathName{fileIdx}, tableTitle, shtName);
            lineNum = lineNum + 1;
        end

        %write results
        tableEntry = {info.AcquisitionKey};
        for i = 1:rows
            for j = 1:cols
                tableEntry{end+1} = featResl(iGr).RL(i, j);
            end
        end
        xlswrite(filePathName{fileIdx}, tableEntry, shtName, ['A', num2str(lineNum)]);
        fileIdx = fileIdx + 1;

%%      Laws.xls
        [rows, cols, pags] = size(featResl(iGr).Laws);
        lineNum = xlsLineNum;

        %write table titles
        if lineNum == 1
            tableTitle = {'AcqId'};
            for i = 1:rows
                for j = 1:cols
                    for k = 1:pags
                        fVer = featParam.Laws.filter{i};
                        fHor = featParam.Laws.filter{j};
                        featName = ['Laws ', fVer, fHor, '_', num2str(k)];
                        tableTitle{end+1} = featName;
                    end
                end
            end
            xlswrite(filePathName{fileIdx}, tableTitle, shtName);
            lineNum = lineNum + 1;
        end

        %write results
        tableEntry = {info.AcquisitionKey};
        for i = 1:rows
            for j = 1:cols
                for k = 1:pags
                    tableEntry{end+1} = featResl(iGr).Laws(i, j, k);
                end
            end
        end
        xlswrite(filePathName{fileIdx}, tableEntry, shtName, ['A', num2str(lineNum)]);
        fileIdx = fileIdx + 1;

%%      Fourier.xls
        [rows, cols] = size(featResl(iGr).FFT);
        lineNum = xlsLineNum;
        fftFeatName = {'RawE', 'NormE'};

        %write table titles
        if lineNum == 1
            tableTitle = {'AcqId'};
            for i = 1:rows
                for j = 1:cols
                    featName = ['FFT ', fftFeatName{i}, '_', num2str(j)];
                    tableTitle{end+1} = featName;
                end
            end
            xlswrite(filePathName{fileIdx}, tableTitle, shtName);
            lineNum = lineNum + 1;
        end

        %write results
        tableEntry = {info.AcquisitionKey};
        for i = 1:rows
            for j = 1:cols
                tableEntry{end+1} = featResl(iGr).FFT(i, j);
            end
        end
        xlswrite(filePathName{fileIdx}, tableEntry, shtName, ['A', num2str(lineNum)]);
        fileIdx = fileIdx + 1;

%%      Wavelet.xls
        n = length(featResl(iGr).Wave);
        lineNum = xlsLineNum;

        %write table titles
        if lineNum == 1
            tableTitle = {'AcqId'};
            for i = 1:n
                featName = ['Wave ', num2str(i)];
                tableTitle{end+1} = featName;
            end
            xlswrite(filePathName{fileIdx}, tableTitle, shtName);
            lineNum = lineNum + 1;
        end

        %write results
        tableEntry = {info.AcquisitionKey};
        for i = 1:n
            tableEntry{end+1} = featResl(iGr).Wave(i);
        end
        xlswrite(filePathName{fileIdx}, tableEntry, shtName, ['A', num2str(lineNum)]);

%%  save the error when no feature results
    else
        tableEntry = {info.AcquisitionKey, errMsg};
        for fileIdx = 1:nFeatSet
            xlswrite(filePathName{fileIdx}, tableEntry, shtName, ['A', num2str(xlsLineNum)]);
        end
    end
end

xlsLineNum = lineNum + 1;
