function sxa_acq_extraction()
    Database.Name = 'mammo_CPMC';
    [FileName,PathName] = uigetfile('\\ming\aadata\aaSTUDIES\Breast Studies\TEST\sxabo_list_mammo.txt','Select the acquisition list txt-file ');   acqs_filename = [PathName,FileName];     %'\'
    FileName_list =  FileName;
    acqs_filename = [PathName,'\',FileName];
    ACQIDList = textread(acqs_filename,'%u');

    for index=1
        
       % SQLStatement = ['SELECT * FROM dbo.sxastepnalysis INNER JOIN dbo.commonanalysis ON dbo.sxaAnalysis.commonanalysis_id = dbo.commonanalysis.commonanalysis_id INNER JOIN dbo.acquisition ON dbo.commonanalysis.acquisition_id = dbo.acquisition.acquisition_id WHERE     dbo.acquisition.acquisition_id =',num2str(ACQIDList(index)),'order by dbo.qcwaxAnalysis.sxa_analysis_date'];
        SQLStatement = ['SELECT * FROM dbo.sxastepanalysis INNER JOIN dbo.commonanalysis ON dbo.sxastepanalysis.commonanalysis_id = dbo.commonanalysis.commonanalysis_id INNER JOIN dbo.acquisition ON dbo.commonanalysis.acquisition_id = dbo.acquisition.acquisition_id WHERE dbo.sxastepanalysis.version LIKE ''%Version7.1%'' AND (dbo.sxastepanalysis.sxa_analysis_date LIKE ''%06-Apr-2012%'' OR  dbo.sxastepanalysis.sxa_analysis_date LIKE ''%07-Apr-2012%''  OR dbo.sxastepanalysis.sxa_analysis_date LIKE ''%08-Apr-2012%'' OR dbo.sxastepanalysis.sxa_analysis_date LIKE ''%09-Apr-2012%'')  AND  dbo.acquisition.acquisition_id =',num2str(ACQIDList(index)),'order by dbo.sxastepanalysis.sxa_analysis_date'];

        [a1,names1]=mxDatabase(Database.Name,SQLStatement);
        output = [names1(end,:);a1(end,:)];
        acq =1;
        a = 1;
    end
     
     for index=2:size(ACQIDList,1)
  
   %     SQLStatement = ['SELECT * FROM dbo.sxastepanalysis INNER JOIN dbo.commonanalysis ON dbo.sxastepanalysis.commonanalysis_id = dbo.commonanalysis.commonanalysis_id INNER JOIN dbo.acquisition ON dbo.commonanalysis.acquisition_id = dbo.acquisition.acquisition_id WHERE dbo.sxastepanalysis.version LIKE ''%Version7.1%'' AND dbo.sxastepanalysis.sxa_analysis_date LIKE ''%06-Apr-2012%'' AND   dbo.acquisition.acquisition_id =',num2str(ACQIDList(index)),'order by dbo.sxastepanalysis.sxa_analysis_date'];
        SQLStatement = ['SELECT * FROM dbo.sxastepanalysis INNER JOIN dbo.commonanalysis ON dbo.sxastepanalysis.commonanalysis_id = dbo.commonanalysis.commonanalysis_id INNER JOIN dbo.acquisition ON dbo.commonanalysis.acquisition_id = dbo.acquisition.acquisition_id WHERE dbo.sxastepanalysis.version LIKE ''%Version7.1%'' AND (dbo.sxastepanalysis.sxa_analysis_date LIKE ''%06-Apr-2012%'' OR  dbo.sxastepanalysis.sxa_analysis_date LIKE ''%07-Apr-2012%''  OR dbo.sxastepanalysis.sxa_analysis_date LIKE ''%08-Apr-2012%'' OR dbo.sxastepanalysis.sxa_analysis_date LIKE ''%09-Apr-2012%'')  AND  dbo.acquisition.acquisition_id =',num2str(ACQIDList(index)),'order by dbo.sxastepanalysis.sxa_analysis_date'];

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
      Excel('INIT');
     Excel('TRANSFERT',acq)
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