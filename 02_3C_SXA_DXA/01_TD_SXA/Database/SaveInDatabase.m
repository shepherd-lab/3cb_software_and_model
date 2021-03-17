%depending on flag.action, save a common analysis, a SXA analysis, a FreeForm Analysis or a Threshold Analysis

% SaveInDatabase
% Author Lionel HERVE
% creation date 5-22-03
%8-16-2003 : two way to save common analysis : peripheral analysis done or
%not

function SaveInDatabase(RequestedAction)

global Database ctrl Info ROI flag ManualEdge Analysis data Roughness Threshold FreeForm f0 ok_continue StructuralAnalysis QA Error ChestWallData Correction
global Phantom  freeform_chestwall_id SXAAnalysis phleanref_vect duration session_id SXAreport MachineParams  FD Automaticduration featParam
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
                    field(11)={num2str(funcFindNextAvailableKey(Database,'ChestWall'))};
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
        
    case 'CancerRegion'
        Message('Create Cancer region record');
        CancerRegionkey=funcFindNextAvailableKey(Database,'CancerRegion');
        for indexpoint=1:CancerRegionData.NumberPoints
            exdata(indexpoint,:)={CancerRegionkey,Info.AcquisitionKey,indexpoint,CancerRegionData.Group,CancerRegionData.Points(indexpoint,1),CancerRegionData.Points(indexpoint,2)};
        end
        mxDatabase(Database.Name,'BULKIN CancerRegion',exdata);
        
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
        
    case 'MANUALTHRESHOLDANALYSIS' %2
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
                SaveInDatabase('MANUALTHRESHOLDANALYSIS');
            end
        elseif Analysis.Step<3
            Message('You must define the ROI and find the skin edge first');
        elseif Info.AcquisitionKey==0;  %to protect from the mess in the files.
            Message('It seems you have open a new file since you have retrieve a acquisition from the database.');
        elseif Info.CommonAnalysisKey==0 ;  %to protect from the mess in the files.
            Message('It seems you have changed the skin detection since you have retrieve a common analysis from the database.');
        else
            Message('Save Manual Threshold Analysis');
            field(1)={num2str(Info.CommonAnalysisKey)};
            field(2)={num2str(Threshold.value)};
            field(3)={num2str(Analysis.Threshold_density)};
            field(4)={Info.Version};
            field(5)={num2str(Info.Operator)};
            field(6)={date};
            field(7)={num2str(Threshold.pixels)};
            Info.ManualThresholdAnalysisKey=funcAddInDatabase(Database,'ManualThresholdAnalysis',field);
            Message('Ok');ok_continue=true;
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
            %ButtonProcessing('SaveInfo');
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
            field(2)={num2str(Analysis.DensityPercentage)};
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
            field(24)={num2str(Analysis.X_angle_orig)}; %Analysis.TotalFatMass
            field(25)={num2str(Analysis.Y_angle_orig )}; %Analysis.TotalLeanMass
            field(26)={num2str(SXAAnalysis.SXABreastVolumeReal)};
            field(27)={num2str(Analysis.breast_areacorr)};
            field(28)={num2str(Analysis.DensityPercentageNoCorr)};
            field(29)={num2str(Analysis.DensityPercentageCut)};
            field(30)={num2str(Analysis.BBcoord_set)};
            field(31)={num2str(Info.AcquisitionKey)};
            field(32)={num2str(Analysis.X_angle)};
            field(33)={num2str(Analysis.Y_angle)};
             %field(27)={Analysis.FileNameDensity};
            %field(28)={Analysis.FileNameThickness};
            %field(21)={num2str(Analysis.DensityPercentageAngle)};
            %field(22)={num2str(Analysis.SXAanalysisStatus)};
            
            %%%%%%%%%% begin new automation optimizing fields
            %fields 32-34 CenterROI subregion
            field(35)={[datestr(now,13)]};
            ang = Analysis.Y_angle
            try
                tElapsed=toc(duration);
                field(36)={num2str(tElapsed)};
                [status, host] = system('hostname');
                field(37)={host(1:end-1)};
                field(38)={session_id};
            end
            field(39)= {num2str(Analysis.calib_diffdays)}
            field(40)={num2str(Analysis.DensityPercentageBFCorr)};
            field(41)={num2str(Analysis.Run_number)};
            field(42)={num2str(Analysis.error_thickDB)};
            field(43)={num2str(Analysis.error_thickDB_nooffset)};
            field(44)={num2str(Info.study_id)};
            %diary on
            %diary ('U:\jwang\My Documents\misc\auto SQL\diary.txt'_
            %[status, result]=dos('tasklist /fi "IMAGENAME eq MATLAB.exe" /fo csv /nh')
            %diary off
            %field(38)=num2str(local_sessions);
            %%%%%%%%%% automation JW 5/12/2011
            
            Info.SXAStepAnalysisKey=funcAddInDatabase(Database,'sxastepanalysis',field);
            
            SaveInDatabase('OTHERSXASTEPINFO');
            %ButtonProcessing('SaveInfo');
            
            %save SXA roi best fit to 'SXAroiFit'
            %added by Song, 03/11/11
            saveToSXAroiFit(Database, Analysis, Info);
            %end of modification
            
        end
        if SXAreport == true
            SaveInDatabase('QACODES');
        end
        
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
        mxDatabase(Database.Name,['insert into OtherSXAinfo values(''',num2str(Info.SXAAnalysisKey),''',''',num2str(BRAND),''',''',num2str(Analysis.Phantomfatlevel),''',''',num2str(Analysis.Phantomleanlevel),''',''',num2str(Phantom.Angle),''',''',num2str(floor(Analysis.OriginalPhantomfatlevel)),''',''',num2str(floor(Analysis.OriginalPhantomleanlevel)),''');']); %,num2str(funcFindNextAvailableKey(Database,'OtherSXAinfo')),''','''
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
        Analysis.ph_slope80 = 0;
        field(12)={num2str(Analysis.ph_slope80)};
        field(13)={num2str(Analysis.ph_offset)};
        field(14)={num2str(Analysis.km)};
        field(15)={num2str(Analysis.klean)};
        field(16)={num2str(Analysis.Phantomleanlevel)};
        field(17)={num2str(Analysis.Phantomfatlevel)};
        Info.OtherSXAStepInfoKey=funcAddInDatabase(Database,'OtherSXAStepinfo',field);
        Message('Ok');
        ok_continue=true
        
    case 'QCDSP7ANALYSIS' %3
        if (Analysis.Step<8)
            Message('You must compute the QC result first');
        elseif Database.Step<1
            Message('You must retrieve an Acquisition first');
        elseif Database.Step<2          % Ask for the creation of a new Common Analysis
            ok_continue=false;
            SaveInDatabase('COMMONANALYSIS');
            SaveInDatabase('QCDSP7ANALYSIS');
        elseif Info.AcquisitionKey==0;  %to protect from the mess in the files.
            Message('It seems you have open a new file since you have retrieve a acquisition from the database.');
        elseif Info.CommonAnalysisKey==0;  %to protect from the mess in the files.
            Message('It seems you have changed the skin detection since you have retrieve a common analysis from the database.');
            % elseif Correction.Type==1
            %    Message('!!!Correction is not valid!!!');  %if the sxa results has been computed without the correction
            %    beep
        else
            %            SaveInDatabase('COMPRESSEDAREAINFO');   %save the peripheral analysis
            Message('Save QC DSP7 Analysis');
            field(1)={num2str(Info.CommonAnalysisKey)};
            field(2)={num2str(Analysis.density_DSP7(1))};      %Info.CorrectionId is defined in funcFlatFieldCorrection
            field(3)={num2str(Analysis.density_DSP7(2))};
            field(4)={num2str(Analysis.density_DSP7(3))};
            field(5)={num2str(Analysis.density_DSP7(4))};
            field(6)={num2str(Analysis.density_DSP7(5))};
            field(7)={num2str(Analysis.density_DSP7(6))};
            field(8)={num2str(Analysis.density_DSP7(7))};
            field(9)={Info.Version};
            field(10)={num2str(Info.Operator)};
            field(11)={Analysis.SXAMode};
            field(12)={date};
            field(13)={num2str(Analysis.thicknessDSP7)};      %Info.CorrectionId is defined in funcFlatFieldCorrection
            field(14)={num2str(MachineParams.comId)};
            %field(1)={num2str(Info.CommonAnalysisKey)};
            field(15)={num2str(Analysis.densityDSP7_quadcorr(1))};      %Info.CorrectionId is defined in funcFlatFieldCorrection
            field(16)={num2str(Analysis.densityDSP7_quadcorr(2))};
            field(17)={num2str(Analysis.densityDSP7_quadcorr(3))};
            field(18)={num2str(Analysis.densityDSP7_quadcorr(4))};
            field(19)={num2str(Analysis.densityDSP7_quadcorr(5))};
            field(20)={num2str(Analysis.densityDSP7_quadcorr(6))};
            field(21)={num2str(Analysis.densityDSP7_quadcorr(7))};
            %field(22)={num2str(Analysis.Analysis.AbsDensityError)};
            field(22)={num2str(Analysis.AbsDensityErrorCorr)};
            field(23)={num2str(Analysis.DensityError)};
            field(24)={num2str(Analysis.AbsDensityError)};
            field(25)={num2str(Analysis.DSP7diffdays)};
            
            Info.QCDSP7AnalysisKey=funcAddInDatabase(Database,'qcdsp7analysis',field);
            SaveInDatabase('QCSXAPHANTOMINFO');
            %ButtonProcessing('SaveInfo');
        end
        SaveInDatabase('QACODES');
        
    case 'QCSXAPHANTOMINFO'
        Message('Saving  QC SXA PHANTOM INFO');
        field={};
        field(1)={num2str(Info.QCDSP7AnalysisKey)};
        field(2)={num2str(phleanref_vect(1))};      %Info.CorrectionId is defined in funcFlatFieldCorrection
        field(3)={num2str(phleanref_vect(2))};
        field(4)={num2str(phleanref_vect(3))};
        field(5)={num2str(phleanref_vect(4))};
        field(6)={num2str(phleanref_vect(5))};
        field(7)={num2str(phleanref_vect(6))};
        field(8)={num2str(phleanref_vect(7))};
        field(9)={num2str(phleanref_vect(8))};
        %             len_roi = length(phleanref_vect);
        if length(Analysis.roi_values)>8
            field(10)={num2str(phleanref_vect(9))};
        end
        field(11)={num2str(Analysis.params(1))};
        field(12)={num2str(Analysis.params(2))};
        field(13)={num2str(Analysis.params(3))};
        field(14)={num2str(Analysis.params(5))};
        field(15)={num2str(Analysis.params(6))};
        field(16)={num2str(Analysis.params(4))};
        field(17)={num2str(Analysis.params(7))};
        field(18)={num2str(Analysis.roi_DSP7values(1))};      %Info.CorrectionId is defined in funcFlatFieldCorrection
        field(19)={num2str(Analysis.roi_DSP7values(2))};
        field(20)={num2str(Analysis.roi_DSP7values(3))};
        field(21)={num2str(Analysis.roi_DSP7values(4))};
        field(22)={num2str(Analysis.roi_DSP7values(5))};
        field(23)={num2str(Analysis.roi_DSP7values(6))};
        field(24)={num2str(Analysis.roi_DSP7values(7))};
        field(25)= {num2str(Analysis.a_offset)};
        field(26)= {num2str(Analysis.b_slope)};
        field(27)={num2str(Analysis.roi_DSP7valGSCorr(1))};      %Info.CorrectionId is defined in funcFlatFieldCorrection
        field(28)={num2str(Analysis.roi_DSP7valGSCorr(2))};
        field(29)={num2str(Analysis.roi_DSP7valGSCorr(3))};
        field(30)={num2str(Analysis.roi_DSP7valGSCorr(4))};
        field(31)={num2str(Analysis.roi_DSP7valGSCorr(5))};
        field(32)={num2str(Analysis.roi_DSP7valGSCorr(6))};
        field(33)={num2str(Analysis.roi_DSP7valGSCorr(7))};
        field(34)={num2str(Analysis.density_DSP7Corr(1))};
        field(35)={num2str(Analysis.density_DSP7Corr(2))};
        field(36)={num2str(Analysis.density_DSP7Corr(3))};
        field(37)={num2str(Analysis.density_DSP7Corr(4))};
        field(38)={num2str(Analysis.density_DSP7Corr(5))};
        field(39)={num2str(Analysis.density_DSP7Corr(6))};
        field(40)={num2str(Analysis.density_DSP7Corr(7))};
        
        %             len_roi = length(Analysis.roi_DSP7values);
        if length(Analysis.roi_DSP7values)>8
            field(10)={num2str(Analysis.roi_DSP7values(9))};
        end
        Info.QCSXAPhantomInfoKey=funcAddInDatabase(Database,'QCSXAPhantominfo',field);
        Message('Ok');
        ok_continue=true;
        
    case 'QCWAXAnalysis' %3
        if (Analysis.Step<8)
            Message('You must compute the QC result first');
        elseif Database.Step<1
            Message('You must retrieve an Acquisition first');
        elseif Database.Step<2          % Ask for the creation of a new Common Analysis
            ok_continue=false;
            SaveInDatabase('COMMONANALYSIS');
            SaveInDatabase('QCWAXAnalysis');
        elseif Info.AcquisitionKey==0;  %to protect from the mess in the files.
            Message('It seems you have open a new file since you have retrieve a acquisition from the database.');
        elseif Info.CommonAnalysisKey==0;  %to protect from the mess in the files.
            Message('It seems you have changed the skin detection since you have retrieve a common analysis from the database.');
            % elseif Correction.Type==1
            %    Message('!!!Correction is not valid!!!');  %if the sxa results has been computed without the correction
            %    beep
        else
            %            SaveInDatabase('COMPRESSEDAREAINFO');   %save the peripheral analysis
            
            
            Message('Save QC WAX Analysis');
            field(1)={num2str(Info.CommonAnalysisKey)};
            field(2)={num2str(Analysis.density_GEN3(1))};      %AFTER CORRECTION
            field(3)={num2str(Analysis.density_GEN3(2))};
            field(4)={num2str(Analysis.density_GEN3(3))};
            field(5)={num2str(Analysis.density_GEN3(4))};
            field(6)={num2str(Analysis.density_GEN3(5))};
            field(7)={num2str(Analysis.density_GEN3(6))};
            field(8)={num2str(Analysis.density_GEN3(7))};
            field(9)={num2str(Analysis.density_GEN3(8))};
            field(10)={num2str(Analysis.density_GEN3(9))};
            field(11)={Info.Version};
            field(12)={num2str(Info.Operator)};
            field(13)={Analysis.SXAMode};
            field(14)={date};
            field(15)={num2str(Analysis.thicknessDSP7)};
            field(16)={num2str(Analysis.thicknessWax1)};
            field(17)={num2str(Analysis.thicknessWax2)};
            field(18)={num2str(Analysis.thicknessWax3)};
            field(19)={num2str(Analysis.thicknessWax4)};
            field(20)={num2str(Analysis.thicknessWax5)};
            field(21)={num2str(Analysis.thicknessWax6)};
% %             field(22)={num2str(Analysis.x0cm_diff)};
% %             field(23)={num2str(Analysis.y0cm_diff)};    %%sypks
% permanent comment out field no longer used.. corresponds to old use of bb
% to determine offset/bias. new method uses wire attached to top of phantom
            field(24)={num2str(Analysis.density_GEN3_246cm(1))};  %    REAL
            field(25)={num2str(Analysis.density_GEN3_246cm(2))};
            field(26)={num2str(Analysis.density_GEN3_246cm(3))};
            field(27)={num2str(Analysis.density_GEN3_246cm(4))};
            field(28)={num2str(Analysis.density_GEN3_246cm(5))};
            field(29)={num2str(Analysis.density_GEN3_246cm(6))};
            field(30)={num2str(Analysis.density_GEN3_246cm(7))};
            field(31)={num2str(Analysis.density_GEN3_246cm(8))};
            field(32)={num2str(Analysis.density_GEN3_246cm(9))};
            field(33)={num2str(Analysis.volume_GEN3(1))};
            field(34)={num2str(Analysis.volume_GEN3(2))};
            field(35)={num2str(Analysis.volume_GEN3(3))};
            field(36)={num2str(Analysis.volume_GEN3(4))};
            field(37)={num2str(Analysis.volume_GEN3(5))};
            field(38)={num2str(Analysis.volume_GEN3(6))};
            field(39)={num2str(Analysis.volume_GEN3(7))};
            field(40)={num2str(Analysis.volume_GEN3(8))};
            field(41)={num2str(Analysis.volume_GEN3(9))};
            field(42)={num2str(Analysis.densevolume_GEN3(1))};
            field(43)={num2str(Analysis.densevolume_GEN3(2))};
            field(44)={num2str(Analysis.densevolume_GEN3(3))};
            field(45)={num2str(Analysis.densevolume_GEN3(4))};
            field(46)={num2str(Analysis.densevolume_GEN3(5))};
            field(47)={num2str(Analysis.densevolume_GEN3(6))};
            field(48)={num2str(Analysis.densevolume_GEN3(7))};
            field(49)={num2str(Analysis.densevolume_GEN3(8))};
            field(50)={num2str(Analysis.densevolume_GEN3(9))};
            field(51)={num2str(Analysis.volume_GEN3_246cm(1))};      %Info.CorrectionId is defined in funcFlatFieldCorrection
            field(52)={num2str(Analysis.volume_GEN3_246cm(2))};
            field(53)={num2str(Analysis.volume_GEN3_246cm(3))};
            field(54)={num2str(Analysis.volume_GEN3_246cm(4))};
            field(55)={num2str(Analysis.volume_GEN3_246cm(5))};
            field(56)={num2str(Analysis.volume_GEN3_246cm(6))};
            field(57)={num2str(Analysis.volume_GEN3_246cm(7))};
            field(58)={num2str(Analysis.volume_GEN3_246cm(8))};
            field(59)={num2str(Analysis.volume_GEN3_246cm(9))};
            field(60)={num2str(Analysis.densevolume_GEN3_246cm(1))};      %Info.CorrectionId is defined in funcFlatFieldCorrection
            field(61)={num2str(Analysis.densevolume_GEN3_246cm(2))};
            field(62)={num2str(Analysis.densevolume_GEN3_246cm(3))};
            field(63)={num2str(Analysis.densevolume_GEN3_246cm(4))};
            field(64)={num2str(Analysis.densevolume_GEN3_246cm(5))};
            field(65)={num2str(Analysis.densevolume_GEN3_246cm(6))};
            field(66)={num2str(Analysis.densevolume_GEN3_246cm(7))};
            field(67)={num2str(Analysis.densevolume_GEN3_246cm(8))};
            field(68)={num2str(Analysis.densevolume_GEN3_246cm(9))};
            field(69)={num2str(Analysis.density_diff)};
            field(70)={num2str(Analysis.volume_diff)};
            field(71)={num2str(Analysis.densevolume_diff)};
            field(72)={num2str(Analysis.thickness_diff)};
            field(73)={num2str(Analysis.density_GEN3BFCorr(1))};      %Info.CorrectionId is defined in funcFlatFieldCorrectionAnalysis.density_GEN3corr
            field(74)={num2str(Analysis.density_GEN3BFCorr(2))};
            field(75)={num2str(Analysis.density_GEN3BFCorr(3))};
            field(76)={num2str(Analysis.density_GEN3BFCorr(4))};
            field(77)={num2str(Analysis.density_GEN3BFCorr(5))};
            field(78)={num2str(Analysis.density_GEN3BFCorr(6))};
            field(79)={num2str(Analysis.density_GEN3BFCorr(7))};
            field(80)={num2str(Analysis.density_GEN3BFCorr(8))};
            field(81)={num2str(Analysis.density_GEN3BFCorr(9))};
            field(82)={num2str(Analysis.density_GEN3_246cmBFCorr(1))};      %Info.BFCorrectionId is defined in funcFlatFieldBFCorrection
            field(83)={num2str(Analysis.density_GEN3_246cmBFCorr(2))};
            field(84)={num2str(Analysis.density_GEN3_246cmBFCorr(3))};
            field(85)={num2str(Analysis.density_GEN3_246cmBFCorr(4))};
            field(86)={num2str(Analysis.density_GEN3_246cmBFCorr(5))};
            field(87)={num2str(Analysis.density_GEN3_246cmBFCorr(6))};
            field(88)={num2str(Analysis.density_GEN3_246cmBFCorr(7))};
            field(89)={num2str(Analysis.density_GEN3_246cmBFCorr(8))};
            field(90)={num2str(Analysis.density_GEN3_246cmBFCorr(9))};
            field(91)= {num2str(Analysis.GEN3diffdays)};
            
            field(92)= {num2str(Info.AcquisitionKey)};
            
            Info.QCWaxAnalysisKey=funcAddInDatabase(Database,'qcwaxanalysis',field);
            SaveInDatabase('QCwaxSXAPHANTOMINFO');
            %ButtonProcessing('SaveInfo');
            saveToSXAroiFit(Database, Analysis, Info);
        end
        SaveInDatabase('QACODES')
        
        
        
        
        
        
        % % %             field(1)={num2str(Info.CommonAnalysisKey)};
        % % %             field(2)={num2str(Analysis.density_WAX(1))};      %Info.CorrectionId is defined in funcFlatFieldCorrection
        % % %             field(3)={num2str(Analysis.density_WAX(2))};
        % % %             field(4)={num2str(Analysis.density_WAX(3))};
        % % %             field(5)={num2str(Analysis.density_WAX(4))};
        % % %             field(6)={num2str(Analysis.density_WAX(5))};
        % % %             field(7)={num2str(Analysis.density_WAX(6))};
        % % %             field(8)={num2str(Analysis.density_WAX(7))};
        % % %             field(9)={num2str(Analysis.density_WAX(8))};
        % % %             field(10)={num2str(Analysis.density_WAX(9))};
        % % %             field(11)={Info.Version};
        % % %             field(12)={num2str(Info.Operator)};
        % % %             field(13)={Analysis.SXAMode};
        % % %             field(14)={date};
        % % %             field(15)={num2str(Analysis.thicknessDSP7)};  %Info.CorrectionId is defined in funcFlatFieldCorrection
        % % %             field(16)={num2str(Analysis.thicknessWax1)};
        % % %             field(17)={num2str(Analysis.thicknessWax2)};
        % % %             field(18)={num2str(Analysis.thicknessWax3)};
        % % %             field(19)={num2str(Analysis.thicknessWax4)};
        % % %             field(20)={num2str(Analysis.thicknessWax5)};
        % % %             field(21)={num2str(Analysis.thicknessWax6)};
        % % %             field(22)={num2str(Analysis.x0cm_diff)};
        % % %             field(23)={num2str(Analysis.y0cm_diff)};
        % % %
        % % %             Info.QCDSP7AnalysisKey=funcAddInDatabase(Database,'qcwaxanalysis',field);
        % % %             SaveInDatabase('QCwaxSXAPHANTOMINFO');
        % % %             %ButtonProcessing('SaveInfo');
        % % %
        % % %             %save SXA roi best fit to 'SXAroiFit'
        % % %             %added by Song, 03/11/11
        % % %             saveToSXAroiFit(Database, Analysis, Info);
        % % %             %end of modification
        % % %
        % % %             Analysis.densityWaxRoiCorr;
        % % %
        % % %         end
        % % %         SaveInDatabase('QACODES')
        
    case 'QCwaxSXAPHANTOMINFO'
        Message('Saving wax QC SXA PHANTOM INFO');
        Field={};
        field(1)={num2str(Info.QCWaxAnalysisKey)};           %Info.QCDSP7AnalysisKey
        field(2)={num2str(phleanref_vect(1))};      %Info.CorrectionId is defined in funcFlatFieldCorrection
        field(3)={num2str(phleanref_vect(2))};
        field(4)={num2str(phleanref_vect(3))};
        field(5)={num2str(phleanref_vect(4))};
        field(6)={num2str(phleanref_vect(5))};
        field(7)={num2str(phleanref_vect(6))};
        field(8)={num2str(phleanref_vect(7))};
        field(9)={num2str(phleanref_vect(8))};
        %         len_roi = length(phleanref_vect);
        if length(Analysis.roi_values)>8
            field(10)={num2str(phleanref_vect(9))};
        end
        field(11)={num2str(Analysis.params(1))};
        field(12)={num2str(Analysis.params(2))};
        field(13)={num2str(Analysis.params(3))};
        field(14)={num2str(Analysis.params(5))};
        field(15)={num2str(Analysis.params(6))};
        field(16)={num2str(Analysis.params(4))};
        field(17)={num2str(Analysis.params(7))};
        field(18)={num2str(Analysis.roigen3_values(1))};      %Info.CorrectionId is defined in funcFlatFieldCorrection
        field(19)={num2str(Analysis.roigen3_values(2))};
        field(20)={num2str(Analysis.roigen3_values(3))};
        field(21)={num2str(Analysis.roigen3_values(4))};
        field(22)={num2str(Analysis.roigen3_values(5))};
        field(23)={num2str(Analysis.roigen3_values(6))};
        field(24)={num2str(Analysis.roigen3_values(7))};
        field(25)={num2str(Analysis.roigen3_values(8))};
        field(26)={num2str(Analysis.roigen3_values(9))};
        
        Info.QCSXAPhantomInfoKey=funcAddInDatabase(Database,'QCwaxSXAPhantominfo',field);
        
        Message('Ok');
        ok_continue=true;
    case 'MachineParametersCorrection_new'
        
        Message('Saving MachineParametersCorrection');
        
        field(1)={num2str(Info.AcquisitionKey)};
        field(2)={num2str(Info.CommonAnalysisKey)};
        field(3)={num2str(Info.machine_id)};
        field(4)={num2str( Analysis.gen3thickness_diff_1sign)};
        field(5)={num2str(Analysis.paddle_type)};
        field(6)={strtrim(num2str(Info.date_acq))};
        field(7)={Info.Version};
        field(8)={num2str(Analysis.tz_angle)};
        field(9)={num2str(Analysis.error_3Drecon)};
        field(10)={num2str(Analysis.MachineParameter_status)};
        field(11)={num2str(Analysis.params(1))};
        field(12)={num2str(Analysis.params(2))};
        field(13)={num2str(Analysis.params(3))};
        
        Info.MachineParametersCorrectionKey=funcAddInDatabase(Database,'MachineParametersCorrection_New',field);
        Message('Ok');
        ok_continue=true;
        
        
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
        field(index+3)={num2str(Info.Version)};
        field(index+4)={num2str(Info.AcquisitionKey)};
        field(index+5) = {num2str(Analysis.FD_downsize)}
        field(index+6) = {num2str(Analysis.downsize)}
        
        
        field(index+7)={[datestr(now,13)]};% Am 08222013
        try
            tElapsed=toc(duration);
            field(index+8)={num2str(tElapsed)};
            [status, host] = system('hostname');
            field(index+9)={num2str(host(1:end-1))};   %{host(1:end-1)};
        end
        
        field(index+10) = {num2str(Analysis.FD_TH_downsize)}
        funcAddInDatabase(Database,'StructuralAnalysis',field);
        
        
    case 'STRUCTURALANALYSISExtra'  % added by APM 02022015
        
        SaveInDatabase('COMMONANALYSIS');

        field(1)={num2str(Info.CommonAnalysisKey)};
        field(2)={date};
        field(3)={num2str(Info.Version)};
        field(4)={num2str(Info.AcquisitionKey)};
        field(5) = {num2str(Analysis.FD_downsize)}
        field(6) = {num2str(Analysis.downsize)}
        field(7)={[datestr(now,13)]};% Am 08222013
        try
            tElapsed=toc(duration);
            field(8)={num2str(tElapsed)};
            [status, host] = system('hostname');
            field(9)={num2str(host(1:end-1))};   %{host(1:end-1)};
        catch
            
        end
        
        Message('Saving Markovian features ...')
       
        nDir = length(featParam.Mark.dir);
        nDist = length(featParam.Mark.dist);
       
        
        
        for iGray = 0:featParam.numGrRed
            for iDir = 1:nDir
                for iDist = 1:nDist
                    for iMarkov = 1:20 
                            field(iGray+10,iDir,iDist,iMarkov)={num2str(StructuralAnalysis.Results_Extra(iGray+1).Mark(iDir, iDist, iMarkov))};  
                    end;
                end;
            end;
        end
        
        delete iDir;     
        nDir = length(featParam.Mark.dir);
        Message('Saving Lenght features ...')
        
        for iGray = 0:featParam.numGrRed
            for iDir = 1:nDir
                for iLenght = 1:8
                    field(681+nDir+iLenght+iGray)={num2str(StructuralAnalysis.Results_Extra(iGray+1).RL(iDir, iLenght))};
                end;
            end;
        end
        
        
        Message('Saving Laws features ...')
        n = length(featParam.Laws.filter);
        for iGray = 0:featParam.numGrRed
            for iVer = 1:n
                for iHor = 1:n
                    for   iLaws=1:2
                        
                        field(809+iVer+iHor+iGray)={num2str(StructuralAnalysis.Results_Extra(iGray+1).Laws(iVer, iHor, iLaws))};
                    end
                end
            end
        end
        
        Message('Saving Fourier features ...')
        
        field(1009+iGray)=num2str(result(iGray+1).FFT);
        
        Message('Saving wavelet features ...')
        for iGray = 0:featParam.numGrRed
            field(1129+iGray)={num2str(StructuralAnalysis.Results_Extra(iGray+1).Wave)};
            
        end


  funcAddInDatabase(Database,'StructuralAnalysisExtra',field);  
    
    

case 'PhantomLessSXA'
    Message('Save Phantomless SXA Analysis');
    field(1)={num2str(Info.AcquisitionKey)};
    field(2)={num2str(Info.CommonAnalysisKey)};
    field(3)={num2str(Analysis.Phantomless.breast_density)};
    field(4)={num2str(Analysis.Phantomless.breast_volume)};
    field(5)={num2str(Analysis.Phantomless.dense_volume)};
    field(6)={date};
    field(7)={num2str(Info.Version)};
    field(8)={datestr(now,13)};
    try
        tElapsed=toc(duration);
        field(9)={num2str(tElapsed)};
        [status, host] = system('hostname');
        field(10)={host(1:end-1)};
    end
    field(11)={''};%num2str(Info.Phantomless.checkSXAResult);
    field(12)={num2str(Info.study_id)};
    funcAddInDatabase(Database,'PhantomLessSXA',field);
    
    
    case 'AutomaticSXAThreshold'
        
        Message('Save AutomaticSXAThreshold Analysis');
        field(1)={num2str(Info.AcquisitionKey)};
        field(2)={ Analysis.BreastMaskCropped_Area};
        field(3)= {Analysis.DenseAreaAll_ExEpectoral};
        field(4)={Analysis.DenseArea_Percentage};
        field(5)={Analysis.MinIntensity_Dense};
        field(6)={ Analysis.MaxIntensity_Dense};
        field(7)= {Analysis.MeanIntensity_Dense};
        field(7)= {Analysis.AnalysisPerimeter_Dense};
        field(8)= {Analysis.EquivDiameter_Dense};
        field(9)={date};
        field(10)={num2str(Info.Version)};
        field(11)={datestr(now,13)};
        try
            tElapsed=duration;
            field(12)={num2str(tElapsed)};
            [status, host] = system('hostname');
            field(13)={host(1:end-1)};
        end
        field(14)={num2str(Info.study_id)};
        funcAddInDatabase(Database,'AutomaticSXAThreshold',field);
        
        %     case 'FractionalDimensionDensity'
        %
        %         field(1)={num2str(Info.AcquisitionKey)};
        %         field(2)={num2str(strtrim(Info.study_id))};
        %         field(3)={num2str(Info.Version)};
        %         field(4)={date};
        %         field(5)={datestr(now,13)};
        %         try
        %             tElapsed=toc(duration);
        %             field(6)={num2str(tElapsed)};
        %             [status, host] = system('hostname');
        %             field(7)={host(1:end-1)};
        %         end
        %
        %         for index=1:length(FD.Density_Results)
        %             field(7+index)={num2str(FD.Density_Results(index))};
        %         end
        %
        %         field(8+index)={num2str(Analysis.DensityPercentage_realSXA)};
        %
        %         funcAddInDatabase(Database,'FD_Density',field);
        
        case 'FractionalDimensionDensity'
            
            field(1)={num2str(Info.AcquisitionKey)};
            field(2)={num2str(strtrim(Info.study_id))};
            field(3)={num2str(Info.Version)};
            field(4)={date};
            field(5)={datestr(now,13)};
            try
                tElapsed=toc(duration);
                field(6)={num2str(tElapsed)};
                [status, host] = system('hostname');
                field(7)={host(1:end-1)};
            end
            
            for index=1:length(FD.Density_Results)
                field(7+index)={num2str(FD.Density_Results(index))};
            end
            
            funcAddInDatabase(Database,'FD_Density_in_out',field);
            
            
            case 'AutomaticContour'
                
                Message('Save AutomaticContour Analysis');
                field(1)={num2str(Info.AcquisitionKey)};
                field(2)={num2str(Threshold.CommonAnalysisKey)};
                field(3)={num2str(Info.study_id)};
                field(4)={date};
                field(5)={datestr(now,13)};
                field(6)={num2str(Info.Version)};
                
                try
                    tElapsed=duration;
                    field(7)={num2str(tElapsed)};
                    [status, host] = system('hostname');
                    field(8)={host(1:end-1)};
                end
                field(9)={num2str(Analysis.Threshold_density_real)};  % Real Density
                field(10)={num2str(Analysis.Threshold_density)};   % BO Reading
                field(11)={num2str(Analysis.OLP)}; % Percentage Overlaping
                
                
                field(12)={num2str(Analysis.Min_Intensity)};  % Min Intensity
                field(13)={num2str(Analysis.Max_Intensity)};   % Max Intensity
                field(14)={num2str(Analysis.Mean_Intensity)}; % Mean Intensity
                
                funcAddInDatabase(Database,'AutomaticContour',field);
                
                
                case 'AutomaticContourNew'
                    
                    Message('Save AutomaticContour Analysis');
                    field(1)={num2str(Info.AcquisitionKey)};
                    field(2)={num2str(Info.study_id)};
                    field(3)={date};
                    field(4)={datestr(now,13)};
                    field(5)={num2str(Info.Version)};
                    
                    try
                        tElapsed=Automaticduration;
                        field(6)={num2str(tElapsed)};
                        [status, host] = system('hostname');
                        field(7)={host(1:end-1)};
                    end
                    field(8)={num2str(Analysis.Threshold_density_real)};   %2D Visual Breast Density
                    field(9)={num2str(Analysis.ValidBreastSurface)};  % Breast Area cm2
                    
                    field(10)={num2str(Analysis.SXADensityPercentage)};  %SXA Result whole breast
                    field(11)={num2str(Analysis.SXABreastVolumeRealNew)};  % Breast Volume cm3
                    
                    field(12)={num2str(Analysis.SXADensityPercentage_inner)};  % SXA Density without prephery
                    field(13)={num2str(Analysis.SXABreastVolumeReal_inner)};   % Dense Volume without prephery
                    field(14)={num2str(Analysis.SXADensityPercentage_periph)}; % SXA Density with prephery
                    field(15)={num2str(Analysis.SXABreastVolumeReal_periph)}; % Dense Volume with preohery
                    
                    field(16)={num2str(Analysis.SXADensityPercentage_in)};  % Density in
                    field(17)={num2str(Analysis.DenseVolume_in)};   % Dense Volume in cm3
                    field(18)={num2str(Analysis.SXADensityPercentage_out)}; % Density out
                    field(19)={num2str(Analysis.DenseVolume_out)}; % Density Volume Out cm3
                    
                    field(20)={num2str(Analysis.Min_Intensity)};  % Min Intensity
                    field(21)={num2str(Analysis.Max_Intensity)};   % Max Intensity
                    field(22)={num2str(Analysis.Mean_Intensity)}; % Mean Intensity
                    
                    funcAddInDatabase(Database,'AutomaticContourNew',field);
                    
                    
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
                                    
                                    %Three cases added by Song, 03/14/11
                                case 49 %BB 3D reconstruction error beyond threshold
                                    set(QA.check(index), 'value', Error.SXAbbRecon);
                                case 50 %SXA attenuation fitting failure
                                    set(QA.check(index), 'value', Error.SXAroiFitFailure);
                                case 51 %SXA attenuation fitting warning
                                    set(QA.check(index), 'value', Error.SXAroiFitWarning);
                                    %End of modification
                                    
                                    %Five cases added by AM 11072013
                                case 52 %Features Faild
                                    set(QA.check(index), 'value', Error.FeaturesFailed);
                                case 53 % ROI Faild
                                    set(QA.check(index), 'value', Error.ROIFailed);
                                case 54 % Image is missing in our database
                                    set(QA.check(index), 'value',  Error.MissingImage);
                                case 55 % There is no Breast
                                    set(QA.check(index), 'value',  Error.NoBreast);
                                case 56 % Phantomless Failed
                                    set(QA.check(index), 'value', Error.PhantomlessFailed);
                            end
                            
                        end
                        QAreport('SAVE')
                        if ~QAstatus
                            QAreport('CLOSE');
                        end
end

%%
function saveToSXAroiFit(Database, Analysis, Info)

field(1) = { num2str( Info.CommonAnalysisKey ) };
field(2) = { num2str( Analysis.roi_values(1) ) };      %Info.CorrectionId is defined in funcFlatFieldCorrection
field(3) = { num2str( Analysis.roi_values(2) ) };
field(4) = { num2str( Analysis.roi_values(3) ) };
field(5) = { num2str( Analysis.roi_values(4) ) };
field(6) = { num2str( Analysis.roi_values(5) ) };
field(7) = { num2str( Analysis.roi_values(6) ) };
field(8) = { num2str( Analysis.roi_values(7) ) };
field(9) = { num2str( Analysis.roi_values(8) ) };
if ( length(Analysis.roi_values) > 8 )
    field(10) = { num2str( Analysis.roi_values(9) ) };
end
field(11) = { Analysis.SXAroiUsed };
field(12) = { num2str( Analysis.SXAroiFit(1) ) };
field(13) = { num2str( Analysis.SXAroiFit(2) ) };
field(14) = { num2str( Analysis.SXAroiFit(3) ) };
field(15) = { num2str( Analysis.SXAroiChiSqr ) };

funcAddInDatabase( Database, 'SXAroiFit', field );
