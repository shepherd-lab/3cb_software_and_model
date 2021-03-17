function  CheckSXA_Struc

% 1) check the image to make sure that we are analyized the image with GEN3  
% 2) Check the information of images with database to prevent duplicates results

% written by Amir Pasha M
% 12182013 version 1.0
% 02072014 version 2.0

global Info flag Analysis Database version  versionSXA versionstruc

Info.date_GEN3_num=[];

try
if Analysis.PhantomID == 9
            
            machine_correction = mxDatabase(Database.Name,['select paddle_type, date_acquisition from MachineParametersCorrection_New where machine_id= ',num2str(Info.centerlistactivated), ' order by date_acquisition DESC']);
            sz_corr = size(machine_correction);

            for i = 1:sz_corr(1)
                
                paddle_type(i)  =  machine_correction{i,1};
                start_date_num(i) = datenum( machine_correction{i,2}, 'yyyymmdd');
% % %                 end_date_num(i) = datenum( machine_correction{i,3}, 'yyyymmdd');
               
            end

            small_index = find(paddle_type==1);
            big_index = find(paddle_type==0);
            date_acquisition_num = datenum(Info.date_acq, 'yyyymmdd');
            Test1=datestr(date_acquisition_num);
             if flag.small_paddle 
                start_date_num_small = start_date_num(small_index); 
                dates_max_start = max(start_date_num_small);
% % %                 dates_max_start = max(start_date_num_small(start_date_num_small < date_acquisition_num ));
% % % %                 end_date_num_small =  end_date_num(big_index );
% % %                 dates_max_end = max(end_date_num_small(end_date_num_small < date_acquisition_num ));
% % %                 dates_max_end = max(end_date_num_small);
                Test=datestr(dates_max_start );
                
% % %                 if  ~isempty(start_date_num_small) 
% % %                     if isempty(dates_max_end)
% % %                         dates_max_end = min(start_date_num_small);
% % %                     end
% % %                 end
                index_date = find(start_date_num_small ==  dates_max_start);
                Test11=datestr(dates_max_start);
              if date_acquisition_num>dates_max_start 
                  Info.date_GEN3_num=false;
                else
                    Info.date_GEN3_num=true;
                end

             else
                start_date_num_big = start_date_num(big_index );
                dates_max_start = max(start_date_num_big);
% % %                 dates_max_start = max(start_date_num_big(start_date_num_big < date_acquisition_num ));
% % %                 end_date_num_big =  end_date_num(big_index );
% % %                 dates_max_end = max(end_date_num_big(end_date_num_big < date_acquisition_num ));
% % %                 dates_max_end = max(end_date_num_big);
                Test=datestr(dates_max_start );
% % %                 if  ~isempty(start_date_num_big) 
% % %                     if isempty(dates_max_end)
% % %                         dates_max_end = min(start_date_num_big);
% % %                     end
% % %                 end
                index_date = find(start_date_num_big == dates_max_start);
                if date_acquisition_num>dates_max_start
                    Info.date_GEN3_num=false;
                else
                    Info.date_GEN3_num=true;
                end
             end
                 
else  
     Analysis.PhantomID = false;
     nextpatient(0);
     multiWaitbar( 'CloseAll' );
     return;
end
catch 
     nextpatient(0);
     multiWaitbar( 'CloseAll' );
     return;
end

try
    version=Info.Version;
catch
    errmsg = lasterr
    try
        version_type = version_retreiving(Info.AcquisitionKey);
    catch
        nextpatient(0);
        multiWaitbar( 'CloseAll' );
        return;
    end
end

% temporary Commnted for Cohort Study 03/31/2014

% % % try
% % %     SXAID=mxDatabase(Database.Name,['select SXAStepAnalysis_id, version from sxastepanalysis where acquisition_id=',num2str(Info.AcquisitionKey),  ' order by SXAStepAnalysis_id DESC']);
% % %     SXAID = SXAID(1,:);
% % %     SXAID1=cell2mat(SXAID(1));
% % %     CheckVersionSXA=cell2mat(SXAID(2));
% % %     
% % %     if strfind(CheckVersionSXA,version)
% % %         
% % %         if SXAID1 ~=0
% % %             Info.CheckSXAStepAnalysis=SXAID1(1);
% % %         else
% % %             Info.CheckSXAStepAnalysis=false;
% % %             versionSXA=false
% % %         end;
% % %         
% % %     else
% % %         if ~strcmp(CheckVersionSXA(1:10),'Version7.1')
% % %             versionSXA=false;
% % %             Info.CheckSXAStepAnalysis=false;
% % %         else
% % %             Info.CheckSXAStepAnalysis=SXAID1(1);
% % %         end;
% % %     end;
% % %     
% % % catch
% % %     Info.CheckSXAStepAnalysis=false;
% % % end

Info.CheckStructural=false;

Info.CheckSXAStepAnalysis=false;
versionSXA=false;

% temproray commented 01232015

% % % try
% % %     StrucID=mxDatabase(Database.Name,['select StructuralAnalysis_id, version from StructuralAnalysis where acquisition_id=',num2str(Info.AcquisitionKey),  ' order by StructuralAnalysis_id DESC']);
% % %     StrucID = StrucID(1,:);
% % %     StrucID1=cell2mat(StrucID(1));
% % %     CheckVersionStruc=cell2mat(StrucID(2));
% % %     
% % %     if strfind(CheckVersionStruc,version)
% % %         
% % %         if StrucID1~=0
% % %             Info.CheckStructural=StrucID1(1);
% % %         else
% % %             Info.CheckStructural=false;
% % %             versionstruc=false;
% % %         end;
% % %     else
% % %         if ~strcmp(CheckVersionStruc(1:10),'Version7.1')
% % %             versionstruc=false;
% % %             Info.CheckVersionStruc=0;
% % %             Info.CheckStructural=false;
% % %         else
% % %             Info.CheckStructural=StrucID1(1);
% % %         end
% % %     end;
% % %     
% % % catch
% % %     Info.CheckStructural=false;
% % % % % %      versionstruc=false;
% % % % % % end;
% % % 
% % % end

