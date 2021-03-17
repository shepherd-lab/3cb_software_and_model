%depending on flag.action, save a common analysis, a SXA analysis, a FreeForm Analysis or a Threshold Analysis

% SaveInDatabase
% Author Lionel HERVE
% creation date 5-22-03
%8-16-2003 : two way to save common analysis : peripheral analysis done or
%not

function SaveInDatabase(RequestedAction)

global Database ctrl Info ROI flag ManualEdge Analysis data Roughness Threshold FreeForm f0 ok_continue StructuralAnalysis QA Error ChestWallData Correction
global Phantom  freeform_chestwall_id SXAAnalysis DXAAnalysis

switch RequestedAction
    case 'COMMONANALYSIS'
        if Database.Step<1
            Message('You must retrieve an Acquisition first');
            beep;
        elseif Analysis.Step<3
            Message('You must define the ROI and find the skin edge first');
            beep;
        elseif Info.AcquisitionKey==0  %to protect from the mess in the files.
            Message('It seems you have open a new file since you have retrieve a acquisition from the database.');
            beep;
        else
            if Info.CommonAnalysisKey==0 
                Message('Create a new common analysis.');
                field(1)={num2str(Info.AcquisitionKey)};
                field(2)={num2str(ROI.xmin)};
                field(3)={num2str(ROI.ymin)};
                field(4)={num2str(ROI.columns)};
                field(5)={num2str(ROI.rows)};
                if strcmp(flag.EdgeMode,'Auto')
                    field(6)={'1'};
                else
                    field(6)={num2str(funcAddSkinEdgeInDatabase(Database,ManualEdge.Points))};
                end
                field(7)={Info.Version};
                field(8)={date};
                field(9)={num2str(Analysis.Surface)};
                field(10)={'2'};   %method
                if ChestWallData.Valid
                    field(11)={num2str(funcfindnextavailablekey(Database,'ChestWall'))};
                    SaveInDatabase('ChestWALL');
                else
                    field(11)={'0'};
                end
               
                Info.CommonAnalysisKey=funcAddInDatabase(Database,'commonanalysis',field);
            elseif (ChestWallData.Valid == true & Analysis.ChestWallID == 0)
                table = 'commonanalysis';
                field = 'ChestWall_ID';
                value = freeform_chestwall_id;
                update_record(Database.Name,table,field, value);
                
            
            end

            Message('Ok');ok_continue=true;
            Database.Step=2;
            SaveInDatabase('BASICOPERATIONS');    %save basic Image Operations
        end
    case 'ChestWALL'
        Message('Create Chest wall record');
        ChestWallkey=funcFindNextAvailableKey(Database,'ChestWall');
        for indexpoint=1:ChestWallData.NumberPoints
            exdata(indexpoint,:)={ChestWallkey,indexpoint,ChestWallData.Points(indexpoint,1),ChestWallData.Points(indexpoint,2)};
        end
        mxDatabase(Database.Name,'BULKIN ChestWall',exdata);

    case 'FREEFORMANALYSIS' %2
        if Database.Step<1
            Message('You must retrieve an Acquisition first');
            beep;
        elseif Database.Step<2          % Ask for the creation of a new Common Analysis
            ok_continue=false;
            SaveInDatabase('COMMONANALYSIS');
            if ok_continue %if the creation of the new common analysis has succeed
                Database.Step=2;
                SaveInDatabase('FREEFORMANALYSIS');
            end
        elseif Analysis.Step<3
            Message('You must define the ROI and find the skin edge first');
            beep;
        elseif Info.AcquisitionKey==0;  %to protect from the mess in the database.
            Message('It seems you have open a new file since you have retrieve a acquisition from the database.');
            beep;
        %elseif Info.CommonAnalysisKey==0;  %to protect from the mess in the database.
        %    Message('It seems you have changed the skin detection since you have retrieve a common analysis from the database.');
        %    beep;
        else
            set(f0.handle,'pointer','watch');
            Message('Save FreeForms');
            freeformskey=funcAddFreeFormsEdgeInDatabase(Database,FreeForm);
            field(1)={num2str(Info.CommonAnalysisKey)};
            field(2)={num2str(freeformskey)};
            field(3)={num2str(cell2mat(data.operator(Info.Operator)))};
            field(4)={Info.Version};
            field(5)={num2str(Analysis.FreeFormResult)};
            field(6)={date};
            field(7)={num2str(round(FreeForm.Area))};
            Info.FreeFormKey=funcAddInDatabase(Database,'FreeFormAnalysis',field);
            set(f0.handle,'pointer','arrow');
            Message('Ok');
        end
    case 'SXAANALYSIS' %3
        if (Analysis.Step<8)
            Message('You must compute the SXA result first');
        elseif Database.Step<1
            Message('You must retrieve an Acquisition first');
        elseif Database.Step<2          % Ask for the creation of a new Common Analysis
            ok_continue=false;
            SaveInDatabase('COMMONANALYSIS');
            SaveInDatabase('SXAANALYSIS');
        elseif Info.AcquisitionKey==0;  %to protect from the mess in the files.
            Message('It seems you have open a new file since you have retrieve a acquisition from the database.');
        elseif Info.CommonAnalysisKey==0;  %to protect from the mess in the files.
            Message('It seems you have changed the skin detection since you have retrieve a common analysis from the database.');
        elseif Correction.Type==1
            Message('!!!Correction is not valid!!!');  %if the sxa results has been computed without the correction
            beep
        else
            %            SaveInDatabase('COMPRESSEDAREAINFO');   %save the peripheral analysis
            Message('Save SXA Analysis');
            field(1)={num2str(Info.CommonAnalysisKey)};
            field(2)={'0'};   %former field for the Roughness percentage
            field(3)={num2str(Analysis.DensityPercentageAngle)};
            field(4)={num2str(Info.CorrectionId)};             %Info.CorrectionId is defined in funcFlatFieldCorrection
            field(5)={Info.Version};
            field(6)={num2str(Info.Operator)};
            field(7)={num2str(Analysis.PhantomFatx(1))};
            field(8)={num2str(Analysis.PhantomFatx(2))};
            field(9)={num2str(Analysis.PhantomFaty(1))};
            field(10)={num2str(Analysis.PhantomFaty(2))};
            field(11)={num2str(Analysis.PhantomLeanx(1))};
            field(12)={num2str(Analysis.PhantomLeanx(2))};
            field(13)={num2str(Analysis.PhantomLeany(1))};
            field(14)={num2str(Analysis.PhantomLeany(2))};
            field(15)={date};
            field(16)={num2str(Analysis.PhantomD1)};
            field(17)={num2str(Analysis.PhantomD2)};
            field(18)={num2str(Analysis.PhantomPosition)};
            field(19)={num2str(Analysis.PhantomHeight)};
            field(20)={Analysis.SXAMode};
           % field(21)={num2str(Analysis.DensityPercentageAngle)};
           % field(22)={num2str(Analysis.SXAanalysisStatus)};
            Info.SXAAnalysisKey=funcAddInDatabase(Database,'sxaanalysis',field);
            
            SaveInDatabase('OTHERSXAINFO');
            ButtonProcessing('SaveInfo');
        end
        SaveInDatabase('QACODES');
   
    case 'SXASTEPANALYSIS' %3
        if (Analysis.Step<8)
            Message('You must compute the SXA result first');
        elseif Database.Step<1
            Message('You must retrieve an Acquisition first');
        elseif Database.Step<2          % Ask for the creation of a new Common Analysis
            ok_continue=false;
            SaveInDatabase('COMMONANALYSIS');
            SaveInDatabase('SXASTEPANALYSIS');
        elseif Info.AcquisitionKey==0;  %to protect from the mess in the files.
            Message('It seems you have open a new file since you have retrieve a acquisition from the database.');
        elseif Info.CommonAnalysisKey==0;  %to protect from the mess in the files.
            Message('It seems you have changed the skin detection since you have retrieve a common analysis from the database.');
       % elseif Correction.Type==1
        %    Message('!!!Correction is not valid!!!');  %if the sxa results has been computed without the correction
        %    beep
        else
            %            SaveInDatabase('COMPRESSEDAREAINFO');   %save the peripheral analysis
            Message('Save SXA STEP Analysis');
            field(1)={num2str(Info.CommonAnalysisKey)};
            field(2)={num2str(Analysis.DensityPercentageSkin)};
            field(3)={date};
            field(4)={num2str(Analysis.roi_valuescorr(1))};      %Info.CorrectionId is defined in funcFlatFieldCorrection
            field(5)={num2str(Analysis.roi_valuescorr(2))};
            field(6)={num2str(Analysis.roi_valuescorr(3))};
            field(7)={num2str(Analysis.roi_valuescorr(4))};
            field(8)={num2str(Analysis.roi_valuescorr(5))};
            field(9)={num2str(Analysis.roi_valuescorr(6))};
            field(10)={num2str(Analysis.roi_valuescorr(7))};
            field(11)={num2str(Analysis.roi_valuescorr(8))};
            if length(Analysis.roi_valuescorr)>8
                field(12)={num2str(Analysis.roi_valuescorr(9))};
            end
            field(13)={num2str(Analysis.params(1))};
            field(14)={num2str(Analysis.params(2))};
            field(15)={num2str(Analysis.params(3))};
            field(16)={num2str(Analysis.params(5))};
            field(17)={num2str(Analysis.params(6))};
            field(18)={num2str(Analysis.params(4))};
            field(19)={num2str(Analysis.params(7))};
            %field(20)={num2str(Info.CorrectionId)};  
            field(20)={num2str(Analysis.BreastAreaCut)};  %alfa
            field(21)={Info.Version};
            field(22)={num2str(Info.Operator)};
            field(23)={Analysis.SXAMode};
            field(24)={num2str(Analysis.TotalFatMass)};
            field(25)={num2str(Analysis.TotalLeanMass)};
            field(26)={num2str(SXAAnalysis.SXABreastVolumeReal)};
            field(27)={num2str(Analysis.DensityPercentage)};
            field(28)={num2str(Analysis.DensityPercentageNoCorr)};
            field(29)={num2str(Analysis.DensityPercentageCut)};
            field(30)={num2str(Analysis.BBcoord_set)};
            field(31)={num2str(0)};
            field(32)={num2str(0)};
            field(33)={num2str(0)};
            field(34)={num2str(0)};
            field(35)={num2str(0)};
            field(36)={num2str(SXAAnalysis.SXABreastVolumeProj)};
            
            %field(27)={Analysis.FileNameDensity};
            %field(28)={Analysis.FileNameThickness};
           % field(21)={num2str(Analysis.DensityPercentageAngle)};
           % field(22)={num2str(Analysis.SXAanalysisStatus)};
            Info.SXAStepAnalysisKey=funcAddInDatabase(Database,'sxastepanalysis',field);
            
            SaveInDatabase('OTHERSXASTEPINFO');
            ButtonProcessing('SaveInfo');
        end
        SaveInDatabase('QACODES');
        
    case 'OTHERSXAINFO'
            Message('Saving other SXA info');
            Field={};
            RoomID=get(ctrl.Center,'value');
            BRAND=((RoomID==13)||(RoomID==15)||(RoomID==16)||(RoomID==17))+1;
