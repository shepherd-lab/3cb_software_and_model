function structanalbreast_acq_extraction()
    Database.Name = 'mammo_CPMC';
    [FileName,PathName] = uigetfile('\\ming\aadata\aaSTUDIES\Breast Studies\TEST\sxabo_list_mammo.txt','Select the acquisition list txt-file ');   acqs_filename = [PathName,FileName];     %'\'
    FileName_list =  FileName;
    acqs_filename = [PathName,'\',FileName];
    ACQIDList = textread(acqs_filename,'%u');
     output = [];
%     for index=1
%         
%         SQLStatement = ['SELECT * FROM dbo.structuralanalysis INNER JOIN dbo.commonanalysis ON dbo.structuralanalysis.commonanalysis_id = dbo.commonanalysis.commonanalysis_id INNER JOIN dbo.acquisition ON dbo.commonanalysis.acquisition_id = dbo.acquisition.acquisition_id WHERE   dbo.structuralanalysis.structuralanalysistype =',num2str(1),' and  dbo.acquisition.acquisition_id =',num2str(ACQIDList(index)),'order by dbo.structuralanalysis.analysis_date'];
%         [a1,names1]=mxDatabase(Database.Name,SQLStatement);
%         output = [names1(end,:);a1(end,:)];
%         acq =1;
%         a = 1;
%     end
     
     for index=2:size(ACQIDList,1)
  
        %SQLStatement = ['SELECT * FROM dbo.qcwaxAnalysis INNER JOIN dbo.commonanalysis ON dbo.qcwaxAnalysis.commonanalysis_id = dbo.commonanalysis.commonanalysis_id INNER JOIN dbo.acquisition ON dbo.commonanalysis.acquisition_id = dbo.acquisition.acquisition_id WHERE     dbo.acquisition.acquisition_id =',num2str(ACQIDList(index)),'order by dbo.qcwaxanalysis.qc_analysis_date'];
        SQLStatement = ['SELECT * FROM dbo.structuralanalysis INNER JOIN dbo.commonanalysis ON dbo.structuralanalysis.commonanalysis_id = dbo.commonanalysis.commonanalysis_id INNER JOIN dbo.acquisition ON dbo.commonanalysis.acquisition_id = dbo.acquisition.acquisition_id WHERE   dbo.structuralanalysis.structuralanalysistype =',num2str(1),' and  dbo.acquisition.acquisition_id =',num2str(ACQIDList(index)),'order by dbo.structuralanalysis.analysis_date'];

        a1=mxDatabase(Database.Name,SQLStatement);
       
        if isempty(a1)
            acq = [acq;ACQIDList(index)];
        else
            output = [output;a1(end,:)];
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