function sxa_acq_extraction_May()
    Database.Name = 'mammo_CPMC';
%     [FileName,PathName] = uigetfile('\\ming\aadata\aaSTUDIES\Breast Studies\TEST\sxabo_list_mammo.txt','Select the acquisition list txt-file ');   acqs_filename = [PathName,FileName];     %'\'
%     FileName_list =  FileName;
%     acqs_filename = [PathName,'\',FileName];
 %   ACQIDList = textread(acqs_filename,'%u');
    count = 0;
    ACQID=105019;
    
    %
        
       % SQLStatement = ['SELECT * FROM dbo.qcwaxAnalysis INNER JOIN dbo.commonanalysis ON dbo.qcwaxAnalysis.commonanalysis_id = dbo.commonanalysis.commonanalysis_id INNER JOIN dbo.acquisition ON dbo.commonanalysis.acquisition_id = dbo.acquisition.acquisition_id WHERE     dbo.acquisition.acquisition_id =',num2str(ACQIDList(index)),'order by dbo.qcwaxAnalysis.qc_analysis_date'];
       %SQLStatement = 'SELECT dbo.acquisition.*, dbo.QCWAXAnalysis.*, dbo.QCwaxSXAPhantomInfo.* FROM dbo.QCwaxSXAPhantomInfo INNER JOIN  dbo.QCWAXAnalysis ON dbo.QCwaxSXAPhantomInfo.QCWAXAnalysis_id = dbo.QCWAXAnalysis.QCWAXAnalysis_id  INNER JOIN  dbo.commonanalysis ON   dbo.QCWAXAnalysis.commonanalysis_id = dbo.commonanalysis.commonanalysis_id INNER        JOIN       dbo.acquisition ON       dbo.commonanalysis.acquisition_id = dbo.acquisition.acquisition_id WHERE dbo.QCWAXAnalysis.QC_analysis_date LIKE ''-Dec-2011'' AND  dbo.acquisition.machine_id = 39';
      % SQLStatement ='SELECT dbo.acquisition.*, dbo.QCWAXAnalysis.*, dbo.QCwaxSXAPhantomInfo.* FROM dbo.QCwaxSXAPhantomInfo INNER JOIN dbo.QCWAXAnalysis ON dbo.QCwaxSXAPhantomInfo.QCWAXAnalysis_id = dbo.QCWAXAnalysis.QCWAXAnalysis_id INNER JOIN dbo.commonanalysis ON dbo.QCWAXAnalysis.commonanalysis_id = dbo.commonanalysis.commonanalysis_id INNER JOIN dbo.acquisition ON dbo.commonanalysis.acquisition_id = dbo.acquisition.acquisition_id WHERE (dbo.QCWAXAnalysis.QC_analysis_date LIKE ''%-Dec-2011%'') AND (dbo.acquisition.machine_id = 39)';
     % SQLStatement =['SELECT dbo.acquisition.*, dbo.QCDSP7Analysis.*, dbo.QCSXAPhantomInfo.* FROM dbo.QCSXAPhantomInfo INNER JOIN dbo.QCDSP7Analysis ON dbo.QCSXAPhantomInfo.QCDSP7Analysis_id = dbo.QCDSP7Analysis.QCDSP7Analysis_id INNER JOIN dbo.commonanalysis ON dbo.QCDSP7Analysis.commonanalysis_id = dbo.commonanalysis.commonanalysis_id INNER JOIN dbo.acquisition ON dbo.commonanalysis.acquisition_id = dbo.acquisition.acquisition_id WHERE (dbo.QCDSP7Analysis.qc_analysis_date LIKE ''%23-Jul-2012%'') and dbo.acquisition.acquisition_id =',num2str(ACQIDList(index)),'order by dbo.QCDSP7Analysis.QC_analysis_date'];
      
%       SQLstatement = ['SELECT TOP 1 * FROM kTableGen3',...
%                ' WHERE (paddle_size lIKE ''', padSize, '''',')',...
%                ' AND (machine_id = ', num2str(machID), ') ',...
%                ' AND (version LIKE ''%Version7.1%'') AND (date_acquisition =',...
%                ' (SELECT MAX(date_acquisition)  FROM kTableGen3 ',...
%                ' WHERE (paddle_size lIKE ''', padSize, '''',')',...
%                ' AND (machine_id = ', num2str(machID), ') ',...
%                ' AND (version LIKE ''%Version7.1%'') ',...
%                ' AND (CONVERT(CHAR(8), date_acquisition, 112) <= CONVERT(CHAR(8),''',imgAcqDate,''', 112)))) ',...
%                ' ORDER BY commonanalysis_id DESC'];       
% %       
% % %       SQLStatement =['SELECT dbo.acquisition.*, dbo.sxastepanalysis.*, dbo.OtherSXAStepInfo.*',... 
% % %                     ' FROM dbo.OtherSXAStepInfo INNER JOIN dbo.sxastepanalysis ON dbo.OtherSXAStepInfo.sxastepanalysis_id = dbo.sxastepanalysis.SXAStepAnalysis_id',...
% % %                     ' INNER JOIN dbo.commonanalysis ON dbo.sxastepanalysis.commonanalysis_id = dbo.commonanalysis.commonanalysis_id',...
% % %                     ' INNER JOIN dbo.acquisition ON dbo.commonanalysis.acquisition_id = dbo.acquisition.acquisition_id',...
% % %                     ' WHERE (dbo.sxastepanalysis.Run_number = 7) AND dbo.acquisition.acquisition_id =' ,num2str(ACQID),...
% % %                     '  ORDER BY dbo.sxastepanalysis.sxa_analysis_date'];
    SQLStatement =['SELECT dbo.acquisition.*, dbo.QCDSP7Analysis.*, dbo.QCSXAPhantomInfo.* FROM dbo.QCSXAPhantomInfo INNER JOIN dbo.QCDSP7Analysis ON dbo.QCSXAPhantomInfo.QCDSP7Analysis_id = dbo.QCDSP7Analysis.QCDSP7Analysis_id INNER JOIN dbo.commonanalysis ON dbo.QCDSP7Analysis.commonanalysis_id = dbo.commonanalysis.commonanalysis_id INNER JOIN dbo.acquisition ON dbo.commonanalysis.acquisition_id = dbo.acquisition.acquisition_id WHERE (dbo.QCDSP7Analysis.qc_analysis_date LIKE ''%19-Aug-2012%'') and (dbo.QCDSP7Analysis.comId = 0)  and dbo.acquisition.acquisition_id =',num2str(20743548),' order by dbo.QCDSP7Analysis.QCDSP7Analysis_id'];

         %(dbo.sxastepanalysis.sxa_analysis_date LIKE ''%30-Jul-2012%'') or
         %(dbo.sxastepanalysis.sxa_analysis_date LIKE ''%31-Jul-2012%'')
% %  SQLStatement =['SELECT dbo.acquisition.*, dbo.sxastepanalysis.*, dbo.OtherSXAStepInfo.*',... 
% %                     ' FROM dbo.OtherSXAStepInfo INNER JOIN dbo.sxastepanalysis ON dbo.OtherSXAStepInfo.sxastepanalysis_id = dbo.sxastepanalysis.SXAStepAnalysis_id',...
% %                     ' INNER JOIN dbo.commonanalysis ON dbo.sxastepanalysis.commonanalysis_id = dbo.commonanalysis.commonanalysis_id',...
% %                     ' INNER JOIN dbo.acquisition ON dbo.commonanalysis.acquisition_id = dbo.acquisition.acquisition_id',...
% %                     ' WHERE (dbo.sxastepanalysis.sxa_analysis_date LIKE ''%May-2012%'') AND dbo.acquisition.acquisition_id =1000083301',...
% %                     '  ORDER BY dbo.sxastepanalysis.sxa_analysis_date'];
                
                [a1,names1]=mxDatabase(Database.Name,SQLStatement);
        if isempty(a1)
           output = [names1(end,:)];
       else
          output = [names1(end,:);a1(end,:)];
       end
        
        acq =1;
        a = 1;
    %end
     
    %
  
       % SQLStatement = ['SELECT * FROM dbo.qcwaxAnalysis INNER JOIN dbo.commonanalysis ON dbo.qcwaxAnalysis.commonanalysis_id = dbo.commonanalysis.commonanalysis_id INNER JOIN dbo.acquisition ON dbo.commonanalysis.acquisition_id = dbo.acquisition.acquisition_id WHERE     dbo.acquisition.acquisition_id =',num2str(ACQIDList(index)),'order by dbo.qcwaxanalysis.qc_analysis_date'];
      % SQLStatement =['SELECT dbo.acquisition.*, dbo.QCWAXAnalysis.*, dbo.QCwaxSXAPhantomInfo.* FROM dbo.QCwaxSXAPhantomInfo INNER JOIN dbo.QCWAXAnalysis ON dbo.QCwaxSXAPhantomInfo.QCWAXAnalysis_id = dbo.QCWAXAnalysis.QCWAXAnalysis_id INNER JOIN dbo.commonanalysis ON dbo.QCWAXAnalysis.commonanalysis_id = dbo.commonanalysis.commonanalysis_id INNER JOIN dbo.acquisition ON dbo.commonanalysis.acquisition_id = dbo.acquisition.acquisition_id WHERE (dbo.QCWAXAnalysis.QC_analysis_date LIKE ''%MAy-2012%'') AND dbo.acquisition.acquisition_id =',num2str(ACQIDList(index)),'order by dbo.qcwaxAnalysis.qc_analysis_date'];
% %        SQLStatement =['SELECT dbo.acquisition.*, dbo.sxastepanalysis.*, dbo.OtherSXAStepInfo.*',... 
% %                     ' FROM dbo.OtherSXAStepInfo INNER JOIN dbo.sxastepanalysis ON dbo.OtherSXAStepInfo.sxastepanalysis_id = dbo.sxastepanalysis.SXAStepAnalysis_id',...
% %                     ' INNER JOIN dbo.commonanalysis ON dbo.sxastepanalysis.commonanalysis_id = dbo.commonanalysis.commonanalysis_id',...
% %                     ' INNER JOIN dbo.acquisition ON dbo.commonanalysis.acquisition_id = dbo.acquisition.acquisition_id',...
% %                     ' WHERE ((dbo.sxastepanalysis.sxa_analysis_date LIKE ''%30-Jul-2012%'') or (dbo.sxastepanalysis.sxa_analysis_date LIKE ''%31-Jul-2012%'')) AND dbo.acquisition.acquisition_id =' ,num2str(ACQIDList(index)),...
% %                     '  ORDER BY dbo.sxastepanalysis.sxa_analysis_date'];
  

      % SQLStatement =['SELECT dbo.acquisition.*, dbo.QCDSP7Analysis.*, dbo.QCSXAPhantomInfo.* FROM dbo.QCSXAPhantomInfo INNER JOIN dbo.QCDSP7Analysis ON dbo.QCSXAPhantomInfo.QCDSP7Analysis_id = dbo.QCDSP7Analysis.QCDSP7Analysis_id INNER JOIN dbo.commonanalysis ON dbo.QCDSP7Analysis.commonanalysis_id = dbo.commonanalysis.commonanalysis_id INNER JOIN dbo.acquisition ON dbo.commonanalysis.acquisition_id = dbo.acquisition.acquisition_id WHERE (dbo.QCDSP7Analysis.qc_analysis_date LIKE ''%23-Jul-2012%'') and dbo.acquisition.acquisition_id =',num2str(ACQIDList(index)),'order by dbo.QCDSP7Analysis.QC_analysis_date'];
% % %          SQLStatement =['SELECT dbo.acquisition.*, dbo.sxastepanalysis.*, dbo.OtherSXAStepInfo.*',... 
% % %                     ' FROM dbo.OtherSXAStepInfo INNER JOIN dbo.sxastepanalysis ON dbo.OtherSXAStepInfo.sxastepanalysis_id = dbo.sxastepanalysis.SXAStepAnalysis_id',...
% % %                     ' INNER JOIN dbo.commonanalysis ON dbo.sxastepanalysis.commonanalysis_id = dbo.commonanalysis.commonanalysis_id',...
% % %                     ' INNER JOIN dbo.acquisition ON dbo.commonanalysis.acquisition_id = dbo.acquisition.acquisition_id',...
% % %                     ' WHERE (dbo.sxastepanalysis.Run_number like 7)',...
% % %                     '  ORDER BY dbo.sxastepanalysis.sxastepanalysis_id'];   
% %       
       SQLStatement =['SELECT dbo.acquisition.*, dbo.QCDSP7Analysis.*, dbo.QCSXAPhantomInfo.* FROM dbo.QCSXAPhantomInfo INNER JOIN dbo.QCDSP7Analysis ON dbo.QCSXAPhantomInfo.QCDSP7Analysis_id = dbo.QCDSP7Analysis.QCDSP7Analysis_id INNER JOIN dbo.commonanalysis ON dbo.QCDSP7Analysis.commonanalysis_id = dbo.commonanalysis.commonanalysis_id INNER JOIN dbo.acquisition ON dbo.commonanalysis.acquisition_id = dbo.acquisition.acquisition_id WHERE ((dbo.QCDSP7Analysis.qc_analysis_date LIKE ''%19-Aug-2012%'') or (dbo.QCDSP7Analysis.qc_analysis_date LIKE ''%20-Aug-2012%'')) and  (dbo.QCDSP7Analysis.comId = 0)  order by dbo.QCDSP7Analysis.QCDSP7Analysis_id'];

       %(dbo.sxastepanalysis.sxa_analysis_date LIKE ''%30-Jul-2012%'') or (dbo.sxastepanalysis.sxa_analysis_date LIKE ''%31-Jul-2012%'')
     try
       a1=mxDatabase(Database.Name,SQLStatement);
     catch
         try
              a1=mxDatabase(Database.Name,SQLStatement);
         catch
              a1=mxDatabase(Database.Name,SQLStatement);
         end
     end
       
% % %         if isempty(a1)
% % %             acq = [acq;ACQIDList(index)];
% % %         else
% % %             output = [output;a1(end,:)];
% % %              acq_1 = [acq;ACQIDList(index)];
% % %             count = count +1
% % %         end
        
    output = [output;a1];
%     file_name = 'U:\smalkov\GEN3 phantom test\WW_test\Run_excels\Run4_3200.xls';
%     [status,msginfo] = xlswrite(file_name, output); 
     Excel('INIT');
     Excel('TRANSFERT',output);
      a = 1;
      
     [FileName,PathName] = uigetfile('\\ming\aadata\aaSTUDIES\Breast Studies\TEST\sxabo_list_mammo.txt','Select the acquisition list txt-file ');  
     acqs_filename = [PathName,FileName];     %'\'
     %acqs_filename = [PathName,'\',FileName];
    ACQIDList = textread(acqs_filename,'%u');
    processed = cell2mat(a1(:,1));
    notprocessed = setdiff(ACQIDList,processed);
    len = length(notprocessed);
    list_num = floor(notprocessed/2000)
    %for i=1:list_num
        
    
    
    
    
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