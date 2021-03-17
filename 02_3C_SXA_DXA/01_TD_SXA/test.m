global Info ChestWallData

Name='mammo_CPMC'
content=cell2mat(mxDatabase(Name,'select Chestwall_id, freeformanalysis_id from commonanalysis,freeformanalysis where freeformanalysis.commonanalysis_id=commonanalysis.commonanalysis_id and Chestwall_id>0'));
for index=1:size(content,1)
   Info.FreeFormAnalysisKey=content(index,2);
   Database.Step=1;     %before 2
   RetrieveInDatabase('FREEFORMANALYSIS'); 
   mxDatabase(Name,['insert into ChestWallInfo values(''',num2str(content(index,1)),''',''',num2str(ChestWallData.pixels),''')'])
end