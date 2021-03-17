function structanalbreast_acq_extraction()
    Database.Name = 'mammo_CPMC';
    [FileName,PathName] = uigetfile('\\\aadata\aaSTUDIES\Breast Studies\TEST\sxabo_list_mammo.txt','Select the acquisition list txt-file ');   acqs_filename = [PathName,FileName];     %'\'
    FileName_list =  FileName;
    acqs_filename = [PathName,'\',FileName];
    ACQIDList = textread(acqs_filename,'%u');
  output = [];
    for index=1
        SQLStatement = ['SELECT ManualThresholdAnalysis.*, commonanalysis.* FROM dbo.ManualThresholdAnalysis INNER JOIN dbo.commonanalysis ON dbo.ManualThresholdAnalysis.commonanalysis_id = dbo.commonanalysis.commonanalysis_id INNER JOIN dbo.acquisition ON dbo.commonanalysis.acquisition_id = dbo.acquisition.acquisition_id WHERE  dbo.ManualThresholdAnalysis.threshold_analysis_date like ''%Jan-2017%''  and  dbo.ManualThresholdAnalysis.operator_id =',num2str(2),' and  dbo.acquisition.acquisition_id =',num2str(ACQIDList(index)),'order by dbo.ManualThresholdAnalysis.ManualThreshAnalysis_id'];
        [a1,names1]=mxDatabase(Database.Name,SQLStatement);
        output = [names1(end,:);a1(end,:)];
        acq =1;
        a = 1;
    end
     
     for index=2:size(ACQIDList,1)
  
        %SQLStatement = ['SELECT * FROM dbo.qcwaxAnalysis INNER JOIN dbo.commonanalysis ON dbo.qcwaxAnalysis.commonanalysis_id = dbo.commonanalysis.commonanalysis_id INNER JOIN dbo.acquisition ON dbo.commonanalysis.acquisition_id = dbo.acquisition.acquisition_id WHERE     dbo.acquisition.acquisition_id =',num2str(ACQIDList(index)),'order by dbo.qcwaxanalysis.qc_analysis_date'];
        SQLStatement = ['SELECT ManualThresholdAnalysis.*, commonanalysis.* FROM dbo.ManualThresholdAnalysis INNER JOIN dbo.commonanalysis ON dbo.ManualThresholdAnalysis.commonanalysis_id = dbo.commonanalysis.commonanalysis_id INNER JOIN dbo.acquisition ON dbo.commonanalysis.acquisition_id = dbo.acquisition.acquisition_id WHERE  dbo.ManualThresholdAnalysis.threshold_analysis_date like ''%Jan-2017%''  and  dbo.ManualThresholdAnalysis.operator_id =',num2str(2),' and  dbo.acquisition.acquisition_id =',num2str(ACQIDList(index)),'order by dbo.ManualThresholdAnalysis.ManualThreshAnalysis_id'];
        a1=mxDatabase(Database.Name,SQLStatement);
       
        if isempty(a1)
            acq = [acq;ACQIDList(index)];
        else
            output = [output;a1(end,:)];
        end
        
        
         a = index
    end
     missing_acq = acq
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