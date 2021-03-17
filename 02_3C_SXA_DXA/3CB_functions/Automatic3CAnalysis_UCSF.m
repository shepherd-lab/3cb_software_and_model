
%%%%%%% TRIM (see oNsypksSRL06012018)

%created exLIST as exclude list since annotations are misssing for CC &
%MLO      4.5.18   sypks

%SEE UCSF_Automatic3C_ERRORS.txt FOR NOTES REGARDING THE COMMENTS
%BELOW!!!!!!!

%these patients are missing both ML and CC annotations and must be
%excluded from study

%missing CC & MLO annotations: [63,65,81,82,124,133,143,144,151,154,157,223,224]

%testing on 4.3-4.5.18 revels that patients             sypks
%CC: starts at 1 and ends at 224 in annotations directory
%The following patients have errors
%CC: [1,7,16,49,50,63,65,70,81,82,98,105,106,118,124,126,133,140,143,144,150,151,152,153,154,157,167,183,210,212,213,216,223,224] all have errors see UCSF_Automatic3C_ERRORS.txt

%From the CC error above the following DEFINITELY cannot be resolved
%missing CC annotations ONLY: [98,105,106,153,216]

%testing on 4.5-4.6.18 revels that patients             sypks
%ML: starts at 1 and ends at 224 in annotations directory
%Excluding the patients missing CC&MLO annotatinos, the following patients have errors
%ML: [7,16,18,22,49,70,126,150,169,210,212,213,214]

%~~~~~~~~~~~~~~~~~~~~~~~FINISHED patients 1-224 4.6.18~~~~~~~~~~~~~~~~~~~~~

% WORK as of 11/29/2018
% Karen 3CB features missing [1,7,16,49,70,114,126,132,162,210,212,213,225,226,227]
% CC: 1,
% MLO: 

function Automatic3CAnalysis_UCSF()
global Info X FreeForm flag
FreeForm.FreeFormnumber = [];
Info.study_3C = true;
flag.MLO = true;
flag.CC = false;        %finished running through patients 4.5.18   sypks
flag.spot_paddle = false;
flag.OUTPUT = 0;            %05252018 sypks for change output directory (see save3CResults_auto)
ccOK = [];     %4.3.2018 sypks
mloOK = [];    %4.3.2018 sypks
ccFAIL = [];     %4.3.2018 sypks
mloFAIL = [];
DEBUGP = 0;

excludeList = [63,65,81,82,124,133,143,144,151,154,157,223,224];     %missing both annotations 4.5.18 sypks

% Static Paths
studyPath = '\SRL\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\';
annotationsPath = '\SRL\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\UCSF_Annotation_images\Annotations\';
xCoefficientPath = '\SRL\aaStudies\Breast Studies\3CB R01\Source Data\Bovine_experiment\Calibration_Bovine_Serghei\Bovine_234567cm_calibration\Calibration_Xcoeffs\';
studyPathContents = dir(studyPath); %get study path contents



