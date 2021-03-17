function Automatic3CAnalysis_UCSFpilot()
global Info X FreeForm flag
FreeForm.FreeFormnumber = [];
Info.study_3C = true;
Info.kVpLE = [];
flag.MLO = true;
flag.CC = false;
flag.spot_paddle = false;
flag.OUTPUT = 0;
init_pat = [];
init_pat1 = [];
init_pat2 = [];

ccOK = [];     %4.17.2018 sypks
mloOK = [];
ccFAIL = [];
mloFAIL = [];
DEBUGP = 1;

%missing both annotation files [2,6,8,14,17,18,20,21,22,25,41,42,45,46,47,50]; %4.17.2018
exLIST = [2,3,6,8,10,11,12,14,17,18,20,21,22,25,33,34,41,42,45,46,47,50]; %4.17.2018`     %removed patient 9 from exclude list 2019-01-02 (successful SXA program run for thickness/density maps)

%refer to WORD DOC 3CB "Pilot Annotation Difficulties" in
%O:\SRL\aaStudies\Breast Studies\3CB R01\Reports\2016 for notes directly
%below

annot_dir = '\SRL\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\UCSF_Annotation_images\';
Xcoeff_dir = '\SRL\aaStudies\Breast Studies\3CB R01\Source Data\Bovine_experiment\Calibration_Bovine_Serghei\Bovine_234567cm_calibration\Calibration_Xcoeffs\';
for ik=[10:50]
    
    %note: started mlo on 16-50
    
    if find(exLIST==ik)
        continue
    end
    % there are 52 patient folders however last 2 don't have any images...
    % 4.17.2018
    %       for i=[164:164]
    %try
    root_dir = '\SRL\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF_pilot\';
    pat_dirs = dir(root_dir);
    %    parentdir = ['\SRL\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF_pilot\3C01',num2str(i,'%03.0f')];
    patient = ['3CB',num2str(ik,'%03.0f')];
    sz_dirs = size(pat_dirs);
    patient_dir = [];
    for ii=1:length(pat_dirs)
        if ~isempty(strfind(pat_dirs(ii).name,patient))
            cur_dir = pat_dirs(ii).name;
            break;
        end
    end
    if isempty(cur_dir)
        break;
    end
    patient_dir = [root_dir,'\', cur_dir,'\png_files\*.png'];
    file_names = dir(patient_dir);
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
    for i=1:length(file_names)
        %          hnd = get(0,'Children');
        
        fn = file_names(i).name
        if  ~isempty(strfind(file_names(i).name,'LECC')) && ~( ~isempty(strfind(file_names(i).name,'LEML')) || ~isempty(strfind(file_names(i).name,'Thickness'))...
                | ~isempty(strfind(file_names(i).name,'Density')) | ~isempty(strfind(file_names(i).name,'water')) | ~isempty(strfind(file_names(i).name,'lipid'))...
                | ~isempty(strfind(file_names(i).name,'protein')) | ~isempty(strfind(file_names(i).name,'orig'))) & ~isempty(strfind(file_names(i).name(end-2:end),'png'))
            full_filenameLECC = [root_dir,cur_dir,'\png_files\',file_names(i).name];
            view = file_names(i).name(3:4);
        end
        if  ~isempty(strfind(file_names(i).name,'LEML')) && ~( ~isempty(strfind(file_names(i).name,'LECC')) || ~isempty(strfind(file_names(i).name,'Thickness'))...
                | ~isempty(strfind(file_names(i).name,'Density')) | ~isempty(strfind(file_names(i).name,'water')) | ~isempty(strfind(file_names(i).name,'lipid'))...
                | ~isempty(strfind(file_names(i).name,'protein')) | ~isempty(strfind(file_names(i).name,'orig'))) & ~isempty(strfind(file_names(i).name(end-2:end),'png'))
            full_filenameLEML = [root_dir,cur_dir,'\png_files\',file_names(i).name];
            view = file_names(i).name(3:4);
        end
        if  ~isempty(strfind(file_names(i).name,'HECC')) && ~( ~isempty(strfind(file_names(i).name,'HEML')) || ~isempty(strfind(file_names(i).name,'Thickness'))...
                | ~isempty(strfind(file_names(i).name,'Density')) | ~isempty(strfind(file_names(i).name,'water')) | ~isempty(strfind(file_names(i).name,'lipid'))...
                | ~isempty(strfind(file_names(i).name,'protein')) | ~isempty(strfind(file_names(i).name,'orig'))) & ~isempty(strfind(file_names(i).name(end-2:end),'png'))
            full_filenameHECC = [root_dir,cur_dir,'\png_files\',file_names(i).name];
        end
        if  ~isempty(strfind(file_names(i).name,'HEML')) && ~( ~isempty(strfind(file_names(i).name,'HECC')) || ~isempty(strfind(file_names(i).name,'Thickness'))...
                | ~isempty(strfind(file_names(i).name,'Density')) | ~isempty(strfind(file_names(i).name,'water')) | ~isempty(strfind(file_names(i).name,'lipid'))...
                | ~isempty(strfind(file_names(i).name,'protein')) | ~isempty(strfind(file_names(i).name,'orig'))) & ~isempty(strfind(file_names(i).name(end-2:end),'png'))
            full_filenameHEML = [root_dir,cur_dir,'\png_files\',file_names(i).name];
        end
        
        if  ~isempty(strfind(file_names(i).name,'LECC')) && ~( ~isempty(strfind(file_names(i).name,'LEML')) || ~isempty(strfind(file_names(i).name,'Thickness'))...
                | ~isempty(strfind(file_names(i).name,'water')) | ~isempty(strfind(file_names(i).name,'lipid')) | ~isempty(strfind(file_names(i).name,'protein'))...
                | ~isempty(strfind(file_names(i).name,'orig'))) &  ( ~isempty(strfind(file_names(i).name,'Density8_0SXA')) | ~isempty(strfind(file_names(i).name,'Density8_1SXA'))...
                &  ~isempty(strfind(file_names(i).name(end-2:end),'png')) | ~isempty(strfind(file_names(i).name,'Density8_3SXA'))...
                &  ~isempty(strfind(file_names(i).name(end-2:end),'png')))  %added another check for new 8_3SXA 2019-01-02
            full_filenameDensityCC = [root_dir,cur_dir,'\png_files\',file_names(i).name];
        end
        
        if  ~isempty(strfind(file_names(i).name,'LEML')) && ~( ~isempty(strfind(file_names(i).name,'LECC')) || ~isempty(strfind(file_names(i).name,'Thickness'))...
                | ~isempty(strfind(file_names(i).name,'water')) | ~isempty(strfind(file_names(i).name,'lipid')) | ~isempty(strfind(file_names(i).name,'protein'))...
                | ~isempty(strfind(file_names(i).name,'orig'))) &  ( ~isempty(strfind(file_names(i).name,'Density8_0SXA')) | ~isempty(strfind(file_names(i).name,'Density8_1SXA'))...
                &  ~isempty(strfind(file_names(i).name(end-2:end),'png')) | ~isempty(strfind(file_names(i).name,'Density8_3SXA'))...
                &  ~isempty(strfind(file_names(i).name(end-2:end),'png')))  %added another check for new 8_3SXA 2019-01-02
            full_filenameDensityML = [root_dir,cur_dir,'\png_files\',file_names(i).name];
        end
    end
    % catch
    init_pat = [init_pat;patient]
    % end
    try
        %this line below was originally commented out from UCSF
        %4/17/2018
        %  full_filenameHECC = '\SRL\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\3C01002\png_files\FFHEraw.png';
        lehe_fnames = [];
        if flag.CC == true            view = 'CC';
            kVpLE = full_filenameLECC(5:6);
            annot_dir = '\SRL\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\UCSF_Annotation_images\Annotations\';
            lehe_fnames.LEfname =  full_filenameLECC;
            lehe_fnames.HEfname =  full_filenameHECC;
            lehe_fnames.mat_annotation = [annot_dir,patient,'_',view,'_annotation.mat'];
            lehe_fnames.Density = full_filenameDensityCC;
            calibration_type = 'Breast ZM10new';
            funcopenSeleniaDXA_auto(lehe_fnames, calibration_type);
            mat_thick = ['LE',view,num2str(Info.kVpLE),'raw_Mat_v8.1.mat'];
            lehe_fnames.mat_thickness = [root_dir,cur_dir,'\png_files\',mat_thick];
            Info.type3C ='QUADRATIC';
            %            CalibrationDXA_3C_fat_water_protein('QUADRATIC');
            Xcoef_name = ['X_BV_60points_',num2str(Info.kVpLE),'kvp.txt'];
            Xcoef_name_full = [Xcoeff_dir,Xcoef_name];
            X = load(Xcoef_name_full, '-ascii');
            Load_thicknessFLIPROIauto(lehe_fnames.mat_thickness);
            LoadAnnotation_auto(lehe_fnames.mat_annotation);
            SeleniaDXAFnc('ShowMaterial');
            SeleniaDXAFnc('ShowThirdComponent');
            save_3CResults_auto(lehe_fnames.Density,'ucsf');
            if DEBUGP
                ccOK = [ccOK,ik];
                disp(ccOK)
            end
        end
    catch
        init_pat1 = [init_pat1;patient]
    end
    try
        lehe_fnames = [];
        if  flag.MLO == true
            view = 'ML';
            kVpLE = full_filenameLEML(5:6);
            annot_dir = '\SRL\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\UCSF_Annotation_images\Annotations\';
            lehe_fnames.LEfname =  full_filenameLEML;
            lehe_fnames.HEfname =  full_filenameHEML;
            lehe_fnames.mat_annotation = [annot_dir,patient,'_',view,'_annotation.mat'];
            lehe_fnames.Density = full_filenameDensityML;
            calibration_type = 'Breast ZM10new';
            funcopenSeleniaDXA_auto(lehe_fnames, calibration_type);
            Info.type3C ='QUADRATIC';
            mat_thick = ['LE',view,num2str(Info.kVpLE),'raw_Mat_v8.1.mat'];
            lehe_fnames.mat_thickness = [root_dir,cur_dir,'\png_files\',mat_thick];
            %          CalibrationDXA_3C_fat_water_protein('QUADRATIC');
            Xcoef_name = ['X_BV_60points_',num2str(Info.kVpLE),'kvp.txt'];
            Xcoef_name_full = [Xcoeff_dir,Xcoef_name];
            X = load(Xcoef_name_full, '-ascii');
            Load_thicknessFLIPROIauto(lehe_fnames.mat_thickness);
            LoadAnnotation_auto(lehe_fnames.mat_annotation);
            SeleniaDXAFnc('ShowMaterial');
            SeleniaDXAFnc('ShowThirdComponent');
            save_3CResults_auto(lehe_fnames.Density,'ucsf');
            if DEBUGP
                mloOK = [mloOK,ik];
                disp(mloOK)
            end
        end
        
        a = 1;
        
        
    catch
        %  init_pat2 = [init_pat2;patient]
    end
end
a = 1;

