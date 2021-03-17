%display information or acquisition Free Form results (which is a combination of tables)
%author Lionel HERVE
%creation date 6-03-2003
% 1-27-03 toggle button management
% march-04 use of mex file to accelerate since tere are more and more scans
% in the database (SortByDate)
% use the function SortByDate2 to improve speed (this one suppose
% everything is order by acquisition_ids)
function [content,title]=funcPopulateResume(Database,listboxhandle,AskedResume,Order);

global content2
if strcmp(AskedResume,'StudySelect')
    content=mxDatabase(Database.Name,'select distinct study_id from acquisition');
elseif strcmpi(AskedResume,'FileOnInternalDrive')
    [content,names]=mxDatabase(Database.Name,'select distinct sfmrbarcode,r2barcode,filedate,status from fileoninternaldrive order by r2barcode');
elseif strcmp(AskedResume,'retrieveAcq')
    SQLstatement='select acquisition.acquisition_ID,study_ID,patient_ID,date_acquisition,film_identifier,view_description,location';
    SQLstatement=[SQLstatement,' from acquisition,mammo_view,reposition'];
    SQLstatement=[SQLstatement,' where reposition.acquisition_id=acquisition.acquisition_id and acquisition.view_id=mammo_view.mammoview_id'];
    SQLstatement=[SQLstatement,' order by acquisition.acquisition_id'];
    [content,names]=mxDatabase(Database.Name,SQLstatement);
    content(:,2)=UpperCell(content(:,2));  %uppercase for study_id
    [so1,so2]=size(content);  %original size of the table
    names(2)={'STUDY'};names(4)={'Date'};names(5)={'Identifier'};names(6)={'View'};
    
    %put the default value of the dates: 'Null'
    content(1:so1,so2+1:so2+5)=[mat2cell(char(ones(so1,1)*'Null'),ones(so1,1),4) mat2cell(char(ones(so1,1)*'Null'),ones(so1,1),4) mat2cell(char(ones(so1,1)*'Null'),ones(so1,1),4) mat2cell(char(ones(so1,1)*'Null'),ones(so1,1),4) mat2cell(char(ones(so1,1)*'Null'),ones(so1,1),4)];    
    %%%%%%%%%%%%%%%%%%%%%%%%
    %Add FreeForm last date
    %%%%%%%%%%%%%%%%%%%%%%%%
    SQLstatement='select acquisition_ID,freeform_analysis_date';
    SQLstatement=[SQLstatement,' from commonanalysis,freeformanalysis'];
    SQLstatement=[SQLstatement,' where freeformanalysis.commonanalysis_id=commonanalysis.commonanalysis_id'];
    SQLstatement=[SQLstatement,' order by acquisition_id,freeformanalysis_id'];
    content2=mxDatabase(Database.Name,SQLstatement);
    content=SortByDate2(content,content2,so2+1);
    names(so2+1)={'Contour'};
    %%%%%%%%%%%%%%%%%%%%% 
    %Add SXA Last Date
    %%%%%%%%%%%%%%%%%%%%%
    %retrieve skipped sxa analysis
    skippedList=mxDatabase(Database.Name,'select acquisitionID from skippedsxaanalysis order by acquisitionID');
    SQLstatement='select acquisition.acquisition_ID,sxa_analysis_date';
    SQLstatement=[SQLstatement,' from acquisition,commonanalysis,sxaanalysis'];
    SQLstatement=[SQLstatement,' where commonanalysis.acquisition_id=acquisition.acquisition_id and sxaanalysis.commonanalysis_id=commonanalysis.commonanalysis_id'];
    SQLstatement=[SQLstatement,' order by acquisition.acquisition_id'];
    content2=mxDatabase(Database.Name,SQLstatement);
    content=SortByDate2(content,content2,so2+2,skippedList);
    names(so2+2)={'sxa'};
    %%%%%%%%%%%%%%%%%%%%%%%% 
    %Add Threshold Last Date
    %%%%%%%%%%%%%%%%%%%%%%%%
    SQLstatement='select acquisition_ID,threshold_analysis_date';
    SQLstatement=[SQLstatement,' from commonanalysis,thresholdanalysis'];
    SQLstatement=[SQLstatement,' where thresholdanalysis.commonanalysis_id=commonanalysis.commonanalysis_id'];
    SQLstatement=[SQLstatement,' order by acquisition_id, thresholdanalysis_id'];
    content2=mxDatabase(Database.Name,SQLstatement);
    content=SortByDate2(content,content2,so2+3);
    names(so2+3)={'threshold'};
    %%%%%%%%%%%%%%%%%%%%%%%% 
    %Add BIRADS Last Date
    %%%%%%%%%%%%%%%%%%%%%%%%
    SQLstatement='select acquisition_ID,BIRADS_analysis_date';
    SQLstatement=[SQLstatement,' from BIRADSresults'];
    SQLstatement=[SQLstatement,' order by acquisition_id, birads_id'];
    content2=mxDatabase(Database.Name,SQLstatement);
    content=SortByDate2(content,content2,so2+4);
    names(so2+4)={'BIRADS'};
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    %Add structuralAnalysis Last Date
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    SQLstatement='select acquisition_ID,structuralanalysis.Analysis_date';
    SQLstatement=[SQLstatement,' from structuralanalysis,commonanalysis'];
    SQLstatement=[SQLstatement,' where structuralanalysis.commonanalysis_id=commonanalysis.commonanalysis_id'];
    content2=mxDatabase(Database.Name,SQLstatement);
    content=SortByDate2(content,content2,so2+5);
    names(so2+5)={'Structure'};