for CurrentPatient = [29]  %patient 219 missing ML DENSITY MAP next time 3.29.2018
    
    %wipe path from previous patient (if needed)
    clear full_filenameLECC full_filenameLEML full_filenameHECC full_filenameHEML full_filenameDensityCC full_filenameDensityML
    
    if CurrentPatient == 10000
        pause
        break
    end
    
    if find(excludeList==CurrentPatient)
        continue
    end
    
    % set patientId
    patientId = ['3C01',num2str(CurrentPatient,'%03.0f')];
    
    % set patient images path
    if studyPathContents(strcmp({studyPathContents.name}, patientId)==1).name
        if isempty(patientId)
            error('Patient folder is empty');
        else
            patientPngs = dir([studyPath,'\', patientId,'\png_files\*.png']);
        end
    else
        error('Patient folder does not exist')
    end
    
    % assign hInit and h_slope handles h1 and h2
    
    h1 = findobj('tag','hInit')
    if ~isempty(h1)
        for k = 1:length(h1)
            delete(h1(k));
        end
    end
    
    h2 = findobj('tag','h_slope')
    if ~isempty(h2)
        for n = 1:length(h2)
            delete(h2(n));
        end
    end
    
    % end of figure handles
    
    % here trying to get the raw images while ensuring that they are png
    % format and that they are not Thickness, Density, Water, lipid,
    % protein, orig
    
    % new way to set path to LE/HE CC/ML images
    %    contains({patientPngFiles.name},'LECC')
    ccDensityPngPath = [];      %assigned to address no file 4.3.18
    mlDensityPngPath = [];      %assigned to address no file 4.3.18
    
    %find indicies of patient raw images whose pngNameDoesNotContain
    pngNameDoesNotContain = {'thickness', 'water', 'lipid','density', 'protein', 'orig'};
    indexPngNameDoesNotContain = ~contains({patientPngs.name},pngNameDoesNotContain,'IgnoreCase',true);
    indexDensity = contains({patientPngs.name},{'Density8_0SXA','Density8_1SXA'},'IgnoreCase',true)
    
    if (flag.CC)
        %LECC raw image and density
        indexLECC = contains({patientPngs.name},{'LECC'},'IgnoreCase',true);        %get the indicies to LECC images
        ccLePngPath = [studyPath,patientId,'\png_files\',patientPngs(indexLECC&indexPngNameDoesNotContain&~indexDensity).name]
        ccDensityFiles = {patientPngs(indexDensity&indexLECC).name};     %get available density files
        ccLatestDensityFile = ccDensityFiles{end};                                 %choose latest version by name
        ccDensityPngPath = [studyPath,patientId,'\png_files\',ccLatestDensityFile];
        
        %HECC image
        indexHECC = contains({patientPngs.name},{'HECCraw'},'IgnoreCase',true);        %get the indicies to LECC images
        ccHePngPath = [studyPath,patientId,'\png_files\',patientPngs(indexHECC&indexPngNameDoesNotContain&~indexDensity).name]
    end
    
    if (flag.MLO)
        %LEML raw image and density
        indexLEML = contains({patientPngs.name},{'LEML'},'IgnoreCase',true);        %get the indicies to LEML images
        mlLePngPath = [studyPath,patientId,'\png_files\',patientPngs(indexLEML&indexPngNameDoesNotContain&~indexDensity).name]
        mlDensityFiles = {patientPngs(indexDensity&indexLEML).name};     %get available density files
        mlLatestDensityFile = mlDensityFiles{end};                                 %choose latest version by name
        mlDensityPngPath = [studyPath,patientId,'\png_files\',mlLatestDensityFile]
        
        %HEML image
        indexHEML = contains({patientPngs.name},{'HEMLraw'},'IgnoreCase',true);        %get the indicies to LECC images
        mlHePngPath = [studyPath,patientId,'\png_files\',patientPngs(indexHEML&indexPngNameDoesNotContain&~indexDensity).name]
    end
    
   % try
        if flag.CC == true
            view = 'CC';
            lehe_fnames.LEfname =  ccLePngPath;
            lehe_fnames.HEfname =  ccHePngPath;
            lehe_fnames.mat_annotation = [annotationsPath,patientId,'_',view,'_annotation.mat'];
            lehe_fnames.Density = ccDensityPngPath;
            
            % create matrix vector to handle naming discrepancy
            nameERRORcc = [1,59]
            
            calibration_type = 'Breast ZM10new';
            funcopenSeleniaDXA_auto(lehe_fnames, calibration_type);
            % if ik <61  & ik ~= 59 original
            if CurrentPatient < 61 & isempty(find(nameERRORcc==CurrentPatient)) %changed 4.3.2018 sypks
                mat_thick = ['LE',view,'raw_Mat_v8.0.mat'];
                % elseif  (ik >=61 & ik < 135) | ik == 59  original
            elseif  (CurrentPatient >=61 & CurrentPatient < 135) | ~isempty(find(nameERRORcc==CurrentPatient))    %changed 4.3.2018 sypks
                mat_thick = ['LE',view,num2str(Info.kVpLE),'raw_Mat_v8.0.mat'];
            elseif  CurrentPatient >=135
                mat_thick = ['LE',view,num2str(Info.kVpLE),'raw_Mat_v8.1.mat'];
            end
            lehe_fnames.mat_thickness = [studyPath,patientId,'\png_files\',mat_thick];
            
            Info.type3C ='QUADRATIC';
            %            CalibrationDXA_3C_fat_water_protein('QUADRATIC');
            Xcoef_name = ['X_BV_60points_',num2str(Info.kVpLE),'kvp.txt'];
            Xcoef_name_full = [xCoefficientPath,Xcoef_name];
            X = load(Xcoef_name_full, '-ascii');
            Load_thicknessFLIPROIauto(lehe_fnames.mat_thickness);
            LoadAnnotation_auto(lehe_fnames.mat_annotation);
            SeleniaDXAFnc('ShowMaterial');
            SeleniaDXAFnc('ShowThirdComponent');
            save_3CResults_auto(lehe_fnames.Density,'ucsf');
            if DEBUGP
                ccOK = [ccOK,CurrentPatient];
                disp(ccOK)
            end
        end
    %catch
     %   ccFAIL = [ccFAIL, CurrentPatient];
   % end
    
   % try
        if  flag.MLO == true
            view = 'ML';
            lehe_fnames.LEfname =  mlLePngPath;
            lehe_fnames.HEfname =  mlHePngPath;
            lehe_fnames.mat_annotation = [annotationsPath,patientId,'_',view,'_annotation.mat'];
            lehe_fnames.Density = mlDensityPngPath;
            
            % create matrix vector to handle naming discrepancy
            nameERRORmlo = [1,59]
            calibration_type = 'Breast ZM10new';
            funcopenSeleniaDXA_auto(lehe_fnames, calibration_type);
            %if ik <61 & ik ~= 59 %original
            if CurrentPatient <61 & isempty(find(nameERRORmlo==CurrentPatient))        %changed 4.3.2018 sypks
                mat_thick = ['LE',view,'raw_Mat_v8.1.mat'];
                %elseif  ik >=61 | ik == 59  %original
            elseif  CurrentPatient >= 61 | ~isempty(find(nameERRORmlo==CurrentPatient))
                mat_thick = ['LE',view,num2str(Info.kVpLE),'raw_Mat_v8.1.mat'];
            end
            %           & ik < 135
            %               mat_thick = ['LE',view,num2str(Info.kVpLE),'raw_Mat_v8.0.mat'];
            %              elseif  ik >=135
            lehe_fnames.mat_thickness = [studyPath,patientId,'\png_files\',mat_thick];
            
            Info.type3C ='QUADRATIC';
            %            CalibrationDXA_3C_fat_water_protein('QUADRATIC');
            Xcoef_name = ['X_BV_60points_',num2str(Info.kVpLE),'kvp.txt'];
            Xcoef_name_full = [xCoefficientPath,Xcoef_name];
            X = load(Xcoef_name_full, '-ascii');
            Load_thicknessFLIPROIauto(lehe_fnames.mat_thickness);
            LoadAnnotation_auto(lehe_fnames.mat_annotation);
            SeleniaDXAFnc('ShowMaterial');
            SeleniaDXAFnc('ShowThirdComponent');
            save_3CResults_auto(lehe_fnames.Density,'ucsf');
            if DEBUGP
                mloOK = [mloOK,CurrentPatient];
                disp(mloOK)
            end
        end
        
 %   catch
 %       mloFAIL = [mloFAIL, CurrentPatient];
  %  end
end
display(ccFAIL)
display(mloFAIL)
a = 1;

