%test room detection
%Lionel HERVE
%8-10-04

%On little breast films from the CPMC database, compute the room #

global Analysis Info Database ctrl AutomaticAnalysis 

Dicom.Database='eFilmDatabase';
Database.Name='mammo_cpmc';
set(ctrl.Cor,'value',false);
PowerPointOn=1;

%CreateReport('NEW');

%AcquisitionIDList=mxDatabase(Database.Name,'select acquisition_id,patient_ID from acquisition where acquisition_id>3004');
AcquisitionIDList={2386};
indexTest=1;RoomList=[];
for indexTest=1:size(AcquisitionIDList)
   Info.AcquisitionKey=cell2mat(AcquisitionIDList(indexTest,1));
   RetrieveInDatabase('ACQUISITION');
   CharacterRecognition;
   [AutomaticAnalysis.Room,AutomaticAnalysis.Imagette,AutomaticAnalysis.Marker,AutomaticAnalysis.Score]=FindRoomNumber2;
   CreateReport('ADDCOMMON');
   CreateReport('ROOMSPECIFIC');
   CreateReport('TAGINFORMATION');
   indexTest=indexTest+1;
   AutomaticAnalysis.Score
   pause(1);
end