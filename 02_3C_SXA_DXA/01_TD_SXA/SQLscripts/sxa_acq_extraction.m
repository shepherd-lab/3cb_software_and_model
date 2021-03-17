function sxa_acq_extraction()
    Database.Name = 'mammo_CPMC';
    [FileName,PathName] = uigetfile('\\ming\aadata\aaSTUDIES\Breast Studies\TEST\sxabo_list_mammo.txt','Select the acquisition list txt-file ');   acqs_filename = [PathName,FileName];     %'\'
    FileName_list =  FileName;
    acqs_filename = [PathName,'\',FileName];
    ACQIDList = textread(acqs_filename,'%u');

    for index=1
        
        SQLStatement = ['SELECT * FROM dbo.SXAStepAnalysis INNER JOIN dbo.commonanalysis ON dbo.SXAStepAnalysis.commonanalysis_id = dbo.commonanalysis.commonanalysis_id INNER JOIN dbo.acquisition ON dbo.commonanalysis.acquisition_id = dbo.acquisition.acquisition_id WHERE     dbo.SXAStepAnalysis.version LIKE ''Version6.6%'' and dbo.acquisition.acquisition_id =',num2str(ACQIDList(index)),'order by dbo.sxastepanalysis.sxa_analysis_date'];
        %p1=max(mxDatabase('mammo_CPMC',SQLStatement));
        [a1,names1]=mxDatabase(Database.Name,SQLStatement);
        SQLStatement = ['SELECT * FROM dbo.ManualThresholdAnalysis INNER JOIN dbo.commonanalysis ON dbo.ManualThresholdAnalysis.commonanalysis_id = dbo.commonanalysis.commonanalysis_id INNER JOIN dbo.acquisition ON dbo.commonanalysis.acquisition_id = dbo.acquisition.acquisition_id WHERE     dbo.acquisition.acquisition_id =',num2str(ACQIDList(index)),'order by dbo.manualthresholdanalysis.manualthreshanalysis_id'];
        %p2=max(mxDatabase('mammo_CPMC',SQLStatement));
        [a2,names2]=mxDatabase(Database.Name,SQLStatement);
        %  output{1,:} = names;
        %  output{2:end,:} = a;
         output = [names1(end,:), names2(end,:);a1(end,:),a2(end,:)];
        acq = 1;
         a = 1;
    end
     
     for index=2:size(ACQIDList,1)
   % index = 81;
         SQLStatement = ['SELECT * FROM dbo.SXAStepAnalysis INNER JOIN dbo.commonanalysis ON dbo.SXAStepAnalysis.commonanalysis_id = dbo.commonanalysis.commonanalysis_id INNER JOIN dbo.acquisition ON dbo.commonanalysis.acquisition_id = dbo.acquisition.acquisition_id WHERE     dbo.SXAStepAnalysis.version LIKE ''Version6.6%'' and dbo.acquisition.acquisition_id =',num2str(ACQIDList(index)),'order by dbo.sxastepanalysis.sxa_analysis_date'];
        %p1=max(mxDatabase('mammo_CPMC',SQLStatement));
        a1=mxDatabase(Database.Name,SQLStatement);
        SQLStatement = ['SELECT * FROM dbo.ManualThresholdAnalysis INNER JOIN dbo.commonanalysis ON dbo.ManualThresholdAnalysis.commonanalysis_id = dbo.commonanalysis.commonanalysis_id INNER JOIN dbo.acquisition ON dbo.commonanalysis.acquisition_id = dbo.acquisition.acquisition_id WHERE     dbo.acquisition.acquisition_id =',num2str(ACQIDList(index)),'order by dbo.manualthresholdanalysis.manualthreshanalysis_id'];
        %p2=max(mxDatabase('mammo_CPMC',SQLStatement));
        a2=mxDatabase(Database.Name,SQLStatement);
        %  output{1,:} = names;
        %  output{2:end,:} = a;
        if isempty(a1) | isempty(a2)
            acq = [acq;ACQIDList(index)];
        else
            output = [output;a1(end,:),a2(end,:)];
        end
        
        
         a = index
    end
    
     Excel('INIT');
     Excel('TRANSFERT',output);
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