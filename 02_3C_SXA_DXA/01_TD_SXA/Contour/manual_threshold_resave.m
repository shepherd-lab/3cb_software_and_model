function sxa_acq_extraction()
    global Info Database
    Database.Name = 'mammo_CPMC';
    [FileName,PathName] = uigetfile('\\ming\aadata\aaSTUDIES\Breast Studies\TEST\manbo_list_mammo.txt','Select the acquisition list txt-file ');   acqs_filename = [PathName,FileName];     %'\'
    FileName_list =  FileName;
    manthreshID_filename = [PathName,'\',FileName];
    ManualThreshIDList = textread(manthreshID_filename,'%u');
    faults = 0;
    for index=1:size(ManualThreshIDList,1)
       Database.Step=2;
       Info.ManualThresholdAnalysisKey =  ManualThreshIDList(index);
       try
           RetrieveInDatabase('MANUALTHRESHOLDANALYSIS');
       catch
           faults = [faults,Info.ManualThresholdAnalysisKey];
           continue;
       end
      % SaveInDatabase('MANUALTHRESHOLDANALYSIS');
       a = index
    end
    
    
      a = 1;
      
%    SQLStatement = 'SELECT * FROM dbo.SXAStepAnalysis INNER JOIN dbo.commonanalysis ON dbo.SXAStepAnalysis.commonanalysis_id = dbo.commonanalysis.commonanalysis_id INNER JOIN dbo.acquisition ON dbo.commonanalysis.acquisition_id = dbo.acquisition.acquisition_id WHERE     dbo.SXAStepAnalysis.version LIKE ''Version6.6%''';
%     p=mxDatabase('mammo_CPMC',SQLStatement);
%     [a,names]=mxDatabase(Database.Name,SQLStatement);
%     %  output{1,:} = names;
%     %  output{2:end,:} = a;
%      output = [names;a];
%      Excel('INIT');
%      Excel('TRANSFERT',output);
%ORDER BY dbo.SXAStepAnalysis.SXAStepAnalysis_id'