elseif strcmp(AskedResume,'Retrievefreeformanalysis')
    SQLstatement='select freeformanalysis_ID,study_ID,patient_ID,view_description,Date_acquisition,freeform_result,freeform_analysis_date,acquisition.acquisition_ID,operator.last_name,breast_area,contour_area';
    SQLstatement=[SQLstatement,' from acquisition,freeformanalysis,commonanalysis,operator,mammo_view'];
    SQLstatement=[SQLstatement,' where acquisition.acquisition_ID=commonanalysis.acquisition_ID and commonanalysis.commonanalysis_ID=freeformanalysis.commonanalysis_ID and freeformanalysis.operator_id=operator.operator_id and mammoview_id=view_id'];% and peripheral_analysis.common_analysis_id=commonanalysis.commonanalysis_id'];
    SQLstatement=[SQLstatement,' order by freeformanalysis_ID,study_ID,patient_ID,view_description'];    
    [content,names]=mxDatabase(Database.Name,SQLstatement);
    
elseif strcmp(AskedResume,'Threshold')
    SQLstatement='select study_ID,patient_ID,view_description,thresholdresult,threshold_analysis_date,acquisition.acquisition_ID,thresholdanalysis_ID,operator.last_name';
    SQLstatement=[SQLstatement,' from acquisition,thresholdanalysis,commonanalysis,operator,mammo_view'];
    SQLstatement=[SQLstatement,' where acquisition.acquisition_ID=commonanalysis.acquisition_ID and commonanalysis.commonanalysis_ID=thresholdanalysis.commonanalysis_ID and thresholdanalysis.operator_id=operator.operator_id and mammoview_id=view_id'];
    SQLstatement=[SQLstatement,' order by study_ID,patient_ID,view_description'];    
    [content,names]=mxDatabase(Database.Name,SQLstatement);
elseif strcmp(AskedResume,'SXA')
    SQLstatement='select *';
    SQLstatement=[SQLstatement,' from acquisition,SXAanalysis,commonanalysis,mammo_view, othersxainfo'];
    SQLstatement=[SQLstatement,' where othersxainfo.SXAanalysis_id=SXAanalysis.SXAanalysis_id and acquisition.acquisition_ID=commonanalysis.acquisition_ID and commonanalysis.commonanalysis_ID=SXAanalysis.commonanalysis_ID and mammoview_id=view_id'];
    SQLstatement=[SQLstatement,' order by acquisition.acquisition_id'];    
    [content,names]=mxDatabase(Database.Name,SQLstatement);
    %Add qa codes
    [content,names]=addQAcodes(content,names,1);
    
    
