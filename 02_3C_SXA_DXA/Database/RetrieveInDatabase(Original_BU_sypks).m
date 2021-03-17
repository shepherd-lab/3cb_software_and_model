%RetrieveInDatabase
%author Lionel HERVE
%7-29-03 Roughness analysis is in commonanalysis now
%9-17-03 Don't divide the correction image by 10000 in order to store them
%in integer precision (save memory)

function RetrieveInDatabase(RequestedAction)
global flag Database Analysis Info ctrl dummyuicontrol2 f0 ManualEdge FreeForm Threshold Correction Result ok_continue ROI Image
global Recognition Error QA ReportText ChestWallData AutomaticAnalysis Phantom flag h_init h_slope number_acqs MachineParams acqs_filename
global InfoDXA startdir_report
%noimage_flag
%noimage_flag = 0;
%Info.Database=true;

switch RequestedAction
    
%% FILE OF LISTNAMES
    case 'FILEOFLISTNAMES'
     % [FileName,PathName] = uigetfile('D:\users\smalkov\list_files\Large_paddle\*.txt','Select the acquisition list txt-file ');
     [FileName,PathName] = uigetfile('\\researchstg\aaDATA\Breast Studies\*.txt','Select the acquisition list txt-file ');
      acqs_filename = [PathName,'\',FileName];  
      RetrieveInDatabase('ACQUISITIONFROMLIST');
      
%% Acquisition from list      
    case 'ACQUISITIONFROMLIST'
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%% retrieve an acquisition %%%%%%%%   Multi analysis possible
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
       %inf1 = Info B:\BIRADS1\Birads_readinglist_original.txt
      %acquisitionkeyList=textread('B:\BIRADS1\Birads_readinglist_original.txt','%u');
%acquisitionkeyList=textread('P:\Temp\good films\stgeorgesgoodccviews.txt','%u'); %for the first Birad Reading
number_acqs =  11000; 
%acqs_filename = 'P:\Temp\good films\Z2list_me.txt';

%
%acqs_filename = 'P:\Temp\good films\Z4rm123list_me2.txt';
%acqs_filename = 'P:\Temp\good films\Z4_sxazero800.txt';
%acqs_filename = 'new_7000.txt';
%acqs_filename = 'breast_list.txt';
%acqs_filename = 'profile_list.txt';

%acqs_filename = 'Z4_5to6percent.txt';
temp_acqs = textread(acqs_filename,'%u');
if length(temp_acqs) >= number_acqs
   acquisitionkeyList = temp_acqs(1:number_acqs);
else
   acquisitionkeyList = temp_acqs;
end
%}
 %acquisitionkeyList=textread('F:\test.txt','%u');
     %  Info.Analysistype=5;
  %acquisitionkeyList=cell2mat(funcSelectInTable('retrieveAcq','Choose an acquisition',0,'Cancel'));
      
        if acquisitionkeyList~=0   %0 if ncel button has not been pressed
            Result.DXASelenia = false;
            flag.RawImage = false;
            if size(acquisitionkeyList,1)==1    %1 patient mode
                Info.MultiAcquisitionAnalysis=false;
                Info.AcquisitionKey=acquisitionkeyList;
                
                
                clear_DXAfields;
                RetrieveInDatabase('ACQUISITION');
                Database.Step=1;
                Analysis.Step=1;
                Info.CommonAnalysisKey=0;
                Info.FreeFormAnalysisKey=0;
                   Analysis.SaveInFile = false;
                %Info.Analysistype = 0;
            else            %multi selection mode
                OperatorSave=Info.Operator;
                if OperatorSave == 20
                    Info.Analysistype = 5;
                else
                    Info.Analysistype=cell2mat(funcSelectInTable('analysistype','What analysis do you want to perform?',0));
                end
                %Info.Analysistype = 5;
                
                 
                Info.MultiAcquisitionAnalysis=true;
                set(ctrl.SaveNextPatient,'enable','on');
                set(ctrl.DontSaveNextPatient,'enable','on');
                set(ctrl.StopReading,'enable','on');
                set(ctrl.Skip,'enable','on');
                set(f0.menu.DatabaseSave,'enable','off');

                StopReading=false;
                FirstPassage=true;
                    
                if (Info.Analysistype==1)  %freeforms
                     %randomize visit
                     acquisitionkeyList
                     acquisitionkeyList=randomizevisit(acquisitionkeyList)
                end
                
                if (Info.Analysistype==7)  %thumbnail films
                    thumbnail(acquisitionkeyList);
                    StopReading=true;
                end

                if (Info.Analysistype==9)  %Prepare CDs
                    prepareCDs(acquisitionkeyList,1);
                    StopReading=true;
                end
                               
                if (Info.Analysistype==6)  %randomize films
                    [SortedRandomNumbers,indexRandom]=sort(rand(size(acquisitionkeyList,1),1));
                    B=str2num(acquisitionkeyList);
                    acquisitionkeyList=num2str(B(indexRandom));
                end

                if (Info.Analysistype==11)  %reposition  Images
                    RepositionImage(acquisitionkeyList,1);
                    StopReading=true;
                end
                Analysis.SaveInFile = false;
                RetrieveInDatabaseCounter=0;
                Info.AcquisitionKey=acquisitionkeyList(1,:);
                  if (Info.Analysistype==5) | (Info.Analysistype==16)
                       CreateReport('NEW',Info.AcquisitionKey);
                  end    
                
               for RetrieveInDatabaseIndex=1:size(acquisitionkeyList,1)
                    hnd = get(0,'Children');
                   if ~isempty(h_init) 
                      for i = 1:length(h_init) 
                       if find(hnd == h_init(i))
                          delete(h_init(i));
                       end
                   end
                 end
                 if  ~isempty(h_slope)  
                     for i = 1:length(h_slope) 
                       if find(hnd == h_slope(i))
                          delete(h_slope(i));
                       end
                     end
                 end   
                  Info.AcquisitionKey=acquisitionkeyList(RetrieveInDatabaseIndex,:);
                    
                  %SQLstatement= ['SELECT ALL SXAAnalysis.SXAAnalysis_id FROM acquisition,commonanalysis,SXAAnalysis WHERE acquisition.acquisition_id = commonanalysis.acquisition_id  AND commonanalysis.commonanalysis_id = sxaanalysis.commonanalysis_id  AND acquisition.acquisition_id = ',num2str(Info.AcquisitionKey)];  
                  %sxa_id=cell2mat(mxDatabase(Database.Name,SQLstatement));;
                  %len = length(sxa_id)
                  %if len ~= 0
                    if StopReading
                        break;
                    end
                    
                    %put the check mark to auto
                    '!!!!!!!!!!!!!!!!! Retrieve in Database modified for SOY analysis !!!!!!!!!!!!!!!!!!!'
                    set(ctrl.CheckAutoROI,'value',true);
                    set(ctrl.CheckAutoSkin,'value',true);                    
                    %set(ctrl.CheckManualPhantom,'value',0);  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SOY ANALYSIS                  
                    set(ctrl.CheckManualPhantom,'value',1);
                    
                    if (Info.Analysistype==4)  %%% add the BIRADS buttons
                        DrawBIRADSButtons(true);
                        Message('Select the BI-RADS score');
                        drawnow;
                    end

                    Info.AcquisitionKey=acquisitionkeyList(RetrieveInDatabaseIndex,:);
                    flag.noimage = false;
                    flag.RawImage = false;
                    try
                        if Info.Analysistype==16
                            Result.calibration_type = 'AutoDXA';
                            Result.DXASelenia = true;
                            Result.DXASeleniaCalculated = false;
                            
                            Result.flagLE = true;
                            Result.flagHE = false;
                            
                            RetrieveInDatabase('ACQUISITION');
                            Info.AcquisitionKeyLE = Info.AcquisitionKey;
                            Info.fnameLE = Info.fname;
                            Info.kVpLE = Info.kVp;
                            Info.mAsLE = Info.mAs;
                            Result.flagHE = true;
                            %SQLstatement=['select patient_id from acquisition where acquisition_id=',num2str(Info.AcquisitionKey),' and digitizer.digitizer_id=acquisition.digitalizer_id'];
                            SQLstatement=['select patient_id,date_acquisition from acquisition where acquisition_id=',num2str(Info.AcquisitionKey)];
                            a = mxDatabase(Database.Name,SQLstatement);
                            patient_ident = a(1);
                            date_acq = a(2);
                            SQLstatement=['select acquisition_id from acquisition where patient_id=',char(patient_ident),' and date_acquisition=',char(date_acq),' and kVp>',num2str(35)];
                            ab  = mxDatabase(Database.Name,SQLstatement);
                            Info.AcquisitionKey = cell2mat(ab); 
                            Result.DXASelenia = true;
                            RetrieveInDatabase('ACQUISITION');
                            Info.kVpHE = Info.kVp;
                            Info.mAsHE = Info.mAs;
                            %kvp_mas = ['kVp';'mAs'];
                            %Info = rmfield(Info,kvp_mas);
                            Info.kVp = Info.kVpLE;
                            Info.mAs = Info.mAsLE;
                            SXAAnalysis = [];
                            DXAAnalysis = [];
                            MaskROIproj = [];
                            BreastMask = [];
                        elseif Info.Analysistype==17
                            Result.calibration_type = 'Auto3CB';
                            Result.DXASelenia = true;
                            Result.DXASeleniaCalculated = false;
                            
                            Result.flagLE = true;
                            Result.flagHE = false;
                            
                            RetrieveInDatabase('ACQUISITION');
                            Info.AcquisitionKeyLE = Info.AcquisitionKey;
                            Info.fnameLE = Info.fname;
                            Info.kVpLE = Info.kVp;
                            Info.mAsLE = Info.mAs;
                            Result.flagHE = true;
                            %SQLstatement=['select patient_id from acquisition where acquisition_id=',num2str(Info.AcquisitionKey),' and digitizer.digitizer_id=acquisition.digitalizer_id'];
                            Database.Name = 'mammo_DXA';
                            SQLstatement=['select patient_id,date_acquisition, fn from acquisition where acquisition_id=',num2str(Info.AcquisitionKey)];
                            a = mxDatabase(Database.Name,SQLstatement);
                            patient_ident = char(a(1));
                            date_acq = char(a(2));
                            fn = char(a(3));
                            fn_he = strrep(fn, 'LE', 'HE');
                            fn_he = fn_he(1:4);
                            SQLstatement=['select acquisition_id from acquisition where patient_id like ''',patient_ident(1:7),''' and date_acquisition like ''',date_acq(1:8),''' and SUBSTRING(fn,1,4) like ''',fn_he,''''];
                            ab  = mxDatabase(Database.Name,SQLstatement);
                            Info.AcquisitionKey = cell2mat(ab); 
                            Result.DXASelenia = true;
                            RetrieveInDatabase('ACQUISITION');
                            Info.kVpHE = Info.kVp;
                            Info.mAsHE = Info.mAs;
                            %kvp_mas = ['kVp';'mAs'];
                            %Info = rmfield(Info,kvp_mas);
                            Info.kVp = Info.kVpLE;
                            Info.mAs = Info.mAsLE;
                            SXAAnalysis = [];
                            DXA3CBAnalysis = [];
                            MaskROIproj = [];
                            BreastMask = [];
                        
                        
                        else
                            Result.flagLE = false; 
                            Result.flagHE = false; 
                            
                            Result.DXASelenia = false;
                            clear_DXAfields;
                            RetrieveInDatabase('ACQUISITION');
                        end
                    catch
                       errmsg = lasterr
                       flag.noimage == true;
                       continue;
                    end
                                           
                    %   set(ctrl.Cor,'value',1);    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SOY ANALYSIS
                    set(ctrl.Cor,'value',0); 
                    RetrieveInDatabase('ERRRORCODES');
                
                    % init analysis variables
                    set(dummyuicontrol2,'value',false);
                    Database.Step=1;
                    Analysis.Step=1;
                    Info.CommonAnalysisKey=0;
                    Info.FreeFormAnalysisKey=0;
                    Info.SXAAnalysisKey=0;

                  %  eval(get(ctrl.ROI,'callback'));    %%%%%%%%%%%%%%%%%%%%% TO ERASE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SOY ANALYSIS
                  %  eval(get(ctrl.SkinDetection,'callback'));    %%%%%%%%%%% TO ERASE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SOY ANALYSIS
                  %  eval(get(ctrl.Phantom,'callback'));    %%%%%%%%%%%%%%%%% TO ERASE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SOY ANALYSIS
                                  
                    
                    if (Info.Analysistype==1)  %%% contour analysis
                        %detect ROI
                        CallBack=get(ctrl.ROI,'callback');
                        eval(CallBack);
                        %detect skin edge
                        CallBack=get(ctrl.SkinDetection,'callback');
                        eval(CallBack);
                    end
                    
                    msg=get(ctrl.text_zone,'string');
                    Message([msg,'   (',num2str(RetrieveInDatabaseIndex),'/',num2str(size(acquisitionkeyList,1)),')']);

                    if (Info.Analysistype==5)
                        Analysis.SXAMode='Auto';
                            
                        Info.Operator=11;  %use operator: automatic
                        AutomaticSXAAnalysis;
                        if Info.ReportCreated == false
                             Message('Creating report...');
                             try
                                 CreateReport('ADDCOMMON');
                                 CreateReport('QACODES');
                                 CreateReport('ADDREPORTTEXT');
                             catch
                                  errmsg = lasterr   
                                  %continue;
                             end
                             Info.ReportCreated = true;
                        end
                        % if (Info.Analysistype==5) %automatic SXA analysis
                        if mod(RetrieveInDatabaseCounter,50)==0 %& Info.SaveStatus ~= 0 
                            if RetrieveInDatabaseCounter %& Info.SaveStatus ~= 0 
                                 CreateReport('SAVECLOSE',Info.AcquisitionKey-1);
                                 CreateReport('NEW',Info.AcquisitionKey);
                            end
                           % CreateReport('NEW',Info.AcquisitionKey);
                        end
                    %end
                    end
                    %% launch single automatic analysis DXA
                    if (Info.Analysistype==16)
                        Analysis.DXAMode='Auto';
                            
                        Info.Operator=11;  %use operator: automatic
                        AutomaticDXAAnalysis(); % launch single automatic analysis DXA
                        if Info.ReportCreated == false
                             Message('Creating report...');
                             CreateReport('ADDCOMMON');
                             CreateReport('QACODES');
                             CreateReport('ADDREPORTTEXT');
                             Info.ReportCreated = true;
                        end
                        % if (Info.Analysistype==5) %automatic SXA analysis
                        if mod(RetrieveInDatabaseCounter,50)==0 %& Info.SaveStatus ~= 0 
                            if RetrieveInDatabaseCounter %& Info.SaveStatus ~= 0 
                                 CreateReport('SAVECLOSE',Info.AcquisitionKey-1);
                                 CreateReport('NEW',Info.AcquisitionKey);
                            end
                           % CreateReport('NEW',Info.AcquisitionKey);
                        end
                    
                    end
                    
                     if (Info.Analysistype==17)
                        Analysis.DXAMode='Auto';
                            
                        Info.Operator=11;  %use operator: automatic
                        Automatic3CAnalysis(); % launch single automatic analysis DXA
                        if Info.ReportCreated == false
                             Message('Creating report...');
                             CreateReport('ADDCOMMON');
                             CreateReport('QACODES');
                             CreateReport('ADDREPORTTEXT');
                             Info.ReportCreated = true;
                        end
                        % if (Info.Analysistype==5) %automatic SXA analysis
                        if mod(RetrieveInDatabaseCounter,50)==0 %& Info.SaveStatus ~= 0 
                            if RetrieveInDatabaseCounter %& Info.SaveStatus ~= 0 
                                 CreateReport('SAVECLOSE',Info.AcquisitionKey-1);
                                 CreateReport('NEW',Info.AcquisitionKey);
                            end
                           % CreateReport('NEW',Info.AcquisitionKey);
                        end
                    
                    end
                    
                    if (Info.Analysistype==12)
                        Info.Operator=11;  %use operator: automatic
                        AutomaticPCAnalysis;
                    end
                    
                    if (Info.Analysistype==13)
                        Info.Operator=11;  %use operator: automatic
                        funcFreeAreaCalculation;
                    end
                    
                    if (Info.Analysistype==14)
                        Info.Operator=11;  %use operator: automatic
                        %funcAtomaticThresholdAnalysis;
                        if mod(RetrieveInDatabaseCounter,50)==0 & Info.SaveStatus ~= 0
                            if RetrieveInDatabaseCounter
                                 CreateReport('SAVECLOSE',Info.AcquisitionKey-1);
                            end
                            CreateReport('NEW',Info.AcquisitionKey);
                        end
                        
                        %AutomaticPCAnalysis;
                        AutoThreshAnalysis;
                    end
                    
                    if (Info.Analysistype==15)  %Prepare CDs
                        Info.Operator=11;
                        AutomaticDSPAnalysis;
                    end
                    
                    ok_continue=false;  %ok_continue will become true when the saving operation is performed all right
                    while ~ok_continue
                        waitfor(dummyuicontrol2,'value',true);      %wait 'save / next patient'
                        if Info.SaveStatus==1
                            %save
                            if (Info.Analysistype==1)||(Info.Analysistype==6)   %free form
                                SaveInDatabase('FREEFORMANALYSIS');
                            elseif (Info.Analysistype==2 | Info.Analysistype==14) & Analysis.SaveInFile ~= true      %threshold
                                 SaveInDatabase('THRESHOLDANALYSIS');
                                 if Analysis.PhantomID == 7 | Analysis.PhantomID == 8 | Analysis.PhantomID == 9
                                     SaveInDatabase('SXASTEPANALYSIS');
                                 else
                                     SaveInDatabase('SXAANALYSIS');
                                 end
                                    
                            elseif (Info.Analysistype==14) & (Analysis.SaveInFile == true)      %threshold
                                 ok_continue=true;   
                            elseif (Info.Analysistype==3)  %SXA
                                 if Analysis.PhantomID == 7 | Analysis.PhantomID == 8 | Analysis.PhantomID == 9
                                     SaveInDatabase('SXASTEPANALYSIS');
                                 else
                                     SaveInDatabase('SXAANALYSIS');
                                 end
                                
                                %  SaveInDatabase('SXAANALYSIS');
%                                 if Info.FakeMAS==true;        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SOY
%                                     clear field
%                                     field(1)={num2str(Info.SXAAnalysisKey)};
%                                     field(2)={'2'};
%                                     field(3)={'1'};
%                                     funcAddInDatabase(Database,'Comment_Results',field);
%                                 end
                            elseif (Info.Analysistype==5)  %AutomaticSXA only for SXA
                              if AutomaticAnalysis.StructuralAnalysisDone
                                SaveInDatabase('COMMONANALYSIS');
                                SaveInDatabase('STRUCTURALANALYSIS');
                              end
                              
                                if AutomaticAnalysis.ThresholdAnalysisDone
                                   try
                                     SaveInDatabase('THRESHOLDANALYSIS'); 
                                   catch  
                                        errmsg = lasterr
                                        try
                                           SaveInDatabase('THRESHOLDANALYSIS'); 
                                        % if(strfind(errmsg, 'Subscripted assignment dimension mismatch'))
                                        catch
                                             errmsg = lasterr  
                                              ok_continue=true;
                                             continue;
                                             %nextpatient(0);
                                             %turn;
                                        end
                                   end   
                                end
                                if ~Error.NoCorrection;
                                %    SaveInDatabase('THRESHOLDANALYSIS');
                                    if ~Error.DENSITY
                                        if Analysis.PhantomID == 7 | Analysis.PhantomID == 8 | Analysis.PhantomID == 9
                                            try
                                                SaveInDatabase('SXASTEPANALYSIS');
                                            catch  
                                                errmsg = lasterr
                                                try
                                                   SaveInDatabase('SXASTEPANALYSIS'); 
                                                % if(strfind(errmsg, 'Subscripted assignment dimension mismatch'))
                                                catch
                                                     errmsg = lasterr  
                                                     ok_continue=true;
                                                     continue;
                                                     %nextpatient(0);
                                                     %return;
                                                end
                                            end   
                                        else
                                            SaveInDatabase('SXAANALYSIS');
                                        end
                                       % SaveInDatabase('SXAANALYSIS');
                                    end
                                end
                            %%  save automatic DXA in database
                            elseif Info.Analysistype==16
                                 if ~Error.DENSITY
                                    try
                                        SaveInDatabase('DXAANALYSIS');
                                    catch  
                                        errmsg = lasterr
                                        try
                                           SaveInDatabase('DXAANALYSIS'); 
                                        catch
                                           errmsg = lasterr  
                                           ok_continue=true;
                                           continue;
                                           %nextpatient(0);
                                           %return;
                                        end
                                    end   
                                 end

                            elseif Info.Analysistype==4  %BI-RADS scoring
                                SaveInDatabase('BI-RADS');
                            elseif (Info.Analysistype==8) %NOTHING
                                Center=get(ctrl.Center,'value');
                                mxDatabase(Database.Name,['update acquisition set machine_id=''',num2str(Center),''' where acquisition_id=',num2str(Info.AcquisitionKey)]);
                                comment=get(ctrl.comment,'string');
                                mxDatabase(Database.Name,['update acquisition set film_identifier=''',comment,''' where acquisition_id=',num2str(Info.AcquisitionKey)]);
                                ok_continue=true;
                            end
                        elseif Info.SaveStatus==2
                            ok_continue=true;
                            StopReading=true;
                        elseif Info.SaveStatus==3
                            ok_continue=true;
                           % mxDatabase(Database.Name,['insert into SkippedSXAAnalysis values (''',num2str(Info.AcquisitionKey),''',''',date,''',''',num2str(Info.Operator),''')']);
                        elseif Info.SaveStatus==4
                            ok_continue=true;
                             mxDatabase(Database.Name,['update acquisition set phantom_id=''',num2str(Analysis.PhantomID),''' where acquisition_id=',num2str(Info.AcquisitionKey)]);
                        else
                            if (Info.Analysistype==5)&(AutomaticAnalysis.StructuralAnalysisDone)
                                SaveInDatabase('COMMONANALYSIS');
                                SaveInDatabase('STRUCTURALANALYSIS');
                            end
                            ok_continue=true;
                        end
                        if ~ok_continue
                            set(dummyuicontrol2,'value',false);
                        end
                    end
                  %end
                 if Info.SaveStatus ~= 0
                   RetrieveInDatabaseCounter=RetrieveInDatabaseCounter+1;
                 end                     
               end             
                if (Info.Analysistype==5)
                    CreateReport('SAVECLOSE',Info.AcquisitionKey);
                    
                    %acqs = (Info.AcquisitionKey+1:1:Info.AcquisitionKey+400);
                    all_acqs = textread(acqs_filename,'%u');             
                    fid = fopen(acqs_filename,'w+');
                   
                    if length(all_acqs) > number_acqs
                        next_acqs = all_acqs(number_acqs+1:end);
                        fprintf(fid,'%u \n',next_acqs);
                        fclose(fid);
                        !matlab_run.bat;
                        quit;
                    else
                        %fprintf(fid,'%u \n',[]);
                        fclose(fid);
                        return;
                    end
                    
                    
                   % acquisitionkeyList = textread('P:\Temp\good films\Z2_test.txt','%u'); 
                   % save('P:\Temp\good films\list_me.txt','acqs', '-ascii');
                    %copyfile('P:\Temp\good films\list.txt','P:\Temp\good films\list.txt');
                   
                end
                Analysis.SXAMode='Manual';
                set(ctrl.Skip,'enable','off');
                set(ctrl.SaveNextPatient,'enable','off');
                set(ctrl.DontSaveNextPatient,'enable','off');
                set(ctrl.StopReading,'enable','off');
                set(f0.menu.DatabaseSave,'enable','on');
                Info.MultiAcquisitionAnalysis=false;
                Info.Operator=OperatorSave;
            end
        end

%% Common analysis from list
    case 'COMMONANALYSISFROMLIST'
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%% retrieve a common analysis %%%%%   Multi analysis possible
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        Info.CommonAnalysisKey=cell2mat(funcSelectInTable('RetrieveCommonAnalysis','Choose a common analysis',0,'Cancel'));
        if Info.CommonAnalysisKey~=0    %0 if if cancel button has not been pressed
            RetrieveInDatabase('COMMONANALYSIS');
            Info.FreeFormAnalysisKey=0;
            Info.SXAAnalysisKey=0;
        end

%% Freeform from list
    case 'FREEFROMFROMLIST'
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%% retrieve a freeforms analysis %%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        Info.FreeFormAnalysisKey=cell2mat(funcSelectInTable('Retrievefreeformanalysis','Choose a contour analysis',0,'Cancel'));
        if Info.FreeFormAnalysisKey~=0    %0 if if cancel button has not been pressed
            Database.Step=1;     %before 2
            RetrieveInDatabase('FREEFORMANALYSIS');
        end

%% SXA from list
    case 'SXAANALYSISFROMLIST'
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%% retrieve a SXA  analysis %%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        Info.SXAAnalysisKey=cell2mat(funcSelectInTable('RetrieveSXAanalysis','Choose a SXA analysis',0,'Cancel'));
        if Info.SXAAnalysisKey~=0    %0 if if cancel button has not been pressed
            Database.Step=1;    %before 2
            RetrieveInDatabase('SXAANALYSIS');
        end

%% Threshold from acquisititon list
    case 'THRESHOLDANALYSISFROMLIST'
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%% retrieve a threshold analysis %%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        Info.ThresholdAnalysisKey=cell2mat(funcSelectInTable('RetrieveThresholdanalysis','Choose a free form analysis',0,'Cancel'));
        if Info.ThresholdAnalysisKey~=0    %0 if if cancel button has not been pressed
            Database.Step=1;    %before 2
            RetrieveInDatabase('THRESHOLDANALYSIS');
        end
    
%% Acquisition
    case 'ACQUISITI_dxa'
        tic
        MachineParams = [];
        ReportText=[];
        Error=[];
        Error.Correction=false;
        Error.DENSITY=false;
        Error.BIGPADDLE=false;
        Error.HEIGHT=false;
        Error.SATURATION=false;
        Error.SuperLeanWarning=false;
        Error.PhantomDetection=0;
        Error.StepPhantomBBsFailure=0;
        Error.StepPhantomFailure=0;
        Error.StepPhantomReconstruction=0;
        Error.StepPhantomPosition=0; 
        Error.Correction=false;
        Error.NoCorrection=false;
        Error.RoomDetection=false;
        Error.MM=false;
       % Info.Analysistype = 0;
        flag.FileFromDatabase=true;
        Info.ChestWallID=0;
        Info.Database=true;
        Info.DXAAnalysisRetrieved = false;
        Threshold.DXAComputed=false;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%% retrieve the  acquisition named acquisitionkey %%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        kGE = 0.71;
        %execute SQL command
        b=mxDatabase(Database.Name,['select * from acquisition where acquisition_id=',num2str(Info.AcquisitionKey)]);
        fname=strcat(cell2mat(b(17)),'');   %erase extra ' '
        %Info.fname = fname;
        %fname(1:2) = [];
        index_slash = find(fname=='\');
        full_fname = fname;
        fname = fname(index_slash(end): end);
        
        str = computer;
        
        %digitizer
        SQLstatement=['select digitizer.digitizer_id,Digitizer_description from acquisition,digitizer where acquisition_id=',num2str(Info.AcquisitionKey),' and digitizer.digitizer_id=acquisition.digitalizer_id'];
        a=mxDatabase(Database.Name,SQLstatement);
        Info.DigitizerId=cell2mat(a(1));
        Info.DigitizerDescription=cell2mat(a(2));
        film_identifier = lower(b(5));
        film_identifier = film_identifier{1};
        study_id = lower(b(2));
        study_id = study_id(1);
        Info.study_id = study_id;
        Analysis.film_identifier = film_identifier;
        
        if Info.DigitizerId >= 5 & Info.DigitizerId <= 7
            crop_coef = kGE;
        else
            crop_coef = 1;
        end
        
        if Info.DigitizerId >= 4 | Info.DigitizerId == 5%digital 
            dvd_str = findstr('dvd',film_identifier);
            date_acq = b{1,6};
            Info.date_acq = date_acq;
            
            if ~strcmp(Database.Name,'mammo')
                c=mxDatabase(Database.Name,['select * from DICOMinfo where DICOM_ID =(select DICOM_id from acquisition where acquisition_id=',num2str(Info.AcquisitionKey),')']);
                %image_columns =mxDatabase(Database.Name,['select columns from DICOMinfo where DICOM_ID =(select DICOM_id from acquisition where acquisition_id=',num2str(Info.AcquisitionKey),')']);
                                
                if ~isempty(c)
                     date_acq = c{1,204};
                     image_columns = cell2mat(c(29))/2;
                      if image_columns > 1350*crop_coef
                         flag.small_paddle = false;
                        else
                            flag.small_paddle = true;
                        end
                else
                     cacq =mxDatabase(Database.Name,['select * from acquisition where acquisition_id=',num2str(Info.AcquisitionKey)]);
                     date_acq = cacq{1,6};       
                     image_size = cacq{1,20}; 
                      if image_size > 3288177
                    flag.small_paddle = false;
                else
                    flag.small_paddle = true;
                 end
                end 
              Info.date_acq = date_acq;
                
                folder = [date_acq(1:4),'-',date_acq(5:6),'\'];
            end
            
            folder = [date_acq(1:4),'-',date_acq(5:6)];
            if (strcmp(film_identifier(1:3),'cpm') | strcmp(film_identifier(1:3),'har') | ~isempty(dvd_str) | strcmp(film_identifier(1:3),'not')) %for CPMC
                if strcmp(str,'PCWIN64')
                    %start_dir = 'D:\aaDATA\Breast Studies\CPMC';
                    start_dir = 'E:\aaDATA\Breast Studies\CPMC\DicomImagesBlinded(digi)\';
                    startdir_report = 'E:\aaDATA\Breast Studies\CPMC';
                else
                    start_dir = '\\ming.radiology.ucsf.edu\aaDATA2\Breast Studies\CPMC\DicomImagesBlinded(digi)';
                    startdir_report = '\\ming.radiology.ucsf.edu\aaDATA2\Breast Studies\CPMC';
                end
            elseif strcmp(film_identifier(1:3),'mgh') % for MGH
                if strcmp(str,'PCWIN64')
                    %start_dir = 'D:\aaDATA\Breast Studies\CPMC';
                    start_dir = 'D:\aaDATA\Breast Studies\MGH\DicomImagesBlinded(digi)\2007-11\';
                    startdir_report = 'D:\aaDATA\Breast Studies\MGH';
                else
                    start_dir = '\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\MGH\DicomImagesBlinded(digi)';
                    startdir_report = '\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\MGH';
                end
            elseif strcmp(film_identifier(1:3),'uvm')  %for UVM
                if strcmp(str,'PCWIN64')
                    %start_dir = 'D:\aaDATA\Breast Studies\CPMC';
                    start_dir = 'D:\aaDATA\Breast Studies\UVM\DicomImagesBlinded(digi)\';
                    startdir_report = 'D:\aaDATA\Breast Studies\UVM';
                    folder = [];
                else
                    start_dir = '\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\UVM\DicomImagesBlinded(digi)';
                    startdir_report = '\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\UVM';
                    folder = [];
                end
            elseif ~isempty(strfind(study_id,'dxa'))
               if strcmp(str,'PCWIN64')
                   %start_dir = 'D:\aaDATA\Breast Studies\CPMC';
                   start_dir = 'D:\aaDATA';
                   startdir_report = 'D:\aaDATA\Breast Studies\Tlsty_P01_invivo';
               else
                   start_dir = '\\ming.radiology.ucsf.edu\aaDATA';
                   startdir_report = '\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\Tlsty_P01_invivo';
               end
               fname = full_fname(4:end); 
               folder = [];
            end
            %start_dir = [start_dir,'\',folder];
            startdir_wfolder = [start_dir,'\',folder];
        elseif Info.DigitizerId == 3 %analog
            if strcmp(str,'PCWIN64')
                %start_dir = 'D:\aaDATA\Breast Studies\CPMC';
                start_dir = 'D:\aaDATA\Breast Studies\CPMC\DicomImageBlinded\';
                startdir_report = 'D:\aaDATA\Breast Studies\CPMC';
            else
                start_dir = '\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\CPMC\DicomImageBlinded';
                startdir_report = '\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\CPMC';
            end
            folder = [];
        end  
        startdir_wfolder = [start_dir,'\',folder];
        fname = [startdir_wfolder,fname];         
        %fname = [start_dir,fname];
        %fname(1) = 'D'; % for digitizer1
        Info.fname = fname;
        Info.PatientID=cell2mat(b(3));
        Info.StudyID=cell2mat(b(2));
        
        %digitizer
       % SQLstatement=['select digitizer.digitizer_id,Digitizer_description from acquisition,digitizer where acquisition_id=',num2str(Info.AcquisitionKey),' and digitizer.digitizer_id=acquisition.digitalizer_id'];
       % a=mxDatabase(Database.Name,SQLstatement);
       % Info.DigitizerId=cell2mat(a(1));
       % Info.DigitizerDescription=cell2mat(a(2));
        
        if Info.DigitizerId == 3
            Analysis.Filmresolution  = 0.15; % in mm
        elseif Info.DigitizerId == 4
            Analysis.Filmresolution = 0.14;
        elseif Info.DigitizerId == 5
            Analysis.Filmresolution = 0.2;
        else
            Analysis.Filmresolution = 0.169;
        end
                
        %mAs
        SQLstatement=['select mAs from acquisition where acquisition_id=',num2str(Info.AcquisitionKey)];
        a=mxDatabase(Database.Name,SQLstatement);
        Info.mAs=cell2mat(a);
        
        %kVp
        SQLstatement=['select kVp from acquisition where acquisition_id=',num2str(Info.AcquisitionKey)];
        a=mxDatabase(Database.Name,SQLstatement);
        Info.kVp=cell2mat(a);

        %View
        SQLstatement=['select view_id from acquisition where acquisition_id=',num2str(Info.AcquisitionKey)];
        a=mxDatabase(Database.Name,SQLstatement);
        Info.ViewId=cell2mat(a);
        
        Info.FakeMAS=false;
        if (Info.mAs==0)||(Info.kVp==0)
            '!!!!!!!!!!!!!!! use follow up mAs, kVp !!!!!!!!!!!!!!!!!!!!!!!!'
           Settings=cell2mat(mxDatabase(Database.Name,['select mas,kvp from acquisition where patient_id=''',deblank(Info.PatientID),''' and study_id=''',deblank(Info.StudyID),''' and view_id=',num2str(Info.ViewId)]));
           Info.mAs=max(Settings(:,1));
           Info.kVp=max(Settings(:,2));
           Info.FakeMAS=true;
        end
        %ctr_kv = ctrl.kVp;
        set(ctrl.kVp,'string',num2str(Info.kVp));
        set(ctrl.mAs,'string',num2str(Info.mAs));

        %technique
        Info.technique=cell2mat(b(11));
        set(ctrl.technique,'value',Info.technique);

        %center
        Info.centerlistactivated=cell2mat(b(7)); %machine_id 
        temp_center = cell2mat(b(7));
        %strfind(Info.StudyID,'MGH')
        k = ~isempty(strfind(lower(film_identifier),lower('MGH')));
        p = ~isempty(strfind(lower(Info.StudyID),lower('MGH')));
        if ~isempty(strfind(lower(film_identifier),lower('MGH'))) | ~isempty(strfind(lower(Info.StudyID),lower('MGH')))
            switch temp_center
                case 1 
                    Info.centerlistactivated = 18;
                case 2
                   Info.centerlistactivated = 19;
                case 3
                    Info.centerlistactivated = 20;
                otherwise
                    ;
            end
        end
                     
        if  Info.centerlistactivated == 116
            Info.centerlistactivated = 39;
        end
        
        set(ctrl.Center,'value',Info.centerlistactivated);
        %Film identifier
        set(ctrl.comment,'string',deblank(b{5}));

        %FilmDate
        SQLstatement=['select date_acquisition from acquisition where acquisition_id=',num2str(Info.AcquisitionKey)];
        Info.FilmDate=cell2mat(mxDatabase(Database.Name,SQLstatement));
                
         Analysis.PhantomID=cell2mat(mxDatabase(Database.Name,['select phantom_id from acquisition where acquisition_id=',num2str(Info.AcquisitionKey)]));
         t1 = toc
         if Analysis.PhantomID == 9
             RetrieveInDatabase('MACHINEPARAMETERS');
         end
         %commented for automatic recalculation
         RetrieveInDatabase('QACODES');
         
        % RetrieveInDatabase('RECOGNITION');
         
         %PhantomReference
       
            Analysis.RefFat=cell2mat(mxDatabase(Database.Name,['select reffat from phantom,acquisition where acquisition.phantom_id=phantom.phantom_id and acquisition_id=',num2str(Info.AcquisitionKey)]));
            Analysis.RefGland=cell2mat(mxDatabase(Database.Name,['select refGland from phantom,acquisition where acquisition.phantom_id=phantom.phantom_id and acquisition_id=',num2str(Info.AcquisitionKey)]));
           % Analysis.PhantomID=cell2mat(mxDatabase(Database.Name,['select phantom_id from acquisition where acquisition_id=',num2str(Info.AcquisitionKey)]));
        if  Info.DigitizerId ~= 4
           RetrieveInDatabase('RECOGNITION');
        end
        '!!!!!!!! RETIEVEINDATABASE ACQUISITION MODIFIED !!!!!!!!!!!!!!!!!!!!!!!!'
        %set(ctrl.Cor,'value',true);      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SOY %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
        %Result.DXASelenia = false;
         %%%% Additional DXA information %%%
        
         %
        %FFHE_filename
        FF_dir = [startdir_wfolder,'Breast Studies\AL_SeleniaData\'];
        SQLstatement=['select FFHE_filename from acquisition where acquisition_id=',num2str(Info.AcquisitionKey)];
        FF_name   = strcat(cell2mat(mxDatabase(Database.Name,SQLstatement)));
        %FF_name   = char(mxDatabase(Database.Name,SQLstatement));
        InfoDXA.FFHE_filename = [FF_dir,FF_name];
        
        
        %Dark counts for the low energy image DCLE
        SQLstatement=['select DCLE from acquisition where acquisition_id=',num2str(Info.AcquisitionKey)];
        InfoDXA.DCLE=cell2mat(mxDatabase(Database.Name,SQLstatement));
        
        %Dark counts for the high energy image DCHE
        SQLstatement=['select DCHE from acquisition where acquisition_id=',num2str(Info.AcquisitionKey)];
        InfoDXA.DCHE=cell2mat(mxDatabase(Database.Name,SQLstatement));
        
        %Calibration_filename
        SQLstatement=['select Calibration_filename from acquisition where acquisition_id=',num2str(Info.AcquisitionKey)];
        calib_dir = [startdir_wfolder,'Breast Studies\AL_SeleniaData\CalibrationFiles\'];
        calib_name   =strcat(cell2mat(mxDatabase(Database.Name,SQLstatement)));
        InfoDXA.Calibration_filename = [calib_dir,calib_name];
        %}
        
        funcOpenImage(fname); % open the file named fname;
        
        [pathstr,name,ext,versn] = fileparts(fname)
        fmat_name = [pathstr(1:end-9),'mat_files\',name,'.mat']
        s=dir (fmat_name);
        if ~isempty(s)
            load(fmat_name);
        else
            fmat_name = [pathstr,'\',name(1:end-3),'.mat']
            load(fmat_name);
            info_dicom = info_dicom_blinded;
        end
        room_name = info_dicom.StationName;
        Info.Position = info_dicom.ViewPosition;
        Info.Laterality = info_dicom.ImageLaterality;
        Info.orientation = info_dicom.PatientOrientation;
        
        if Info.Database == true      
            if  (~isempty(strfind(Info.orientation,'A\F')))
                if isempty(strfind(Info.orientation,'A\FR'))                 
                    imagemenu('flipV');
                end
            elseif (~isempty(strfind(Info.orientation,'A\L')))
                imagemenu('flipV');
            elseif (~isempty(strfind(Info.orientation,'P\F')))
                if (~isempty(strfind(Info.orientation,'P\FL')))                 
                    imagemenu('flipV');
                    imagemenu('flipH');
                else
                    imagemenu('flipH');
                    imagemenu('flipV');
                end
            elseif (~isempty(strfind(Info.orientation,'P\H')))
                imagemenu('flipH');
            elseif (~isempty(strfind(Info.orientation,'P\L'))) 
                imagemenu('flipH');
                imagemenu('flipV');
            elseif (~isempty(strfind(Info.orientation,'P\R')))
                imagemenu('flipH');
            elseif (~isempty(strfind(Info.orientation,'A\H'))) %A\H and A\R are not required any flipping
                ;
            elseif (~isempty(strfind(Info.orientation,'A\R')))
                ;
            elseif (~isempty(strfind(Info.orientation,'film')))
                ;
            end  
        end   
        
        %{
        if ~(Info.Analysistype==16 | Result.DXASelenia == true)  % %isempty(strfind(study_id,'dxa'))  Info.Analysistype==5
            if Info.DigitizerId == 4
                if (strcmp(film_identifier(1:3),'mgh') | Info.centerlistactivated == 116)
                    if Info.ViewId==2
                        imagemenu('flipV');
                        imagemenu('flipH');
                    end
                else
                    if Info.ViewId==2
                        imagemenu('flipV');
                    elseif Info.ViewId==3
                        imagemenu('flipH');
                    elseif Info.ViewId==4
                        imagemenu('flipV');
                    elseif Info.ViewId==5
                        imagemenu('flipH');
                    elseif Info.ViewId==1
                        imagemenu('flipH'); 
                        imagemenu('flipV');
                    end
                end
            end
        end
           %}
           
        ROI = [];   
        %Analysis.BackGroundComputed=false; 
        Analysis=ComputeBackGroundV2(Analysis,Image,Info,ctrl);
        % ax = 1;
        if Analysis.PhantomID == 9
            if Image.columns < 1350  %small paddle
                params_temp = [MachineParams.thicknessSmall_corr,MachineParams.rxSmall_corr,MachineParams.rySmall_corr];
                MachineParams.bucky_distance = params_temp(1);
                MachineParams.rx_correction = params_temp(2);
                MachineParams.ry_correction = params_temp(3); 
            else
                params_temp = [MachineParams.thicknessBig_corr,MachineParams.rxBig_corr,MachineParams.ryBig_corr];
                MachineParams.bucky_distance = params_temp(1);
                MachineParams.rx_correction = params_temp(2);
                MachineParams.ry_correction =  params_temp(3);
            end
        end
        %}
        set(ctrl.CheckAutoROI,'value',true);
        set(ctrl.text_zone,'String',['Ok ']); %,Info.Comments
        %CharacterRecognition('CharacterRecognition');
        
%% Acquisition
    case 'ACQUISITION'       
         ROI = [];
        MachineParams = [];
        ReportText=[];
        Error=[];
        Error.Correction=false;
        Error.DENSITY=false;
        Error.BIGPADDLE=false;
        Error.HEIGHT=false;
        Error.SATURATION=false;
        Error.SuperLeanWarning=false;
        Error.PhantomDetection=0;
        Error.StepPhantomBBsFailure=0;
        Error.StepPhantomFailure=0;
        Error.StepPhantomReconstruction=0;
        Error.StepPhantomPosition=0;
        Error.Correction=false;
        Error.NoCorrection=false;
        Error.RoomDetection=false;
        Error.SkinEdgeFailed=false;
        Error.MM=false;
        % Info.Analysistype = 0;
        flag.FileFromDatabase=true;
        Info.ChestWallID=0;
        Info.Database=true;
        flag.small_paddle = [];
         
        Info.DXAAnalysisRetrieved = false;
        Threshold.DXAComputed=false;
               
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%% retrieve the  acquisition named acquisitionkey %%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
          kGE = 0.71;
        
        key_ids = Info.AcquisitionKey
        %execute SQL command
      
  
        b=mxDatabase(Database.Name,['select * from [mammo_CPMC].[dbo].[acquisition] where acquisition_id=',num2str(Info.AcquisitionKey)]);
        fname=strcat(cell2mat(b(17)),'');   %erase extra ' '
        %Info.fname = fname;
        %fname(1:2) = [];
        %fname_init = fname;
        index_slash = find(fname=='\');
        fname = fname(index_slash(end)+1: end);
        fname_short = fname;
        str = computer;
        patient_id=cell2mat(b(3));
        Analysis.patient_id = patient_id;
        %digitizer
        SQLstatement=['select digitizer.digitizer_id,Digitizer_description from acquisition,digitizer where acquisition_id=',num2str(Info.AcquisitionKey),' and digitizer.digitizer_id=acquisition.digitalizer_id'];
        a=mxDatabase(Database.Name,SQLstatement);
        Info.DigitizerId=cell2mat(a(1));
        Info.DigitizerDescription=cell2mat(a(2));
        Info.study_id = lower(b(2));
        date_driveI = datenum('20081231', 'yyyymmdd');
        date_driveKM = datenum('20090930', 'yyyymmdd');
        date_driveK = datenum('20110630', 'yyyymmdd');
        date_driveN = datenum('20120601', 'yyyymmdd');
        date_driveNK=datenum('20120501', 'yyyymmdd'); % Modified by Amir 04032013
        if ~isempty(cell2mat(b(2)))
            study_id = lower(b(2));
            study_id = study_id{1};
        else
            study_id = 'none';
        end
        %%%%%%%%%%%%%%%%%% Error: It was before declaration of digitizer
        %%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%
        if Info.DigitizerId >= 5 & Info.DigitizerId <= 7
            crop_coef = kGE;
        else
            crop_coef = 1;
        end
        
        if ~isempty(cell2mat(b(5)))
            film_identifier = lower(b(5));
            film_identifier = film_identifier{1};
            try
                if film_identifier=='                    '
                    film_identifier = lower(b(2));
                    film_identifier = film_identifier{1};
                end
            end
        else
            film_identifier = 'none';
        end
        Analysis.film_identifier = film_identifier;
        [ret, comp_name] = system('hostname');
        image_columns = [];
        image_size = [];
        if Info.DigitizerId >= 4  & Info.DigitizerId <= 7 %| Info.DigitizerId == 11 %digitalInfo.DigitizerId >= 4 %digital
            dvd_str = findstr('dvd',film_identifier);
            date_acq = b{1,6}; %5/1/09: % JW replaced with study_date from DICOMinfo table
            Info.date_acq = date_acq;
            if ~strcmp(Database.Name,'mammo')
                c=mxDatabase(Database.Name,['select * from DICOMinfo where DICOM_ID =(select DICOM_id from acquisition where acquisition_id=',num2str(Info.AcquisitionKey),')']);
                %image_columns =mxDatabase(Database.Name,['select columns from DICOMinfo where DICOM_ID =(select DICOM_id from acquisition where acquisition_id=',num2str(Info.AcquisitionKey),')']);
                                
                if ~isempty(c)
                     date_acq = c{1,204};
                     image_columns = cell2mat(c(29))/2;
                      if image_columns > 1350*crop_coef
                         flag.small_paddle = false;
                        else
                            flag.small_paddle = true;
                        end
                else
                     cacq =mxDatabase(Database.Name,['select * from acquisition where acquisition_id=',num2str(Info.AcquisitionKey)]);
                     date_acq = cacq{1,6};       
                     image_size = cacq{1,20}; 
                      if image_size > 3288177
                    flag.small_paddle = false;
                else
                    flag.small_paddle = true;
                 end
                end 
              Info.date_acq = date_acq;
                
                folder = [date_acq(1:4),'-',date_acq(5:6),'\'];
            end
            
            fg = strcmp(film_identifier(1:3),'non')
            
            if (strcmp(film_identifier(1:3),'cpm') | strcmp(film_identifier(1:4),'cpuc') | strcmp(film_identifier(1:3),'har') | ~isempty(dvd_str) | strcmp(film_identifier(1:3),'not') | strcmp(film_identifier(1:3),'non')| strcmp(film_identifier(1),'0') | strcmp(film_identifier(1),'1')) %for CPMC
                date_acq_num = datenum(date_acq, 'yyyymmdd');
                %date_driveI = datenum('20081231', 'yyyymmdd');
                %date_driveK = datenum('20110630', 'yyyymmdd');
                
                if date_acq_num > date_driveN
                    start_dir = '\\researchstg\aaDATA8\Lucyz-Desktop\Breast Studies\CPMC\DicomImagesBlinded(digi)';
                    startdir_report = '\\researchstg\aaDATA8\Lucyz-Desktop\Breast Studies\CPMC';
                elseif date_acq_num > date_driveK
                    start_dir = '\\researchstg\aaDATA5\Breast Studies\CPMC\DicomImagesBlinded(digi)';
                    startdir_report = '\\researchstg\aaDATA5\Breast Studies\CPMC';
                elseif date_acq_num > date_driveI
                    start_dir = '\\researchstg\aaDATA4\Breast Studies\CPMC\DicomImagesBlinded(digi)';
                    startdir_report = '\\researchstg\aaDATA4\Breast Studies\CPMC';
                else
                    start_dir = '\\ming\aadata2\Breast Studies\CPMC\DicomImagesBlinded(digi)';
                    startdir_report = '\\ming\aadata2\Breast Studies\CPMC';
                    
                end
            elseif strcmp(film_identifier(1:3),'mgh') % for MGH
                date_acq_num = datenum(date_acq, 'yyyymmdd');
%                 if date_acq_num > date_driveNK % added by Amir 04032013
%                     start_dir = '\\researchstg\aaDATA8\Lucyz-Desktop\Breast Studies\MGH\DicomImagesBlinded(digi)'; %Added by Amir 04032013
%                     startdir_report = '\\researchstg\aaDATA8\Lucyz-Desktop\Breast Studies\MGH'; %Added by Amir 04032013
%                 elseif date_acq_num > date_driveKM % (else added to if)Updated by Amir 04032013
                     if date_acq_num > date_driveKM
                    if strcmp(comp_name(1:4),'Ming')
                        %start_dir = 'D:\aaDATA\Breast Studies\CPMC';
                        start_dir = 'K:\aaDATA5\Breast Studies\MGH\DicomImagesBlinded(digi)';
                        startdir_report = 'K:\aaDATA5\Breast Studies\MGH';
                    else
                        start_dir = '\\researchstg\aaDATA5\Breast Studies\MGH\DicomImagesBlinded(digi)'; 
                        startdir_report = '\\researchstg\aaDATA5\Breast Studies\MGH';
                    end
                else
                    if strcmp(comp_name(1:4),'Ming')
                        %start_dir = 'D:\aaDATA\Breast Studies\CPMC';
                        start_dir = 'L:\aaDATA6\Breast Studies\MGH\DicomImagesBlinded(digi)';
                        startdir_report = 'L:\aaDATA6\Breast Studies\MGH';
                    else
                        start_dir = '\\researchstg\aaDATA6\Breast Studies\MGH\DicomImagesBlinded(digi)';
                        startdir_report = '\\researchstg\aaDATA6\Breast Studies\MGH';
                    end
                end
            elseif strcmp(film_identifier(1:3),'uvm')  %for UVM
                if strcmp(comp_name(1:4),'Ming')
                    start_dir = 'H:\aaDATA3\Breast Studies\UVM\DicomImagesBlinded(digi)';
                    startdir_report = 'H:\aaDATA3\Breast Studies\UVM';
                else
                    start_dir = '\\researchstg\aaDATA3\Breast Studies\UVM\DicomImagesBlinded(digi)';
                    startdir_report = '\\researchstg\aaDATA3\Breast Studies\UVM';
                end
                folder = [];
            elseif strcmp(film_identifier(1:3),'ucs')  %for UCSF
                 if strcmp(patient_id(1:4),'3C01')
                      start_dir = ['\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\',patient_id(1:7),'\png_files'];
                      startdir_report = '\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\'; 
                      folder = [];                  
                 elseif  ~isempty(strfind(film_identifier,'ucsf_03-12-2014')) 
                      start_dir = ['\\researchstg\aaStudies\Breast Studies\3CB R01\Source Data\Tissue Homogenization Project\E1111112029L\png_files'];
                      startdir_report = '\\researchstg\aaStudies\Breast Studies\3CB R01\Source Data\Tissue Homogenization Project\E1111112029L\'; 
                      folder = [];         
                  
                 else
                     start_dir = '\\researchstg\aaDATA6\Breast Studies\UCSFMedCtr\DicomImagesBlinded(digi)';
                        startdir_report = '\\researchstg\aaDATA6\Breast Studies\UCSFMedCtr';
                    
                 end
            elseif strcmp(film_identifier(1:3),'mof')  %for UCSF
                      start_dir = ['\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\Moffitt\',patient_id(1:7),'\png_files']; 
                      startdir_report = '\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\Moffitt\'; 
                      folder = [];                  
                
            elseif  ~isempty(strfind(film_identifier,'nc'))%strcmp(film_identifier(1:2),'nc')  %for NC
                if strcmp(comp_name(1:4),'Ming')
                    start_dir = 'K:\aaData5\Breast Studies\NC\DicomImagesBlinded(digi)'; % (aaData4 changed to aaData5) updated by Amir 04032013
                    startdir_report = 'K:\aaData5\Breast Studies\NC';%(aaData4 changed to aaData5)updated by Amir 04032013
                else
                    start_dir = '\\researchstg\aaDATA5\Breast Studies\NC\DicomImagesBlinded(digi)';%(aaData4 changed to aaData5) updated by Amir 04032013
                    startdir_report = '\\researchstg\aaDATA5\Breast Studies\NC';%(aaData3 changed to aaData5) updated by Amir 04032013
                end
                folder = [];
                %Case added for Avon, by Song, 1/24/11
            elseif strcmpi(film_identifier(1:3), 'avo')     %for Avon
                if strcmp(comp_name(1:4),'Ming')
                    start_dir = 'D:\aaData\Breast Studies\Shanghai\DicomImagesBlinded(digi)';
                    startdir_report = 'D:\aaData\Breast Studies\Shanghai';
                else
                    start_dir = '\\researchstg\aaData\Breast Studies\Shanghai\DicomImagesBlinded(digi)';
                    startdir_report = '\\researchstg\aaData\Breast Studies\Shanghai';
                end
                folder = [];
                %End of change by Song, 1/24/11
                %Case for Marsden images acquired separately for Volpara, JW 11/7/12
            elseif strcmpi(film_identifier(1:18), 'marsden_11-07-2012')      
                if strcmp(comp_name(1:4),'Ming')
                    start_dir = 'K:\aaData5\Breast Studies\Marsden\DicomImagesBlinded(digi)';
                    startdir_report = 'K:\aaData5\Breast Studies\Marsden';
                else
                    start_dir = '\\researchstg\aaData5\Breast Studies\Marsden\DicomImagesBlinded(digi)';
                    startdir_report = '\\researchstg\aaData5\Breast Studies\Marsden';
                end
                folder = [];
                %End change by JW 11/7/12                
                %Case added for Marsden, by Song, 1/26/11
            elseif strcmpi(film_identifier(1:3), 'mar')     %for Marsden
                if strcmp(comp_name(1:4),'Ming')
                    start_dir = 'H:\aaData3\Breast Studies\Marsden\DicomImagesBlinded(digi)';
                    startdir_report = 'H:\aaData3\Breast Studies\Marsden';
                else
                    start_dir = '\\researchstg\aaData3\Breast Studies\Marsden\DicomImagesBlinded(digi)';
                    startdir_report = '\\researchstg\aaData3\Breast Studies\Marsden';
                end
                folder = [];
                %End of change by Song, 1/26/11
                %startdir_wfolder = [start_dir,'\',folder];
                %%% JW added 9/3/09 for Bayer GE 2000D images %%%
            elseif strcmp(film_identifier(1:3),'p01')||strcmp(film_identifier(1:3),'po1')||strcmp(film_identifier(1:3),'PO1')
                if strcmp(comp_name(1:4),'Ming')
                    %start_dir = 'D:\aaDATA\Breast Studies\CPMC';
                    start_dir = 'D:\aadata\Breast Studies\Tlsty_P01_invivo\P01';
                    startdir_report = 'D:\aadata\Breast Studies\Tlsty_P01_invivo\P01';
                else
                    if strcmp(b(16),'01-Feb-2010         ')
                        start_dir = '\\researchstg.radiology.ucsf.edu\working_directory\projects-snap\aaSTUDIES\Breast Studies\TLSTY_P01_invivo\Source Data\Mammograms\second batch\DicomImagesBlinded';
                        startdir_report = '\\researchstg\aadata\Breast Studies\Tlsty_P01_invivo\AutomaticAnalysisReports';
                    else
                        start_dir = '\\researchstg\aadata\Breast Studies\Tlsty_P01_invivo\P01';
                        startdir_report = '\\researchstg\aadata\Breast Studies\Tlsty_P01_invivo\AutomaticAnalysisReports';
                    end
                end
                folder = [];
            elseif strcmp(film_identifier(1:2),'3c')
                if strcmp(comp_name(1:4),'Ming')
                    %start_dir = 'D:\aaDATA\Breast Studies\CPMC';
                    start_dir = 'D:\aaDATA\Breast Studies\3C_data';
                    startdir_report = 'D:\aaDATA\Breast Studies\3C_data\AutomaticAnalysisReports';
                else
                    start_dir = '\\researchstg\aaDATA\Breast Studies\3C_data';
                    startdir_report = '\\researchstg\aaDATA\Breast Studies\3C_data\AutomaticAnalysisReports';
                end
                
                folder = [];
                tempfname=strcat(cell2mat(b(17)),'');   %erase extra ' '
                index_slash = find(tempfname=='\');
                folder = tempfname(index_slash(end-2)+1: index_slash(end));

            elseif ~isempty(strfind(study_id,'bayer'))
                if strcmp(comp_name(1:4),'Ming')
                    if Info.DigitizerId == 8 || Info.DigitizerId == 5 || Info.DigitizerId == 4 || Info.DigitizerId == 11
                        start_dir = 'D:\Working_Directory\Projects-Snap\aaSTUDIES\Breast Studies\Bayer 2009 (bay09)\SOURCE DATA\DicomImagesBlinded';
                        startdir_report = 'D:\Working_Directory\Projects-Snap\aaSTUDIES\Breast Studies\Bayer 2009 (bay09)\SOURCE DATA';
                    else
                        %start_dir = 'D:\aaDATA\Breast Studies\CPMC';P:\aaSTUDIES\Breast Studies\Bayer 2009 (bay09)\SOURCE DATA\DigitizedImages\Bayer8001282V1LCC.dcm
                        start_dir = 'D:\Working_Directory\Projects-Snap\aaSTUDIES\Breast Studies\Bayer 2009 (bay09)\SOURCE DATA\DigitizedImages';
                        startdir_report = 'D:\Working_Directory\Projects-Snap\aaSTUDIES\Breast Studies\Bayer 2009 (bay09)\SOURCE DATA';
                    end
                else
                    if Info.DigitizerId == 8 || Info.DigitizerId == 5 || Info.DigitizerId == 4 || Info.DigitizerId == 11
                        start_dir = '\\researchstg\Working_Directory\Projects-Snap\aaSTUDIES\Breast Studies\Bayer 2009 (bay09)\SOURCE DATA\DicomImagesBlinded';
                        startdir_report = '\\researchstg\Working_Directory\Projects-Snap\aaSTUDIES\Breast Studies\Bayer 2009 (bay09)\SOURCE DATA';
                    else
                        start_dir = '\\researchstg\Working_Directory\Projects-Snap\aaSTUDIES\Breast Studies\Bayer 2009 (bay09)\SOURCE DATA\DigitizedImages';
                        startdir_report = '\\researchstg\Working_Directory\Projects-Snap\aaSTUDIES\Breast Studies\Bayer 2009 (bay09)\SOURCE DATA';
                    end
                end
                folder = [];
                %%%end JW added 9/3/09 %%%
            end
        elseif Info.DigitizerId == 3 %analog
            if strcmp(comp_name(1:4),'Ming')
                %start_dir = 'D:\aaDATA\Breast Studies\CPMC';
                start_dir = 'K:\aaDATA5\CPMC(analog)\DicomImageBlinded';
                startdir_report = 'K:\aaDATA5\CPMC(analog)';
            else
                start_dir = '\\researchstg\aaDATA5\CPMC(analog)\DicomImageBlinded';
                startdir_report = '\\researchstg\aaDATA5\CPMC(analog)';
            end
            folder = [];
        elseif Info.DigitizerId == 1 | Info.DigitizerId >= 8 & Info.DigitizerId <= 11
            if ~isempty(strfind(lower(study_id),lower('mayo'))) %strcmp(study_id,'mayo') %~isempty(strfind(lower(film_identifier),lower('MGH')));
                start_dir = '\\digitizer1\d\DicomImages\Bo_files\Dicom\png_files';
                startdir_report = start_dir;
                folder = [];
            elseif ~isempty(strfind(study_id,'bayer'))
                if strcmp(comp_name(1:4),'Ming')
                    if Info.DigitizerId >= 8 & Info.DigitizerId <= 11
                        start_dir = 'D:\Working_Directory\Projects-Snap\aaSTUDIES\Breast Studies\Bayer 2009 (bay09)\SOURCE DATA\DicomImagesBlinded';
                        startdir_report = 'D:\Working_Directory\Projects-Snap\aaSTUDIES\Breast Studies\Bayer 2009 (bay09)\SOURCE DATA';
                    else
                        %start_dir = 'D:\aaDATA\Breast Studies\CPMC';P:\aaSTUDIES\Breast Studies\Bayer 2009 (bay09)\SOURCE DATA\DigitizedImages\Bayer8001282V1LCC.dcm
                        start_dir = 'D:\Working_Directory\Projects-Snap\aaSTUDIES\Breast Studies\Bayer 2009 (bay09)\SOURCE DATA\DigitizedImages';
                        startdir_report = 'D:\Working_Directory\Projects-Snap\aaSTUDIES\Breast Studies\Bayer 2009 (bay09)\SOURCE DATA';
                    end
                else
                    if Info.DigitizerId >= 8 & Info.DigitizerId <= 11
                        start_dir = '\\researchstg\Working_Directory\Projects-Snap\aaSTUDIES\Breast Studies\Bayer 2009 (bay09)\SOURCE DATA\DicomImagesBlinded';
                        startdir_report = '\\researchstg\Working_Directory\Projects-Snap\aaSTUDIES\Breast Studies\Bayer 2009 (bay09)\SOURCE DATA';
                    else
                        start_dir = '\\researchstg\Working_Directory\Projects-Snap\aaSTUDIES\Breast Studies\Bayer 2009 (bay09)\SOURCE DATA\DigitizedImages';
                        startdir_report = '\\researchstg\Working_Directory\Projects-Snap\aaSTUDIES\Breast Studies\Bayer 2009 (bay09)\SOURCE DATA';
                    end
                end
                folder = [];
            end
        end
        
        %         elseif Info.DigitizerId == 1
        %             if ~isempty(strfind(lower(study_id),lower('mayo'))) %strcmp(study_id,'mayo') %~isempty(strfind(lower(film_identifier),lower('MGH')));
        %                 start_dir = '\\digitizer1\d\DicomImages\Bo_files\Dicom\png_files';
        %                 startdir_report = start_dir;
        %                 folder = [];
        %             end
        %         end
        startdir_wfolder = [start_dir,'\',folder];
        
        % fname = [start_dir,'\',fdir_name,fname]; %commented for temporary
        
        fname = [startdir_wfolder,fname];
        %fname(1) = 'D'; % for digitizer1
        Info.PatientID=cell2mat(b(3));
        Info.StudyID=cell2mat(b(2));
        
        %digitizer
        % SQLstatement=['select digitizer.digitizer_id,Digitizer_description from acquisition,digitizer where acquisition_id=',num2str(Info.AcquisitionKey),' and digitizer.digitizer_id=acquisition.digitalizer_id'];
        % a=mxDatabase(Database.Name,SQLstatement);
        % Info.DigitizerId=cell2mat(a(1));
        % Info.DigitizerDescription=cell2mat(a(2));
        crop_coef  = 1;
        if Info.DigitizerId == 3
            Analysis.Filmresolution  = 0.15; % in mm
        elseif Info.DigitizerId == 4
            Analysis.Filmresolution = 0.14;
        elseif Info.DigitizerId >= 5 & Info.DigitizerId <= 7
            Analysis.Filmresolution = 0.2;
            crop_coef = 0.71;
       else
            Analysis.Filmresolution = 0.169;
        end
        
        %Read mAs, kVp and view_id by one query. Combined by Song 6-23-2010
        %mAs, kVp, view_id & date_acquisition
        SQLstatement=['select mAs, kVp, view_id, date_acquisition from acquisition where acquisition_id=',num2str(Info.AcquisitionKey)];
        a=mxDatabase(Database.Name,SQLstatement);
        Info.mAs=a{1};
        Info.kVp = a{2};
        Info.ViewId = a{3};
        Info.acqDate = strtrim(a{4});
        
        %         %kVp
        %         SQLstatement=['select kVp from acquisition where acquisition_id=',num2str(Info.AcquisitionKey)];
        %         a=mxDatabase(Database.Name,SQLstatement);
        %         Info.kVp=cell2mat(a);
        %
        %         %View
        %         SQLstatement=['select view_id from acquisition where acquisition_id=',num2str(Info.AcquisitionKey)];
        %         a=mxDatabase(Database.Name,SQLstatement);
        %         Info.ViewId=cell2mat(a);
        
        if Info.DigitizerId >3
            %if Info.DigitizerId >3 & Info.DigitizerId ~= 8 & Info.DigitizerId ~= 11 & Info.DigitizerId ~= 10
            if  ~strcmp(Database.Name,'mammo')
                SQLstatement=['select DICOM_ID  from acquisition where acquisition_id=',num2str(Info.AcquisitionKey)];
                [dicom_id] = cell2mat(mxDatabase(Database.Name,SQLstatement));
                SQLstatement=['select PatientOrientation, StationName from DICOMinfo where DICOM_ID=',num2str(dicom_id)];
                Info.orientation = cell2mat(mxDatabase(Database.Name,SQLstatement));
                SQLstatement=['select StationName from DICOMinfo where DICOM_ID=',num2str(dicom_id)];
                station_name = cell2mat(mxDatabase(Database.Name,SQLstatement));
            else
                Info.orientation = 'film';
            end
            
            
            %             SQLstatement=['select DICOM_ID from acquisition where acquisition_id=',num2str(Info.AcquisitionKey)];
            %             dicom_id = cell2mat(mxDatabase(Database.Name,SQLstatement));
            %             SQLstatement=['select PatientOrientation from DICOMinfo where DICOM_ID=',num2str(dicom_id)];
            %             Info.orientation = cell2mat(mxDatabase(Database.Name,SQLstatement));
            %%%%%%%%% extraction of Info.orientation without dicominfo table
            %{
              [pathstr,name,ext,versn] = fileparts(fname)
              fmat_name = [pathstr(1:end-9),'mat_files\',name,'.mat']
              s=dir (fmat_name);
              if ~isempty(s)
                  load(fmat_name);
              else
                  fmat_name = [pathstr,'\',name(1:end-3),'.mat']
                  load(fmat_name);
                  info_dicom = info_dicom_blinded;
              end
              Info.orientation = info_dicom.PatientOrientation;
            %}
        else
            Info.orientation = 'film';
        end
        
        
        
        
        Info.FakeMAS=false;
        if (Info.mAs==0)||(Info.kVp==0)
            '!!!!!!!!!!!!!!! use follow up mAs, kVp !!!!!!!!!!!!!!!!!!!!!!!!'
            Settings=cell2mat(mxDatabase(Database.Name,['select mas,kvp from acquisition where patient_id=''',deblank(Info.PatientID),''' and study_id=''',deblank(Info.StudyID),''' and view_id=',num2str(Info.ViewId)]));
            Info.mAs=max(Settings(:,1));
            Info.kVp=max(Settings(:,2));
            Info.FakeMAS=true;
        end
        %ctr_kv = ctrl.kVp;
        set(ctrl.kVp,'string',num2str(Info.kVp));
        set(ctrl.mAs,'string',num2str(Info.mAs));
        
        %technique
        Info.technique=cell2mat(b(11));
        set(ctrl.technique,'value',Info.technique);
        
        %center
        Info.centerlistactivated=cell2mat(b(7));
%         if Info.centerlistactivated == 46
%              Analysis.Filmresolution = 0.131; % added for UK Selenia 12.10.12
%         end
        
        temp_center = cell2mat(b(7));
        %strfind(Info.StudyID,'MGH')
        k = ~isempty(strfind(lower(film_identifier),lower('MGH')));
        p = ~isempty(strfind(lower(Info.StudyID),lower('MGH')));
        if ~isempty(strfind(lower(film_identifier),lower('MGH'))) | ~isempty(strfind(lower(Info.StudyID),lower('MGH')))
            switch temp_center
                case 1
                    Info.centerlistactivated = 18;
                case 2
                    Info.centerlistactivated = 19;
                case 3
                    Info.centerlistactivated = 20;
                otherwise
                    ;
            end
        end
        
        if ~isempty(strfind(lower(film_identifier),lower('uvm'))) | ~isempty(strfind(lower(Info.StudyID),lower('uvm')))
            if temp_center == 1
                Info.centerlistactivated = 29;
            end
        end
        
        if (strcmp(film_identifier(1:3),'cpm') & Info.DigitizerId >= 4)
            %set(ctrl.Center,'value',Info.centerlistactivated+10);
            if Info.centerlistactivated == 13
                Info.centerlistactivated = 3;
            end
            set(ctrl.Center,'value',Info.centerlistactivated);
        end
        
        % set(ctrl.Center,'value',Info.centerlistactivated);
        
        %Film identifier
        set(ctrl.comment,'string',deblank(b{5}));
        
        %FilmDate and timeAcq
        SQLstatement=['select date_acquisition, time_acquisition from acquisition where acquisition_id=',num2str(Info.AcquisitionKey)];
        entryRead = mxDatabase(Database.Name, SQLstatement);
        Info.FilmDate = entryRead{1};
        Info.timeAcq = entryRead{2};
        %         Info.FilmDate=cell2mat(mxDatabase(Database.Name,SQLstatement));
        
        Analysis.PhantomID=cell2mat(mxDatabase(Database.Name,['select phantom_id from acquisition where acquisition_id=',num2str(Info.AcquisitionKey)]));
        %%%%%%%%%% t1 = toc
        if Analysis.PhantomID == 9 %&& Info.Analysistype ~= 16)
            %condition analysis type ~= 16 is added by Song 6-24-2010
            %When analysistype == 16, retrive machine parameters after the
            %machine parameters are calculated from calibration.
            RetrieveInDatabase('MACHINEPARAMETERS');
        end
        
        %Added by Song 08-03-10
        %When Analysisyype == 16, read dark_counts for MachineParams,
        %which will be used in funcloadImage
        if Info.Analysistype == 16
            MachineParams.dark_counts = getDarkCounts(Database.Name, Info.centerlistactivated);
        end
        
        %commented for automatic recalculation
        RetrieveInDatabase('QACODES');
        
        % RetrieveInDatabase('RECOGNITION');
        
        %PhantomReference
        
        Analysis.RefFat=cell2mat(mxDatabase(Database.Name,['select reffat from phantom,acquisition where acquisition.phantom_id=phantom.phantom_id and acquisition_id=',num2str(Info.AcquisitionKey)]));
        Analysis.RefGland=cell2mat(mxDatabase(Database.Name,['select refGland from phantom,acquisition where acquisition.phantom_id=phantom.phantom_id and acquisition_id=',num2str(Info.AcquisitionKey)]));
        % Analysis.PhantomID=cell2mat(mxDatabase(Database.Name,['select phantom_id from acquisition where acquisition_id=',num2str(Info.AcquisitionKey)]));
        if  Info.DigitizerId == 1    %Info.DigitizerId ~= 4
            RetrieveInDatabase('RECOGNITION');
        end
        '!!!!!!!! RETIEVEINDATABASE ACQUISITION MODIFIED !!!!!!!!!!!!!!!!!!!!!!!!'
        %set(ctrl.Cor,'value',true);      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SOY %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
       % Result.DXASelenia = false;
        funcOpenImage(fname);
        
        %         if  (~isempty(strfind(Info.orientation,'P\R')) | ~isempty(strfind(Info.orientation,'P\F')) | ~isempty(strfind(Info.orientation,'P\H')))   %strfind(Info.orientation,'P\R')
        %             imagemenu('flipH');
        %         elseif (~isempty(strfind(Info.orientation,'P\L')) | ~isempty(strfind(Info.orientation,'P\FL')))
        %             imagemenu('flipH');
        %             imagemenu('flipV');
        %         elseif (~isempty(strfind(Info.orientation,'A\L')) | ~isempty(strfind(Info.orientation,'A\R'))) %strfind(Info.orientation,'A\L')
        %             imagemenu('flipV');
        %         end
        
        if Info.DigitizerId >= 8 & Info.DigitizerId <= 11 %| Info.DigitizerId == 1
            if Info.ViewId==2
                imagemenu('flipH');
            elseif Info.ViewId==3
                imagemenu('flipV');
            end
            
        else
            %if strcmp(study_id(1:3),'p01')
            %%% added 9/28/2009 JW to include Info.DICOMinfo field
            %                   SQLstatement= ['SELECT PatientOrientation FROM acquisition, DICOMinfo WHERE acquisition.DICOM_id = DICOMinfo.DICOM_id  AND acquisition.acquisition_id = ',num2str(Info.AcquisitionKey)];
            %                   Info.DICOMinfo.PatientOrientation=mxDatabase(Database.Name,SQLstatement);
            % %              Info.Position = Info.DICOMinfo.ViewPosition;
            % %              Info.Laterality = Info.DICOMinfo.ImageLaterality;
            %             Info.orientation = Info.DICOMinfo.PatientOrientation;
          if Result.DXASelenia ~= true
            if ~isempty(Info.orientation)  
                
                if  (~isempty(strfind(Info.orientation,'A\F')))
                    if ~isempty(strfind(Info.orientation,'A\FR'))
                        imagemenu('flipV');
                    end
                elseif (~isempty(strfind(Info.orientation,'A\L')))
                    imagemenu('flipV');
                elseif (~isempty(strfind(Info.orientation,'P\F')))
                    if (~isempty(strfind(Info.orientation,'P\FL')))
                        imagemenu('flipV');
                        imagemenu('flipH');
                    else
                        imagemenu('flipH');
                        imagemenu('flipV');
                    end
                elseif (~isempty(strfind(Info.orientation,'P\H')))
                    imagemenu('flipH');
                elseif (~isempty(strfind(Info.orientation,'P\L')))
                    imagemenu('flipH');
                    imagemenu('flipV');
                elseif (~isempty(strfind(Info.orientation,'P\R')))
                    imagemenu('flipH');
                elseif (~isempty(strfind(Info.orientation,'A\H'))) %A\H and A\R are not required any flipping
                    ;
                elseif (~isempty(strfind(Info.orientation,'A\R')))
                    ;
                elseif (~isempty(strfind(Info.orientation,'film')))
                    ;
                end
                %             else
                % %                  if  Info.ViewId==2
                % %                      imagemenu('flipV');
                % %                      imagemenu('flipH');
                % %                  end
                %             end
            else

                    if Info.DigitizerId >= 4
                if strcmp(film_identifier(1:3),'mgh')
                    if Info.ViewId==2
                        imagemenu('flipV');
                        imagemenu('flipH');
                    end
                elseif Info.DigitizerId == 5 | Info.DigitizerId == 6
                    if Info.ViewId==2
                        imagemenu('flipH');
                    ;
                    end
                else
                    if Info.ViewId==2 & Info.centerlistactivated ~= 39
                        imagemenu('flipV');
                    elseif Info.ViewId==3
                        imagemenu('flipH');
                    elseif Info.ViewId==4
                        imagemenu('flipV');
                    elseif Info.ViewId==5
                        imagemenu('flipH');
                    elseif Info.ViewId==1
                        imagemenu('flipH');
                        imagemenu('flipV');
                    elseif Info.ViewId==2 & Info.centerlistactivated == 39
                        imagemenu('flipH');    
                        imagemenu('flipV');
                    end
                end
                    end
            

            end
            
          end  
            
        end
        
        
        
        %{
            if Info.DigitizerId >= 4
                if strcmp(film_identifier(1:3),'mgh')
                    if Info.ViewId==2
                        imagemenu('flipV');
                        imagemenu('flipH');
                    end
                elseif Info.DigitizerId == 5 | Info.DigitizerId == 6
                    if Info.ViewId==2
                        imagemenu('flipH');
                    ;
                    end
                else
                    if Info.ViewId==2
                        imagemenu('flipV');
                    elseif Info.ViewId==3
                        imagemenu('flipH');
                    elseif Info.ViewId==4
                        imagemenu('flipV');
                    elseif Info.ViewId==5
                        imagemenu('flipH');
                    elseif Info.ViewId==1
                        imagemenu('flipH');
                        imagemenu('flipV');
                    end
                end
            end
        %}
        %        Analysis.BackGroundComputed=false;
        Analysis=ComputeBackGroundV2(Analysis,Image,Info,ctrl);
        % ax = 1;
        %Commented out by Song 07-19-2010
        %         if (Analysis.PhantomID == 9 && Info.Analysistype ~= 16)
        %              %condition analysis type ~= 16 is added by Song
        %              %When analysistype == 16, don't update MachineParams
        %             if Image.columns < 1350  %small paddle
        %                 params_temp = [MachineParams.thicknessSmall_corr,MachineParams.rxSmall_corr,MachineParams.rySmall_corr];
        %                 MachineParams.bucky_distance = params_temp(1);
        %                 MachineParams.rx_correction = params_temp(2);
        %                 MachineParams.ry_correction = params_temp(3);
        %             else
        %                 params_temp = [MachineParams.thicknessBig_corr,MachineParams.rxBig_corr,MachineParams.ryBig_corr];
        %                 MachineParams.bucky_distance = params_temp(1);
        %                 MachineParams.rx_correction = params_temp(2);
        %                 MachineParams.ry_correction =  params_temp(3);
        %             end
        %         end
        %}
        
        
        if Analysis.PhantomID == 9
            if flag.small_paddle %Image.columns < 1350  %small paddle
                params_temp = [MachineParams.thicknessSmall_corr,MachineParams.rxSmall_corr,MachineParams.rySmall_corr];
                MachineParams.bucky_distance = params_temp(1) + Analysis.error_thickDB*0.1;
                MachineParams.rx_correction = params_temp(2);
                MachineParams.ry_correction = params_temp(3);
                MachineParams.padSize = 'Small';
            else
                params_temp = [MachineParams.thicknessBig_corr,MachineParams.rxBig_corr,MachineParams.ryBig_corr];
                MachineParams.bucky_distance = params_temp(1) + Analysis.error_thickDB*0.1;
                MachineParams.rx_correction = params_temp(2);
                MachineParams.ry_correction =  params_temp(3);
                MachineParams.padSize = 'Large';
            end
        end
        
        set(ctrl.CheckAutoROI,'value',true);
        set(ctrl.text_zone,'String',['Ok ']); %,Info.Comments
        %CharacterRecognition('CharacterRecognition');
        
        %%%JW added 9/1/2011 for creating DICOMs and
        %%%pushing to Quantra system for "Volumetric Assessment" (SMF density analysis)
        compname=getenv('COMPUTERNAME');
        if Info.Operator == 11 && strcmp(compname,'QUANTRA');
            PullImages_CreateDICOMs_PushToQuantra(film_identifier, Info.AcquisitionKey);
        end
        %%%end addition
        
        
        
%% MACHINE PARAMETERS
    case 'MACHINEPARAMET_old'
         tic
          MachineParams = [];
          %Info.centerlistactivated = 1;
          param_list=mxDatabase(Database.Name,['select * from MachineParameters where machine_id=',num2str(Info.centerlistactivated)]);
          param_list = param_list(1,:);
          MachineParams.x0_shift = cell2mat(param_list(2))/Analysis.Filmresolution*10;
          MachineParams.y0_shift = cell2mat(param_list(3))/Analysis.Filmresolution*10;
          MachineParams.source_height = cell2mat(param_list(4));
          MachineParams.dark_counts = cell2mat(param_list(6));
          MachineParams.thicknessSmall_corr = cell2mat(param_list(7));
          MachineParams.rxSmall_corr = cell2mat(param_list(8));
          MachineParams.rySmall_corr = cell2mat(param_list(9));
          MachineParams.thicknessBig_corr = cell2mat(param_list(10));
          MachineParams.rxBig_corr = cell2mat(param_list(11));
          MachineParams.ryBig_corr = cell2mat(param_list(12));
          MachineParams.linear_coef = 1;
          t3 = toc
         % MachineParams.num_machine = cell2mat(param_list(10));
         
                  
   case 'MACHINEPARAMETERS'      
           MachineParams = [];
        Analysis.error_thickDB_nooffset = [];
        Analysis.error_thickDB = [];
        %Info.centerlistactivated = 1;
        kGE = 0.71;
        if Info.DigitizerId >= 5 & Info.DigitizerId <= 7
            crop_coef = kGE;
        else
            crop_coef = 1;
        end
        
        if (Analysis.PhantomID == 9 & Info.Database == true)
            
            machine_correction = mxDatabase(Database.Name,['select * from MachineParametersCorrection where machine_id= ',num2str(Info.centerlistactivated), ' order by start_date']);
            sz_corr = size(machine_correction);
           % machine_correction = sort(machine_correction,4);
            for i = 1:sz_corr(1)
                start_date_num(i) = datenum( machine_correction{i,4}, 'yyyymmdd');
                end_date_num(i) = datenum( machine_correction{i,5}, 'yyyymmdd');
                paddle_type(i)  =  machine_correction{i,3};
                error_thickDB(i) = machine_correction{i,2};
                tz_angleDB(i) = machine_correction{i,6};
                error_3DreconDB(i) = machine_correction{i,7};
            end
            
            % %               index_date_small = min(find(start_date_num_small < date_acquisition_num ));
            % %               thickness_error_small = error_thickDB_small{index_date_small};
            % %
            % %               index_date_big = min(find(start_date_num_big < date_acquisition_num ));
            % %               thickness_error_big = error_thickDB_big{index_date_big;
% % %             image_columns =mxDatabase(Database.Name,['select columns from DICOMinfo where DICOM_ID =(select DICOM_id from acquisition where acquisition_id=',num2str(Info.AcquisitionKey),')']);
% % %             image_columns = cell2mat(image_columns)/2;
% % %             if ~isempty(image_columns)
% % %                 if image_columns > 1350*crop_coef
% % %                     flag.small_paddle = false;
% % %                 else
% % %                     flag.small_paddle = true;
% % %                 end
% % %             else
% % %                  if image_size < 3288177
% % %                     flag.small_paddle = false;
% % %                 else
% % %                     flag.small_paddle = true;
% % %                  end
% % %             end
                
                
% % %             c_date=mxDatabase(Database.Name,['select  date_acquisition from acquisition where acquisition_id=',num2str(Info.AcquisitionKey)]);
% % %             date_acq = c_date{1,1};
               % start_date_num = sort(start_date_num);
             small_index = find(paddle_type==1);
             big_index = find(paddle_type==0);
            date_acquisition_num = datenum(Info.date_acq, 'yyyymmdd');
            if flag.small_paddle %image_columns < 1350
                start_date_num_small = start_date_num(small_index); %paddle_type==1
                error_thickDB_small = error_thickDB(small_index);   %paddle_type==1
                tz_angleDB_small = tz_angleDB(small_index);
                error_3DreconDB_small = error_3DreconDB(small_index);
                
                dates_max = max(start_date_num_small(start_date_num_small < date_acquisition_num ));
                if  ~isempty(start_date_num_small) 
                    if isempty(dates_max)
                        dates_max = min(start_date_num_small);
                    end
                end
                    
                    
                index_date = find(start_date_num_small == dates_max);
                
                if ~isempty(index_date)
                    Analysis.error_thickDB = error_thickDB_small(index_date);
                    Analysis.tz_angleDB = tz_angleDB_small(index_date);
                    Analysis.error_3DreconDB = error_3DreconDB_small(index_date);
                else
                    Analysis.error_thickDB = 0;
                    Analysis.tz_angleDB = [];
                    Analysis.error_3DreconDB = [];
                end
                
            else
                start_date_num_big = start_date_num(big_index );
                error_thickDB_big = error_thickDB(big_index );
                tz_angleDB_big = tz_angleDB(big_index );
                error_3DreconDB_big = error_3DreconDB(big_index );
                dates_max = max(start_date_num_big(start_date_num_big < date_acquisition_num ));
                if  ~isempty(start_date_num_big) 
                    if isempty(dates_max)
                        dates_max = min(start_date_num_big);
                    end
                end
                index_date = find(start_date_num_big == dates_max);
                %index_date = max(find(start_date_num_big < date_acquisition_num ));
                
                if ~isempty(index_date)
                    Analysis.error_thickDB = error_thickDB_big(index_date);
                    Analysis.tz_angleDB = tz_angleDB_big(index_date);
                    Analysis.error_3DreconDB = error_3DreconDB_big(index_date);
                else
                    Analysis.error_thickDB = 0;
                    Analysis.tz_angleDB = [];
                    Analysis.error_3DreconDB = [];
                end
            end
            Analysis.error_thickDB_nooffset = Analysis.error_thickDB;
            Info.date_acquisition_num = date_acquisition_num;
            Info.date_GEN3_num = datenum('20090701', 'yyyymmdd');
            %offset_GEN3 = -2.1; % compensate calibration difference DSP7 and  GEN3 phantoms
            offset_GEN3 = 0;
            if date_acquisition_num < Info.date_GEN3_num
                Analysis.error_thickDB = Analysis.error_thickDB + offset_GEN3;
            end
            
            
            
            
            Analysis.index_date = index_date;
            param_list=mxDatabase(Database.Name,['select * from MachineParameters where machine_id=',num2str(Info.centerlistactivated)]);
            MachineParams.x0_shift = cell2mat(param_list(2))/Analysis.Filmresolution*10;
            MachineParams.y0_shift = cell2mat(param_list(3))/Analysis.Filmresolution*10;
            MachineParams.source_height = cell2mat(param_list(4));
            MachineParams.dark_counts = cell2mat(param_list(6));
            MachineParams.thicknessSmall_corr = cell2mat(param_list(7));
            MachineParams.rxSmall_corr = cell2mat(param_list(8));
            MachineParams.rySmall_corr = cell2mat(param_list(9));
            MachineParams.thicknessBig_corr = cell2mat(param_list(10));
            MachineParams.rxBig_corr = cell2mat(param_list(11));
            MachineParams.ryBig_corr = cell2mat(param_list(12));
% %             MachineParams.a_init = cell2mat(param_list(13));
% %             MachineParams.b_init = cell2mat(param_list(14));
            MachineParams.linear_coef = 1;
        else
            MachineParams.x0_shift = 0;
            MachineParams.y0_shift = 0;
            MachineParams.source_height = 65;
            MachineParams.dark_counts = 40;
            MachineParams.thicknessSmall_corr = 2;
            MachineParams.rxSmall_corr = 0;
            MachineParams.rySmall_corr = 0;
            MachineParams.thicknessBig_corr = 2;
            MachineParams.rxBig_corr = 0;
            MachineParams.ryBig_corr = 0;
% %             MachineParams.a_init = 0;
% %             MachineParams.b_init = 1;
            MachineParams.linear_coef = 1;
        end
        
         
%% Common Analysis
    case 'COMMONANALYSIS'
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%% retrieve a Common analysis named commonalysiskey %%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %retrieve the key of the acquisition

        SQLstatement=['select acquisition_id from commonanalysis where commonanalysis_id=',num2str(Info.CommonAnalysisKey)];
        acquisitionkey=cell2mat(mxDatabase(Database.Name,SQLstatement));

        % check if the open image is the good one
        
        if Result.DXASelenia == true
            Result.calibration_type = 'AutoDXA';
            Result.DXASelenia = true;
            Result.DXASeleniaCalculated = false;
            
            Result.flagLE = true;
            Result.flagHE = false;
            
            SQLstatement=['select patient_id,date_acquisition from acquisition where acquisition_id=',num2str(acquisitionkey)];
            aL = mxDatabase(Database.Name,SQLstatement);
            patient_ident = aL(1);
            date_acq = aL(2);
            SQLstatement=['select acquisition_id from acquisition where patient_id=',char(patient_ident),' and date_acquisition=',char(date_acq),' and kVp<',num2str(38)];
            abL  = mxDatabase(Database.Name,SQLstatement);
            Info.AcquisitionKey = cell2mat(abL); 
            RetrieveInDatabase('ACQUISITION');
            Info.AcquisitionKeyLE = Info.AcquisitionKey;
            Info.kVpLE = Info.kVp;
            Info.mAsLE = Info.mAs;
            Result.flagHE = true;
            %SQLstatement=['select patient_id from acquisition where acquisition_id=',num2str(Info.AcquisitionKey),' and digitizer.digitizer_id=acquisition.digitalizer_id'];
            SQLstatement=['select patient_id,date_acquisition from acquisition where acquisition_id=',num2str(Info.AcquisitionKey)];
            a = mxDatabase(Database.Name,SQLstatement);
            patient_ident = a(1);
            date_acq = a(2);
            SQLstatement=['select acquisition_id from acquisition where patient_id=',char(patient_ident),' and date_acquisition=',char(date_acq),' and kVp>',num2str(35)];
            ab  = mxDatabase(Database.Name,SQLstatement);
            Info.AcquisitionKey = cell2mat(ab); 
            Result.DXASelenia = true;
            RetrieveInDatabase('ACQUISITION');
            Info.kVpHE = Info.kVp;
            Info.mAsHE = Info.mAs;
            Info.kVp = Info.kVpLE;
            Info.mAs = Info.mAsLE;
                                 
        else
            if Info.AcquisitionKey~=acquisitionkey
                Info.AcquisitionKey=acquisitionkey;
                RetrieveInDatabase('ACQUISITION');
            end
        end
        %retrieve ROI coordinates
        a=cell2mat(mxDatabase(Database.Name,['select ROI_xmin,ROI_ymin,ROI_columns,ROI_rows,manualedge_id,Method,Chestwall_ID from commonanalysis where commonanalysis_id=',num2str(Info.CommonAnalysisKey)]));
        ROI.xmin=a(1);ROI.ymin=a(2);ROI.columns=a(3);ROI.rows=a(4);manualedge_id=a(5);ManualEdge.Method=a(6);Analysis.ChestWallID=a(7);
        ROI.xmax=ROI.xmin+ROI.columns-1;ROI.ymax=ROI.ymin+ROI.rows-1;
        funcBox(ROI.xmin,ROI.ymin,ROI.xmin+ROI.columns,ROI.ymin+ROI.rows,'b');

        %retrieve ROI.image
        ROIDetection('FROMOUTSIDE');
        if manualedge_id==1    %if the edge has been computed automatically
            flag.EdgeMode='Auto';
        else  %need to retrieve the manualedge
            flag.EdgeMode='manual';
            SQLstatement=['select * from manualedge where manualedge_id=',num2str(manualedge_id),'order by point_id'];
            content=cell2mat(mxDatabase(Database.Name,SQLstatement));
            ManualEdge.Points=(content(:,3:4));
        end
        SkinDetection('FROMDATABASE');
        if Analysis.ChestWallID
            SQLstatement=['select * from Chestwall where id=',num2str(Analysis.ChestWallID),'order by point_id'];
            content=cell2mat(mxDatabase(Database.Name,SQLstatement));
            ChestWallData.Points=(content(:,3:4));
            Chestwall('FROMDATABASE');
        end
        
%% Freeform analysis
    case 'FREEFORMANALYSIS'
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%% retrieve a FreeForm analysis named Info.FreeFormAnalysisKey %%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        funcerasefreeforms;
        protection='yes';     %if no, retrieve only the freeform, don't mind to retrieve the good acquisition...
        if strcmp(protection,'yes')
            %retrieve the key of the common analysis
            SQLstatement=['select commonanalysis_id from freeformanalysis where freeformanalysis_id=',num2str(Info.FreeFormAnalysisKey)];
            CommonAnalysisKey=cell2mat(mxDatabase(Database.Name,SQLstatement));
            % check if the Common analysis is the good one
            if Info.CommonAnalysisKey~=CommonAnalysisKey
                Info.CommonAnalysisKey=CommonAnalysisKey;
                RetrieveInDatabase('COMMONANALYSIS');
            end
        end
        %retrieve freeformcluster_id
        SQLstatement=['select freeformscluster_id from freeformanalysis where freeformanalysis_id=',num2str(Info.FreeFormAnalysisKey)];
        freeformcluster=cell2mat(mxDatabase(Database.Name,SQLstatement));
        %retrieve freeforms
        SQLstatement=['select distinct freeforms_id from freeforms where freeformscluster_id=',num2str(freeformcluster)];
        freeformslist=cell2mat(mxDatabase(Database.Name,SQLstatement));
        FreeForm.FreeFormnumber=size(freeformslist,1);
        for index=1:FreeForm.FreeFormnumber
            FreeForm.FreeFormCluster(index).valid=true;
            SQLstatement=['select * from freeforms where freeformscluster_id=',num2str(freeformcluster),' and freeforms_id=',num2str(freeformslist(index)),' order by point_id'];
            b=mxDatabase(Database.Name,SQLstatement);
            FreeForm.FreeFormCluster(index).face=cell2mat(b(:,4:5));
            FreeForm.FreeFormCluster(index).surface=funcComputeFreeFormArea(FreeForm.FreeFormCluster(index).face);
        end

        draweverything;
        Message('Ok');

%% SXA Analysis
    case 'SXAANALYSIS'
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%% retrieve a SXA analysis named Info.ThresholdAnalysisKey   %%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        %retrieve The Flat Field Correction status
        SQLstatement=['select flatfieldcorrection_id from sxaanalysis where sxaanalysis_id=',num2str(Info.SXAAnalysisKey)];
   %     Info.CorrectionId=cell2mat(mxDatabase(Database.Name,SQLstatement));

        %retrieve the key of the common analysis
        SQLstatement=['select commonanalysis_id from sxaanalysis where sxaanalysis_id=',num2str(Info.SXAAnalysisKey)];
        CommonAnalysisKey=cell2mat(mxDatabase(Database.Name,SQLstatement));
        % check if the Common analysis is the good one
        if Info.CommonAnalysisKey~=CommonAnalysisKey
            Info.CommonAnalysisKey=CommonAnalysisKey;
            RetrieveInDatabase('COMMONANALYSIS');
        end

        %retrieve PhantomFatArea
        SQLstatement=['select phantomfat_xmin,phantomfat_xmax,phantomfat_ymin,phantomfat_ymax from sxaanalysis where sxaanalysis_id=',num2str(Info.SXAAnalysisKey)];
        toto=cell2mat(mxDatabase(Database.Name,SQLstatement));
        Analysis.PhantomFatx(1)=toto(1);
        Analysis.PhantomFatx(2)=toto(2);
        Analysis.PhantomFaty(1)=toto(3);
        Analysis.PhantomFaty(2)=toto(4);

        %retrieve PhantomLeanArea
        SQLstatement=['select phantomlean_xmin,phantomlean_xmax,phantomlean_ymin,phantomlean_ymax from sxaanalysis where sxaanalysis_id=',num2str(Info.SXAAnalysisKey)];
        toto=cell2mat(mxDatabase(Database.Name,SQLstatement));
        Analysis.PhantomLeanx(1)=toto(1);
        Analysis.PhantomLeanx(2)=toto(2);
        Analysis.PhantomLeany(1)=toto(3);
        Analysis.PhantomLeany(2)=toto(4);
        
        %retrieve PhantomAngleHoriz
        % SQLstatement=[SELECT ALL OtherSxaInfo.Angle FROM acquisition,commonanalysis,OtherSxaInfo,SXAAnalysis WHERE acquisition.acquisition_id = commonanalysis.acquisition_id  AND commonanalysis.commonanalysis_id = sxaanalysis.commonanalysis_id  AND SXAAnalysis.SXAAnalysis_id = OtherSXAinfo.sxaanalysis_id  AND acquisition.acquisition_id = '1914'  
       % SQLstatement=['select phantomlean_xmin,phantomlean_xmax,phantomlean_ymin,phantomlean_ymax from sxaanalysis where sxaanalysis_id=',num2str(Info.SXAAnalysisKey)];
        SQLstatement=['SELECT OtherSxaInfo.Angle FROM OtherSxaInfo,SXAAnalysis WHERE  SXAAnalysis.SXAAnalysis_id = OtherSXAinfo.sxaanalysis_id  AND OtherSXAinfo.sxaanalysis_id=',num2str(Info.SXAAnalysisKey)];  
        anglehoriz=cell2mat(mxDatabase(Database.Name,SQLstatement))
        len = length(anglehoriz);
        Analysis.AngleHoriz=anglehoriz(len);
        Phantom.AngleHoriz = Analysis.AngleHoriz;
        SQLstatement=['SELECT ALL acquisition.phantom_id FROM acquisition,commonanalysis WHERE acquisition.acquisition_id = commonanalysis.acquisition_id  AND commonanalysis.commonanalysis_id =',num2str(Info.SXAAnalysisKey)];  
        Analysis.Phantom_id =cell2mat(mxDatabase(Database.Name,SQLstatement)) ;
        Info.PhantomComputed=true;
        
        %retrieve pahntomD1 and PhantomD2 Distances
        try
            SQLstatement=['select Distance1,Distance2,Phantom_position from sxaanalysis where sxaanalysis_id=',num2str(Info.SXAAnalysisKey)];
            toto=cell2mat(mxDatabase(Database.Name,SQLstatement));
            Analysis.PhantomD1=toto(1,1);
            Analysis.PhantomD2=toto(1,2);
            Analysis.PhantomPosition=toto(1,3);
        catch
            Analysis.PhantomD1=0;
            Analysis.PhantomD2=0;
            Analysis.PhantomPosition=700;
        end
        
        if Analysis.ThresholdOnly == false
        %    set(ctrl.Cor,'value',true);
        %    eval(get(ctrl.CorrectionButton,'callback'));  %press on correction button
        %    ComputeDensity;
        else
            SQLstatement=['select SXAresult from sxaanalysis where sxaanalysis_id=',num2str(Info.SXAAnalysisKey)];
            Analysis.DensityPercentageAngle  = cell2mat(mxDatabase(Database.Name,SQLstatement))
        end
        %% load comments
        try
            comment=mxDatabase(Database.Name,['select comment from comment,comment_results where comment.id=comment_id and analysis_id=',num2str(Info.SXAAnalysisKey),' and analysis_type=2']);
            for index=1:length(comment)
                ReportText=[ReportText cell2mat(comment(index)) '@'];
            end
        end
        Analysis.ThresholdOnly = false;
        Message('Ok');
        
%% SXA STEP ANALYSIS FROM LIST 
case 'SXASTEPANALYSISFROMLIST'
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%% retrieve a SXA  analysis %%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        Info.SXAStepAnalysisKey=cell2mat(funcSelectInTable('RetrieveSXAStepanalysis','Choose a SXA Step analysis',0,'Cancel'));
        if Info.SXAStepAnalysisKey~=0    %0 if if cancel button has not been pressed
            Database.Step=1;    %before 2
            RetrieveInDatabase('SXASTEPANALYSIS');
        end

%% SXA Step Analysis = automatic SXA Analysis
    case 'SXASTEPANALYSIS'
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%% retrieve a SXA analysis named Info.SXAAnalysisKey   %%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        %retrieve The Flat Field Correction status
        Info.CorrectionAsked = false; % for digital machines
        %retrieve the key of the common analysis
        SQLstatement=['select commonanalysis_id from sxastepanalysis where sxastepanalysis_id=',num2str(Info.SXAStepAnalysisKey)];
        CommonAnalysisKey=cell2mat(mxDatabase(Database.Name,SQLstatement));
       
        % check if the Common analysis is the good one
        if Info.CommonAnalysisKey~=CommonAnalysisKey
            Info.CommonAnalysisKey=CommonAnalysisKey;
            RetrieveInDatabase('COMMONANALYSIS');
        end

        %retrieve parameters from SXAStepAnalysis table
        SQLstatement=['select SXAStepResult, angle_ry, coord_tz, error_3DReconstruction, total_fatmass, total_leanmass, breast_volume_proj from sxastepanalysis where sxastepanalysis_id=',num2str(Info.SXAStepAnalysisKey)];
        sxa_results = cell2mat(mxDatabase(Database.Name,SQLstatement));
       Analysis.DensityPercentage = sxa_results(1);
       Analysis.Y_angle = sxa_results(2);
       Analysis.ph_thickness = (sxa_results(3)- MachineParams.bucky_distance) / MachineParams.linear_coef;;
       Analysis.error_3DReconstruction = sxa_results(4);
       Analysis.TotalFatMass = sxa_results(5);
       Analysis.TotalLeanMass = sxa_results(6);
       Analysis.BreastVolume = sxa_results(7);
       SQLstatement=['select phantomfatref, phantomleanref  from othersxastepinfo where sxastepanalysis_id=',num2str(Info.SXAStepAnalysisKey)];
       othersxa_results = cell2mat(mxDatabase(Database.Name,SQLstatement));
      % Analysis.Phantomfatlevel = othersxa_results(end,1);
      % Analysis.Phantomleanlevel = othersxa_results(end,2);
       
       FileNameDensity = [Info.fname(1:end-4),'SXADensity',Info.fname(end-3:end) ]; 
       FileNameThickness = [Info.fname(1:end-4),'SXAThickness',Info.fname(end-3:end)]; 
       %FileNameDensity = ['Density', Info.fname]; 
       %FileNameThickness =['Thickness', Info.fname];
       
       s=dir (FileNameDensity);
       if ~isempty(s)
            Analysis.DensityImage = double(imread(FileNameDensity))/100;   
            Analysis.SXADensityImageCrop = Analysis.DensityImage;
       end
       
       s=dir (FileNameThickness);
       if ~isempty(s)
            Analysis.ThicknessImage = double(imread(FileNameThickness))/1000; 
            Analysis.SXAThicknessImageTotal = Analysis.ThicknessImage;
       end
      
        SQLstatement=['SELECT ALL acquisition.phantom_id FROM acquisition,commonanalysis WHERE acquisition.acquisition_id = commonanalysis.acquisition_id  AND commonanalysis.commonanalysis_id =',num2str(Info.SXAStepAnalysisKey)];  
        Analysis.Phantom_id =cell2mat(mxDatabase(Database.Name,SQLstatement)) ;
        Info.PhantomComputed=true;
        Analysis.Step = 8;
        draweverything;
        Analysis.ThresholdOnly = false;
        Message('Ok');
%% DXA ANALYSIS FROM LIST 
    case 'DXAANALYSISFROMLIST'
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%% retrieve a DXA  analysis %%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        Info.CommonAnalysisKey = -1;
        Info.AcquisitionKey = -1;
        Result.DXASelenia = true;
        Info.DXAAnalysisKey=cell2mat(funcSelectInTable('RetrieveDXAanalysis','Choose a DXA analysis',0,'Cancel'));
        if Info.DXAAnalysisKey~=0    %0 if if cancel button has not been pressed
            Database.Step=1;    %before 2
            RetrieveInDatabase('DXAANALYSIS');
        end

%% DXA Analysis = automatic DXA Analysis
    case 'DXAANALYSIS'
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%% retrieve a DXA analysis named Info.DXAAnalysisKey   %%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        Info.CommonAnalysisKey = -1;
        Info.AcquisitionKey = -1;
        Result.DXASelenia = true;
        %retrieve The Flat Field Correction status
        Info.CorrectionAsked = false; % for digital machines
        %retrieve the key of the common analysis
        DXAAnalysisKey=cell2mat(funcSelectInTable('RetrieveDXAanalysis','Choose a DXA analysis',0,'Cancel'));
        Info.DXAAnalysisKey = DXAAnalysisKey(1);
        SQLstatement=['select commonanalysis_id from dxaanalysis where dxaanalysis_id=',num2str(Info.DXAAnalysisKey)];
        CommonAnalysisKey=cell2mat(mxDatabase(Database.Name,SQLstatement));
       
        % check if the Common analysis is the good one
        if Info.CommonAnalysisKey~=CommonAnalysisKey
            Info.CommonAnalysisKey=CommonAnalysisKey;
            RetrieveInDatabase('COMMONANALYSIS');
        end

        %retrieve parameters from DXAAnalysis table
       SQLstatement=['select DXADensityPercentageTotal, DXABreastAreaTotal, DXABreastVolumeProj from dxaanalysis where dxaanalysis_id=',num2str(Info.DXAAnalysisKey)];
       dxa_results = cell2mat(mxDatabase(Database.Name,SQLstatement));
       DXAAnalysis.DXADensityPercentageTotal = dxa_results(1);
       DXAAnalysis.DXABreastAreaTotal = dxa_results(2);
       DXAAnalysis.DXABreastVolumeProj = dxa_results(3);
              
       FileNameDensity = [Info.fname(1:end-4),'Density',Info.fname(end-3:end) ]; 
       FileNameThickness = [Info.fname(1:end-4),'Thickness',Info.fname(end-3:end)]; 
             
       s=dir (FileNameDensity);
       if ~isempty(s)
            Image.material = double(imread(FileNameDensity))/100;                
       end
       
       s=dir (FileNameThickness);
       if ~isempty(s)
            Image.thickness = double(imread(FileNameThickness))/1000;               
       end
        Result.DXASeleniaCalculated = false; 
        Info.DXAAnalysisRetrieved = true;
        Analysis.Step = 6;
        draweverything;
        Analysis.ThresholdOnly = false;
        set(ctrl.text_zone,'String',strcat('DXA Breast Density: ',num2str(DXAAnalysis.DXADensityPercentageTotal),' %', ', DXA Breast Volume: ',num2str(DXAAnalysis.DXABreastVolumeProj),' cm^3' , ' ,  DXA Breast Area: ',num2str(DXAAnalysis.DXABreastAreaTotal),' cm^2'));
        %Message('Ok');
       
    %% Threshold Analysis
    case 'THRESHOLDANALYSIS'
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%% retrieve a Threshold analysis named Info.ThresholdAnalysisKey %%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        %retrieve The Flat Field Correction status
        SQLstatement=['select flatfieldcorrection_id from thresholdanalysis where thresholdanalysis_id=',num2str(Info.ThresholdAnalysisKey)];
        Info.CorrectionId=cell2mat(mxDatabase(Database.Name,SQLstatement));
        set(ctrl.Cor,'value',Info.CorrectionId>1);  %check or decheck Correction checkbox

        %retrieve the key of the common analysis
        SQLstatement=['select commonanalysis_id from thresholdanalysis where thresholdanalysis_id=',num2str(Info.ThresholdAnalysisKey)];
        CommonAnalysisKey=cell2mat(mxDatabase(Database.Name,SQLstatement));
        % check if the Common analysis is the good one
        if Info.CommonAnalysisKey~=CommonAnalysisKey
            Info.CommonAnalysisKey=CommonAnalysisKey;
            RetrieveInDatabase('COMMONANALYSIS');
        end

        %retrieve thresholdvalue
        SQLstatement=['select thresholdvalue from thresholdanalysis where thresholdanalysis_id=',num2str(Info.ThresholdAnalysisKey)];
        Threshold.value=cell2mat(mxDatabase(Database.Name,SQLstatement));
        HistogramManagement('ThresholdManagement',1);    %put the threshold bar at its right position
        funcThresholdContour;     %Compute the Threshold Result value + redraw
        draweverything;


        Message('Ok');

%% Correction
    case 'CORRECTION'
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%% retrieve a Correction CorrectionID  %%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        inf = Info;
        Message('retrieving correction file...');
        if Info.DigitizerId==1  %vidar
            if get(ctrl.Cor,'value')                
                %xm = strmatch('UKMarsden', Info.StudyID, 'exact');
                  xm = strmatch('mammo_Marsden', Database.Name, 'exact');
                if xm > 0
                    MachineID=get(ctrl.Center,'value');
                    if get(ctrl.Cor,'value')&&(MachineID>0)   %%11 .. are real machines
                        %%Find the good correction = previous flat field correction of the same room
                        temp=mxDatabase(Database.Name,['select FlatFieldCorrection_Id, CorrectionDate from correction where machine_id=''',num2str(1),''' order by CorrectionDate']);
                        datelist=ConvertDate(cell2mat(temp(:,2))); %work on the string to obtain the date 20040605 (05 june 2004) 2004/05/06
                        FilmDate=datenum(ConvertDate(Info.FilmDate));

                        if FilmDate>datelist(end)
                           % Info.CorrectionId=9;  %%in order that works, we need to have a correction ready with a date after (in order to be sure no correction will be inserted afterward before the filmdate).
                            %Error.NoCorrection=true;
                            [foe,index]=max(datelist);
                            Info.CorrectionId=cell2mat(temp(max(1,index-1),1));
                            ReportText=[ReportText,'Warning: No Flat Field correction available after the acquisition date.@'];
                        else
                            [foe,index]=max(FilmDate<=datelist);
                            Info.CorrectionId=cell2mat(temp(max(1,index-1),1));
                        end

                    else
                        Info.CorrectionId=9;    %%9 is for no correction
                    end
                else    
                    if Info.centerlistactivated==8 %Mont Zion GE
                        Info.CorrectionId=21; %before 4 Info.CorrectionId=11;
                    elseif Info.centerlistactivated==7 %Mont Zion Lorad Sutter
                        Info.CorrectionId=17; %before 4    
                    elseif Info.centerlistactivated==10
                        Info.CorrectionId=17; 
                    elseif Info.centerlistactivated==11
                        Info.CorrectionId=22
                    elseif Info.centerlistactivated==3 | Info.centerlistactivated==2
                        Info.CorrectionId=21; 
                    else
                        Info.CorrectionId=4;
                    end
                end
            else
                Info.CorrectionId=1;
            end
        elseif Info.DigitizerId==2 %Kodak
            Info.CorrectionId=10;
            set(ctrl.Cor,'value',false)
        elseif  Info.DigitizerId==3 %CPMC R2DG
            MachineID=get(ctrl.Center,'value');
            if get(ctrl.Cor,'value')&&(MachineID>10)   %%11 .. are real machines
                %%Find the good correction = previous flat field correction of the same room
                temp=mxDatabase(Database.Name,['select FlatFieldCorrection_Id, CorrectionDate from correction where machine_id=''',num2str(MachineID),''' order by CorrectionDate']);
                datelist=ConvertDate(cell2mat(temp(:,2))); %work on the string to obtain the date 20040605 (05 june 2004) 2004/05/06
                FilmDate=datenum(ConvertDate(Info.FilmDate));
       %{
                if FilmDate>datelist(end)
                    Info.CorrectionId=9;  %%in order that works, we need to have a correction ready with a date after (in order to be sure no correction will be inserted afterward before the filmdate).
                    Error.NoCorrection=true;
                    ReportText=[ReportText,' No Flat Field correction available after the acquisition date.@         All operation aborted@'];
                else
                    [foe,index]=max(FilmDate<=datelist);
                    Info.CorrectionId=cell2mat(temp(max(1,index-1),1));
                end
       %}
           
                if FilmDate>datelist(end)
                   % Info.CorrectionId=9;  %%in order that works, we need to have a correction ready with a date after (in order to be sure no correction will be inserted afterward before the filmdate).
                    %Error.NoCorrection=true;
                    [foe,index]=max(datelist);
                    Info.CorrectionId=cell2mat(temp(max(1,index-1),1));
                    ReportText=[ReportText,'Warning: No Flat Field correction available after the acquisition date.@'];
                else
                    [foe,index]=max(FilmDate<=datelist);
                    Info.CorrectionId=cell2mat(temp(max(1,index-1),1));
                end
                
            else
                Info.CorrectionId=9;    %%9 is for no correction
            end
        end


    %    if Correction.activeCorrection~=Info.CorrectionId  %if the correction has changed since the last time...
            SQLstatement=['select correctiontype,CorrectionName from correction where FlatFieldCorrection_id=',num2str(Info.CorrectionId)];
            temp=mxDatabase(Database.Name,SQLstatement);
            Info.Correctiontype=cell2mat(temp(1));
            Info.CorrectionName=cell2mat(temp(2))

            %retrieve the correction file
            if Info.FlatFieldCorrectionAsked
                SQLstatement=['select Correction_filename from correction where FlatFieldCorrection_id=',num2str(Info.CorrectionId)];
                filename=cell2mat(mxDatabase(Database.Name,SQLstatement));
              
               %for manual 
             % [filename, pathname] = ...
             %  uigetfile({'*.m';'*.mdl';'*.mat';'*.*'},'File Selector');  % for manual flat field file selection, comment if auto
                
                filename=deblank(filename)    %for auto need to be uncomment
                if ~strcmpi(filename,Correction.Filename)
                    if ~strcmpi(filename,'none')
                        Message('Load Flat Field Correction file...');
                      %load( [pathname filename]); %manual, comment if  auto
                        %figure('Name', 'Corr_InterpolatedImage1R');
                        % imagesc(Correction.InterpolatedImage1); colormap(gray);  
                        a = exist(filename)
                        if a > 0
                        load(filename); % for auto need to uncomment
                        else
                         filename(1) = 'Z';
                         load(filename);
                        end
                        Correction.Filename=filename;
                       % if Info.Correctiontype<4   %to mange old versions of corrections
                       %     Correction.InterpolatedImage1=Correction.InterpolatedImage1/10000;
                       % end
                        if Info.Correctiontype~=2  %this correction (5) type has no cosimage to load
                            Correction.CosImage=double(Correction.CosImage)/10000;
                        end
                    end
                end
            end
            Correction.Type=Info.Correctiontype;

            %retrieve coefficient
            SQLstatement=['select coef1,coef2,coef3,coef4,coef5,coef6,coef7,coef8,coef9,coef10,coef11 from correction where FlatFieldCorrection_id=',num2str(Info.CorrectionId)];
            data=cell2mat(mxDatabase(Database.Name,SQLstatement));
            Correction.zerox=data(1); Correction.maxx=data(2); Correction.dilatation=data(3); %data obtain by fit in p83lh1-pixellaw-thickness step.xls
            Correction.zerox2=data(4); Correction.maxx2=data(5); Correction.dilatation2=data(6); %data obtain by fit in p83lh1-pixellaw-thickness step.xls
            Correction.Z=data(7);Correction.K=data(8);Correction.Kmu=data(9); %coef are obtain for study p76lh1-pixelLawVidar
            Correction.kVp0=data(10);Correction.SaturatedThreshold=data(11);
            Correction.activeCorrection=Info.CorrectionId;
       % end
       
%% basic Operations
    case 'BASICOPERATION'
       % case 'BASICOPERATION'
        if ~Result.DXA
            SQLstatement=['select * from BasicImageOperation where acquisition_id=',num2str(Info.AcquisitionKey),' order by basicoperation_id'];
            data=mxDatabase(Database.Name,SQLstatement)
            
          %  data_num = cell2mat(data)
            if isempty(data)
                fd = false;
            else
                fdupl = duplicatecell_search(data);
                fd = true;
            end
            
            if ((fd == false)  | (fdupl == true))
                %data = cell([1 4]);
                imagemenu('AutomaticCrop');
            else
                for index=1:size(data,1)
                    switch cell2mat(data(index,3))
                        case 'USAM'
                            imagemenu('undersampling');
                        case 'ROTA'
                            imagemenu('rotation');
                        case 'FLIP'
                            imagemenu('flipV');
                        case 'FLIPH'
                            imagemenu('flipH');

                        case 'CUTL'
                            param=cell2mat(data(index,4));
                            if param > 30
                               param=DetectImageEdge(Image.OriginalImage,'LEFT');
                            end
                            imagemenu('CutLeftWithParam',param);                                                         
                        case 'CUTR'
                            param=cell2mat(data(index,4));                         
                            imagemenu('CutRightWithParam',param);                        
                        case 'CUTT'
                            param=cell2mat(data(index,4));                        
                            imagemenu('CutTopWithParam',param);
                        case 'CUTB'
                            param=cell2mat(data(index,4));                       
                            imagemenu('CutBottomWithParam',param);                        
                    end
                end
            end
        end
        Analysis.OperationList={};
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %{
        if ~Result.DXA
            SQLstatement=['select * from BasicImageOperation where acquisition_id=',num2str(Info.AcquisitionKey),' order by basicoperation_id'];
            data=mxDatabase(Database.Name,SQLstatement)
            dt = data
            for index=1:size(data,1)
                switch cell2mat(data(index,3))
                    case 'USAM'
                        imagemenu('undersampling');
                    case 'ROTA'
                        imagemenu('rotation');
                    case 'FLIP'
                        imagemenu('flipV');
                    case 'FLIPH'
                        imagemenu('flipH');

                    case 'CUTL'
                        param=cell2mat(data(index,4));
                        imagemenu('CutLeftWithParam',param);
                    case 'CUTR'
                        param=cell2mat(data(index,4));
                        imagemenu('CutRightWithParam',param);
                    case 'CUTT'
                        param=cell2mat(data(index,4));
                        imagemenu('CutTopWithParam',param);
                    case 'CUTB'
                        param=cell2mat(data(index,4));
                        imagemenu('CutBottomWithParam',param);

                end
            end
        end
        Analysis.OperationList={};
        %}
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
%% Recognition
    case 'RECOGNITION'
        try
            Recognition.MAS=cell2mat(mxDatabase(Database.Name,['select mas from acquisition where acquisition_ID=''',num2str(Info.AcquisitionKey),''''])); Error.MAS=(Recognition.MAS<=0)|Error.MAS;
            Recognition.KVP=cell2mat(mxDatabase(Database.Name,['select kvp from acquisition where acquisition_ID=''',num2str(Info.AcquisitionKey),'''']));  Error.KVP=(Recognition.KVP<=0)|Error.KVP;
            Recognition.MM=cell2mat(mxDatabase(Database.Name,['select thickness from acquisition where acquisition_ID=''',num2str(Info.AcquisitionKey),''''])); Error.MM=(Recognition.MM<=0)|(Error.MM);
            Recognition.DAN=cell2mat(mxDatabase(Database.Name,['select force from acquisition where acquisition_ID=''',num2str(Info.AcquisitionKey),''''])); Error.DAN=(Recognition.DAN<=0)|(Error.DAN);
            TechniqueID=cell2mat(mxDatabase(Database.Name,['select technique_id from  acquisition where acquisition_ID=''',num2str(Info.AcquisitionKey),''''])); Error.TECHNIQUE=(Recognition.TECHNIQUE==3);
            Recognition.TECHNIQUE=false;
            switch TechniqueID
                case 1
                    Recognition.TECHNIQUE='MO/MO';
                case 2
                    Recognition.TECHNIQUE='MO/RH';
                case 4
                    Recognition.TECHNIQUE='RH/RH';
                otherwise
                    Error.TECHNIQUE=true;
                    Recognition.TECHNIQUE='Unknown';
            end
        end
        
%% QA codes
    case 'QACODES'
        tic
        QAstatus=QAreport('OPEN?');  %check if the QA report is already open
        QAreport; %open (or not)
        qa = QA;
        qa_cd = QA.codeDescription;
        qa_check = QA.check;
        for index=1:size(QA.codeDescription,1)
            switch cell2mat(QA.codeDescription(index,2))
                case 15 %'Big Paddle'
                    Error.BIGPADDLE=get(QA.check(index),'value');
                case 11 %'Saturation Problems'
                    Error.SATURATION=get(QA.check(index),'value');
                case 32 %'Super Lean Warning'
                    Error.SuperLeanWarning=get(QA.check(index),'value');
                case 10 %'Phantom detection failure'
                    Error.PhantomDetection=get(QA.check(index),'value');
                case 17 %'Height Warning'
                    Error.HEIGHT=get(QA.check(index),'value');
                case 27 %'auto BDPC failed'
                    Error.PC=get(QA.check(index),'value');
                case 28 %'Thickness discrepancy'
                    Error.ThicknessDiscrepancy=get(QA.check(index),'value');
                case 26 %'auto BDMD failed'
                    Error.AutoBDMD=get(QA.check(index),'value');
                case 18 %'mAs reading failed'
                    Error.MAS=get(QA.check(index),'value');
                case 19 %'kVp reading failed'
                    Error.KVP=get(QA.check(index),'value');
                case 20 %'Thickness reading failed'
                    Error.MM=get(QA.check(index),'value');
                case 22 %'Force reading failed'
                    Error.DAN=get(QA.check(index),'value');
                case 21 %'Technique reading failed'
                    Error.TECHNIQUE=get(QA.check(index),'value');
                case 23 %'kVp warning'
                    Error.KVPWarning=get(QA.check(index),'value');
                case 25 %'auto BDSXA failed'
                    Error.DENSITY=get(QA.check(index),'value');
                case 29 %'Uniformity Correction failed'
                    Error.Correction=get(QA.check(index),'value');
                case 34 %Room detection
                    Error.RoomDetection=get(QA.check(index),'value'); 
                case 44
                    Error.StepPhantomBBsFailure = get(QA.check(index), 'value');
                case 45  
                    Error.StepPhantomFailure = get(QA.check(index), 'value');
                case 46
                    Error.StepPhantomPosition = get(QA.check(index), 'value');
                case 47
                    Error.StepPhantomReconstruction = get(QA.check(index), 'value');
                case 48 
                    Error.PeripheryCalculation = get(QA.check(index), 'value');
                case 3
                    Error.SkinEdgeFailed = get(QA.check(index), 'value');
            end
        end
        err = Error;
        if ~QAstatus
            QAreport('CLOSE');
        end
      t2 = toc
end

