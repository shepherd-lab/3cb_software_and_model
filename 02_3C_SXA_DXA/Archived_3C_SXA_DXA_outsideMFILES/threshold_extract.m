function thresh_array = threshold_extract()
    database_name = 'mammo_CPMC';
    acq_idlist = textread('P:\Temp\good films\50films.txt','%u'); 
    len = length(acq_idlist);
    count = 0;
    thresh_array = zeros(50,24);
    for i = 1:len
          str_list = num2str(acq_idlist(i))
         %  = mxDatabase(database_name, ['SELECT ALL qa_code_results.QA_Code FROM acquisition,qa_code_results WHERE acquisition.acquisition_id = qa_code_results.acquisition_id  AND acquisition.acquisition_id =',  str_list]);  
         thresh_cell = mxDatabase(database_name,['SELECT ALL acquisition.acquisition_id,commonanalysis.commonanalysis_id,SXAAnalysis.SXAresult,ThresholdAnalysis.thresholdresult5,ThresholdAnalysis.thresholdresult10,ThresholdAnalysis.thresholdresult15,ThresholdAnalysis.thresholdresult20,ThresholdAnalysis.thresholdresult25,ThresholdAnalysis.thresholdresult30,ThresholdAnalysis.thresholdresult35,ThresholdAnalysis.thresholdresult40,ThresholdAnalysis.thresholdresult45,ThresholdAnalysis.thresholdresult50,ThresholdAnalysis.thresholdresult55,ThresholdAnalysis.thresholdresult60,ThresholdAnalysis.thresholdresult65,ThresholdAnalysis.thresholdresult70,ThresholdAnalysis.thresholdresult75,ThresholdAnalysis.thresholdresult80,ThresholdAnalysis.thresholdresult85,ThresholdAnalysis.thresholdresult90,ThresholdAnalysis.thresholdresult95 FROM acquisition,commonanalysis,SXAAnalysis, ThresholdAnalysis WHERE acquisition.acquisition_id = commonanalysis.acquisition_id  AND commonanalysis.commonanalysis_id = sxaanalysis.commonanalysis_id   AND commonanalysis.commonanalysis_id = thresholdanalysis.commonanalysis_id AND  commonanalysis.acquisition_id=',str_list]);  
         free_cell = mxDatabase(database_name,['SELECT ALL acquisition.acquisition_id,FreeFormAnalysis.freeform_result FROM acquisition,commonanalysis,FreeFormAnalysis WHERE acquisition.acquisition_id = commonanalysis.acquisition_id  AND FreeFormAnalysis.commonanalysis_id = commonanalysis.commonanalysis_id  AND commonanalysis.acquisition_id = ',str_list]);   
         sz_thresh = size(thresh_cell);
         len = sz_thresh(1);
         xlen = sz_thresh(2);
         b = thresh_cell(len,1:end);
         thresh_num = cell2mat(b);

         sz_free = size(free_cell);
         flen = sz_free(1);
         fxlen = sz_free(2);
         d = free_cell(flen,1:end);
         free_num = cell2mat(d);

         % sz_thresh = size(thresh_num)
       %  len = sz_thresh(1)
       %  xlen = sz_thresh(2)
         thresh_array(i,1:fxlen) = free_num;
         thresh_array(i,fxlen+1:xlen+fxlen) = thresh_num;
    end
    
    file_name = 'threshfree50_5-95n.txt';
    save(['P:\Temp\ThresholdAnalysis\',file_name],'thresh_array','-ascii'); 

  
    %'SELECT ALL acquisition.acquisition_id,commonanalysis.commonanalysis_id,SXAAnalysis.SXAresult,ThresholdAnalysis.thresholdresult FROM acquisition,commonanalysis,SXAAnalysis,ThresholdAnalysis WHERE acquisition.acquisition_id = commonanalysis.acquisition_id  AND commonanalysis.commonanalysis_id = sxaanalysis.commonanalysis_id  AND commonanalysis.commonanalysis_id = thresholdanalysis.commonanalysis_id  AND commonanalysis.acquisition_id = '  
    %thresh_cell = mxDatabase(database_name,['SELECT ALL acquisition.acquisition_id,commonanalysis.commonanalysis_id,SXAAnalysis.SXAresult,ThresholdAnalysis.thresholdresult FROM acquisition,commonanalysis,SXAAnalysis,ThresholdAnalysis WHERE acquisition.acquisition_id = commonanalysis.acquisition_id  AND commonanalysis.commonanalysis_id = sxaanalysis.commonanalysis_id  AND commonanalysis.commonanalysis_id = thresholdanalysis.commonanalysis_id  AND commonanalysis.acquisition_id=',str_list]);  