elseif strcmp(AskedResume,'RetrieveCommonAnalysis')
    SQLstatement='select commonanalysis.commonanalysis_ID,study_ID,patient_ID,view_description';%,operator.last_name';
    SQLstatement=[SQLstatement,' from acquisition,commonanalysis,mammo_view'];%,operator'];
    SQLstatement=[SQLstatement,' where acquisition.acquisition_ID=commonanalysis.acquisition_ID and mammoview_id=view_id'];% and commonanalysis.operator_id=operator.operator_id'];
    SQLstatement=[SQLstatement,' order by study_ID,patient_ID,view_description'];    
    [content,names]=mxDatabase(Database.Name,SQLstatement);
elseif strcmp(AskedResume,'RetrieveSXAanalysis')
    SQLstatement='select *';
    SQLstatement=[SQLstatement,' from sxaanalysis'];
    [content,names]=mxDatabase(Database.Name,SQLstatement);
elseif strcmp(AskedResume,'RetrieveSXAStepanalysis')
    SQLstatement='select *';
    SQLstatement=[SQLstatement,' from sxastepanalysis'];
    [content,names]=mxDatabase(Database.Name,SQLstatement);
elseif strcmp(AskedResume,'RetrieveDXAanalysis')
    SQLstatement='select *';
    SQLstatement=[SQLstatement,' from dxaanalysis'];
    [content,names]=mxDatabase(Database.Name,SQLstatement);
elseif strcmp(AskedResume,'RetrieveThresholdanalysis')
    SQLstatement='select *';
    SQLstatement=[SQLstatement,' from thresholdanalysis'];
    [content,names]=mxDatabase(Database.Name,SQLstatement);
elseif strcmp(AskedResume,'BIRADSresults')
    SQLstatement='select BIRADS_id,acquisition.acquisition_id,study_id,patient_id,view_description,BIRADS_analysis_date,biradsscore_id,description';
    SQLstatement=[SQLstatement,' from acquisition,BIRADSdescription,BIRADSresults,mammo_view where biradsdescription_id=biradsscore_id and acquisition.acquisition_id=BIRADSresults.acquisition_id and mammoview_id=view_id'];
    [content,names]=mxDatabase(Database.Name,SQLstatement);  
