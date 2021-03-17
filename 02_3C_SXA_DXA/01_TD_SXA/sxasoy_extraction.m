function sxasoy_data = sxasoy_extraction()
    % SQLstatement=['select * from Chestwall where id=',num2str(Analysis.ChestWallID),'order by point_id'];
     %       content=cell2mat(mxDatabase(Database.Name,SQLstatement));
     
     acqid_list = load('P:\Temp\good films\soy_sxaall.txt');
     sxasoy_data = zeros(length(acqid_list),4);
     Database.Name = 'mammo';
     for index = 1:length(acqid_list)
        SQLstatement=['SELECT ALL acquisition.acquisition_id,commonanalysis.commonanalysis_id,SXAAnalysis.SXAAnalysis_id,SXAAnalysis.SXAresult FROM acquisition,commonanalysis,SXAAnalysis WHERE acquisition.acquisition_id = commonanalysis.acquisition_id  AND commonanalysis.commonanalysis_id = sxaanalysis.commonanalysis_id  AND acquisition.acquisition_id =' ,num2str(acqid_list(index)),  'ORDER BY SXAAnalysis.SXAAnalysis_id DESC']; 
        temp = cell2mat(mxDatabase(Database.Name,SQLstatement));
        sxasoy_data(index,:) = temp(1,:);
        save('P:\Temp\good films\soysxadata_all.txt','temp', '-ascii', '-append');
     end