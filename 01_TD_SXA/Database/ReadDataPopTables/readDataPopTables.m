function noAnaIDList = readDataPopTables(acqIDList)

%This function reads in the list of acquisition ID and outputs the ID list
%without analysis results.

% rootdir=[pwd,'\'];
% addpath(rootdir);
% addpath([rootdir,'Compiler']);
% addpath([rootdir,'Database']);
% 
% acqIDList = load('CPMC machine 1 GEN3.txt', '-ascii');
numEntry = length(acqIDList);
noAnaNum = 0;   %records how many IDs have no analysis
noAnaIDList = [];
numAttri = 13;
machParams = cell(numAttri, 1);

phanThick = [2, 4, 6];  %cm
dens = [0, 50, 100];    %percentage of fibroglandular
phanAtnu = zeros(3, 3);  %row: thickness, col: density
SXAthick = [1.2, 1.9, 2.6, 3.3, 4, 4.7, 5.4, 6.1, 6.8];
SXAatnu = zeros(1, 9);
kLean = zeros(3, 1);    %row: thickness
km = zeros(3, 1);
refDSPtoWAX = 30;  %DSP 0% is 30% on the wax-to-water scale

analysisVersion = 'Version6.6'; %read data analyzed by Version 6.6

for i = 1:numEntry

    %STEP 1: read analysis results according to acquisition_id
    [machParams, phanAtnu, SXAatnu, hasAnalysis] = readPhantomResults(acqIDList(i));
    
    if hasAnalysis
    %STEP 2: write analysis results to 'machineParametersByDate'
        SQLstatement = ['IF NOT EXISTS ', ...
                        '(SELECT * ', ...
                        'FROM machineParametersByDate ', ...
                        'WHERE commonanalysis_id = ', num2str(machParams{1}), ') '];
        SQLstatement = [SQLstatement, 'INSERT INTO machineParametersByDate VALUES ('];
        for j = 1:numAttri
            if isempty(machParams{j})
                SQLstatement = [SQLstatement, 'NULL'];
            else
                if isstr(machParams{j})
                    SQLstatement = [SQLstatement, '''', machParams{j}, ''''];
                else
                    SQLstatement = [SQLstatement, num2str(machParams{j})];
                end
            end
            if j ~= numAttri
                SQLstatement = [SQLstatement, ', '];
            else
                SQLstatement = [SQLstatement, ')'];
            end
        end
        mxDatabase('mammo_cpmc', SQLstatement);
    
        %STEP 3: calculate kLean and km
        SXAcoeff = polyfit(SXAthick, SXAatnu, 2);
        for iterH = 1:3 %for each height of GEN3 phantom
% original code for calculating k valus on the WAX-water reference
%             H = phanThick(iterH);
%             VD0 = phanAtnu(iterH, 1);
%             %get VD80
%             phanCoeff = polyfit(dens, phanAtnu(iterH, :), 2);
%             VD80 = phanCoeff(1)*80^2 + phanCoeff(2)*80 + phanCoeff(3);
%             %get V80 at H
%             V80 = SXAcoeff(1)*H^2 + SXAcoeff(2)*H + SXAcoeff(3);
% 
%             kLean(iterH) = VD80/V80;
%             m80 = kLean(iterH)*(2*SXAcoeff(1)*H + SXAcoeff(2));
%             km(iterH) = m80*H/(m80*H - VD80 + VD0);

            %code for calculating k values on the DSP7 reference
            H = phanThick(iterH);
            phanCoeff = polyfit(dens, phanAtnu(iterH, :), 2);
            VD0 = phanCoeff(1)*refDSPtoWAX^2 + phanCoeff(2)*refDSPtoWAX + ...
                  phanCoeff(3);
            VD80 = phanCoeff(1)*80^2 + phanCoeff(2)*80 + phanCoeff(3);
            V80 = SXAcoeff(1)*H^2 + SXAcoeff(2)*H + SXAcoeff(3);
            kLean(iterH) = VD80/V80;
            m80 = kLean(iterH)*(SXAcoeff(1)*H + SXAcoeff(2));
            km(iterH) = m80*H/(m80*H - VD80 + VD0);
        end

        %STEP 4 Populate table 'kValues'
        %read kVp, mAs
        SQLstatement = ['SELECT kVp, mAs ', ...
                        'FROM acquisition ', ...
                        'WHERE acquisition_id = ', num2str(acqIDList(i))];
        entryRead = mxDatabase('mammo_cpmc', SQLstatement);
        voltage = entryRead{1};
        current = entryRead{2};

        %write data to 'kValues'
        SQLstatement = ['IF NOT EXISTS ', ...
                        '(SELECT * ', ...
                        'FROM kValuesDSP7 ', ...
                        'WHERE acquisition_id = ', num2str(acqIDList(i)), ') '];
        SQLstatement = [SQLstatement, 'INSERT INTO kValuesDSP7 VALUES (', ...
                        num2str(acqIDList(i)), ', ', ...
                        num2str(machParams{2}), ', ', ...
                        num2str(machParams{3}), ', ', ...
                        '''', num2str(machParams{4}), '''', ', ', ...
                        num2str(voltage), ', ', ...
                        num2str(current), ', '];
        for j = 1:3
            SQLstatement = [SQLstatement, num2str(kLean(j)), ', '];
        end
        for j = 1:3
            if j ~= 3
                SQLstatement = [SQLstatement, num2str(km(j)), ', '];
            else
                SQLstatement = [SQLstatement, num2str(km(j)), ')'];
            end
        end

        mxDatabase('mammo_cpmc', SQLstatement);
    else
        noAnaNum = noAnaNum + 1;
        noAnaIDList(noAnaNum, 1) = acqIDList(i);
    end
    
end

