% retrieve the patieent ids of the guys I have in my database
% the problem come from the fact we got some information (race, age,
% childs) which don't match correctly each other.

%Lionel HERVE
%12-10-04

[content,Name]=mxDatabase(Database.Name,'select acquisition.patient_id from acquisition where study_id=''BBD''');
excel('INIT');
excel('TRANSFERT',content,Name);

[content,Name]=mxDatabase(Database.Name,'select distinct acquisition.patient_id from acquisition,commonanalysis,freeformanalysis where freeformanalysis.commonanalysis_id=commonanalysis.commonanalysis_id and commonanalysis.acquisition_id=acquisition.acquisition_id and study_id=''BBD''')
excel('INIT');
excel('TRANSFERT',content,Name);

