function Generate_manualthreshold_report()
    global PowerPointReport Database Info  PathName

CreateReport('NEW');
  
  
      %  study=cell2mat(data.study(get(PowerPointReport.Study,'value')));
        
        %compute the which freeform analysis have been done between the dates
%         content=mxDatabase(Database.Name,['select manualthreshanalysis_id,threshold_analysis_date,acquisition.acquisition_id from manualthresholdanalysis,commonanalysis,acquisition where manualthresholdanalysis.commonanalysis_id=commonanalysis.commonanalysis_id and commonanalysis.acquisition_id=acquisition.acquisition_id and study_id=''',study,''' order by patient_id,visit_id,view_id']);
%         
%         date1str=get(PowerPointReport.date1,'string');        
%         date2str=get(PowerPointReport.date2,'string');
%         
%         if strcmpi(date1str,'0')
%             date1str='1-janv-0';
%         end
%         if strcmpi(date2str,'today')
%             date2str=date;
%         end
%         
%         date1num=datenum(date1str);
%         date2num=datenum(date2str);        
%         datelist=datenum(cell2mat(content(:,2)));
%         ValidDate=(datelist>=date1num).*(datelist<=date2num);
        [FileName,PathName] = uigetfile('\\ming\aaSTUDIES\Breast Studies\CPMC\Analysis Code\SAS\RO1 CPMC Data analysis\testing_BF.txt','Select the manual threshold analysis list txt-file ');   
        %manualthresh_id_filename = [PathName,FileName];     %'\'
        %FileName_list =  FileName;
        manualthresh_id_filename = [PathName,'\',FileName];
        manualthreshIDList = textread(manualthresh_id_filename,'%u');
        %manualthreshIDList=cell2mat(content(:,1));
        path = pwd;
        fid = fopen([path,'\no_reports.txt'],'w+'); 
        PathName = path;
        for index=1:size(manualthreshIDList,1)
            try
                %if ValidDate(index)
                    %retrieve acqusition
                    Info.ManualThresholdAnalysisKey=manualthreshIDList(index);
                    
                    Database.Step=2;
                    RetrieveInDatabase('MANUALTHRESHOLDANALYSIS');
                   
                    CreateReport('ADDCOMMON');
                    CreateReport('QACODES');
                    PowerPoint('addtext','text','');

                    %Contour results
                    SQLstatement=['select ManualThresholdAnalysis.thresholdresult,ManualThresholdAnalysis.threshold_analysis_date,ManualThresholdAnalysis.operator_id from manualthresholdanalysis, operator'];
                    SQLstatement=[SQLstatement,' where manualthresholdanalysis.operator_id=operator.operator_id and manualthreshanalysis_id=',num2str(Info.ManualThresholdAnalysisKey)];
                    % SQLstatement=['SELECT     dbo.ManualThresholdAnalysis.thresholdresult, dbo.ManualThresholdAnalysis.threshold_analysis_date, dbo.ManualThresholdAnalysis.operator_id FROM dbo.ManualThresholdAnalysis INNER JOIN   dbo.operator ON dbo.ManualThresholdAnalysis.operator_id = dbo.operator.operator_id WHERE     (dbo.ManualThresholdAnalysis.ManualThreshAnalysis_id =',num2str(Info.ManualThresholdAnalysisKey)];
                    a=mxDatabase(Database.Name,SQLstatement);
                    PowerPointReport.ContourResults=a;
                    PowerPoint('addtext','text','Manual Threshold Analysis Results','fontsize',1.2,'underlined',true);
                    PowerPoint('addtext','text',[cell2mat(PowerPointReport.ContourResults(1,2)),': ',num2str(cell2mat(PowerPointReport.ContourResults(1,1))),' %' ]); %(',strcat(cell2mat(PowerPointReport.ContourResults(1,3)),''),')'
                %end
            catch
                fprintf(fid,'%u \n',Info.ManualThresholdAnalysisKey);

                Info.ManualThresholdAnalysisKey
            end
        end
        fclose(fid);
        delete(PowerPointReport.figure);