%RetrieveInDatabase
%author Lionel HERVE
%7-29-03 Roughness analysis is in commonanalysis now
%9-17-03 Don't divide the correction image by 10000 in order to store them
%in integer precision (save memory)

function retrieveindatabase(RequestedAction,file_list)
global flag Database Analysis Info ctrl dummyuicontrol2 f0 ManualEdge FreeForm Threshold Correction Result ok_continue ROI Image
global Recognition Error QA ReportText ChestWallData AutomaticAnalysis Phantom  h_init h_slope number_acqs MachineParams acqs_filename
global startdir_report PathName FileName_list image_filename figuretodraw fname acquisitionkeyList ROI2
global xlsLineNum refDSPtoWAX debugMode  temp_acqs duration SXAreport  Random_Acquisition  Nacquisition 
refDSPtoWAX = 30;   %DSP 0% is 30% on the wax-water scale
debugMode = 0;
%%%VALIDATION_MODE = true;
%noimage_flag
%noimage_flag = 0;
%Info.Database=true;
SXAreport = true;   %true for Powr Popint Reports
%profile on -history
cf = RequestedAction
number_acqs = 10000;  %matlab restart
Random_Acquisition=false; %true for choosing randomly acquisition_id
GEN3_MODE = true; % if it is true, error thickness is zero for GEN3 (Calibration), false to run validation 
flag.Density = false; 
% AutomaticAnalysis.StructuralAnalysisDone=2;% going to Fred Feature;
flag.large_swapped= false;

switch RequestedAction
    %% Acquisition from list
    case 'FILEOFLISTNAMES'

        
        if  Random_Acquisition==true;  % Added by AM 12172013
            Info.Operator = 14;
            Analysis.Auto=true;
            options.Resize='on';
            options.WindowStyle='normal';
            options.Interpreter='tex';
            prompt = {'How Many Random Acquisition_id do you need?'};
            dlg_title = 'How Many Random Acquisition_id do you need?';
            num_lines = 1;
            def = {'3000'};
            k = inputdlg(prompt,dlg_title,num_lines,def);
            Nacquisition=cell2mat(k);
            Nacquisition=str2num(Nacquisition);
            temp_acqs=0;
            PathName=0;
            FileName1=0;
            
            acqs_filename = [PathName,FileName1];
        else
            %[FileName_new,PathName] = uigetfile('O:\SRL\aaStudies\Breast Studies\Auto Dense Study\Reading List\ViewID_4_5\','Select the acquisition list txt-file ');
            [FileName_new,PathName] = uigetfile('*.*');
            acqs_filename = [PathName,FileName_new];     %'\'
            temp_acqs = textread(acqs_filename,'%u');
            FileName1=true;
        end
        FileName_list = FileName_new;
    
        if ((FileName1 ==true) || (FileName1 == 0 && Random_Acquisition==true) )
            RetrieveInDatabase('ACQUISITIONFROMLIST');
        end
    case 'ACQUISITIONFROMLIST'
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%% retrieve an acquisition %%%%%%%%   Multi analysis possible
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %inf1 = Info B:\BIRADS1\Birads_readinglist_original.txt
        %acquisitionkeyList=textread('B:\BIRADS1\Birads_readinglist_original.txt','%u');
        %acquisitionkeyList=textread('P:\Temp\good films\stgeorgesgoodccviews.txt','%u'); %for the first Birad Reading
        
        s = 2;
        %acqs_filename = 'Z4_5to6percent.txt';
      
        if exist('file_list')
            acqs_filename = file_list
        end
        
        
% %         commented by SM two 081115
% %         if (Info.Operator == 11 ) || (Info.Operator == 14)
% %             RandomAcquisitionKey;
% % % % %             Number_AutoAcqList= size(cell2mat(acquisitionkeyList),1)
% %             % % %             number_acqs = Number_AutoAcqList;
% %         else
            temp_acqs = textread(acqs_filename,'%u');
% %         end
        
% % %         if length(temp_acqs) >= number_acqs
% % %             acquisitionkeyList = temp_acqs(1:number_acqs);
% % %         else
            if Info.Operator == 14
                
                acquisitionkeyList=cell2mat(Info.acquisitionkeyList);
            else
                acquisitionkeyList = temp_acqs;
            end
% % %         end
        %}
        %acquisitionkeyList=textread('F:\test.txt','%u');
        %  Info.Analysistype=5;
        %acquisitionkeyList=cell2mat(funcSelectInTable('retrieveAcq','Choose an acquisition',0,'Cancel'));
        
        %New case 19 added by Song
        %It reads the analysis results from database and populate
        %'machineParameterByData' and 'kValues'
        
        if acquisitionkeyList~=0   %0 if ncel button has not been pressed
            xlsLineNum = 1;
            Result.DXASelenia = false;
            flag.RawImage = false;
            if size(acquisitionkeyList,1)==1    %1 patient mode
                Info.MultiAcquisitionAnalysis=false;
                Info.AcquisitionKey=acquisitionkeyList;
                Result.DXAProdigyCalculated = false;
                Result.DXAProdigyBreastCalculated = false;
                RetrieveInDatabase('ACQUISITION');
                Database.Step=1;
                Analysis.Step=1;
                Info.CommonAnalysisKey=0;
                Info.FreeFormAnalysisKey=0;
                Analysis.SaveInFile = false;
                %Info.Analysistype = 0;
            else            %multi selection mode
                OperatorSave=Info.Operator;
                %%Operator 20 is for automatic restarting Matlab, Is  is
                %%used in the startup.m file Commented by SM 081115
% %                 if  OperatorSave == 11 %%%%%%%%%% changed from 20, no such operator. automation JW 5/11/2011 SM removed 3/7/13OperatorSave == 20 ||
% %                     if Info.Analysistype == 0
% %                     Info.Analysistype = 5;
% %                     end
% %                 else
                    Info.Analysistype=cell2mat(funcSelectInTable('analysistype','What analysis do you want to perform?',0));
% %                 end
                %Info.Analysistype = 5;
                Result.DXAProdigyCalculated = false;
                Result.DXAProdigyBreastCalculated = false;
                Info.MultiAcquisitionAnalysis=true;
                set(ctrl.SaveNextPatient,'enable','on');
                set(ctrl.DontSaveNextPatient,'enable','on');
                set(ctrl.StopReading,'enable','on');
                set(ctrl.Skip,'enable','on');
                set(f0.menu.DatabaseSave,'enable','off');
                
                StopReading=false;
                FirstPassage=true;
                
% % % %                 acquisitionkeyListSXA=mxDatabase(Database.Name,['select acquisition_id from acquisition where acquisition_id=',num2str(Info.AcquisitionKey)]);
% % % %                  Info.AcquisitionKey=cell2mat(acquisitionkeyListSXA(1));
                
                AutomaticAnalysis.StructuralAnalysisDone=0;
                
                if Info.Analysistype==5
                    Info.FD_Density = false;
                    AutomaticAnalysis.StructuralAnalysisDone=0;
                end;
                 
                 if (Info.Analysistype == 23)    % added by AM 11042013
                      Info.Analysistype=5;
                      Info.Operator23=true;
                      AutomaticAnalysis.StructuralAnalysisDone=1;
                      AutomaticAnalysis.StructuralAnalysisDone_Extra=false;
                      flag.Density = false;
                      Info.FD_Density = false;
                 end
                
                 if (Info.Analysistype == 24)    % added by AM 11262013
                     
                     Analysis.SXAMode='Auto';
                     AutomaticAnalysis.PhantomlessisDone=1;
                     flag.Density = false;
                     Info.FD_Density = false;

                 end
                 
                 if (Info.Analysistype == 25)
                     
                     Analysis.SXAMode='Auto';
                     AutomaticAnalysis.AutomaticSXAThreshold=true;
                     flag.Density = false;
                     Info.FD_Density = false;
                     
                 end
                 
                 
                 if (Info.Analysistype == 26)
                     Info.Analysistype=5;
                     Analysis.SXAMode='Auto';
                     AutomaticAnalysis.StructuralAnalysisDone=1;
                     Info.FD_Density = true;
                     flag.Density = false;
                 end
                 
                 if (Info.Analysistype == 27)
                     flag.Density = false;
                     Info.Operator=true;
                     Info.QualityControl=false;
                     Info.AutomaticThreshold=true;
                     Info.FD_Density = false;
                 end
                 
                 
                  if (Info.Analysistype == 29)
                      
                      Info.Analysistype=5;
                      Info.Operator23=true;
                      AutomaticAnalysis.StructuralAnalysisDone=1;
                      AutomaticAnalysis.StructuralAnalysisDone_Extra=true;
                      flag.Density = false;
                      Info.FD_Density = false;
                 end
                 

                 
                 if (Info.Analysistype == 19)    %Case 19 added by Song 06-15-2010
                    noAnaIDList = readDataPopTables(acquisitionkeyList);
                    if ~isempty(noAnaIDList)
                        disp('No analysis available for the following acquisition IDs:');
                        disp(noAnaIDList);
                    end
                else %for all other analysis types
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
                    if (Info.Analysistype==5  | Info.Analysistype==16)
                       if SXAreport == true
                            if ~debugMode
                                CreateReport('NEW',Info.AcquisitionKey);
                            end
                       end
                    end
                    
                    if Info.Operator == 14
                        if Analysis.Auto==true    % Added by Am 12172013
                            acquisitionkeyList= Nacquisition;
                        else
                            acquisitionkeyList=temp_acqs;
                        end;
                    end
% % %                     for RetrieveInDatabaseIndex=1:size(acquisitionkeyList,1)
                  


                     %%% Added by AM 12092013
% % %                     multiWaitbar( 'CloseAll' );
% % %                     multiWaitbar( 'Acquisition List Progress', 0, 'CancelFcn', @(a,b) disp( ['Cancel ',a] ) );

                    for RetrieveInDatabaseIndex=1:size(acquisitionkeyList,1)
%                         abort = multiWaitbar( 'Acquisition List Progress', RetrieveInDatabaseIndex/size(acquisitionkeyList,1) );
% % %                         if abort
% % %                             
% % %                             break
% % %                         else
% % %                             pause( 0 )
% % %                         end

                        
                        
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
                        all_slopes = findobj('Tag', 'Slope');
                        for i = 1:length(all_slopes)
                            delete(all_slopes(i));
                        end
                        all_inits = findobj('Tag', 'hInit');
                        for i = 1:length(all_inits)
                            delete(all_inits(i));
                        end
                        all_images = findobj('Tag', 'BreastImage');
                        for i = 1:length(all_images)
                            delete(all_images(i));
                        end
                        all_images = findobj('Tag','QC_phant');
                        for i = 1:length(all_images)
                            delete(all_images(i));
                        end
                        all_images = findobj('Tag','GEN3');
                        for i = 1:length(all_images)
                            delete(all_images(i));
                        end
                        
                        h_slope = [];
                        h_init = [];
                        
                        if Random_Acquisition==true; % RAndomly Pick Acquisition            % Added by Am 12102013
                         
                            RandomAcquisitionKey;
                            
                      
                        else
                            Info.AcquisitionKey=acquisitionkeyList(RetrieveInDatabaseIndex,:);
                        end;

                        
                        %%%%%%%%%% automation end if 4am
                        duration=tic;
                        H=clock;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  temporary commented till Ming previledges                        
% % %                         if H(4) == 4
% % %                             createReadingList('close');
% % %                            if  Info.Analysistype == 5
% % %                             try
% % %                                 if SXAreport == true
% % %                                     CreateReport('SAVECLOSE',Info.AcquisitionKey-1);
% % %                                 end
% % %                                 %taskkill /im powerpnt.exe /f
% % %                                 %taskkill /im powerpnt.exe /f
% % %                             end
% % %                            end
% % %                             exit;
% % %                         end
                        %%%%%%%%%% automation JW 5/11/2011
                        
                        %Added by Song, 07-09-2010
                        %retrive paddle thickness and force based on the acquisition id
                        SQLstatement = ['SELECT Thickness, Force ', ...
                            'FROM acquisition ', ...
                            'WHERE acquisition_id = ', num2str(Info.AcquisitionKey)];
                        try
                        entryRead = mxDatabase(Database.Name, SQLstatement);
                        Info.thickness = entryRead{1};
                        Info.force = entryRead{2};
                        catch
                            try
                              entryRead = mxDatabase(Database.Name, SQLstatement);
                               Info.thickness = entryRead{1};
                               Info.force = entryRead{2};
                            catch
                              errmsg = lasterr
                              continue;
                            end
                        end
                            