elseif strcmp(AskedResume,'GENERALresults')    
    %%%%%%%%%%%%%%%%%%%%%%%%%
    'begin by contour results'
    %%%%%%%%%%%%%%%%%%%%%%%%%
    SQLstatement='select ''CONTOUR   '',freeformanalysis_ID,acquisition.acquisition_ID,study_ID,patient_ID,view_description,location,resolution,mAs,kVp,technique_description,Date_acquisition,freeform_result,freeform_analysis_date,operator.last_name,breast_area,contour_area,correctionname,0,0,''Manual'',0,0';
    SQLstatement=[SQLstatement,' from machine,technique,acquisition,freeformanalysis,commonanalysis,operator,mammo_view,correction'];
    SQLstatement=[SQLstatement,' where freeformanalysis.commonanalysis_ID=commonanalysis.commonanalysis_ID and commonanalysis.acquisition_ID=acquisition.acquisition_ID and acquisition.machine_id=machine.machine_id and freeformanalysis.operator_id=operator.operator_id and mammoview_id=view_id and technique.technique_id=acquisition.technique_id and correction.flatfieldcorrection_id=1'];
    SQLstatement=[SQLstatement,' order by study_ID,patient_ID,view_description'];    
    [content,names]=mxDatabase(Database.Name,SQLstatement);
    
    %change some column names
    names(1)={'AnalysisType'};
    names(2)={'AnalysisID'};
    names(11)={'Technique'};    
    names(13)={'Results'};
    names(14)={'Analysis_date'};        
    names(15)={'Reader'};
    names(18)={'Correction'};    
    names(19)={'PhantomFatArea'};
    names(20)={'PhantomLeanArea'};    
    names(21)={'Analysis Mode'};    
    names(22)={'FatWedge'};    
    names(23)={'LeanWedge'};    
    
    %add a 'C' to the analaysisID
    for index=1:size(content,1)
        content(index,2)={['CO',cell2mat(funcconverttostring(content(index,2)))]};
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%
    'continue with threshold'
    %%%%%%%%%%%%%%%%%%%%%%%%%
    SQLstatement='select ''THRESHOLD'',thresholdanalysis_ID,acquisition.acquisition_ID,study_ID,patient_ID,view_description,location,resolution,mAs,kVp,technique_description,Date_acquisition,thresholdresult,threshold_analysis_date,operator.last_name,breast_area,0,correctionname,0,0,Mode,0,0';
    SQLstatement=[SQLstatement,' from machine,technique,acquisition,thresholdanalysis,commonanalysis,operator,mammo_view,correction'];
    SQLstatement=[SQLstatement,' where acquisition.machine_id=machine.machine_id and acquisition.acquisition_ID=commonanalysis.acquisition_ID and commonanalysis.commonanalysis_ID=thresholdanalysis.commonanalysis_ID and thresholdanalysis.operator_id=operator.operator_id and mammoview_id=view_id and technique.technique_id=acquisition.technique_id and correction.flatfieldcorrection_id=1'];
    SQLstatement=[SQLstatement,' order by study_ID,patient_ID,view_description'];    
    [tempcontent,tempnames]=mxDatabase(Database.Name,SQLstatement);
    %add a 'MT' to the analaysisID
    for index=1:size(tempcontent,1)
        tempcontent(index,2)={['MT',cell2mat(funcconverttostring(tempcontent(index,2)))]};
    end
    content=[content;tempcontent];
    
    %%%%%%%%%%%%%%%%%%
    'add SXA analysis'
    %%%%%%%%%%%%%%%%%%
    SQLstatement='select ''SXA       '',sxaanalysis.SXAanalysis_ID,acquisition.acquisition_ID,study_ID,patient_ID,view_description,location,resolution,mAs,kVp,technique_description,Date_acquisition,SXAresult,SXA_analysis_date,operator.last_name,breast_area,0,correctionname,phantomfat_xmin,phantomfat_xmax,phantomfat_ymin,phantomfat_ymax,phantomlean_xmin,phantomlean_xmax,phantomlean_ymin,phantomlean_ymax,Mode,FET_Fat_wedge,FET_Lean_wedge';
    SQLstatement=[SQLstatement,' from othersxainfo,machine,technique,acquisition,SXAanalysis,commonanalysis,operator,mammo_view,correction'];
    SQLstatement=[SQLstatement,' where acquisition.machine_id=machine.machine_id and acquisition.acquisition_ID=commonanalysis.acquisition_ID and commonanalysis.commonanalysis_ID=SXAanalysis.commonanalysis_ID and SXAanalysis.operator_id=operator.operator_id and mammoview_id=view_id and technique.technique_id=acquisition.technique_id and SXAanalysis.flatfieldcorrection_id=correction.flatfieldcorrection_id and othersxainfo.sxaanalysis_id=sxaanalysis.sxaanalysis_id'];
    SQLstatement=[SQLstatement,' order by study_ID,patient_ID,view_description'];    
    [tempcontent,tempnames]=mxDatabase(Database.Name,SQLstatement);
    
