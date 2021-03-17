function sxa_acq_extraction_May()
    Database.Name = 'mammo_CPMC';
    [FileName,PathName] = uigetfile('\\ming\aadata\aaSTUDIES\Breast Studies\TEST\sxabo_list_mammo.txt','Select the acquisition list txt-file ');   acqs_filename = [PathName,FileName];     %'\'
    FileName_list =  FileName;
    acqs_filename = [PathName,'\',FileName];
    ACQIDList = textread(acqs_filename,'%u');
    count = 0;
    for index=1
        
       % SQLStatement = ['SELECT * FROM dbo.qcwaxAnalysis INNER JOIN dbo.commonanalysis ON dbo.qcwaxAnalysis.commonanalysis_id = dbo.commonanalysis.commonanalysis_id INNER JOIN dbo.acquisition ON dbo.commonanalysis.acquisition_id = dbo.acquisition.acquisition_id WHERE     dbo.acquisition.acquisition_id =',num2str(ACQIDList(index)),'order by dbo.qcwaxAnalysis.qc_analysis_date'];
       %SQLStatement = 'SELECT dbo.acquisition.*, dbo.QCWAXAnalysis.*, dbo.QCwaxSXAPhantomInfo.* FROM dbo.QCwaxSXAPhantomInfo INNER JOIN  dbo.QCWAXAnalysis ON dbo.QCwaxSXAPhantomInfo.QCWAXAnalysis_id = dbo.QCWAXAnalysis.QCWAXAnalysis_id  INNER JOIN  dbo.commonanalysis ON   dbo.QCWAXAnalysis.commonanalysis_id = dbo.commonanalysis.commonanalysis_id INNER        JOIN       dbo.acquisition ON       dbo.commonanalysis.acquisition_id = dbo.acquisition.acquisition_id WHERE dbo.QCWAXAnalysis.QC_analysis_date LIKE ''-Dec-2011'' AND  dbo.acquisition.machine_id = 39';
      % SQLStatement ='SELECT dbo.acquisition.*, dbo.QCWAXAnalysis.*, dbo.QCwaxSXAPhantomInfo.* FROM dbo.QCwaxSXAPhantomInfo INNER JOIN dbo.QCWAXAnalysis ON dbo.QCwaxSXAPhantomInfo.QCWAXAnalysis_id = dbo.QCWAXAnalysis.QCWAXAnalysis_id INNER JOIN dbo.commonanalysis ON dbo.QCWAXAnalysis.commonanalysis_id = dbo.commonanalysis.commonanalysis_id INNER JOIN dbo.acquisition ON dbo.commonanalysis.acquisition_id = dbo.acquisition.acquisition_id WHERE (dbo.QCWAXAnalysis.QC_analysis_date LIKE ''%-Dec-2011%'') AND (dbo.acquisition.machine_id = 39)';
         SQLStatement =['SELECT dbo.acquisition.*, dbo.QCWAXAnalysis.*, dbo.QCwaxSXAPhantomInfo.* FROM dbo.QCwaxSXAPhantomInfo INNER JOIN dbo.QCWAXAnalysis ON dbo.QCwaxSXAPhantomInfo.QCWAXAnalysis_id = dbo.QCWAXAnalysis.QCWAXAnalysis_id INNER JOIN dbo.commonanalysis ON dbo.QCWAXAnalysis.commonanalysis_id = dbo.commonanalysis.commonanalysis_id INNER JOIN dbo.acquisition ON dbo.commonanalysis.acquisition_id = dbo.acquisition.acquisition_id WHERE (dbo.QCWAXAnalysis.QC_analysis_date LIKE ''%May-2012%'') AND dbo.acquisition.acquisition_id =',num2str(ACQIDList(index)),'order by dbo.qcwaxAnalysis.qc_analysis_date'];
        [a1,names1]=mxDatabase(Database.Name,SQLStatement);
        if isempty(a1)
           output = [names1(end,:)];
       else
          output = [names1(end,:);a1(end,:)];
       end
        
        acq =1;
        a = 1;
    end
     
     for index=2:size(ACQIDList,1)
  
       % SQLStatement = ['SELECT * FROM dbo.qcwaxAnalysis INNER JOIN dbo.commonanalysis ON dbo.qcwaxAnalysis.commonanalysis_id = dbo.commonanalysis.commonanalysis_id INNER JOIN dbo.acquisition ON dbo.commonanalysis.acquisition_id = dbo.acquisition.acquisition_id WHERE     dbo.acquisition.acquisition_id =',num2str(ACQIDList(index)),'order by dbo.qcwaxanalysis.qc_analysis_date'];
       SQLStatement =['SELECT dbo.acquisition.*, dbo.QCWAXAnalysis.*, dbo.QCwaxSXAPhantomInfo.* FROM dbo.QCwaxSXAPhantomInfo INNER JOIN dbo.QCWAXAnalysis ON dbo.QCwaxSXAPhantomInfo.QCWAXAnalysis_id = dbo.QCWAXAnalysis.QCWAXAnalysis_id INNER JOIN dbo.commonanalysis ON dbo.QCWAXAnalysis.commonanalysis_id = dbo.commonanalysis.commonanalysis_id INNER JOIN dbo.acquisition ON dbo.commonanalysis.acquisition_id = dbo.acquisition.acquisition_id WHERE (dbo.QCWAXAnalysis.QC_analysis_date LIKE ''%MAy-2012%'') AND dbo.acquisition.acquisition_id =',num2str(ACQIDList(index)),'order by dbo.qcwaxAnalysis.qc_analysis_date'];
       a1=mxDatabase(Database.Name,SQLStatement);
       
        if isempty(a1)
            acq = [acq;ACQIDList(index)];
        else
            output = [output;a1(end,:)];
             acq_1 = [acq;ACQIDList(index)];
            count = count +1
        end
        
        
         a = index
    end
  
     Excel('INIT');
     Excel('TRANSFERT',output);
      a = 1;
%     save('U:\smalkov\GEN3 phantom test\CPMC_6_not.txt','acq','-ascii');
%      save('U:\smalkov\GEN3 phantom test\CPMC_6.txt','acq_1','-ascii');
      
      
      
  %  SQLStatement = 'SELECT * FROM dbo.SXAStepAnalysis INNER JOIN dbo.commonanalysis ON dbo.SXAStepAnalysis.commonanalysis_id = dbo.commonanalysis.commonanalysis_id INNER JOIN dbo.acquisition ON dbo.commonanalysis.acquisition_id = dbo.acquisition.acquisition_id WHERE     dbo.SXAStepAnalysis.version LIKE ''Version6.6%''';
%     p=mxDatabase('mammo_CPMC',SQLStatement);
%     [a,names]=mxDatabase(Database.Name,SQLStatement);
%     %  output{1,:} = names;
%     %  output{2:end,:} = a;
%      output = [names;a];
%      Excel('INIT');
%      Excel('TRANSFERT',output);
%ORDER BY dbo.SXAStepAnalysis.SXAStepAnalysis_id'