%            PhantomDetection;
            try
                Phantom.Angle=Phantom.Angle+0;
            catch 
                Phantom.Angle=-90;
            end
            mxDatabase(Database.Name,['insert into OtherSXAinfo values(''',num2str(funcFindNextAvailableKey(Database,'OtherSXAinfo')),''',''',num2str(Info.SXAAnalysisKey),''',''',num2str(BRAND),''',''',num2str(Analysis.Phantomfatlevel),''',''',num2str(Analysis.Phantomleanlevel),''',''',num2str(Phantom.Angle),''',''',num2str(floor(Analysis.OriginalPhantomfatlevel)),''',''',num2str(floor(Analysis.OriginalPhantomleanlevel)),''');']);
            Message('Ok');
            ok_continue=true;
    
    case 'OTHERSXASTEPINFO'
            Message('Saving other SXA Step info');
            Field={};
            RoomID=get(ctrl.Center,'value');
            BRAND=((RoomID==13)||(RoomID==15)||(RoomID==16)||(RoomID==17))+1;   
            field(1)={num2str(Info.SXAStepAnalysisKey)};
            field(2)={num2str(BRAND)};
            field(3)={num2str(Analysis.roi_values(1))};      %Info.CorrectionId is defined in funcFlatFieldCorrection
            field(4)={num2str(Analysis.roi_values(2))};
            field(5)={num2str(Analysis.roi_values(3))};
            field(6)={num2str(Analysis.roi_values(4))};
            field(7)={num2str(Analysis.roi_values(5))};
            field(8)={num2str(Analysis.roi_values(6))};
            field(9)={num2str(Analysis.roi_values(7))};
            field(10)={num2str(Analysis.roi_values(8))};
            if length(Analysis.roi_values)>8
                field(11)={num2str(Analysis.roi_values(9))};
            end
            field(12)={num2str(Analysis.ph_slope80)};
            field(13)={num2str(Analysis.ph_offset)};
            field(14)={num2str(Analysis.km)};
            field(15)={num2str(Analysis.klean)};
            field(16)={num2str(Analysis.Phantomleanlevel)};
            field(17)={num2str(Analysis.Phantomfatlevel)};
            Info.OtherSXAStepInfoKey=funcAddInDatabase(Database,'OtherSXAStepinfo',field);               
            Message('Ok');
            ok_continue=true;
            
    case 'DXAANALYSIS'  
        if (Analysis.Step<6)
            Message('You must compute the DXA result first');
        elseif Database.Step<1
            Message('You must retrieve an Acquisition first');
        elseif Database.Step<2          % Ask for the creation of a new Common Analysis
            ok_continue=false;
            Info.AcquisitionKey = Info.AcquisitionKeyLE;
            SaveInDatabase('COMMONANALYSIS');
            SaveInDatabase('DXAANALYSIS');
        elseif Info.AcquisitionKey==0;  %to protect from the mess in the files.
            Message('It seems you have open a new file since you have retrieve a acquisition from the database.');
        elseif Info.CommonAnalysisKey==0;  %to protect from the mess in the files.
            Message('It seems you have changed the skin detection since you have retrieve a common analysis from the database.');
        else
            Message('Save DXA Analysis');
            field(1)={num2str(Info.CommonAnalysisKey)};                % this is CommonAnalysis_id in the Database Table
            %field(2)={num2str(XXX)};                                   % DXAanalysis_id
            field(2)={date};                                           % DXA_analysis_date
            field(3)={num2str(DXAAnalysis.DXADensityPercentageTotal)}; % DXADensityPercentageTotal
            field(4)={num2str(DXAAnalysis.DXABreastAreaTotal)};         % DXABreatAreaTotal
            field(5)={num2str(DXAAnalysis.DXABreastVolumeProj)};       % DXABreastVolumeProj
            field(6)={Info.Version};                                   % Version
            field(7)={num2str(Info.Operator)};                         % Operator
            field(8)={Analysis.DXAMode};                               % DXAMode
            
            Info.DXAAnalysisKey=funcAddInDatabase(Database,'dxaanalysis',field); % save all these fields in the Database
        end              
        SaveInDatabase('QACODES');
            %ButtonProcessing('SaveInfo');
            
    case 'THRESHOLDANALYSIS' %4
        inf = Info.AcquisitionKey
        if ~Threshold.Computed
            Message('You must compute the threshold result first');
        elseif Database.Step<1
            Message('You must retrieve an Acquisition first');
        elseif Database.Step<2
            ok_continue=false;
            SaveInDatabase('COMMONANALYSIS');
            if ok_continue  %if the common analysis creation has succeed
                Database.Step=2;
                SaveInDatabase('THRESHOLDANALYSIS');
            end
        elseif Analysis.Step<3
            Message('You must define the ROI and find the skin edge first');
        elseif Info.AcquisitionKey==0;  %to protect from the mess in the files.
            Message('It seems you have open a new file since you have retrieve a acquisition from the database.');
        elseif Info.CommonAnalysisKey==0 ;  %to protect from the mess in the files.
            Message('It seems you have changed the skin detection since you have retrieve a common analysis from the database.');
        else
            Message('Save Threshold Analysis');
            ln = length(Analysis.Threshold_densityAll);
            %Threshold.pixels/Analysis.Surface*100
            field(1)={num2str(Info.CommonAnalysisKey)};
            field(2)={num2str(Threshold.value30)};
            field(3)={num2str(Analysis.Threshold_density)};
            field(4)={num2str(Info.CorrectionId)};             %Info.CorrectionId is defined in funcFlatFieldCorrection
            field(5)={Info.Version};
            field(6)={num2str(Info.Operator)};
            field(7)={date};
            field(8)={Analysis.SXAMode};
            for i = 1:ln
              field(i+8)={num2str(Analysis.Threshold_densityAll(i))};  
            end
            Info.ThresholdAnalysisKey=funcAddInDatabase(Database,'ThresholdAnalysis',field);
            Message('Ok');ok_continue=true;
        end

    case 'BI-RADS' %4
        score=0;
        for index=1:4
            if get(ctrl.BIRADS(index),'value')
                score=index;
            end
        end
        if score==0 %check if the BIRADS analysis was done
            Message('String','Select a BI-RADS score');
        else
            field(1)={num2str(Info.AcquisitionKey)};
            field(2)={num2str(score)};
            field(3)={date};
            field(4)={num2str(Info.Operator)};
            funcAddInDatabase(Database,'BIRADSresults',field);
            Message('Ok');ok_continue=true;
        end

    case 'COMPRESSEDAREAINFO' %7
        Message('Update the previous common analysis.');
        if Analysis.Step>4
            a=mxDatabase(Database.Name,['select * from peripheral_analysis where common_analysis_id=',num2str(Info.CommonAnalysisKey)]); %check if there were some previous peripheral analysis
            if size(a,1)>0 %in this case, delete it
                key=cell2mat(a(1,1));
                funcDelete(Database,'peripheral_analysis',key);
            end
            field(1)={num2str(Info.CommonAnalysisKey)};
            field(2)={num2str(Roughness.percentthreshold)};
            field(3)={num2str(Analysis.CompressedArea)};
            funcAddInDatabase(Database,'peripheral_analysis',field);
        end

    case 'BASICOPERATIONS' %8
        for index=1:size(Analysis.OperationList,1)
            field(1)={num2str(Info.AcquisitionKey)};
            field(2)=Analysis.OperationList(index,1);
            field(3)={num2str(cell2mat(Analysis.OperationList(index,2)))};
            funcAddInDatabase(Database,'BasicImageOperation',field);
        end
        Analysis.OperationList={};
    case 'STRUCTURALANALYSIS'
        clear field;
        SaveInDatabase('COMMONANALYSIS');
        field(1)={num2str(Info.CommonAnalysisKey)};
        field(2)={date};
        for index=1:length(StructuralAnalysis.Results)
            field(2+index)={num2str(StructuralAnalysis.Results(index))};
        end
        funcAddInDatabase(Database,'StructuralAnalysis',field);

    case 'QACODES'
        QAstatus=QAreport('OPEN?');  %check if the QA report is already open
        QAreport; %open (or not)
        for index=1:size(QA.codeDescription,1)
            switch cell2mat(QA.codeDescription(index,2))
                case 15 %'Big Paddle'
                    set(QA.check(index),'value',Error.BIGPADDLE);
                case 11 %'Saturation Problems'
                    set(QA.check(index),'value',Error.SATURATION);
                case 32 %'Super Lean Warning'
                    set(QA.check(index),'value',Error.SuperLeanWarning);
                case 10 %'Phantom detection failure'   NOT CHANGED IN MANUAL MODE
                    set(QA.check(index),'value',Error.PhantomDetection);
                case 17 %'Height Warning'              NOT CHANGED IN MANUAL MODE
                    set(QA.check(index),'value',Error.HEIGHT);
                case 28 %'Thickness discrepancy'       NOT CHANGED IN MANUAL MODE
                    set(QA.check(index),'value',Error.ThicknessDiscrepancy);
                case 26 %'auto BDMD failed'            NOT CHANGED IN MANUAL MODE
                    set(QA.check(index),'value',Error.AutoBDMD);
                case 27 %'auto BDPC failed'            NOT CHANGED IN MANUAL MODE
                    set(QA.check(index),'value',Error.PC);
                case 18 %'mAs reading failed'          NOT CHANGED IN MANUAL MODE
                    set(QA.check(index),'value',Error.MAS);
                case 19 %'kVp reading failed'          NOT CHANGED IN MANUAL MODE
                    set(QA.check(index),'value',Error.KVP);
                case 20 %'Thickness reading failed'    NOT CHANGED IN MANUAL MODE
                    set(QA.check(index),'value',Error.MM);
                case 22 %'Force reading failed'        NOT CHANGED IN MANUAL MODE
                    set(QA.check(index),'value',Error.DAN);
                case 21 %'Technique reading failed     NOT CHANGED IN MANUAL MODE
                    set(QA.check(index),'value',Error.TECHNIQUE);
                case 23 %'kVp warning'                 NOT CHANGED IN MANUAL MODE
                    set(QA.check(index),'value',Error.KVPWarning);
                case 25 %'auto BDSXA failed'           NOT CHANGED IN MANUAL MODE
                    set(QA.check(index),'value',Error.DENSITY);
                case 29 %'Uniformity Correction failed'
                    set(QA.check(index),'value',Error.Correction);
                case 34 %'Auto room detection failed    NOT CHANGED IN MANUAL MODE
                    set(QA.check(index),'value',Error.RoomDetection);      
                case 44 %'Number of BBs less than 6    NOT CHANGED IN MANUAL MODE
                    set(QA.check(index),'value',Error.StepPhantomBBsFailure);
                case 45 %'no phantom for digital machine    NOT CHANGED IN MANUAL MODE
                    set(QA.check(index),'value',Error.StepPhantomFailure);   
                case 46 %'bad position or breast influence    NOT CHANGED IN MANUAL MODE
                    set(QA.check(index),'value',Error.StepPhantomPosition);       
                case 47
                    set(QA.check(index),'value',Error.StepPhantomReconstruction);    
                case 48
                    set(QA.check(index),'value',Error.PeripheryCalculation);       
                case 3
                    set(QA.check(index),'value',Error.SkinEdgeFailed); 
                end
            
        end
        QAreport('SAVE')
        if ~QAstatus
            QAreport('CLOSE');
        end
end

