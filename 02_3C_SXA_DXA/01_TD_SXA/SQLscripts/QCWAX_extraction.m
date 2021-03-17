function sxacomdicom_extraction_extraction()
    Database.Name = 'mammo_CPMC';
    [FileName,PathName] = uigetfile('\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\*.txt','Select the acquisition list txt-file ');   
    FileName_list =  FileName;
    acqs_filename = [PathName,'\',FileName];
    ACQIDList = textread(acqs_filename,'%u');
    output = [];
    for index=1
        
        
        %SQLStatement = ['SELECT QCWAXAnalysis.*, commonanalysis.*   FROM dbo.acquisition, mammo_CPMC.dbo.QCWAXAnalysis, dbo.commonanalysis  where acquisition.acquisition_id = commonanalysis.acquisition_id and QCWAXAnalysis.commonanalysis_id = commonanalysis.commonanalysis_id  and (QCWAXAnalysis.version like ''%Version7.1%'' or QCWAXAnalysis.version like ''%Version8.0%'') and acquisition.acquisition_id = ',num2str(ACQIDList(index)),'order by dbo.QCWAXAnalysis.QCWAXAnalysis_id'];
        SQLStatement = ['SELECT  acquisition.*,QCWAXAnalysis.*, commonanalysis.*, QCwaxSXAPhantomInfo.*  FROM dbo.acquisition, mammo_CPMC.dbo.QCWAXAnalysis, dbo.commonanalysis, dbo.QCwaxSXAPhantomInfo where acquisition.acquisition_id = commonanalysis.acquisition_id and QCWAXAnalysis.commonanalysis_id = commonanalysis.commonanalysis_id and  QCwaxSXAPhantomInfo.qcwaxanalysis_id = qcwaxanalysis.qcwaxanalysis_id and (QCWAXAnalysis.version like ''%Version8.0%'' ) and acquisition.acquisition_id = ',num2str(ACQIDList(index)),'order by dbo.QCWAXAnalysis.QCWAXAnalysis_id'];
        
        %SQLStatement = ['SELECT structuralanalysis.*, acquisition.* FROM dbo.structuralanalysis INNER JOIN dbo.commonanalysis ON dbo.structuralanalysis.commonanalysis_id = dbo.commonanalysis.commonanalysis_id INNER JOIN dbo.acquisition ON dbo.commonanalysis.acquisition_id = dbo.acquisition.acquisition_id WHERE   dbo.structuralanalysis.structuralanalysistype =',num2str(1),' and  dbo.acquisition.acquisition_id =',num2str(ACQIDList(index)),'order by dbo.structuralanalysis.analysis_date'];
        [a1,names1]=mxDatabase(Database.Name,SQLStatement);
        output = [names1(end,:)]; %;a1(end,:)
        acq =1;
        a = 1;
    end
     
    
    
     for index=2:size(ACQIDList,1)
  
        %SQLStatement = ['SELECT * FROM dbo.qcwaxAnalysis INNER JOIN dbo.commonanalysis ON dbo.qcwaxAnalysis.commonanalysis_id = dbo.commonanalysis.commonanalysis_id INNER JOIN dbo.acquisition ON dbo.commonanalysis.acquisition_id = dbo.acquisition.acquisition_id WHERE     dbo.acquisition.acquisition_id =',num2str(ACQIDList(index)),'order by dbo.qcwaxanalysis.qc_analysis_date'];
        %SQLStatement = ['SELECT structuralanalysis.*, acquisition.*  FROM dbo.structuralanalysis INNER JOIN dbo.commonanalysis ON dbo.structuralanalysis.commonanalysis_id = dbo.commonanalysis.commonanalysis_id INNER JOIN dbo.acquisition ON dbo.commonanalysis.acquisition_id = dbo.acquisition.acquisition_id WHERE   dbo.structuralanalysis.structuralanalysistype =',num2str(1),' and  dbo.acquisition.acquisition_id =',num2str(ACQIDList(index)),'order by dbo.structuralanalysis.analysis_date'];
        
        %SQLStatement = ['SELECT QCWAXAnalysis.*, commonanalysis.*   FROM dbo.acquisition, mammo_CPMC.dbo.QCWAXAnalysis, dbo.commonanalysis  where acquisition.acquisition_id = commonanalysis.acquisition_id and QCWAXAnalysis.commonanalysis_id = commonanalysis.commonanalysis_id  and (QCWAXAnalysis.version like ''%Version7.1%'' or QCWAXAnalysis.version like ''%Version8.0%'') and acquisition.acquisition_id = ',num2str(ACQIDList(index)),'order by dbo.QCWAXAnalysis.QCWAXAnalysis_id'];
         SQLStatement = ['SELECT  acquisition.*,QCWAXAnalysis.*, commonanalysis.*, QCwaxSXAPhantomInfo.*  FROM dbo.acquisition, mammo_CPMC.dbo.QCWAXAnalysis, dbo.commonanalysis, dbo.QCwaxSXAPhantomInfo where acquisition.acquisition_id = commonanalysis.acquisition_id and QCWAXAnalysis.commonanalysis_id = commonanalysis.commonanalysis_id and  QCwaxSXAPhantomInfo.qcwaxanalysis_id = qcwaxanalysis.qcwaxanalysis_id and (QCWAXAnalysis.version like ''%Version8.0%'' ) and acquisition.acquisition_id = ',num2str(ACQIDList(index)),'order by dbo.QCWAXAnalysis.QCWAXAnalysis_id'];
        
        
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
      
%    SQLStatement = 'SELECT * FROM dbo.QCWAXAnalysis INNER JOIN dbo.commonanalysis ON dbo.QCWAXAnalysis.commonanalysis_id = dbo.commonanalysis.commonanalysis_id INNER JOIN dbo.acquisition ON dbo.commonanalysis.acquisition_id = dbo.acquisition.acquisition_id WHERE     dbo.QCWAXAnalysis.version LIKE ''Version6.6%''';
%     p=mxDatabase('mammo_CPMC',SQLStatement);
%     [a,names]=mxDatabase(Database.Name,SQLStatement);
%     %  output{1,:} = names;
%     %  output{2:end,:} = a;
%      output = [names;a];
%      Excel('INIT');
%      Excel('TRANSFERT',output);
%ORDER BY dbo.QCWAXAnalysis.QCWAXAnalysis_id'