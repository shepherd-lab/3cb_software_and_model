function dicom_extraction()
    Database.Name = 'mammo_CPMC';
    [FileName,PathName] = uigetfile('\\researchstg\Users\smalkov\Case-control_studies\*.txt','Select the acquisition list txt-file ');   
    FileName_list =  FileName;
    acqs_filename = [PathName,'\',FileName];
    ACQIDList = textread(acqs_filename,'%u');
    output = [];
    for index=1
        
        %SQLStatement = ['SELECT sxastepanalysis.* FROM mammo_CPMC.dbo.sxastepanalysis INNER JOIN dbo.commonanalysis ON dbo.sxastepanalysis.commonanalysis_id = dbo.commonanalysis.commonanalysis_id INNER JOIN dbo.acquisition ON dbo.commonanalysis.acquisition_id = dbo.acquisition.acquisition_id WHERE (dbo.sxastepanalysis.version like ''%Version7.1%'' or dbo.sxastepanalysis.version like ''%Version8.0%'')  and dbo.sxastepanalysis.sxastepanalysistype =',num2str(1),' and  dbo.acquisition.acquisition_id =',num2str(ACQIDList(index)),' order by dbo.sxastepanalysis.sxastepanalysis_id'];
       % SQLStatement = ['SELECT * FROM mammo_CPMC.dbo.sxastepanalysis INNER JOIN dbo.commonanalysis ON mammo_CPMC.dbo.sxastepanalysis.commonanalysis_id = dbo.commonanalysis.commonanalysis_id INNER JOIN dbo.acquisition ON dbo.commonanalysis.acquisition_id = dbo.acquisition.acquisition_id WHERE (mammo_CPMC.dbo.sxastepanalysis.version like ''%Version7.1%'')  and mammo_CPMC.dbo.sxastepanalysis.sxastepanalysistype =',num2str(1),' and  dbo.acquisition.acquisition_id =',num2str(ACQIDList(index)),' order by mammo_CPMC.dbo.sxastepanalysis.sxastepanalysis_id'];
%          SQLStatement = ['SELECT * FROM sxastepanalysis INNER JOIN commonanalysis ON sxastepanalysis.commonanalysis_id = commonanalysis.commonanalysis_id INNER JOIN acquisition ON commonanalysis.acquisition_id = acquisition.acquisition_id WHERE (sxastepanalysis.version like ''%Version8%'')  and  acquisition.acquisition_id =',num2str(ACQIDList(index)),' order by sxastepanalysis.sxastepanalysis_id'];
        SQLStatement = ['SELECT *  FROM [mammo_CPMC].[dbo].[DICOMinfo], [mammo_CPMC].[dbo].[acquisition]  where DICOMinfo.DICOM_ID = acquisition.DICOM_ID and acquisition_id = ',num2str(ACQIDList(index))];    
        
        [a1,names1]=mxDatabase(Database.Name,SQLStatement);
        if isempty(a1)
            acq =  ACQIDList(index)
            output = [names1(end,:)];
        else
            output = [names1(end,:);a1(end,:)];
            acq =1;
        end
        a = 1;
    end
     
     for index=2:size(ACQIDList,1)
  
        %SQLStatement = ['SELECT * FROM dbo.qcwaxAnalysis INNER JOIN dbo.commonanalysis ON dbo.qcwaxAnalysis.commonanalysis_id = dbo.commonanalysis.commonanalysis_id INNER JOIN dbo.acquisition ON dbo.commonanalysis.acquisition_id = dbo.acquisition.acquisition_id WHERE     dbo.acquisition.acquisition_id =',num2str(ACQIDList(index)),'order by dbo.qcwaxanalysis.qc_analysis_date'];
        %SQLStatement = ['SELECT * FROM dbo.sxastepanalysis INNER JOIN dbo.commonanalysis ON dbo.sxastepanalysis.commonanalysis_id = dbo.commonanalysis.commonanalysis_id INNER JOIN dbo.acquisition ON dbo.commonanalysis.acquisition_id = dbo.acquisition.acquisition_id WHERE  sxastepanalysis.version like ''%Version8.0%''and dbo.sxastepanalysis.sxastepanalysistype =',num2str(1),' and  dbo.acquisition.acquisition_id =',num2str(ACQIDList(index)),'order by dbo.sxastepanalysis.sxastepanalysis_id'];
     %SQLStatement = ['SELECT * FROM mammo_CPMC.dbo.sxastepanalysis INNER JOIN dbo.commonanalysis ON dbo.sxastepanalysis.commonanalysis_id = dbo.commonanalysis.commonanalysis_id INNER JOIN dbo.acquisition ON dbo.commonanalysis.acquisition_id = dbo.acquisition.acquisition_id WHERE (dbo.sxastepanalysis.version like ''%Version7.1%'' or dbo.sxastepanalysis.version like ''%Version8.0%'')  and dbo.sxastepanalysis.sxastepanalysistype =',num2str(1),' and  dbo.acquisition.acquisition_id =',num2str(ACQIDList(index)),' order by dbo.sxastepanalysis.sxastepanalysis_id'];
       %SQLStatement = ['SELECT * FROM mammo_CPMC.dbo.sxastepanalysis INNER JOIN dbo.commonanalysis ON dbo.sxastepanalysis.commonanalysis_id = dbo.commonanalysis.commonanalysis_id INNER JOIN dbo.acquisition ON dbo.commonanalysis.acquisition_id = dbo.acquisition.acquisition_id WHERE (dbo.sxastepanalysis.version like ''%Version7.1%'' )  and dbo.sxastepanalysis.sxastepanalysistype =',num2str(1),' and  dbo.acquisition.acquisition_id =',num2str(ACQIDList(index)),' order by dbo.sxastepanalysis.sxastepanalysis_id'];
%         SQLStatement = ['SELECT * FROM sxastepanalysis INNER JOIN commonanalysis ON sxastepanalysis.commonanalysis_id = commonanalysis.commonanalysis_id INNER JOIN acquisition ON commonanalysis.acquisition_id = acquisition.acquisition_id WHERE (sxastepanalysis.version like ''%Version8.0'')  and  acquisition.acquisition_id =',num2str(ACQIDList(index)),' order by sxastepanalysis.sxastepanalysis_id'];
%        SQLStatement = ['SELECT * FROM sxastepanalysis INNER JOIN commonanalysis ON sxastepanalysis.commonanalysis_id = commonanalysis.commonanalysis_id INNER JOIN acquisition ON commonanalysis.acquisition_id = acquisition.acquisition_id WHERE (sxastepanalysis.version like ''%Version8%'')  and  acquisition.acquisition_id =',num2str(ACQIDList(index)),' order by sxastepanalysis.sxastepanalysis_id'];
          SQLStatement = ['SELECT *  FROM [mammo_CPMC].[dbo].[DICOMinfo], [mammo_CPMC].[dbo].[acquisition]  where DICOMinfo.DICOM_ID = acquisition.DICOM_ID and acquisition_id = ',num2str(ACQIDList(index))] ;   
        
       
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
     acq
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