% % %                        rce = entryRead{2};
                        
                        %SQLstatement= ['SELECT ALL SXAAnalysis.SXAAnalysis_id FROM acquisition,commonanalysis,SXAAnalysis WHERE acquisition.acquisition_id = commonanalysis.acquisition_id  AND commonanalysis.commonanalysis_id = sxaanalysis.commonanalysis_id  AND acquisition.acquisition_id = ',num2str(Info.AcquisitionKey)];
                        %sxa_id=cell2mat(mxDatabase(Database.Name,SQLstatement));;
                        %len = length(sxa_id)
                        %if len ~= 0
                        if StopReading
                            break;
                        end                       
                        %put the check mark to auto
                        '!!!!!!!!!!!!!!!!! Retrieve in Database modified for SXA analysis !!!!!!!!!!!!!!!!!!!'
                        set(ctrl.CheckAutoROI,'value',true);
                        set(ctrl.CheckAutoSkin,'value',true);
                        %set(ctrl.CheckManualPhantom,'value',0);  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SOY ANALYSIS
                        set(ctrl.CheckManualPhantom,'value',1);
                        
                        if (Info.Analysistype==4)  %%% add the BIRADS buttons
                            DrawBIRADSButtons(true);
                            Message('Select the BI-RADS score');
                            drawnow;
                        end
                        
                        %Info.AcquisitionKey=acquisitionkeyList(RetrieveInDatabaseIndex,:);
                        flag.noimage = false;
                        flag.RawImage = false;
                        
                         try   %added by AM 11142013

%                             multiWaitbar( 'Busy...', 'Busy');
                            RetrieveInDatabase('ACQUISITION');
%                             multiWaitbar( 'Busy...', 'Reset' );
                        catch                               
%                             multiWaitbar( 'CloseAll' );
                            flag.noimage == true;
                            a = 1;
                            Error.MissingImage = true;
% % %                             try
% % %                                 SaveInDatabase('QACODES');
% % %                                 
% % %                             catch
% % %                                 
% % %                             end;
                            
                            continue;
                        end
                        
                        %{
                    if flag.noimage == true;
                       continue;
                        % RetrieveInDatabaseCounter=RetrieveInDatabaseCounter+1;
                       % RetrieveInDatabase('ERRRORCODES');
                       % RetrieveInDatabase('ACQUISITION');
                    end
                        %}
                        
                        %{
                    if (Info.Analysistype==5) %automatic SXA analysis
                        if mod(RetrieveInDatabaseCounter,50)==0 %& Info.SaveStatus ~= 0
                            if RetrieveInDatabaseCounter & Info.SaveStatus ~= 0
                                 CreateReport('SAVECLOSE',Info.AcquisitionKey-1);
                                 CreateReport('NEW',Info.AcquisitionKey);
                            end
                           % CreateReport('NEW',Info.AcquisitionKey);
                        end
                    end
                        %}
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
                            Info.FD_Density = false
                            %detect ROI
                            CallBack=get(ctrl.ROI,'callback');
                            eval(CallBack);
                            %detect skin edge
                            CallBack=get(ctrl.SkinDetection,'callback');
                            eval(CallBack);
                        end
                        
                        if (Info.Analysistype==2 )  %%% contour analysis
                            %detect ROI
                            Info.FD_Density = false
                            try
% % %                                 manualnippledetection('find'); %1/13/10 JW added for nipple loc NCI/UVM biopsy patients
                                
                                CallBack=get(ctrl.ROI,'callback');
                                eval(CallBack);
                     
                                CallBack=get(ctrl.SkinDetection,'callback');
                                eval(CallBack);
                                %                             temproi=Image.image(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1);
                                %                             ReinitImage(temproi,'OPTIMIZEHIST');
                                funcThresholdContour;
                                
                                draweverything;
                                %HistogramManagement('ThresholdManagement',0);
                            catch
                                errmsg = lasterr
                                Message(['ERROR: Try manually!']);
                                %nextpatient(0);
                                % continue;
                                % return;
                            end
                        end
                        msg=get(ctrl.text_zone,'string');
                        Message([msg,'   (',num2str(RetrieveInDatabaseIndex),'/',num2str(size(acquisitionkeyList,1)),')']);
                        
                        if (Info.Analysistype==5) %from the poping window
                            Analysis.SXAMode='Auto';
                            
                            Info.Operator=11;  %use operator: automatic
                            Info.Operator=5;
                            flag.Density = false;

                            AutomaticSXAAnalysis;
                           
                            if SXAreport == true
                                if ~debugMode
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
                                    if mod(RetrieveInDatabaseCounter, 50)==0 %& Info.SaveStatus ~= 0 50
                                        if RetrieveInDatabaseCounter %& Info.SaveStatus ~= 0
                                            try
                                                CreateReport('SAVECLOSE',Info.AcquisitionKey-1);
                                            catch
                                                try
                                                    CreateReport('SAVECLOSE',Info.AcquisitionKey-1);
                                                catch
                                                    errmsg = lasterr
                                                end
                                            end

                                            CreateReport('NEW',Info.AcquisitionKey);
                                        end
                                        % CreateReport('NEW',Info.AcquisitionKey);
                                    end
                                end
                                %%%%% commented by AM 11052013
% % %                             elseif  AutomaticAnalysis.StructuralAnalysisDone == 1
% % %                                 %AutomaticPCAnalysis;
% % %                                 Info.Analysistype=12;
                             
                            end
                        end
                        
                        
                        if (Info.Analysistype==12)
                            Info.Operator=11;  %use operator: automatic
                             flag.Density = false;
                             Info.FD_Density = false;
%                             AutomaticPCAnalysis;
                  AutomaticAnalysis.StructuralAnalysisDone_Extra = false;
                           AutomaticPCAnalysis;
                            %%% commented by SM
% % %                             temp=mxDatabase(Database.Name,['select * from acquisition where acquisition_id=',num2str(Info.AcquisitionKey)]);
% % %                             SQLstatement=['select * from CancerRegion where acquisition_id=',num2str(Info.AcquisitionKey),'order by id'];
% % %                             content=cell2mat(mxDatabase(Database.Name,SQLstatement));
% % %                             if ~isempty(content)
% % %                                 groups = content(:,4);
% % %                                 num_group = max(groups);
% % %                                 for i = 1:num_group
% % %                                     index = find(groups == i);
% % %                                     NumberPoints = length(index);
% % %                                     CancerRegionData.ID = content(index(1),1);
% % %                                     CancerRegionData.Points=(content(index,5:6));
% % %                                     % draw outline
% % %                                     if NumberPoints>0
% % %                                         points.NumberPoints=NumberPoints+1;
% % %                                         points.Points= CancerRegionData.Points;
% % %                                         points.Points(end+1,1:2)=CancerRegionData.Points(1,1:2);
% % %                                         Curve=funcComputeInterpolationCurve(points);
% % %                                         
% % %                                         DeactivateContour;
% % %                                         figure(figuretodraw);
% % %                                         for index=1:length(Curve(:,1))
% % %                                             plot(Curve(index,1),Curve(index,2),'linestyle','-','LineWidth',1,'marker','o','MarkerFaceColor','r','MarkerEdgeColor','r','markersize',1);
% % %                                         end
% % %                                         Message('Ok');
% % %                                     end;
% % %                                     %CancerROIMask = roipoly(Image.OriginalImage, CancerRegionData.Points(:,1);, CancerRegionData.Points(1,2);)
% % %                                     AutomaticPCAnalysisROI(CancerRegionData);
% % %                                     %Chestwall('FROMDATABASE');
% % %                                 end
% % %                             end
                            msg=get(ctrl.text_zone,'string');
                            Message([msg,'   (',num2str(RetrieveInDatabaseIndex),'/',num2str(size(acquisitionkeyList,1)),')  ',num2str(Info.AcquisitionKey)]);
                            
                        end
                        
                        if (Info.Analysistype==13)
                            Info.Operator=11;  %use operator: automatic
                            funcFreeAreaCalculation;
                            flag.Density = false;
                            Info.FD_Density = false;
                        end
                        
                        if (Info.Analysistype==14)
                            Info.Operator=11;  %use operator: automatic
                            flag.Density = false;
                            Info.FD_Density = false;
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
                        
                        if (Info.Analysistype==15)  %Auto DSP7 QC
                            Info.Operator=11;
                            Analysis.SXAMode='Auto';
                            flag.Density = false;
                            Info.FD_Density = false;
                            AutomaticQCDSP7Analysis;
                        end
                        
                        if (Info.Analysistype==16)  %Auto Wax/GEN3 QC
                            %Info.Operator=11;
                            Analysis.SXAMode='Auto';
                            flag.Density = false
                            AutomaticQCWAXAnalysis;
                            Info.FD_Density = false;;
                            if mod(RetrieveInDatabaseCounter,100)==0 %& Info.SaveStatus ~= 0 50
                                if RetrieveInDatabaseCounter %& Info.SaveStatus ~= 0
                                    try                                                      %%% comented Am 06262013
                                        CreateReport('SAVECLOSE',Info.AcquisitionKey-1);
                                    catch
                                        try
                                            CreateReport('SAVECLOSE',Info.AcquisitionKey-1);
                                        catch
                                            errmsg = lasterr
                                        end
                                    end
                                    if SXAreport == true
                                        if ~debugMode
                                            CreateReport('NEW',Info.AcquisitionKey);
                                        end
                                    end
%                                     CreateReport('NEW',Info.AcquisitionKey);
                                end
                                if SXAreport == true
                                        if ~debugMode
                                            CreateReport('NEW',Info.AcquisitionKey);
                                        end
                                    end
%                                 CreateReport('NEW',Info.AcquisitionKey);
                            end
                        end
                        
                        
                        if (Info.Analysistype == 24)
                            Info.Operator=24;
                            Info.FD_Density = false;
                            try
                                AutomaticPhantomLessSXA;
                            catch
                                errmsg = lasterr
% % %                           ok_continue=true;
                            end;
                        end
                        
                        
                        
                        if   (Info.Analysistype == 25)
                            
                            AutomaticAnalysis.AutomaticSXAThreshold==true;
                            Breast_Density3;
                            
                        end
                        
                        
                        if (Info.Analysistype==27 )  %%% contour analysis  added by AM 05142014
                            
                            try
                                
% % %                                 CallBack=get(ctrl.ROI,'callback');
                                                                             %  % Temproray commented 09/192014
% % %                                 eval(CallBack);
% % %                                 CallBack=get(ctrl.SkinDetection,'callback');
% % %                                 eval(CallBack);   
                                AutomaticSXAAnalysis;
                                AutomaticDensity;
                                draweverything;
                                
                            catch
                                try
                                AutomaticDensity;
                                draweverything;
                                catch
                                    
                                errmsg = lasterr
                                Message(['ERROR: Try manually!']);
                                nextpatient(1);
%                                 multiWaitbar( 'CloseAll' );     
%                                 
                                end
                            end
                        end
                        
                        if (Info.Analysistype==8) %NOTHING
                                                 
                             Replace_flipinfo();
                                                            
                        end
                                               
                        ok_continue=false;  %ok_continue will become true when the saving operation is performed all right
                        while ~ok_continue
                       
% % %                             set(dummyuicontrol2,'value',true)                                
                            waitfor(dummyuicontrol2,'value',true);      %wait 'save / next patient'

                           
                            if (Info.SaveStatus==1 ||(Info.SaveStatus==0 && AutomaticAnalysis.StructuralAnalysisDone==1) || (Info.SaveStatus==1 && AutomaticAnalysis.StructuralAnalysisDone==0))
                                %save
                                if (Info.Analysistype==1)||(Info.Analysistype==6)   %free form
                                    SaveInDatabase('FREEFORMANALYSIS');
                                elseif (Info.Analysistype==14) & Analysis.SaveInFile ~= true      %threshold
                                    SaveInDatabase('THRESHOLDANALYSIS');
                                    if Analysis.PhantomID == 7 | Analysis.PhantomID == 8 | Analysis.PhantomID == 9
                                        SaveInDatabase('SXASTEPANALYSIS');
                                    
                                    else
                                        SaveInDatabase('SXAANALYSIS');
                                    end
                                elseif (Info.Analysistype==2)      % manual threshold
                                    SaveInDatabase('MANUALTHRESHOLDANALYSIS');
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
                                                    if debugMode
                                                        genBreastXlsReport(Analysis, SXAAnalysis, Info, MachineParams, 'SXAstepAnalysis');
                                                        ok_continue = true;
                                                    else
                                                        SaveInDatabase('SXASTEPANALYSIS');
                                                    end
                                                catch
                                                    errmsg = lasterr
                                                    
                                                    try
                                                        SaveInDatabase('SXASTEPANALYSIS');
                                                        % if(strfind(errmsg, 'Subscripted assignment dimension mismatch'))
                                                    catch
                                                        errmsg = lasterr
                                                        wr_msg = 'Failed DB SXA'
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
                                
                                    if ((Info.Analysistype == 5 ) & (Info.SaveStatus==0))
                                        ok_continue=true;
                                    end;
                                %%%%Added by AM for operator 23  11222013    
                                if ((AutomaticAnalysis.StructuralAnalysisDone==1) &&  (Info.Analysistype == 5 ) && (Info.SaveStatus==1))
                                    try
                                        SaveInDatabase('COMMONANALYSIS');
                                    catch
                                        errmsg = lasterr
                                      
                                     end
                                     try
                                         if  Info.CommonAnalysisKey~=0
                                             if Info.CheckStructural==false
                                                 Message('Saving results ... ');
                                                 SaveInDatabase('STRUCTURALANALYSIS');
                                                 
