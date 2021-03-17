[content,title]=mxDatabase(Database.Name,'select * from acquisition, commonanalysis, freeformanalysis where study_id=''SOY'' and freeformanalysis.commonanalysis_id=commonanalysis.commonanalysis_id and commonanalysis.acquisition_id=acquisition.acquisition_id')
excel('INIT')
excel('TRANSFERT',content,title)