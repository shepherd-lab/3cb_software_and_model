[content,title]=funcShowQSLinTable('select acquisition_id,Angle from 	commonanalysis,sxaanalysis,othersxainfo where 	othersxainfo.sxaanalysis_id=sxaanalysis.sxaanalysis_id and 	sxaanalysis.commonanalysis_id=commonanalysis.commonanalysis_id order by 	Angle');