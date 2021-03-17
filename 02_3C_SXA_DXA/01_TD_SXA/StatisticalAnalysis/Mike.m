%% Report form Mike Hoffman

global Database ctrl dummyuicontrol2

[content,columntitle]=funcPopulateResume(Database,0,'GENERALresults');
excel('INIT');
excel('SAVEAS','cpmc_results.xls');
set(ctrl.DontSaveNextPatient,'enable','on');
Message('Change column 5 to string then press next');
waitfor(dummyuicontrol2,'value',true);
Message('Doing some database manipulations');

content2=content;
content2(:,12)=funcConvertToString(content2(:,12));
excel('TRANSFERT',content2,columntitle);

[contour,title]=mxDatabase('Excel Files',['select AnalysisType,AnalysisID,acquisition_ID,study_ID,patient_id,view_description,Date_acquisition,Results,breast_area from "sheet1$" where AnalysisType=''CONTOUR''']);
[thresholdauto,title]=mxDatabase('Excel Files',['select AnalysisType,AnalysisID,acquisition_ID,study_ID,patient_id,view_description,Date_acquisition,Results,breast_area from "sheet1$" where AnalysisType=''THRESHOLD'' and "Invalid auto SXA"=0']);
[sxaauto,title]=mxDatabase('Excel Files',['select AnalysisType,AnalysisID,acquisition_ID,study_ID,patient_id,view_description,Date_acquisition,Results,breast_area from "sheet1$" where AnalysisType=''SXA'' and "Invalid auto SXA"=0 and "Analysis Mode"=''Auto''']);
[sxamanual,title]=mxDatabase('Excel Files',['select AnalysisType,AnalysisID,acquisition_ID,study_ID,patient_id,view_description,Date_acquisition,Results,breast_area from "sheet1$" where AnalysisType=''SXA'' and "Analysis Mode"=''Manual''']);

excel('INIT');
excel('SAVEAS','cpmc_results_Simplified.xls');
Message('Change column 5 to string then press next');
waitfor(dummyuicontrol2,'value',true);
excel('TRANSFERT',[contour;sxaauto;sxamanual],title);

set(ctrl.DontSaveNextPatient,'enable','off');