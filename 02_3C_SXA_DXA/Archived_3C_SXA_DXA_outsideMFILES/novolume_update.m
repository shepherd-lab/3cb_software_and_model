function novolume_update()
     [FileName,PathName] = uigetfile('\\ming.radiology.ucsf.edu\Projects-Snap\aaSTUDIES\Breast Studies\CPMC\Reports\*.txt','Select the acquisition list txt-file ');
     acqs_filename = [PathName,'\',FileName];  
     temp_acqs = textread(acqs_filename,'%u');
     acquisitionkeyList = temp_acqs;
     Database.Name = 'mammo_CPMC';
     nosxa = [];
     count_no = 0;
     count_yes = 0;
     for index=2001:size(acquisitionkeyList,1)
        acq_id = acquisitionkeyList(index);
        SQLstatement=['SELECT ALL acquisition.acquisition_id,commonanalysis.commonanalysis_id,SXAStepAnalysis.SXAStepAnalysis_id,SXAStepAnalysis.SXAStepresult, commonanalysis.ROI_columns, sxastepanalysis.angle_ry, sxastepanalysis.coord_tx, sxastepanalysis.coord_tz, commonanalysis.breast_area  FROM acquisition,commonanalysis,SXAStepAnalysis WHERE acquisition.acquisition_id = commonanalysis.acquisition_id  AND commonanalysis.commonanalysis_id = sxastepanalysis.commonanalysis_id  AND acquisition.acquisition_id =' ,num2str(acq_id),  'ORDER BY SXAStepAnalysis.SXAStepAnalysis_id DESC']; 
        temp = cell2mat(mxDatabase(Database.Name,SQLstatement));
        if ~isempty(temp)
            count_yes = count_yes + 1;
            sxa_data(count_yes,:) = temp(1,:);
            sxa_temp = temp(1,:);
            h = 1.92;
            tz = sxa_temp(8);
            tx = sxa_temp(7);
            ROI_col = sxa_temp(5);
            ry = sxa_temp(6);
            breast_area = sxa_temp(9);
            sxastep_id = sxa_temp(3);
            H = (tz - h) + (tx - ROI_col * 0.014 / 2) * tan(-ry * pi / 180);
            breast_volume = breast_area * H * 0.85 * 0.92 * 0.014 * 0.014;
            %save('C:\Documents and Settings\smalkov.RADIOLOGY\My Documents\CalibrationFiles\CPMC\step_phantom\sxadata_novolume_analog2.txt','sxa_temp', '-ascii', '-append');
            mxDatabase(Database.Name,['update sxastepanalysis set breast_volume=''',num2str(breast_volume),''' where sxastepanalysis_id=',num2str(sxastep_id)]);
        else
            count_no = count_no + 1;
            nosxa(count_no) = acquisitionkeyList(index);
        end
        
        a = count_yes
     end
    % save('C:\Documents and Settings\smalkov.RADIOLOGY\My Documents\CalibrationFiles\CPMC\step_phantom\sxadata_novolume_Allanalog2.txt','sxa_data','-ascii');
     c = count_no
     c1 = count_yes