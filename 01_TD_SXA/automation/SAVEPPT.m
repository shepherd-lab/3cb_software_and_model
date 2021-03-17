%power point report
%author Lionel HERVE
%creation date 4-15-2004
%print all the analysis and not just the last one

function saveppt(RequestedAction)
global data PowerPointReport Database Info ctrl figuretodraw PathName
switch RequestedAction
    case 'SXADXA'
        CreateReport('NEW');
        study=cell2mat(data.study(get(PowerPointReport.Study,'value')));
        
        Message('The date is not taking into account in this mode');
        content=mxDatabase(Database.Name,['select acquisition_id from acquisition where study_id=''',study,''' order by patient_id, view_id, acquisition_id']);
        AcquisitionList=cell2mat(content(:,1));
          
        for index=1:size(AcquisitionList,1)
               %retrieve acqusition
                SXAAnalysisKeyList=mxDatabase(Database.Name,['select * from sxaanalysis,commonanalysis where acquisition_id=''',num2str(AcquisitionList(index)),''' and sxaanalysis.commonanalysis_id=commonanalysis.commonanalysis_id order by sxaanalysis_id']);
                if size(SXAAnalysisKeyList,1)>0
                    Info.SXAAnalysisKey=SXAAnalysisKeyList{end,1};
                    Database.Step=2;    
                    RetrieveInDatabase('SXAANALYSIS');     
                else
                    Database.Step=2;    
                    Info.AcquisitionKey=AcquisitionList(index);
                    RetrieveInDatabase('ACQUISITION');     
                end
                
                CreateReport('ADDCOMMON');
                PowerPoint('addtext','text',['mAs: ',num2str(Info.mAs)]);
                PowerPoint('addtext','text',['kVs: ',num2str(Info.kVp)]);
                CreateReport('QACODES');
        
                PowerPoint('addtext','text','');
                %Contour results
                PowerPoint('addtext','text','Contour Results','fontsize',1.2,'underlined',true);                
                FreeFormAnalysisKeyList=mxDatabase(Database.Name,['select * from freeformanalysis,commonanalysis where acquisition_id=''',num2str(AcquisitionList(index)),''' and freeformanalysis.commonanalysis_id=commonanalysis.commonanalysis_id order by freeformanalysis_id']);
                for index2=1:size(FreeFormAnalysisKeyList,1)
                    SQLstatement=['select freeform_result,freeform_analysis_date,last_name from freeformanalysis,operator'];
                    SQLstatement=[SQLstatement,' where freeformanalysis.operator_id=operator.operator_id and freeformanalysis_id=',num2str(FreeFormAnalysisKeyList{index2})];
                    a=mxDatabase(Database.Name,SQLstatement);ContourResults=a;
                    PowerPoint('addtext','text',[cell2mat(ContourResults(1,2)),': ',num2str(cell2mat(ContourResults(1,1))),'  (',strcat(cell2mat(ContourResults(1,3)),''),')']);
                end
                
                PowerPoint('addtext','text','');
                %SXADXA results
                PowerPoint('addtext','text','SXADXA Results','fontsize',1.2,'underlined',true);                
                SXADXA=mxDatabase(Database.Name,['select SXAresult,sxa_analysis_date,last_name,sxaanalysis.version from sxaanalysis,commonanalysis,operator where acquisition_id=''',num2str(AcquisitionList(index)),''' and sxaanalysis.commonanalysis_id=commonanalysis.commonanalysis_id and sxaanalysis.operator_id=operator.operator_id and flatfieldcorrection_id<>1 order by sxaanalysis_id']);
                for index2=1:size(SXADXA,1)
                    PowerPoint('addtext','text',[SXADXA{index2,2},': ',num2str(cell2mat(SXADXA(index2,1))),'  (',deblank(cell2mat(SXADXA(index2,3))),')  ,',SXADXA{index2,4}]);
                end
                
                PowerPoint('addtext','text','');
                
                CreateReport('ADDREPORTTEXT');

         end
        
        delete(PowerPointReport.figure);
    case 'SXADXAJESSIE'
        CreateReport('NEW');
        study=cell2mat(data.study(get(PowerPointReport.Study,'value')));
        
        Message('The date is not taking into account in this mode');
        content=mxDatabase(Database.Name,['select acquisition_id from acquisition where study_id=''',study,''' order by patient_id, view_id']);
        AcquisitionList=cell2mat(content(:,1));
          
        for index=1:size(AcquisitionList,1)
               %retrieve acqusition
                FreeFormAnalysisKeyList=mxDatabase(Database.Name,['select * from freeformanalysis,commonanalysis where acquisition_id=''',num2str(AcquisitionList(index)),''' and freeformanalysis.commonanalysis_id=commonanalysis.commonanalysis_id order by freeformanalysis_id']);
                if size(FreeFormAnalysisKeyList,1)>0
                    Info.FreeFormAnalysisKey=FreeFormAnalysisKeyList{end,1};
                    Database.Step=2;    
                    RetrieveInDatabase('FREEFORMANALYSIS');     
                else
                    Database.Step=2;    
                    Info.AcquisitionKey=AcquisitionList(index);
                    RetrieveInDatabase('ACQUISITION');     
                end
                
                CreateReport('ADDCOMMON');
                CreateReport('QACODES');
        
                PowerPoint('addtext','text','');
                %Contour results
                PowerPoint('addtext','text','Contour Results','fontsize',1.2,'underlined',true);                
                for index2=1:size(FreeFormAnalysisKeyList,1)
                    SQLstatement=['select freeform_result,freeform_analysis_date,last_name from freeformanalysis,operator'];
                    SQLstatement=[SQLstatement,' where freeformanalysis.operator_id=operator.operator_id and freeformanalysis_id=',num2str(FreeFormAnalysisKeyList{index2})];
                    a=mxDatabase(Database.Name,SQLstatement);ContourResults=a;
                    PowerPoint('addtext','text',[cell2mat(ContourResults(1,2)),': ',num2str(cell2mat(ContourResults(1,1))),'  (',strcat(cell2mat(ContourResults(1,3)),''),')']);
                end
                
                PowerPoint('addtext','text','');
                %SXADXA results
                PowerPoint('addtext','text','SXADXA Results','fontsize',1.2,'underlined',true);                
                SXADXA=mxDatabase(Database.Name,['select SXAresult,sxa_analysis_date,last_name,sxaanalysis.version from sxaanalysis,commonanalysis,operator where acquisition_id=''',num2str(AcquisitionList(index)),''' and sxaanalysis.commonanalysis_id=commonanalysis.commonanalysis_id and sxaanalysis.operator_id=operator.operator_id and flatfieldcorrection_id<>1 order by sxaanalysis_id']);
                for index2=1:size(SXADXA,1)
                    PowerPoint('addtext','text',[SXADXA{index2,2},': ',num2str(cell2mat(SXADXA(index2,1))),'  (',deblank(cell2mat(SXADXA(index2,3))),')  ,',SXADXA{index2,4}]);
                end
                
                PowerPoint('addtext','text','');
                
                CreateReport('ADDREPORTTEXT');

         end
        
        delete(PowerPointReport.figure);
        
    case 'CONTOUR'
        CreateReport('NEW');
        study=cell2mat(data.study(get(PowerPointReport.Study,'value')));
        
        %compute the which freeform analysis have been done between the dates
        content=mxDatabase(Database.Name,['select freeformanalysis_id,freeform_analysis_date,acquisition.acquisition_id from freeformanalysis,commonanalysis,acquisition where freeformanalysis.commonanalysis_id=commonanalysis.commonanalysis_id and commonanalysis.acquisition_id=acquisition.acquisition_id and study_id=''',study,''' order by patient_id,visit_id,view_id']);
        
        date1str=get(PowerPointReport.date1,'string');        
        date2str=get(PowerPointReport.date2,'string');
        
        if strcmpi(date1str,'0')
            date1str='1-janv-0';
        end
        if strcmpi(date2str,'today')
            date2str=date;
        end
        
        date1num=datenum(date1str);
        date2num=datenum(date2str);        
        datelist=datenum(cell2mat(content(:,2)));
        ValidDate=(datelist>=date1num).*(datelist<=date2num);

        AcquisitionList=cell2mat(content(:,1));
          
        for index=1:size(AcquisitionList,1)
            if ValidDate(index)
                %retrieve acqusition
                Info.FreeFormAnalysisKey=AcquisitionList(index);
                Database.Step=2;    
                RetrieveInDatabase('FREEFORMANALYSIS');     
                
                CreateReport('ADDCOMMON');
                CreateReport('QACODES');
                PowerPoint('addtext','text','');
                
                %Contour results
                SQLstatement=['select freeform_result,freeform_analysis_date,last_name from freeformanalysis,operator'];
                SQLstatement=[SQLstatement,' where freeformanalysis.operator_id=operator.operator_id and freeformanalysis_id=',num2str(Info.FreeFormAnalysisKey)];
                a=mxDatabase(Database.Name,SQLstatement);PowerPointReport.ContourResults=a;
                PowerPoint('addtext','text','Contour Results','fontsize',1.2,'underlined',true);
                PowerPoint('addtext','text',[cell2mat(PowerPointReport.ContourResults(1,2)),': ',num2str(cell2mat(PowerPointReport.ContourResults(1,1))),'  (',strcat(cell2mat(PowerPointReport.ContourResults(1,3)),''),')']);
            end
        end
        
        delete(PowerPointReport.figure);
    
    case 'MANUALTHRESHOLD'
        CreateReport('NEW');
        study=cell2mat(data.study(get(PowerPointReport.Study,'value')));
        
        %compute the which freeform analysis have been done between the dates
        content=mxDatabase(Database.Name,['select manualthreshanalysis_id,threshold_analysis_date,acquisition.acquisition_id from manualthresholdanalysis,commonanalysis,acquisition where manualthresholdanalysis.commonanalysis_id=commonanalysis.commonanalysis_id and commonanalysis.acquisition_id=acquisition.acquisition_id and study_id=''',study,''' order by patient_id,visit_id,view_id']);
        
        date1str=get(PowerPointReport.date1,'string');        
        date2str=get(PowerPointReport.date2,'string');
        
        if strcmpi(date1str,'0')
            date1str='1-janv-0';
        end
        if strcmpi(date2str,'today')
            date2str=date;
        end
        
        date1num=datenum(date1str);
        date2num=datenum(date2str);        
        datelist=datenum(cell2mat(content(:,2)));
        ValidDate=(datelist>=date1num).*(datelist<=date2num);

        AcquisitionList=cell2mat(content(:,1));
        path = pwd;
        fid = fopen([path,'\unprocessed_films.txt'],'w+'); 
        PathName = path;
        for index=1:size(AcquisitionList,1)
            try
                if ValidDate(index)
                    %retrieve acqusition
                    Info.ManualThresholdAnalysisKey=AcquisitionList(index);
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
                end
            catch
                fprintf(fid,'%u \n',Info.ManualThresholdAnalysisKey);

                Info.ManualThresholdAnalysisKey
            end
        end
        fclose(fid);
        delete(PowerPointReport.figure);
    otherwise
        PowerPointReport.figure=figure;
        
        background=[0.1 0.1 0.4];
        foreground=[1 1 1];
        
        set(PowerPointReport.figure,'units','normalized','position',[0.0 0.05 0.3 0.3],'NumberTitle','off','name','Report tool','color',background);
        set(PowerPointReport.figure,'MenuBar','None');
        
        factor=2;
        buttony=0.85;separation=0.07*factor;heightbox=0.035*factor;
        buttonminx=0.45;buttonsizex=0.50;
        buttonminx2=0.05;buttonsizex2=0.40;
        heightbutton=0.07*factor;
        
        uicontrol('style','text','string','Report tools','units','normalized','position',[0,1-heightbox,1,heightbox],'background',[1 0.6 0]);
        
        %study
        buttony=buttony-heightbox;
        uicontrol('style','text','string','Study ','units','normalized','position',[buttonminx2,buttony,buttonsizex2,heightbox],'backgroundcolor',background,'HorizontalAlignment','right','foreground',foreground);
        PowerPointReport.Study=uicontrol('style','popupmenu','string',data.study,'units','normalized','position',[buttonminx,buttony,buttonsizex,heightbox],'HorizontalAlignment','left','Max',1,'Min',1,'value',1,'BackgroundColor','white');
        
        %beginning date
        buttony=buttony-separation;
        uicontrol('style','text','string','From (date 0=Jesus)','units','normalized','position',[buttonminx2,buttony,buttonsizex2,heightbox],'HorizontalAlignment','right','background',background,'foreground',foreground);
        PowerPointReport.date1=uicontrol('style','edit','string','0','units','normalized','position',[buttonminx,buttony,buttonsizex,heightbox],'HorizontalAlignment','left','background','white');
        
        %beginning date
        buttony=buttony-separation;
        uicontrol('style','text','string','To (date ''Today''0=today)','units','normalized','position',[buttonminx2,buttony,buttonsizex2,heightbox],'HorizontalAlignment','right','background',background,'foreground',foreground);
        PowerPointReport.date2=uicontrol('style','edit','string','TODAY','units','normalized','position',[buttonminx,buttony,buttonsizex,heightbox],'HorizontalAlignment','left','background','white');
        
        %Launch button
        buttony=buttony-2*heightbox;
        uicontrol('style','pushbutton','string','Launch','units','normalized','position',[buttonminx,buttony,buttonsizex2,heightbox],'CallBack',['SAVEPPT(''',RequestedAction(1:end-1),''')']);        
end