%     
%     'temporary for mammo database'
%     SQLstatement='select ''SXA       '',sxaanalysis.SXAanalysis_ID,acquisition.acquisition_ID,study_ID,patient_ID,view_description,location,resolution,mAs,kVp,technique_description,Date_acquisition,SXAresult,SXA_analysis_date,operator.last_name,breast_area,0,correctionname,phantomfat_xmin,phantomfat_xmax,phantomfat_ymin,phantomfat_ymax,phantomlean_xmin,phantomlean_xmax,phantomlean_ymin,phantomlean_ymax,Mode,0,0';
%     SQLstatement=[SQLstatement,' from machine,technique,acquisition,SXAanalysis,commonanalysis,operator,mammo_view,correction'];
%     SQLstatement=[SQLstatement,' where acquisition.machine_id=machine.machine_id and acquisition.acquisition_ID=commonanalysis.acquisition_ID and commonanalysis.commonanalysis_ID=SXAanalysis.commonanalysis_ID and SXAanalysis.operator_id=operator.operator_id and mammoview_id=view_id and technique.technique_id=acquisition.technique_id and SXAanalysis.flatfieldcorrection_id=correction.flatfieldcorrection_id'];
%     SQLstatement=[SQLstatement,' order by study_ID,patient_ID,view_description'];    
%     [tempcontent,tempnames]=mxDatabase(Database.Name,SQLstatement);
     
    %compute the phantom areas
    ShiftIndex=1;
    FatSize=num2cell((cell2mat(tempcontent(:,19+ShiftIndex))-cell2mat(tempcontent(:,18+ShiftIndex))).*(cell2mat(tempcontent(:,21+ShiftIndex))-cell2mat(tempcontent(:,20+ShiftIndex))));
    LeanSize=num2cell((cell2mat(tempcontent(:,23+ShiftIndex))-cell2mat(tempcontent(:,22+ShiftIndex))).*(cell2mat(tempcontent(:,25+ShiftIndex))-cell2mat(tempcontent(:,24+ShiftIndex))));
    tempcontent(:,18+ShiftIndex)=FatSize;
    tempcontent(:,19+ShiftIndex)=LeanSize;    
    tempcontent(:,20+ShiftIndex)=tempcontent(:,26+ShiftIndex);
    tempcontent(:,21+ShiftIndex:end-2)=[];
    %add a 'S' to the analaysisID
    for index=1:size(tempcontent,1)
        if ~mod(index,100)
            ['SXA:',num2str(index)]
        end
        tempcontent(index,2)={['SX',cell2mat(funcconverttostring(tempcontent(index,2)))]};
    end
    content=[content;tempcontent];
    
    SQLstatement='select ''SXASKIPPED'',acquisition.acquisition_ID,acquisition.acquisition_ID,study_ID,patient_ID,view_description,location,resolution,mAs,kVp,technique_description,Date_acquisition,0,analysis_date,operator.last_name,0,0,0,0,0,0,0,0,0,0,0,''NC'',0,0';
    SQLstatement=[SQLstatement,' from machine,technique,acquisition,SkippedSXAanalysis,operator,mammo_view'];
    SQLstatement=[SQLstatement,' where acquisition.machine_id=machine.machine_id and acquisition.acquisition_ID=SkippedSXAanalysis.acquisitionID and SkippedSXAanalysis.operatorid=operator.operator_id and mammoview_id=view_id and technique.technique_id=acquisition.technique_id'];
    SQLstatement=[SQLstatement,' order by study_ID,patient_ID,view_description'];    
    [tempcontent,tempnames]=mxDatabase(Database.Name,SQLstatement);
    %compute the phantom areas
    FatSize=num2cell((cell2mat(tempcontent(:,19+ShiftIndex))-cell2mat(tempcontent(:,18+ShiftIndex))).*(cell2mat(tempcontent(:,21+ShiftIndex))-cell2mat(tempcontent(:,20+ShiftIndex))));
    LeanSize=num2cell((cell2mat(tempcontent(:,23+ShiftIndex))-cell2mat(tempcontent(:,22+ShiftIndex))).*(cell2mat(tempcontent(:,25+ShiftIndex))-cell2mat(tempcontent(:,24+ShiftIndex))));
    tempcontent(:,18+ShiftIndex)=FatSize;
    tempcontent(:,19+ShiftIndex)=LeanSize;    
    tempcontent(:,20+ShiftIndex:end-3)=[];
    %add a 'S' to the analaysisID
    for index=1:size(tempcontent,1)
        if ~mod(index,100)
            ['SkippedSXA:',num2str(index)]
        end
   
        tempcontent(index,2)={['SK',cell2mat(funcconverttostring(tempcontent(index,2)))]};
    end
    content=[content;tempcontent];
     