% % %                                                  try % added by AMP 02022015
% % %                                                      SaveInDatabase('STRUCTURALANALYSISExtra');
% % %                                                      
% % %                                                  catch  err
% % %                                                      
% % %                                                      disp(err.identifier);
% % %                                                      disp(err.message);
% % %                                                      disp('STRUCTURALANALYSISExtra Failed');
% % %                                                      ok_continue=true;
% % %                                                      continue;
% % %                                                  end
                                                 ok_continue=true;
                                                 append = true;
                                                 % Extra Features
                                                 %  genRoiXlsReport(roiParams, Info, append);
                                                 %  genFeatXlsReport(featParam, StructuralAnalysis_400, featErr, Info, append);
                                             end
                                             
                                         end
                                         
                                     catch  err
                                         
                                         disp(err.identifier);
                                         disp(err.message);
                                         disp('STRUCTURALANALYSIS Failed');
                                         ok_continue=true;
                                         continue;
                                     end
                                        
                                         try
                                        if   Info.FD_Density==true;
                                            SaveInDatabase('FractionalDimensionDensity');
                                            ok_continue=true;
                                        end
                                        
                                    catch
                                        errmsg = lasterr
                                        ok_continue=true;
                                        continue;
                                    end
                                        
                                
                                end
                
                                elseif   (Info.Analysistype == 25)
                                    
                                    AutomaticAnalysis.AutomaticSXAThreshold==true;
                                    
                                    try
                                        SaveInDatabase('AutomaticSXAThreshold');
                                    catch
                                        errmsg = lasterr
                                        
                                        try
                                            SaveInDatabase('AutomaticSXAThreshold');
                                           
                                        catch
                                            errmsg = lasterr
                                            ok_continue=true;
                                            continue;
                                            
                                        end
                                        
                                        ok_continue=true;
                                        continue;
                                    end
                                    
                                    
                                elseif   (Info.Analysistype == 27 && Info.SaveStatus==1)
                                    
                                    try
                                        SaveInDatabase('AutomaticContour');
                                        ok_continue=true;
                                    catch
                                        
                                        try
                                            SaveInDatabase('AutomaticContour');   
                                        catch exception 
                                            disp(exception)
                                            ok_continue=true;
                                            continue;
                                            
                                        end
                                        
                                        ok_continue=true;
                                        continue;
                                    end
                                    
                                    
                                 
                                elseif Info.Analysistype==15
                                    if ~Error.DENSITY
                                        try
                                            SaveInDatabase('QCDSP7ANALYSIS');
                                        catch
                                            errmsg = lasterr
                                            try
                                                SaveInDatabase('QCDSP7ANALYSIS');
                                            catch
                                                errmsg = lasterr
                                                ok_continue=true;
                                                continue;
                                                %nextpatient(0);
                                                %return;
                                            end
                                        end
                                    end
                                elseif Info.Analysistype==16
                                    if debugMode
                                        genGen3XlsReport(Analysis, Info, MachineParams, 'Gen3Analysis');
                                        ok_continue = true;
                                    else
                                        if ~Error.DENSITY
                                            try
                                                SaveInDatabase('QCWAXAnalysis');
                                             
                                            catch
                                                errmsg = lasterr

                                                    try
                                                        SaveInDatabase('QCWAXAnalysis');
                                                        
                                                    catch
                                                        errmsg = lasterr
                                                        ok_continue=true;
                                                        continue;
                                                        %nextpatient(0);
                                                        %return;
                                                    end
                                                
                                            end
                                        end
                                    end
                                elseif Info.Analysistype==4  %BI-RADS scoring
                                    SaveInDatabase('BI-RADS');
                                elseif (Info.Analysistype==8) %NOTHING
                                    %                                 Center=get(ctrl.Center,'value');
                                    %                                 mxDatabase(Database.Name,['update acquisition set machine_id=''',num2str(Center),''' where acquisition_id=',num2str(Info.AcquisitionKey)]);
                                    %                                 comment=get(ctrl.comment,'string');
                                    %                                 mxDatabase(Database.Name,['update acquisition set film_identifier=''',comment,''' where acquisition_id=',num2str(Info.AcquisitionKey)]);
%                                     Replace_flipinfo();
                                    ok_continue=true;
                                                     

                                
                                        %%%%Added by AM for operator 24 12032013    
                                elseif  ((Info.Analysistype==24) & (AutomaticAnalysis.PhantomlessisDone==1) & (Info.SaveStatus==1));
                                    try
                                        if Info.CommonAnalysisKey==0
                                        SaveInDatabase('COMMONANALYSIS');
                                        end
                                    catch
                                        errmsg = lasterr
                                        ok_continue=true;
                                        
                                    end
                                    try
                                        if  ((Info.CommonAnalysisKey~=0) & (Info.StructuralAnalysis_id==0))
                                            SaveInDatabase('STRUCTURALANALYSIS');
                                            ok_continue=true;
                                            
                                        end
                                        
                                    catch
                                        
                                        errmsg = lasterr
                                        ok_continue=true;
                                        
                                    end
                                    
                                    try
                                        if Info.StructuralAnalysis_id~=0
                                            SaveInDatabase('PhantomLessSXA');
                                            ok_continue=true;
                                        end
                                        
                                    catch
                                        errmsg = lasterr
                                        ok_continue=true;
                                        continue;
                                    end
                                    
                                    ok_continue=true;
                                    
                                else
                                    ok_continue=true;
                                end

                                if ((Info.Analysistype==24) & (Info.SaveStatus==0))
                                    ok_continue=true;
                                end;
                                
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
% % %                                 if (Info.Analysistype==5)&(AutomaticAnalysis.StructuralAnalysisDone)
% % %                                  try
% % %                                     SaveInDatabase('COMMONANALYSIS');
% % %                                     SaveInDatabase('STRUCTURALANALYSIS');
% % %                                     catch
% % %                                        errmsg = lasterr
% % % %                                        ok_continue=true;
% % % %                                        continue;
% % %                                  end
% % %                                     
% % %                                  end
                            ok_continue=true;
                            end
                            if ~ok_continue
                                set(dummyuicontrol2,'value',false); % false
                            end
                        end
                        %                     end
                        %end
                        %if Info.SaveStatus ~= 0   %commented in order to increment RetrieveInDatabaseCounter
                        RetrieveInDatabaseCounter=RetrieveInDatabaseCounter+1;
                        %end
                        
                    end
%                     multiWaitbar( 'Acquisition List Progress', 'Close' )
                    
                    if Info.BIRADS
                        DrawBIRADSbuttons(false);
                    end
                    
                    if (Info.Analysistype==5)
                        if ~debugMode
                            if SXAreport == true
                                try
                                    CreateReport('SAVECLOSE',Info.AcquisitionKey);
                                catch
                                    try
                                        CreateReport('SAVECLOSE',Info.AcquisitionKey);
                                    catch
                                        errmsg = lasterr
                                    end
                                end
                            end
                            %acqs = (Info.AcquisitionKey+1:1:Info.AcquisitionKey+400);
                            all_acqs = textread(acqs_filename,'%u');
                            fid = fopen(acqs_filename,'w+');
                            
                            if length(all_acqs) > number_acqs
                                next_acqs = all_acqs(number_acqs+1:end);
                                fprintf(fid,'%u \n',next_acqs);
                                fclose(fid);
%                                 save_name = [acqs_filename(1:end-3),'mat'];
%                                 save(save_name,'acqs_filename');
                                %!matlab_run.bat;
                                mcmd = ['matlab.exe -r r_startup2(''"', acqs_filename,'"'') &']
                                %system('matlab.exe -r r_startup2(acqs_filename) &')
                                system(mcmd);
                                quit;
                            else
                                %fprintf(fid,'%u \n',[]);
                                fclose(fid);
                                delete(image_filename);
                                Message('Finish...');
%                                 multiWaitbar( 'CloseAll' );                        
%                                 send_text_message('937-829-4615','T-Mobile','Analysis is done!!!','Please Check MATLAB');  %Added by AM 12122013
                                return;
                            end
                            
                            
                            % acquisitionkeyList = textread('P:\Temp\good films\Z2_test.txt','%u');
                            % save('P:\Temp\good films\list_me.txt','acqs', '-ascii');
                            %copyfile('P:\Temp\good films\list.txt','P:\Temp\good films\list.txt');
                        end
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
    case 'ACQUISITION'
        %%%%%%%%%% tic
        ROI = [];
%         ROI2 = [];
        MachineParams = [];
        ReportText=[];
        Error=[];
        Error.MissingImage = false;
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
        Error.FeaturesFailed=false;
        Error.ROIFailed=false;
        Error.MM=false;
        % Info.Analysistype = 0;
        flag.FileFromDatabase=true;
        Info.ChestWallID=0;
        Info.Database=true;
        flag.small_paddle = [];
        flag.small_swapped = false;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%% retrieve the  acquisition named acquisitionkey %%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
          kGE = 0.71;
        
% % %         SQLstatement=['select * from QA_code_results where acquisition_ID=',num2str(Info.AcquisitionKey)];    
% % %         H=mxDatabase(Database.Name,SQLstatement);
% % %         QA.codeDescription=lower(H(2));  
        
        %execute SQL command
        b=mxDatabase(Database.Name,['select * from acquisition where acquisition_id=',num2str(Info.AcquisitionKey)]);
        
        if isempty(b)
            b1=mxDatabase(Database.Name,['select * from acquisition_tomo where acquisition_id=',num2str(Info.AcquisitionKey)]);
            if ~isempty(b1)
                acquisition = 'acquisition_tomo';
                dicominfo = 'DICOMinfo_tomo';
            else
                acquisition = 'acquisition';
                dicominfo = 'DICOMinfo_tomo';
            end
        else
            b1=mxDatabase(Database.Name,['select image_Number from acquisition_tomo where acquisition_id=',num2str(Info.AcquisitionKey)]);
            if ~isempty(b1)
                acquisition = 'acquisition_tomo';
                dicominfo = 'DICOMinfo_tomo';
            else
                acquisition = 'acquisition';
                dicominfo = 'DICOMinfo';
            end
        end        
          
        b=mxDatabase(Database.Name,['select * from ', acquisition, ' where acquisition_id=',num2str(Info.AcquisitionKey)]);
        fname=strcat(cell2mat(b(17)),'');   %erase extra ' '
        [fname_dir,name,ext] = fileparts(fname);
        %Info.fname = fname;
        %fname(1:2) = [];
        %fname_init = fname;
        if ~isempty(cell2mat(b(2)))
            study_id = lower(b(2));
            study_id = study_id{1};
        else
            study_id = 'none';
        end
       
        Info.study_id =study_id;
        index_slash = find(fname=='\');
        fname = fname(index_slash(end)+1: end);
        Info.patient_id=cell2mat(b(3));
        str = computer;
    
        Info.machine_id=num2str(b{1,7});
        date_acq = b{1,6};
        
        %%%Added by AM for AutomaticSXAAnalysis to find out the Breast
        h=mxDatabase(Database.Name,['select PerformedProcedureStepDescription, SeriesDescription, ViewPosition, Manufacturer, ManufacturerModelName  from ', dicominfo, ' where DICOM_ID =(select DICOM_id from  ', acquisition, '  where acquisition_id=',num2str(Info.AcquisitionKey),')']);
        Info.PerformedProcedureStepDescription=cell2mat(h(1));
        Info.SeriesDescription=cell2mat(h(2));
        Info.ViewPosition=cell2mat(h(3));
        Info.Manufacturer=cell2mat(h(4));
        Info.ManufacturerModelName=cell2mat(h(5));
        
        %digitizer
        SQLstatement=['select digitizer.digitizer_id,Digitizer_description from  ', acquisition, ' ,digitizer where acquisition_id=',num2str(Info.AcquisitionKey),' and digitizer.digitizer_id=',acquisition,'.digitalizer_id'];
        a=mxDatabase(Database.Name,SQLstatement);
        Info.DigitizerId=cell2mat(a(1));
        Info.DigitizerDescription=cell2mat(a(2));
% % %   Info.study_id = lower(b(2));
        date_driveI = datenum('20081231', 'yyyymmdd');
% % %         DateNumber = date_driveI;
% % %         formatOut = 'mmmm-dd-yyyy';
% % %         date_driveI = datestr(DateNumber,formatOut)
        
        
        date_driveKM = datenum('20090930', 'yyyymmdd');
        date_driveK = datenum('20110630', 'yyyymmdd');
       
         date_driveMGH=datenum('20120501', 'yyyymmdd'); 
         date_driveMGH1=datenum('20130501', 'yyyymmdd');
         date_driveN = datenum('20120601', 'yyyymmdd');
         date_driveUVM=datenum('20120901', 'yyyymmdd');
         date_driveUVM1=datenum('20130401', 'yyyymmdd');
         date_driveCP=datenum('20130631', 'yyyymmdd');  %Am 10072013
         date_driveUCSF=datenum('20130901', 'yyyymmdd'); % Am 10112013
         
         date_40swap_beg=datenum('20160428', 'yyyymmdd');
         date_40swap_end=datenum('20161012', 'yyyymmdd');
         
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
        elseif ~strcmp(study_id(1:3),'non')  %SM modified 05-17-13
            film_identifier = study_id;
        else
            film_identifier = 'none';
        end
        Analysis.film_identifier = film_identifier;
        [ret, comp_name] = system('hostname');
        image_columns = [];
        image_size = [];
        if Info.DigitizerId >= 4  & Info.DigitizerId <= 7 %| Info.DigitizerId == 11 %digitalInfo.DigitizerId >= 4 %digital
            dvd_str = findstr('dvd',film_identifier);
            %date_acq = b{1,6}; %5/1/09: JW replaced with study_date from DICOMinfo table
            
            if ~strcmp(Database.Name,'mammo')
                c=mxDatabase(Database.Name,['select * from ', dicominfo, ' where DICOM_ID =(select DICOM_id from ',acquisition,' where acquisition_id=',num2str(Info.AcquisitionKey),')']);
                %image_columns =mxDatabase(Database.Name,['select columns from DICOMinfo where DICOM_ID =(select DICOM_id from acquisition where acquisition_id=',num2str(Info.AcquisitionKey),')']);
                                
                if ~isempty(c)
                     date_acq = c{1,204};
                     if Info.centerlistactivated == 75
                         image_columns = cell2mat(c(29));
                     else   
                         image_columns = cell2mat(c(29))/2;
                     end
                      if image_columns > 1350*crop_coef
                         flag.small_paddle = false;
                        else
                            flag.small_paddle = true;
                        end
                else
                     cacq =mxDatabase(Database.Name,['select * from  ', acquisition, '  where acquisition_id=',num2str(Info.AcquisitionKey)]);
                     date_acq = cacq{1,6};       
                     image_size = cacq{1,20}; 
                      if image_size > 3288177
                    flag.small_paddle = false;
                else
                    flag.small_paddle = true;
                 end
                end 
              Info.date_acq = date_acq(1:8);
                
                folder = [date_acq(1:4),'-',date_acq(5:6),'\'];
            end
            if flag.small_paddle == true
                Info.paddle_type = 1;
            else
                Info.paddle_type = 2;
            end
            
            if ~isempty(strfind(c{1,15},'MOLYBDENUM'))
                Info.targetmaterial = 'MOLYBDENUM';
            elseif ~isempty(strfind(c{1,15},'TUNGSTEN'))
                Info.targetmaterial = 'TUNGSTEN';
            else
                Info.targetmaterial = 'unknown'
            end    
           Info.thickness_dicom = c{1,20};
            Info.force = c{1,31};
            if Info.force == 0 
                Info.force = 44.5;
            end
            fg = strcmp(film_identifier(1:3),'non')
            date_acq_num = datenum(date_acq, 'yyyymmdd'); % AM 10122013
% % %             DateNumber = date_acq_num;   
% % %             formatOut = 'mmmm-dd-yyyy';
% % %             date_acq_num = datestr(DateNumber,formatOut)
            machine_id = Info.centerlistactivated;
            if (date_acq_num > date_40swap_beg & date_acq_num < date_40swap_end) & machine_id == 40
                flag.small_swapped = true;
            end
                

% %             if (strcmp(film_identifier(1:3),'cpm') | strcmp(film_identifier(1:4),'cpuc') |...
% %                     strcmp(film_identifier(1:3),'har') | ~isempty(dvd_str) | strcmp(film_identifier(1:3),'not')...
% %                     | strcmp(film_identifier(1:3),'non')| strcmp(film_identifier(1),'0') | strcmp(film_identifier(1),'1')) | strfind(film_identifier,'DVD')%for CPMC
% %                 
             %%NO LONGER NEEDED sypks 06-08-2018
% % % %                if date_acq_num>date_driveCP     %AM 10072013
% % % %                     start_dir = '\\researchstg\aaData10\Breast Studies\CPMC\DicomImageBlinded(digi)';
% % % %                     startdir_report = '\\researchstg\aaData10\Breast Studies\CPMC\';
% % % %                 elseif date_acq_num >= date_driveN
% % % %                     start_dir = '\\researchstg\aaDATA8\Lucyz-Desktop\Breast Studies\CPMC\DicomImagesBlinded(digi)';
% % % %                     startdir_report = '\\researchstg\aaDATA8\Lucyz-Desktop\Breast Studies\CPMC';
% % % %                 elseif date_acq_num >= date_driveK
% % % %                     start_dir = '\\researchstg\aaDATA5\Breast Studies\CPMC\DicomImagesBlinded(digi)';
% % % %                     startdir_report = '\\researchstg\aaDATA5\Breast Studies\CPMC';  % Am 04172013
% % % %                 elseif date_acq_num >= date_driveI
% % % %                     start_dir = '\\researchstg\aaDATA4\Breast Studies\CPMC\DicomImagesBlinded(digi)';%  Am 04/17/2013
% % % %                     startdir_report = '\\researchstg\aaDATA4\Breast Studies\CPMC';
% % % %                 else
% % % %                     start_dir = '\\researchstg\aaDATA2\Breast Studies\CPMC\DicomImagesBlinded(digi)';
% % % %                     startdir_report = '\\researchstg\aaDATA2\Breast Studies\CPMC';
% % % %                     
% % % %                 end
% % % %                 
% % % %             elseif strcmp(film_identifier(1:3),'mgh') || strcmp(film_identifier(1:3),'nov') || strcmp(film_identifier(1:3),'MGH')% for MGH %added Novato 06062013
% % % %                 
% % % %                 if date_acq_num> date_driveMGH1
% % % %                     start_dir = '\\researchstg\aaData10\Breast Studies\MGH\DicomImageBlinded(digi)';
% % % %                     startdir_report = '\\researchstg\aaData10\Breast Studies\MGH\DicomImageBlinded(digi)';
% % % %                     
% % % %                 elseif  date_acq_num> date_driveMGH
% % % %                     start_dir = '\\researchstg\aaDATA8\Lucyz-Desktop\Breast Studies\MGH\DicomImagesBlinded(digi)'; %Added by Am 04032013
% % % %                     startdir_report = '\\researchstg\aaDATA8\Lucyz-Desktop\Breast Studies\MGH'; %Added by Am 04032013
% % % %                     
% % % %                 elseif  date_acq_num > date_driveKM
% % % %                     start_dir = '\\researchstg\aaDATA5\Breast Studies\MGH\DicomImagesBlinded(digi)';
% % % %                     startdir_report = '\\researchstg\aaDATA5\Breast Studies\MGH';
% % % %                 else
% % % %                     start_dir = '\\researchstg\aaDATA6\Breast Studies\MGH\DicomImagesBlinded(digi)'; %Am Changed ming to win 05/07/2013
% % % %                     startdir_report = '\\researchstg\aaDATA6\Breast Studies\MGH';
% % % %                     
% % % %                 end
% % % %                      
% % % %             elseif strcmp(film_identifier(1:3),'uvm')  %for UVM
% % % %              
% % % %            if  date_acq_num>date_driveUVM1
% % % %                start_dir = '\\researchstg\aaData\Breast Studies\Breast Studies\UVM\DicomImageBlinded(digi)';
% % % %                      startdir_report ='\\researchstg\aaData\Breast Studies\Breast Studies\UVM\DicomImageBlinded(digi)';
% % % % 
% % % %             elseif  date_acq_num> date_driveUVM % || strcmpi(film_identifier(1:14),'UVM_09-10-2013') || strcmpi(film_identifier(1:14),'UVM_09-11-2013'));
% % % %                  start_dir = '\\researchstg\aaDATA8\Lucyz-Desktop\Breast Studies\UVM\UVM_New\DicomImagesBlinded(digi)';
% % % %                      startdir_report ='\\researchstg\aaDATA8\Lucyz-Desktop\Breast Studies\UVM\UVM_New\DicomImagesBlinded(digi)';
% % % %                 
% % % %             elseif (strcmpi(film_identifier(1:14), 'UVM_06-13-2013') || strcmpi(film_identifier(1:14), 'UVM_06_14_2013') || strcmpi(film_identifier(1:14), 'UVM_06-14-2013')  || strcmpi(film_identifier(1:14), 'UVM_06-15-2013') || strcmpi(film_identifier(1:14), 'UVM_06-16-2013') || strcmpi(film_identifier(1:14), 'UVM_06-17-2013')) 
% % % %                   start_dir = '\\researchstg\aaDATA8\Lucyz-Desktop\Breast Studies\UVM\DicomImagesBlinded(digi)';
% % % %                   startdir_report ='\\researchstg\aaDATA8\Lucyz-Desktop\Breast Studies\UVM\DicomImagesBlinded(digi)';
% % % %                    folder = [];
% % % %             else
% % % %                 start_dir = '\\researchstg\aaDATA3\Breast Studies\UVM\DicomImagesBlinded(digi)';
% % % %                 startdir_report = '\\researchstg\aaDATA3\Breast Studies\UVM';
% % % %                 folder = [];
% % % %            end
% % % %            
            if strcmp(lower(film_identifier(1:3)),'mof')  %for UCSF
                if strcmp(Info.patient_id(1:4),'3C02')
                      start_dir = ['O:\SRL\aaData\Breast Studies\3C_data\RO1_3Cimages\Moffitt\',Info.patient_id(1:7),'\png_files'];
                      startdir_report = 'O:\SRL\aaData\Breast Studies\3C_data\RO1_3Cimages\Moffitt\'; 
                      folder = []; 
                elseif strcmp(lower(Info.patient_id(1:3)),'gen')
                      start_dir = [fname_dir]; 
                      startdir_report = [fname_dir, '\'];
                      folder = []; 
                end
                %%NO LONGER NEEDED sypks 06-08-2018
% % % %             elseif strcmp(film_identifier(1:3),'sti')  %for UCSF                      
% % % %                       start_dir = '\\researchstg\aaStudies\Breast Studies\Stiffness_mammo\TTDXA_slices\png_files';
% % % %                       startdir_report = '\\researchstg\aaStudies\Breast Studies\Stiffness_mammo\TTDXA_slices'; 
% % % %                       folder = [];          
                %%NO LONGER NEEDED sypks 06-08-2018
           %% elseif strcmp(lower(film_identifier(1:3)),'ucs') || strcmp(film_identifier(1:3),'ucsf_automatic') %for UCSF  original
            elseif strcmp(lower(film_identifier(1:3)),'ucs') | strcmp(lower(film_identifier(1:5)),'pilot') %for UCSF modified by sypks 12-18-2018
                if strcmp(Info.patient_id(1:4),'3C01')
                    start_dir = ['O:\SRL\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\',Info.patient_id(1:7),'\png_files'];
                    startdir_report = 'O:\SRL\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\';
                    folder = [];
                elseif  strcmp(Info.patient_id(1:3),'3CB')
                    strcmp(Info.patient_id(1:3),'3CB')
                    start_dir = ['O:\SRL\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF_pilot\',Info.patient_id(1:6),'\png_files'];
                    startdir_report = 'O:\SRL\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF_pilot\';
                    folder = [];
                end
%% THIS IS TEMP PATH FOR RUNNING TEST 07-24-18
            elseif contains(film_identifier(1:end),'073118') || strcmp(film_identifier(1:3),'ucsf_automatic') %for UCSF
                if strcmp(Info.patient_id(1:4),'3C01')
                    start_dir = ['O:\SRL\aaStudies\Breast Studies\3CB R01\Analysis Code\Matlab\temporary_UCSF\',Info.patient_id(1:7),'\png_files'];
                    startdir_report = 'O:\SRL\aaStudies\Breast Studies\3CB R01\Analysis Code\Matlab\temporary_UCSF\';
                    folder = [];

                        %%NO LONGER NEEDED sypks 06-08-2018
% % % %                 elseif strcmp(Info.patient_id(1:5),'3C_01') | strcmp(Info.patient_id(1:8),'3C111111')
% % % %                     start_dir = '\\researchstg\aaData7\Breast Studies\UCSF-Tomo\3D';
% % % %                     startdir_report = '\\researchstg\aaData7\Breast Studies\UCSF-Tomo\3D';
% % % %                     fname = [fname(1:end-4),'_compress.dcm'];
                        %%NO LONGER NEEDED sypks 06-08-2018
%                     folder = [];
                end
                
%% Added on 08072018 to run new temporary UCSF folder with all 250 patient folders in aadata by sypks
            elseif contains(film_identifier(1:end),'alltempucsf') || strcmp(film_identifier(1:3),'ucsf_automatic') %for UCSF
                if strcmp(Info.patient_id(1:4),'3C01')
                    start_dir = ['O:\SRL\aaData\Breast Studies\3C_data\RO1_3Cimages\temporary_UCSF\',Info.patient_id(1:7),'\png_files'];
                    startdir_report = 'O:\SRL\aaData\Breast Studies\3C_data\RO1_3Cimages\temporary_UCSF\dataFiles\';
                    folder = [];

                        %%NO LONGER NEEDED sypks 06-08-2018
% % % %                 elseif strcmp(Info.patient_id(1:5),'3C_01') | strcmp(Info.patient_id(1:8),'3C111111')
% % % %                     start_dir = '\\researchstg\aaData7\Breast Studies\UCSF-Tomo\3D';
% % % %                     startdir_report = '\\researchstg\aaData7\Breast Studies\UCSF-Tomo\3D';
% % % %                     fname = [fname(1:end-4),'_compress.dcm'];
                        %%NO LONGER NEEDED sypks 06-08-2018
%                     folder = [];
                end

%% Added 07012019 to account for trace_1 film_identifier images taken at VA hospital Hawaii by sypks
            elseif contains(film_identifier(1:end),'trace_1') %for VA 1st run to get thickness to report to GE
                if strcmp(Info.patient_id(1:4),'3C03')
                    start_dir = ['O:\SRL\aaData\Breast Studies\3C_data\RO1_3Cimages\va_test_run\',Info.patient_id(1:7),'\png_files'];
                    startdir_report = 'O:\SRL\aaData\Breast Studies\3C_data\RO1_3Cimages\va_test_run\dataFiles\';
                    folder = [];

                        %%NO LONGER NEEDED sypks 06-08-2018
% % % %                 elseif strcmp(Info.patient_id(1:5),'3C_01') | strcmp(Info.patient_id(1:8),'3C111111')
% % % %                     start_dir = '\\researchstg\aaData7\Breast Studies\UCSF-Tomo\3D';
% % % %                     startdir_report = '\\researchstg\aaData7\Breast Studies\UCSF-Tomo\3D';
% % % %                     fname = [fname(1:end-4),'_compress.dcm'];
                        %%NO LONGER NEEDED sypks 06-08-2018
%                     folder = [];
                end                
%% end of addition 07012019                
                
            end
% % % %                 elseif  ~isempty(strfind(film_identifier,'ucsf_03-12-2014'))
% % % %                     start_dir = ['\\researchstg\aaStudies\Breast Studies\3CB R01\Source Data\Tissue Homogenization Project\E1111112029L\png_files'];
% % % %                     startdir_report = '\\researchstg\aaStudies\Breast Studies\3CB R01\Source Data\Tissue Homogenization Project\E1111112029L\';
% % % %                     folder = [];                  
% % % %                 elseif  ~isempty(strfind(film_identifier,'ucsf_10-17-2016'))
% % % %                     start_dir = ['\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\GEN3TEST\png_files'];
% % % %                     startdir_report = '\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\GEN3TEST\';
% % % %                     folder = [];   
% % % %                 elseif  ~isempty(strfind(film_identifier,'ucsf_10-19-2016'))
% % % %                     start_dir = ['\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\GEN3TEST\Gen3test_101916\png_files'];
% % % %                     startdir_report = '\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\GEN3TEST\Gen3test_101916\';
% % % %                     folder = [];    
% % % %                 elseif  ~isempty(strfind(film_identifier,'ucsf_10-20-2016'))
% % % %                     start_dir = ['\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\GEN3TEST\Gen3test_102016\png_files'];
% % % %                     startdir_report = '\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\GEN3TEST\Gen3test_102016\';
% % % %                     folder = [];     
% % % %                 elseif   date_acq_num>date_driveUCSF
% % % %                     start_dir = '\\researchstg\aaDATA8\Lucyz-Desktop\Breast Studies\UCSF\DicomImagesBlinded(digi)';
% % % %                     startdir_report = '\\researchstg\aaDATA8\Lucyz-Desktop\Breast Studies\UCSF\DicomImagesBlinded(digi)';                   
% % % %                 else         
% % % %                 
% % % %                     start_dir = '\\researchstg\aaData6\Breast Studies\UCSFMedCtr\DicomImagesBlinded(digi)';
% % % %                     startdir_report = '\\researchstg\aaData6\Breast Studies\UCSFMedCtr';              
% % % %                 end
% % % %             elseif  ~isempty(strfind(film_identifier,'nc'))%strcmp(film_identifier(1:2),'nc')  %for NC
% % % %                 if strcmp(comp_name(1:4),'Ming')
% % % %                     start_dir = 'U:\aaData5\Breast Studies\NC\DicomImagesBlinded(digi)'; % (aaData4 changed to aaData5) updated by Amir 04032013
% % % %                     startdir_report = 'U:\aaData5\Breast Studies\NC';%(aaData4 changed to aaData5)updated by Amir 04032013
% % % %                 else
% % % %                     start_dir = '\\researchstg\aaDATA5\Breast Studies\NC\DicomImagesBlinded(digi)';%(aaData4 changed to aaData5) updated by Amir 04032013
% % % %                     startdir_report = '\\researchstg\aaDATA5\Breast Studies\NC';%(aaData3 changed to aaData5) updated by Amir 04032013
% % % %                 end
% % % %                 folder = [];
% % % %                 
% % % %                 
% % % %                  elseif strcmpi(film_identifier(1:4),'mayo') %strcmp(study_id,'mayo') %~isempty(strfind(lower(film_identifier),lower('MGH')));
% % % %                 start_dir = '\\researchstg\aaData10\Breast Studies\MAYO';
% % % %                     startdir_report = '\\researchstg\aaData10\Breast Studies\MAYO\';
% % % %                 
% % % %                 
% % % %                 %Case added for Avon, by Song, 1/24/11
% % % %             elseif strcmpi(film_identifier(1:3),'avo')     %for Avon
% % % %                 if strcmp(comp_name(1:4),'Ming')
% % % %                     start_dir = 'D:\aaData\Breast Studies\Shanghai\DicomImagesBlinded(digi)';
% % % %                     startdir_report = 'D:\aaData\Breast Studies\Shanghai';
% % % %                 else
% % % %                     start_dir = '\\researchstg\aaData\Breast Studies\Shanghai\DicomImagesBlinded(digi)';
% % % %                     startdir_report = '\\researchstg\aaData\Breast Studies\Shanghai';
% % % %                 end
% % % %                 folder = [];
% % % %                 %End of change by Song, 1/24/11
% % % %                 %Case for Marsjden images acquired separately for Volpara, JW 11/7/12
% % % %             elseif strcmpi(film_identifier(1:18), 'marsden_11-07-2012')      
% % % %                 
% % % %                     start_dir = '\\researchstg\aaData5\Breast Studies\Marsden\DicomImagesBlinded(digi)';
% % % %                     startdir_report = '\\researchstg\aaData5\Breast Studies\Marsden';
% % % %                
% % % %                 folder = [];
% % % %                 %End change by JW 11/7/12                
% % % %                 %Case added for Marsden, by Song, 1/26/11
% % % %             elseif strcmpi(film_identifier(1:3), 'mar')     %for Marsden
% % % %                
% % % %                     start_dir = '\\researchstg\aaData3\Breast Studies\Marsden\DicomImagesBlinded(digi)';
% % % %                     startdir_report = '\\researchstg\aaData3\Breast Studies\Marsden';
% % % %                
% % % %                 folder = [];
% % % %                 %End of change by Song, 1/26/11
% % % %                 %startdir_wfolder = [start_dir,'\',folder];
% % % %                 %%% JW added 9/3/09 for Bayer GE 2000D images %%%
% % % %             elseif strcmp(film_identifier(1:3),'p01')||strcmp(film_identifier(1:3),'po1')||strcmp(film_identifier(1:3),'PO1')  % Amir added 08132013 For P01 
% % % %               
% % % %                  if strcmp(b(16),'01-Feb-2010')
% % % %                         start_dir = '\\researchstg\working_directory\projects-snap\aaSTUDIES\Breast Studies\TLSTY_P01_invivo\Source Data\Mammograms\second batch\DicomImagesBlinded_P01';
% % % %                         startdir_report = '\\researchstg\aadata\Breast Studies\Tlsty_P01_invivo\AutomaticAnalysisReports';
% % % %                 
% % % %                 
% % % %                  else   
% % % %                         start_dir = '\\researchstg\aadata8\Lucyz-Desktop\Breast Studies\P01\DicomImagesBlinded(digi)';
% % % %                         startdir_report = '\\researchstg\aadata8\Lucyz-Desktop\Breast Studies\P01';
% % % %                                  
% % % %          %           start_dir = 'D:\aadata\Breast Studies\Tlsty_P01_invivo\P01';
% % % %          %          startdir_report = 'D:\aadata\Breast Studies\Tlsty_P01_invivo\P01';    
% % % %               
% % % %                 end
% % % %                 folder = [];
% % % %             elseif strcmp(film_identifier(1:2),'3c')
% % % %                 if strcmp(comp_name(1:4),'Ming')
% % % %                     %start_dir = 'D:\aaDATA\Breast Studies\CPMC';
% % % %                     start_dir = 'D:\aaDATA\Breast Studies\3C_data';
% % % %                     startdir_report = 'D:\aaDATA\Breast Studies\3C_data\AutomaticAnalysisReports';
% % % %                 else
% % % %                     start_dir = '\\researchstg\aaDATA\Breast Studies\3C_data';
% % % %                     startdir_report = '\\researchstg\aaDATA\Breast Studies\3C_data\AutomaticAnalysisReports';
% % % %                 end
% % % %                 
% % % %                 folder = [];
% % % %                 tempfname=strcat(cell2mat(b(17)),'');   %erase extra ' '
% % % %                 index_slash = find(tempfname=='\');
% % % %                 folder = tempfname(index_slash(end-2)+1: index_slash(end));
% % % % 
% % % %             elseif ~isempty(strfind(study_id,'bayer'))
% % % %                 if strcmp(comp_name(1:4),'Ming')
% % % %                     if Info.DigitizerId == 8 || Info.DigitizerId == 5 || Info.DigitizerId == 4 || Info.DigitizerId == 11
% % % %                         start_dir = 'D:\Working_Directory\Projects-Snap\aaSTUDIES\Breast Studies\Bayer 2009 (bay09)\SOURCE DATA\DicomImagesBlinded';
% % % %                         startdir_report = 'D:\Working_Directory\Projects-Snap\aaSTUDIES\Breast Studies\Bayer 2009 (bay09)\SOURCE DATA';
% % % %                     else
% % % %                         %start_dir = 'D:\aaDATA\Breast Studies\CPMC';P:\aaSTUDIES\Breast Studies\Bayer 2009 (bay09)\SOURCE DATA\DigitizedImages\Bayer8001282V1LCC.dcm
% % % %                         start_dir = 'D:\Working_Directory\Projects-Snap\aaSTUDIES\Breast Studies\Bayer 2009 (bay09)\SOURCE DATA\DigitizedImages';
% % % %                         startdir_report = 'D:\Working_Directory\Projects-Snap\aaSTUDIES\Breast Studies\Bayer 2009 (bay09)\SOURCE DATA';
% % % %                     end
% % % %                 else
% % % %                     if Info.DigitizerId == 8 || Info.DigitizerId == 5 || Info.DigitizerId == 4 || Info.DigitizerId == 11
% % % %                         start_dir = '\\researchstg\Working_Directory\Projects-Snap\aaSTUDIES\Breast Studies\Bayer 2009 (bay09)\SOURCE DATA\DicomImagesBlinded';
% % % %                         startdir_report = '\\researchstg\Working_Directory\Projects-Snap\aaSTUDIES\Breast Studies\Bayer 2009 (bay09)\SOURCE DATA';
% % % %                     else
% % % %                         start_dir = '\\researchstg\Working_Directory\Projects-Snap\aaSTUDIES\Breast Studies\Bayer 2009 (bay09)\SOURCE DATA\DigitizedImages';
% % % %                         startdir_report = '\\researchstg\Working_Directory\Projects-Snap\aaSTUDIES\Breast Studies\Bayer 2009 (bay09)\SOURCE DATA';
% % % %                     end
% % % %                 end
% % % %                 folder = [];
% % % %                 %%%end JW added 9/3/09 %%%
            %%NO LONGER NEEDED sypks 06-08-2018
% % % % % % % % % % %             end
            %%NO LONGER NEEDED sypks 06-08-2018
% % % %         elseif Info.DigitizerId == 3   %analog
% % % %      
% % % %                 start_dir = '\\researchstg\aaData7\restored from backup\4-30-2012\aaData7\Breast Studies\CPMC(analog)\DicomImageBlinded';
% % % %                 startdir_report = '\\researchstg\aaData7\restored from backup\4-30-2012\aaData7\Breast Studies\CPMC(analog)\DicomImageBlinded';
% % % % % % %             else
% % % % % % %                 start_dir = '\\researchstg\aaDATA5\CPMC(analog)\DicomImageBlinded';
% % % % % % %                 startdir_report = '\\researchstg\aaDATA5\CPMC(analog)';
% % % % % % %             end
% % % %             folder = [];
% % % %             
% % % %             elseif Info.DigitizerId == 12
% % % %                  if strcmp(b(16),'01-Feb-2010')
% % % %                         start_dir = '\\researchstg\working_directory\projects-snap\aaSTUDIES\Breast Studies\TLSTY_P01_invivo\Source Data\Mammograms\second batch\DicomImagesBlinded_P01';
% % % %                         startdir_report = '\\researchstg\aadata\Breast Studies\Tlsty_P01_invivo\AutomaticAnalysisReports';
% % % %                 
% % % %                 
% % % %                  else   
% % % %                         start_dir = '\\researchstg\aadata8\Lucyz-Desktop\Breast Studies\P01\DicomImagesBlinded(digi)';
% % % %                         startdir_report = '\\researchstg\aadata8\Lucyz-Desktop\Breast Studies\P01';
% % % %                                    
% % % %                 end
% % % %                 folder = [];
                
            
% % % %         elseif Info.DigitizerId == 1 | Info.DigitizerId >= 8 & Info.DigitizerId <= 11
% % % %             if ~isempty(strfind(lower(study_id),lower('mayo'))) %strcmp(study_id,'mayo') %~isempty(strfind(lower(film_identifier),lower('MGH')));
% % % %                 start_dir = '\\digitizer1\d\DicomImages\Bo_files\Dicom\png_files';
% % % %                 startdir_report = start_dir;
% % % %                 folder = [];
% % % %             elseif ~isempty(strfind(study_id,'bayer'))
% % % %                 if strcmp(comp_name(1:4),'Ming')
% % % %                     if Info.DigitizerId >= 8 & Info.DigitizerId <= 11
% % % %                         start_dir = 'D:\Working_Directory\Projects-Snap\aaSTUDIES\Breast Studies\Bayer 2009 (bay09)\SOURCE DATA\DicomImagesBlinded';
% % % %                         startdir_report = 'D:\Working_Directory\Projects-Snap\aaSTUDIES\Breast Studies\Bayer 2009 (bay09)\SOURCE DATA';
% % % %                     else
% % % %                         %start_dir = 'D:\aaDATA\Breast Studies\CPMC';P:\aaSTUDIES\Breast Studies\Bayer 2009 (bay09)\SOURCE DATA\DigitizedImages\Bayer8001282V1LCC.dcm
% % % %                         start_dir = 'D:\Working_Directory\Projects-Snap\aaSTUDIES\Breast Studies\Bayer 2009 (bay09)\SOURCE DATA\DigitizedImages';
% % % %                         startdir_report = 'D:\Working_Directory\Projects-Snap\aaSTUDIES\Breast Studies\Bayer 2009 (bay09)\SOURCE DATA';
% % % %                     end
% % % %                 else
% % % %                     if Info.DigitizerId >= 8 & Info.DigitizerId <= 11
% % % %                         start_dir = '\\researchstg\Working_Directory\Projects-Snap\aaSTUDIES\Breast Studies\Bayer 2009 (bay09)\SOURCE DATA\DicomImagesBlinded';
% % % %                         startdir_report = '\\researchstg\Working_Directory\Projects-Snap\aaSTUDIES\Breast Studies\Bayer 2009 (bay09)\SOURCE DATA';
% % % %                     else
% % % %                         start_dir = '\\researchstg\Working_Directory\Projects-Snap\aaSTUDIES\Breast Studies\Bayer 2009 (bay09)\SOURCE DATA\DigitizedImages';
% % % %                         startdir_report = '\\researchstg\Working_Directory\Projects-Snap\aaSTUDIES\Breast Studies\Bayer 2009 (bay09)\SOURCE DATA';
% % % %                     end
% % % %                 end
% % % %                 folder = [];
% % % %             end
        %%NO LONGER NEEDED sypks 06-08-2018
        end
        
        %         elseif Info.DigitizerId == 1
        %             if ~isempty(strfind(lower(study_id),lower('mayo'))) %strcmp(study_id,'mayo') %~isempty(strfind(lower(film_identifier),lower('MGH')));
        %                 start_dir = '\\digitizer1\d\DicomImages\Bo_files\Dicom\png_files';
        %                 startdir_report = start_dir;
        %                 folder = [];
        %             end
        %         end
       startdir_wfolder = [start_dir,'\',folder]; 
        
      %  fname = [start_dir,'\',fdir_name,fname]; %commented for temporary
        
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
        if Info.centerlistactivated == 75
            Analysis.Filmresolution = 0.1;
            crop_coef = 1.42;
        end
            
        
        %Read , kVp and view_id by one query. Combined by Song 6-23-2010
        %mAs, kVp, view_id & date_acquisition
        SQLstatement=['select mAs, kVp, view_id, date_acquisition, Thickness from  ', acquisition, '  where acquisition_id=',num2str(Info.AcquisitionKey)];
        a=mxDatabase(Database.Name,SQLstatement);
        Info.mAs=a{1};
        Info.kVp = a{2};
        Info.ViewId = a{3};
        Info.acqDate = strtrim(a{4});
        Info.Thickness = a{5};
        
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
                SQLstatement=['select DICOM_ID  from ', acquisition, ' where acquisition_id=',num2str(Info.AcquisitionKey)];
                [dicom_id] = cell2mat(mxDatabase(Database.Name,SQLstatement));
                SQLstatement=['select PatientOrientation, StationName, PresentationIntentType from ', dicominfo, ' where DICOM_ID=',num2str(dicom_id)];
                Info.orientation = cell2mat(mxDatabase(Database.Name,SQLstatement));
                SQLstatement=['select StationName from ', dicominfo, ' where DICOM_ID=',num2str(dicom_id)];
                station_name = cell2mat(mxDatabase(Database.Name,SQLstatement));
                SQLstatement=['select  PresentationIntentType from ', dicominfo, ' where DICOM_ID=',num2str(dicom_id)];
                Info.PresType = cell2mat(mxDatabase(Database.Name,SQLstatement));               
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
            Settings=cell2mat(mxDatabase(Database.Name,['select mas,kvp from  ', acquisition, '  where patient_id=''',deblank(Info.PatientID),''' and study_id=''',deblank(Info.StudyID),''' and view_id=',num2str(Info.ViewId)]));
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
        SQLstatement=['select date_acquisition, time_acquisition from  ', acquisition, '  where acquisition_id=',num2str(Info.AcquisitionKey)];
        entryRead = mxDatabase(Database.Name, SQLstatement);
        Info.FilmDate = entryRead{1};
        Info.timeAcq = entryRead{2};
        %         Info.FilmDate=cell2mat(mxDatabase(Database.Name,SQLstatement));
        
        Analysis.PhantomID=cell2mat(mxDatabase(Database.Name,['select phantom_id from  ', acquisition, '  where acquisition_id=',num2str(Info.AcquisitionKey)]));
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
        %included back into code sypks 06122018
        RetrieveInDatabase('QACODES');
        
        % RetrieveInDatabase('RECOGNITION');
        
        %PhantomReference
        
        Analysis.RefFat=cell2mat(mxDatabase(Database.Name,['select reffat from phantom,  ', acquisition, '  where ',acquisition,'.phantom_id=phantom.phantom_id and acquisition_id=',num2str(Info.AcquisitionKey)]));
        Analysis.RefGland=cell2mat(mxDatabase(Database.Name,['select refGland from phantom,  ', acquisition, '  where ',acquisition,'.phantom_id=phantom.phantom_id and acquisition_id=',num2str(Info.AcquisitionKey)])); % Am 05192013
        %Analysis.RefGland=cell2mat(mxDatabase(Database.Name,['SELECT refGland from [mammo_CPMC].[dbo].[phantom],[mammo_CPMC].[dbo].[acquisition] where acquisition.phantom_id=phantom.phantom_id and acquisition_id=',num2str(Info.AcquisitionKey)]));
        % Analysis.PhantomID=cell2mat(mxDatabase(Database.Name,['select phantom_id from acquisition where acquisition_id=',num2str(Info.AcquisitionKey)]));
        if  Info.DigitizerId ~= 4
            RetrieveInDatabase('RECOGNITION');
        end
        '!!!!!!!! RETIEVEINDATABASE ACQUISITION MODIFIED !!!!!!!!!!!!!!!!!!!!!!!!'
        %set(ctrl.Cor,'value',true);      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SOY %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
        Result.DXASelenia = false;
        
%         try
            funcOpenImage(fname);
%         catch
%             try
%             funcOpenImage(fname);
%             catch
%                 
%             end;
%         end;

        
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
            
            
        elseif (Info.DigitizerId == 5) | (Info.DigitizerId == 6) | (Info.DigitizerId )== 7   % & ~findstr(Info.study_id,'UVM')
                    if Info.ViewId==2 % vIEW ID =3 IT'S NOT REQUIRED TO FLIP
% % %                         imagemenu('flipH');
                        imagemenu('flipV');
                           imagemenu('flipH');
                  if ~isempty(Info.orientation)
                  
                 if (~isempty(strfind(Info.orientation,'P\L')))
% % %                         imagemenu('flipH');
% % %                     imagemenu('flipV');
                 elseif (~isempty(strfind(Info.orientation,'A\H'))) %A\H and A\R are not required any flipping
                    ;
                elseif (~isempty(strfind(Info.orientation,'A\R')))
                    ;
                elseif (~isempty(strfind(Info.orientation,'film')))
                    ;
                end
                  end
                    end
            
        else
            %if strcmp(study_id(1:3),'p01')
            %%% added 9/28/2009 JW to include Info.DICOMinfo field
            %                   SQLstatement= ['SELECT PatientOrientation FROM acquisition, DICOMinfo WHERE acquisition.DICOM_id = DICOMinfo.DICOM_id  AND acquisition.acquisition_id = ',num2str(Info.AcquisitionKey)];
            %                   Info.DICOMinfo.PatientOrientation=mxDatabase(Database.Name,SQLstatement);
            % %              Info.Position = Info.DICOMinfo.ViewPosition;
            % %              Info.Laterality = Info.DICOMinfo.ImageLaterality;
            %             Info.orientation = Info.DICOMinfo.PatientOrientation;
            
           if ~isempty(Info.orientation)                
                if  (~isempty(strfind(Info.orientation,'A\F')))
                    if ~isempty(strfind(Info.orientation,'A\FR'))
                        imagemenu('flipV');
                    elseif Info.ViewId ==4 | Info.ViewId ==29 | Info.ViewId ==35  | Info.ViewId==1
                        imagemenu('flipV');
                    end
                elseif (~isempty(strfind(Info.orientation,'A\L')))
                    imagemenu('flipV');
                elseif (~isempty(strfind(Info.orientation,'P\F')))
                    if (~isempty(strfind(Info.orientation,'P\FL')))
                        imagemenu('flipV');
                        imagemenu('flipH');
                        flag.HorizontalFlip=true;
                    else

                            imagemenu('flipH');
                            flag.HorizontalFlip=true;
                            if Info.ViewId ==4
                                imagemenu('flipV');
                            end

                    end
                elseif (~isempty(strfind(Info.orientation,'P\H')))
                    imagemenu('flipH');
                    flag.HorizontalFlip=true;
                elseif (~isempty(strfind(Info.orientation,'P\L')))
                    imagemenu('flipH');
                    flag.HorizontalFlip=true;
                    imagemenu('flipV');
                elseif (~isempty(strfind(Info.orientation,'P\R')))
                    imagemenu('flipH');
                    flag.HorizontalFlip=true;
                elseif (~isempty(strfind(Info.orientation,'A\H'))) %A\H and A\R are not required any flipping
                    ;
                elseif (~isempty(strfind(Info.orientation,'A\R')))
                    ;
                elseif (~isempty(strfind(Info.orientation,'film')))
                    ;
                end
% % %             if ~isempty(Info.orientation)
% % %                 
% % %                 if  (~isempty(strfind(Info.orientation,'A\F')))
% % %                    if ~isempty(strfind(Info.orientation,'A\FR'))
% % %                         imagemenu('flipV');
% % %                     elseif Info.ViewId ==4 | Info.ViewId ==29 | Info.ViewId ==35  | Info.ViewId==1
% % %                         imagemenu('flipV');
% % %                     end
% % %                 elseif (~isempty(strfind(Info.orientation,'A\L')))
% % %                     imagemenu('flipV');
% % %                 elseif (~isempty(strfind(Info.orientation,'P\F')))
% % %                     if (~isempty(strfind(Info.orientation,'P\FL')))
% % %                         imagemenu('flipV');
% % %                         imagemenu('flipH');
% % %                     else
% % %                         imagemenu('flipH');
% % %                         imagemenu('flipV');
% % %                     end
% % %                 elseif (~isempty(strfind(Info.orientation,'P\H')))
% % %                     imagemenu('flipH');
% % %                 elseif (~isempty(strfind(Info.orientation,'P\L')))
% % %                     imagemenu('flipH');
% % %                     imagemenu('flipV');
% % %                 elseif (~isempty(strfind(Info.orientation,'P\R')))
% % %                     imagemenu('flipH');
% % %                 elseif (~isempty(strfind(Info.orientation,'A\H'))) %A\H and A\R are not required any flipping
% % %                     ;
% % %                 elseif (~isempty(strfind(Info.orientation,'A\R')))
% % %                     ;
% % %                 elseif (~isempty(strfind(Info.orientation,'film')))
% % %                     ;
% % %                 end
% % %                 
                
               %v8 old 
% %                 if  (~isempty(strfind(Info.orientation,'A\F')))
% %                     if ~isempty(strfind(Info.orientation,'A\FR'))
% %                         imagemenu('flipV');
% %                     elseif Info.ViewId ==4
% %                         imagemenu('flipV');
% %                     end
% %                 elseif (~isempty(strfind(Info.orientation,'A\L')))
% %                     imagemenu('flipV');
% %                 elseif (~isempty(strfind(Info.orientation,'P\F')))
% %                     if (~isempty(strfind(Info.orientation,'P\FL')))
% %                         imagemenu('flipV');
% %                         imagemenu('flipH');
% %                     else
% %                         imagemenu('flipH');
% %                         if Info.ViewId ==4
% %                             imagemenu('flipV');
% %                         end
% %                     end
% %                 elseif (~isempty(strfind(Info.orientation,'P\H')))
% %                     imagemenu('flipH');
% %                 elseif (~isempty(strfind(Info.orientation,'P\L')))
% %                     imagemenu('flipH');
% %                     imagemenu('flipV');
% %                 elseif (~isempty(strfind(Info.orientation,'P\R')))
% %                     imagemenu('flipH');
% %                 elseif (~isempty(strfind(Info.orientation,'A\H'))) %A\H and A\R are not required any flipping
% %                     ;
% %                 elseif (~isempty(strfind(Info.orientation,'A\R')))
% %                     ;
% %                 elseif (~isempty(strfind(Info.orientation,'film')))
% %                     ;
% %                 end
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
% % %                 elseif Info.DigitizerId == 5 | Info.DigitizerId == 6
%      AM 09162013
% % %                     if Info.ViewId==2
% % %                         imagemenu('flipH');   
% % %                  
% % %                   
% % %                     end
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
        set(ctrl.CheckAutoSkin,'value',true);  %for manual temporary whole line
        set(ctrl.CheckAutoROI,'value',true); %for manual temporary false
        set(ctrl.text_zone,'String',['Ok ']); %,Info.Comments
        %CharacterRecognition('CharacterRecognition');
        
        %%%JW added 9/1/2011 for creating DICOMs and
        %%%pushing to Quantra system for "Volumetric Assessment" (SMF density analysis)
        compname=getenv('COMPUTERNAME');
        if Info.Operator == 11 && strcmp(compname,'QUANTRA');
            PullImages_CreateDICOMs_PushToQuantra(film_identifier, Info.AcquisitionKey);
        end
        %%%end addition
        
    case 'MACHINEPARAMETERS'
        %tic
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
        date_acquisition_num = datenum(Info.date_acq, 'yyyymmdd');
        Info.date_GEN3_num = datenum('20090701', 'yyyymmdd');
        
        if date_acquisition_num < Info.date_GEN3_num    
            Info.preGen3=true;
        else
            Info.preGen3=false;
        end
% % %             machine_correction = mxDatabase(Database.Name,['select * from MachineParametersCorrection where machine_id= ',num2str(Info.centerlistactivated), ' order by start_date']);
% % %                      sz_corr = size(machine_correction);
           % machine_correction = sort(machine_correction,4);
% % %             for i = 1:sz_corr(1)
% % %                 start_date_num(i) = datenum( machine_correction{i,4}, 'yyyymmdd');
% % %                 end_date_num(i) = datenum( machine_correction{i,5}, 'yyyymmdd');
% % %                 paddle_type(i)  =  machine_correction{i,3};
% % %                 error_thickDB(i) = machine_correction{i,2};
% % %                 tz_angleDB(i) = machine_correction{i,6};
% % %                 error_3DreconDB(i) = machine_correction{i,7};
% % %             end   
 
if Analysis.PhantomID == 9 & isempty(strfind(Info.study_id,'mayo'))      %% Added by AM 03112014~strfind(Info.study_id,'mayo')
    
    try
        
        if ~GEN3_MODE   % if it is false pick the value from MachineParametersCorrection_New table...
            % otherwise error thickness is zero for calibration
            
            if 0 %date_acquisition_num < Info.date_GEN3_num  % because the tables are not the same we use diff codes for Pre-GEN3 period
                
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
                
                
                
            else
                machine_correction = mxDatabase(Database.Name,['select * from MachineParametersCorrection_New where machine_id= ',num2str(Info.centerlistactivated),...
                    ' AND (MachineParameter_status LIKE ''%True%'') ',...
                    ' order by date_acquisition']);
                sz_corr = size(machine_correction);
                % machine_correction = sort(machine_correction,4);
                for i = 1:sz_corr(1)
                    
                    acquisition_id(i)=machine_correction{i,2};
                    start_date_num(i) = datenum( machine_correction{i,7}, 'yyyymmdd');
                    paddle_type(i)  =  machine_correction{i,6};
                    error_thickDB(i) = machine_correction{i,5};
                    tz_angleDB(i) = machine_correction{i,9};
                    error_3DreconDB(i) = machine_correction{i,10};
                end
                
                
                
                small_index = find(paddle_type==1);
                big_index = find(paddle_type==0);
                
                Test1=datestr(date_acquisition_num);
                
                if flag.small_paddle %image_columns < 1350
                    start_date_num_small = start_date_num(small_index); %paddle_type==1
                    error_thickDB_small = error_thickDB(small_index);   %paddle_type==1
                    tz_angleDB_small = tz_angleDB(small_index);
                    error_3DreconDB_small = error_3DreconDB(small_index);
                    acquisition_id_small=acquisition_id(small_index);
                    
                    Test2=datestr(start_date_num_small);
                    
                    dates_max = max(start_date_num_small(start_date_num_small <= date_acquisition_num ));
                    
                    Test3=datestr(dates_max);
                    if  ~isempty(start_date_num_small)
                        if isempty(dates_max)
                            dates_max = min(start_date_num_small);
                        end
                    end
                    
                    index_date = find(start_date_num_small == dates_max);
                    index_date=index_date(:,1)
                    acquisition_id_K =num2str( acquisition_id_small(index_date));
                    
                else
                    start_date_num_big = start_date_num(big_index );
                    error_thickDB_big = error_thickDB(big_index );
                    tz_angleDB_big = tz_angleDB(big_index );
                    error_3DreconDB_big = error_3DreconDB(big_index);
                    acquisition_id_big=acquisition_id(big_index);
                    
                    dates_max = max(start_date_num_big(start_date_num_big <= date_acquisition_num ));
                    if  ~isempty(start_date_num_big)
                        if isempty(dates_max)
                            dates_max = min(start_date_num_big);
                        end
                    end
                    index_date = find(start_date_num_big == dates_max);
                    index_date=index_date(:,1)
                    %index_date = max(find(start_date_num_big < date_acquisition_num ));
                    acquisition_id_K=num2str(acquisition_id_big(index_date))
                    
                end
                
                SQLstatement_Machine = ['SELECT TOP 1 *  FROM MachineParametersCorrection_New',...
                    ' WHERE (acquisition_id lIKE ''',acquisition_id_K, '''',')',...
                    ' AND (MachineParameter_status LIKE ''%True%'') ',...
                    ' order by date_acquisition'];
                
                kentry_Alt = mxDatabase(Database.Name, SQLstatement_Machine);
                
                
                if ~isempty(kentry_Alt)
                    
                    Analysis.error_thickDB = kentry_Alt{1,5};
                    Analysis.tz_angleDB = kentry_Alt{1,9};
                    Analysis.error_3DreconDB = kentry_Alt{1,10};
                else
                    Analysis.error_thickDB = 0;
                    Analysis.tz_angleDB = [];
                    Analysis.error_3DreconDB = [];
                end
            end
            
        else
            
            Analysis.error_thickDB = 0;
            Analysis.tz_angleDB = [];
            Analysis.error_3DreconDB = [];
            index_date =0;
        end
        
    catch
        
        Analysis.error_thickDB = 0;
        Analysis.tz_angleDB = [];
        Analysis.error_3DreconDB = [];
        index_date =0;
    end
    machine_id = str2num(Info.machine_id);
 

    pregen3_thickness(date_acquisition_num,machine_id,flag);  % thickness
   % correction, added by SM 071714 %% Commented Temrorary 09/08/2014 AMP
   

   
    Analysis.error_thickDB_nooffset = Analysis.error_thickDB;
    Info.date_acquisition_num = date_acquisition_num;
    
    %offset_GEN3 = -2.1; % compensate calibration difference DSP7 and  GEN3 phantoms
% % %     offset_GEN3 = 0;
% % %     if date_acquisition_num < Info.date_GEN3_num
% % %         Analysis.error_thickDB = Analysis.error_thickDB + offset_GEN3;
% % %     end
    
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
%     MachineParams.rxBig_corr = cell2mat(param_list(11));
    MachineParams.rxBig_corr = 0;
    MachineParams.ryBig_corr = cell2mat(param_list(12));
    MachineParams.a_init = cell2mat(param_list(13));
    MachineParams.b_init = cell2mat(param_list(14));
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
    MachineParams.a_init = 0;
    MachineParams.b_init = 1;
    MachineParams.linear_coef = 1;
end

%  gen3angle_correction();
%small paddle
 date_20130812 =datenum('20130812', 'yyyymmdd');
 date_20140109 =datenum('20130812', 'yyyymmdd');
 date_20140814 =datenum('20140814', 'yyyymmdd');
 date_20160203 =datenum('20160203', 'yyyymmdd');
 date_20160401 =datenum('20160401', 'yyyymmdd');
 date_20160429 =datenum('20160429', 'yyyymmdd');
 %large paddle
 date_20130819 =datenum('20130819', 'yyyymmdd');
 date_20131219 =datenum('20131219', 'yyyymmdd');
 date_20131227 =datenum('20131227', 'yyyymmdd');
 date_20140127 =datenum('20140127', 'yyyymmdd');
 date_20140807 =datenum('20140807', 'yyyymmdd');
 date_20150812 =datenum('20150812', 'yyyymmdd');
 date_20160219 =datenum('20160614', 'yyyymmdd');
 date_20160614 =datenum('20160219', 'yyyymmdd');
 date_20160801 =datenum('20160801', 'yyyymmdd');
 date_20161020 =datenum('20161020', 'yyyymmdd');
 if strcmp(Analysis.film_identifier(1:3),'ucs') 
if flag.small_paddle == false
   if date_acquisition_num >= date_20130819 & date_acquisition_num < 20131219 
       MachineParams.rxSmall_corr = 0.3;
        MachineParams.rySmall_corr = -0.1;
   elseif date_acquisition_num >= date_20131219 & date_acquisition_num < date_20131227   
        MachineParams.rxSmall_corr =  1.1;
        MachineParams.rySmall_corr = -1.2;
   elseif date_acquisition_num >= date_20131227 & date_acquisition_num < date_20140127   
        MachineParams.rxSmall_corr = 0.3;
        MachineParams.rySmall_corr = 0;
    elseif date_acquisition_num >= date_20140127 & date_acquisition_num < date_20140807   
         MachineParams.rxSmall_corr = 0.6;
        MachineParams.rySmall_corr = -0.8;
    elseif date_acquisition_num >= date_20140807 & date_acquisition_num < date_20150812
         MachineParams.rxSmall_corr = 0.7;
        MachineParams.rySmall_corr = -0.2;
    elseif date_acquisition_num >= date_20150812 & date_acquisition_num < date_20160219        
          MachineParams.rxSmall_corr = 0.41;
        MachineParams.rySmall_corr = -1;  
    elseif date_acquisition_num >= date_20160219 & date_acquisition_num < date_20160614        
          MachineParams.rxSmall_corr = 0.67;
        MachineParams.rySmall_corr = -1.3;
    elseif date_acquisition_num >= date_20160614 & date_acquisition_num < date_20160801        
          MachineParams.rxSmall_corr = 0.68;
        MachineParams.rySmall_corr = -0.8;
    elseif date_acquisition_num >= date_20160801 %& date_acquisition_num < date_20151027        
          MachineParams.rxSmall_corr = 0.94;
        MachineParams.rySmall_corr = -0.8;       
   end
else
   if date_acquisition_num >= date_20130812 & date_acquisition_num < date_20140109 
       MachineParams.rxSmall_corr = 0.34;
        MachineParams.rySmall_corr = 1.75;
   elseif date_acquisition_num >= date_20140109 & date_acquisition_num < date_20140814   
        MachineParams.rxSmall_corr =  1;
        MachineParams.rySmall_corr = 0;
   elseif date_acquisition_num >= date_20140814 & date_acquisition_num < date_20160203   
        MachineParams.rxSmall_corr = 0.9;
        MachineParams.rySmall_corr = 0.5;
   elseif date_acquisition_num >= date_20160203 & date_acquisition_num < date_20160401   
         MachineParams.rxSmall_corr = 1.32;
        MachineParams.rySmall_corr = -3.3;
   elseif date_acquisition_num >= date_20160401 & date_acquisition_num < date_20160429   
         MachineParams.rxSmall_corr = 1.45;
        MachineParams.rySmall_corr = -3.9;
   elseif date_acquisition_num >= date_20160429 %& date_acquisition_num < date_20130812        
          MachineParams.rxSmall_corr = 0.3;
        MachineParams.rySmall_corr = -0.8;  
   end
end
              
if date_acquisition_num >= date_20160429 & date_acquisition_num  < date_20161020 & Info.centerlistactivated == 40 & flag.small_paddle ==true
    flag.large_swapped = true;
end    
 end       % t3 = toc 
        % MachineParams.num_machine = cell2mat(param_list(10));
        %
        %% Common Analysis
    case 'COMMONANALYSIS'
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%% retrieve a Common analysis named commonalysiskey %%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %retrieve the key of the acquisition
        
        SQLstatement=['select acquisition_id from commonanalysis where commonanalysis_id=',num2str(Info.CommonAnalysisKey)];
        acquisitionkey=cell2mat(mxDatabase(Database.Name,SQLstatement));
        
        % check if the open image is the good one
        if Info.AcquisitionKey~=acquisitionkey
            Info.AcquisitionKey=acquisitionkey;
            RetrieveInDatabase('ACQUISITION');
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
        funcErasefreeforms;
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
        
    case 'SXASTEPANALYSISFROMLIST'
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%% retrieve a SXA  analysis %%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        Info.SXAStepAnalysisKey=cell2mat(funcSelectInTable('RetrieveSXAStepanalysis','Choose a SXA Step analysis',0,'Cancel'));
        if Info.SXAStepAnalysisKey~=0    %0 if if cancel button has not been pressed
            Database.Step=1;    %before 2
            RetrieveInDatabase('SXASTEPANALYSIS');
        end
        
    case 'SXASTEPANALYSIS'
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%% retrieve a SXA analysis named Info.SXAAnalysisKey   %%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %retrieve The Flat Field Correction status
        %{
     if Info.PhantomID == 7
        SQLstatement=['select flatfieldcorrection_id from sxaanalysis where sxaanalysis_id=',num2str(Info.SXAAnalysisKey)];
     end
        %}
        %     Info.CorrectionId=cell2mat(mxDatabase(Database.Name,SQLstatement));
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
        SQLstatement=['select SXAStepResult, angle_ry, coord_tz, error_3DReconstruction, total_fatmass, total_leanmass, breast_volume from sxastepanalysis where sxastepanalysis_id=',num2str(Info.SXAStepAnalysisKey)];
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
        
        FileNameDensity = [Info.fname(1:end-4),'Density',Info.fname(end-3:end) ];
        FileNameThickness = [Info.fname(1:end-4),'Thickness',Info.fname(end-3:end)];
        %FileNameDensity = ['Density', Info.fname];
        %FileNameThickness =['Thickness', Info.fname];
        
        s=dir (FileNameDensity);
        if ~isempty(s)
            Analysis.DensityImage = double(imread(FileNameDensity))/100;
        end
        
        s=dir (FileNameThickness);
        if ~isempty(s)
            Analysis.ThicknessImage = double(imread(FileNameThickness))/1000;
        end
        
        SQLstatement=['SELECT ALL acquisition.phantom_id FROM acquisition,commonanalysis WHERE acquisition.acquisition_id = commonanalysis.acquisition_id  AND commonanalysis.commonanalysis_id =',num2str(Info.SXAStepAnalysisKey)];
        Analysis.Phantom_id =cell2mat(mxDatabase(Database.Name,SQLstatement)) ;
        Info.PhantomComputed=true;
        
        %retrieve pahntomD1 and PhantomD2 Distances
        %{
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
        %}
        %{
        if Analysis.ThresholdOnly == false
        %    set(ctrl.Cor,'value',true);
        %    eval(get(ctrl.CorrectionButton,'callback'));  %press on correction button
        %    ComputeDensity;
        else
            SQLstatement=['select SXAresult from sxaanalysis where sxaanalysis_id=',num2str(Info.SXAAnalysisKey)];
            Analysis.DensityPercentageAngle  = cell2mat(mxDatabase(Database.Name,SQLstatement))
        end
        %}
        %% load comments
        %{
        try
            comment=mxDatabase(Database.Name,['select comment from comment,comment_results where comment.id=comment_id and analysis_id=',num2str(Info.SXAAnalysisKey),' and analysis_type=2']);
            for index=1:length(comment)
                ReportText=[ReportText cell2mat(comment(index)) '@'];
            end
        end
        %}
        Analysis.Step = 8;
        draweverything;
        Analysis.ThresholdOnly = false;
        Message('Ok');
        
        
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
        funcThresholdContour;          %Compute the Threshold Result value + redraw
        draweverything;
        
        
        Message('Ok');
        
        
        %% Manual Threshold Analysis from the list
    case 'MANUALTHRESHOLDANALYSISFROMLIST'
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%% retrieve a threshold analysis %%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        Info.CommonAnalysisKey = -1;
        Info.AcquisitionKey = -1;
        Info.ManualThresholdAnalysisKey=cell2mat(funcSelectInTable('RetrieveManualThresholdanalysis','Choose a manual threshold analysis',0,'Cancel'));
        if Info.ManualThresholdAnalysisKey~=0    %0 if if cancel button has not been pressed
            Database.Step=1;    %before 2
            RetrieveInDatabase('MANUALTHRESHOLDANALYSIS');
        end
        %% Manual Threshold Analysis
    case 'MANUALTHRESHOLDANALYSIS'
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%% retrieve a Threshold analysis named Info.ManualThresholdAnalysisKey %%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        
        %retrieve the key of the common analysis
        SQLstatement=['select commonanalysis_id from manualthresholdanalysis where manualthreshanalysis_id=',num2str(Info.ManualThresholdAnalysisKey)];
        mananal = num2str(Info.ManualThresholdAnalysisKey);
        CommonAnalysisKey=cell2mat(mxDatabase(Database.Name,SQLstatement));
        % check if the Common analysis is the good one
        %isempty(Info.CommonAnalysisKey) |
        if  (Info.CommonAnalysisKey~=CommonAnalysisKey | Info.SkinDetection == false)
            Info.CommonAnalysisKey=CommonAnalysisKey;
            RetrieveInDatabase('COMMONANALYSIS');
        end
        
        %retrieve thresholdvalue
        SQLstatement=['select thresholdvalue,thresholdresult, threshold_area from manualthresholdanalysis where manualthreshanalysis_id=',num2str(Info.ManualThresholdAnalysisKey)];
        thresh_params = cell2mat(mxDatabase(Database.Name,SQLstatement));
        Threshold.value=thresh_params(1);
        Threshold.ThresholdResult = thresh_params(2);
        Threshold.pixels = thresh_params(3);
        Analysis.Threshold_density = thresh_params(2);
        
        set(ctrl.Cor,'value',false);
        %imagemenu('AutomaticCrop');
        %         temproi=Image.image(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1);
        %         ReinitImage(temproi,'OPTIMIZEHIST');
        HistogramManagement('ThresholdManagement',1);    %put the threshold bar at its right position
        funcThresholdContour;
        %Threshold.Computed = true;%Compute the Threshold Result value + redraw
        %draweverything;
        
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
            if isempty(strfind(filename,'none'))
                index_slash = find(filename=='\');
                fname_correction = filename(index_slash(end): end);
                filename = [startdir_report,'\corrections',fname_correction];
                filename=deblank(filename)    %for auto need to be uncomment
                %for manual
                % [filename, pathname] = ...
                %  uigetfile({'*.m';'*.mdl';'*.mat';'*.*'},'File Selector');  % for manual flat field file selection, comment if auto
            else
                filename = filename;
            end
            
            if ~strcmpi(filename,Correction.Filename)
                if isempty(strfind(filename,'none')) %~strcmpi(filename,'none')
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
                            ImageMenu('CutTopWithParam',param);
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
                        ImageMenu('CutTopWithParam',param);
                    case 'CUTB'
                        param=cell2mat(data(index,4));
                        imagemenu('CutBottomWithParam',param);

                end
            end
        end
        Analysis.OperationList={};
        %}
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
        
    
    %retrieve the state of the QA report
 
    
    
    case 'QACODES'
        %%%%%%%%%% tic
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
                case 49 %BB 3D reconstruction error beyond threshold
                    Error.SXAbbRecon = get(QA.check(index), 'value');

                case 50 %SXA attenuation fitting failure
                    Error.SXAroiFitFailure = get(QA.check(index), 'value');
                    
                case 51 %SXA attenuation fitting warning
                    Error.SXAroiFitWarning = get(QA.check(index), 'value');
                    
                case 3
                    Error.SkinEdgeFailed = get(QA.check(index), 'value');
                    
                case 52 %Features Faild
                    Error.FeaturesFailed=get(QA.check(index), 'value');
                    
                case 53 %ROI Faild 
                    Error.FeaturesFailed=get(QA.check(index), 'value');    
                    
                case 54 % Images is missing in  database 
                    Error.MissingImage=get(QA.check(index), 'value');
                case 55 % There is no Breast    
                    Error.NoBreast = get(QA.check(index), 'value');
                case 56 % Phantomless Failed  
                    Error.PhantomlessFailed= get(QA.check(index), 'value');
                    
            end
        end
        err = Error;
        if ~QAstatus
            QAreport('CLOSE');
        end
        %%%%%%%%%% t2 = toc
end

%%
function darkCounts = getDarkCounts(dbName, machId)

SQLstatement = ['SELECT dark_counts ', ...
    'FROM MachineParameters ', ...
    'WHERE machine_id = ', num2str(machId)];
entryRead = mxDatabase(dbName, SQLstatement);
darkCounts = entryRead{1};