%     
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     % Add fractal Analysis Results %
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     %test if the table is empty
%     if size(mxdatabase(Database.Name,'select * from structuralanalysis',1),1)
%         SQLstatement='select ''STRUCTURE '',structuralanalysis_ID,acquisition.acquisition_ID,study_ID,patient_ID,view_description,location,resolution,mAs,kVp,technique_description,Date_acquisition,result1,structuralanalysis.analysis_date,operator.last_name,breast_area,0,''NoCorrection'',0,0';
%         SQLstatement=[SQLstatement,' from machine,technique,acquisition,structuralanalysis,commonanalysis,operator,mammo_view,correction'];
%         SQLstatement=[SQLstatement,' where acquisition.machine_id=machine.machine_id and acquisition.acquisition_ID=commonanalysis.acquisition_ID and commonanalysis.commonanalysis_ID=structuralanalysis.commonanalysis_ID and operator.operator_id=structuralanalysis.operator_id and mammoview_id=view_id and technique.technique_id=acquisition.technique_id and correction.flatfieldcorrection_id=10'];
%         SQLstatement=[SQLstatement,' order by study_ID,patient_ID,view_description'];    
%         [tempcontent,tempnames]=mxDatabase(Database.Name,SQLstatement);
%         %add a 'MT' to the analaysisID
%         for index=1:size(tempcontent,1)
%             if ~mod(index,100)
%                 ['Fractal:',num2str(index)]
%             end
%             tempcontent(index,2)={['SA',cell2mat(funcconverttostring(tempcontent(index,2)))]};
%         end
%         content=[content;tempcontent];
%     end
%     
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     % Add BIRADS  Analysis Results %
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     if size(mxdatabase(Database.Name,'select * from biradsresults',1),1)
%         SQLstatement='select ''BIRADS    '',birads_ID,acquisition.acquisition_ID,study_ID,patient_ID,view_description,location,resolution,mAs,kVp,technique_description,Date_acquisition,biradsscore_id,BIRADS_analysis_date,operator.last_name,0,0,correctionname,0,0,''Manual''';
%         SQLstatement=[SQLstatement,' from machine,technique,acquisition,biradsresults,operator,mammo_view,correction'];
%         SQLstatement=[SQLstatement,' where acquisition.machine_id=machine.machine_id and biradsresults.acquisition_ID=acquisition.acquisition_id and operator.operator_id=biradsresults.operator_id and mammoview_id=view_id and technique.technique_id=acquisition.technique_id and correction.flatfieldcorrection_id=1'];
%         SQLstatement=[SQLstatement,' order by study_ID,patient_ID,view_description'];    
%         [tempcontent,tempnames]=mxDatabase(Database.Name,SQLstatement);
%         %add a 'MT' to the analaysisID
%         for index=1:size(tempcontent,1)
%             tempcontent(index,2)={['BI',cell2mat(funcconverttostring(tempcontent(index,2)))]};
%         end
%         content=[content;tempcontent];
%     end
    [content,names]=addQAcodes(content,names,3);
 end

if listboxhandle
    UpdateListBox(listboxhandle,content,names);
end

title=names;


function  [content,names]=addQAcodes(content,names,acquisitionColumn)
    global Database
    %%%%%%%%%%%%%
    %retrieve QAcode ID and description
    QAcodes=mxDatabase(Database.Name,'select * from QAcode');
    LastColumnIndex=size(content,2);  
    content=[content num2cell(zeros(size(content,1),1+size(QAcodes,1)))];
    contentID=cell2mat(content(:,acquisitionColumn));
    for index=1:size(QAcodes,1)
        if ~mod(index,10)
               ['adding QA codes',num2str(index),'/',num2str(size(QAcodes,1))]
        end
        names(LastColumnIndex+index)=QAcodes(index,2);
        %find the lines with true values
        AcqID=cell2mat(mxDatabase(Database.Name,['select acquisition_ID from QA_code_results where QA_code=',num2str(cell2mat(QAcodes(index,1)))]));
        for index2=1:size(AcqID,1)
            content(find(contentID==AcqID(index2)),LastColumnIndex+index)={1};
        end
    end
    'Add skipped SXA analysis'
    names(LastColumnIndex+index+1)={'SkippedSXA'};
    AcqID=cell2mat(mxDatabase(Database.Name,'select acquisitionID from skippedSXAAnalysis'));
    for index2=1:size(AcqID,1)
            content(find(contentID==AcqID(index2)),LastColumnIndex+index+1)={1};
    end
    
    
