function Automatic3CAnalysis_MOFF()
global Info X FreeForm flag ROI
FreeForm.FreeFormnumber = [];
Info.study_3C = true;
flag.MLO = true;
flag.CC = false;
flag.spot_paddle = false;
flag.rect_spot_paddle = true; %created for patient with rect spot CC view 4.26.18 sypks
                    % 2019-01-07 sypks
flag.OUTPUT = 0;    %temp flag that adjusts 3CB image and excel save output
flag.UHCCrun = 0;   %temp flag to allow mat thick extension *v8.3.mat
init_pat = [];
init_pat1 = [];
init_pat2 = [];
full_filenameDensityCC = [];
full_filenameDensityML = [];

ccOK = [];     %4.6.2018 sypks
mloOK = [];
ccFAIL = [];
mloFAIL = [];
DEBUGP = 1;

annot_dir = '\SRL\aaData\Breast Studies\3C_data\RO1_3Cimages\Moffitt\Moffitt_Annotation_images\Annotations';
Xcoeff_dir = '\SRL\aaStudies\Breast Studies\3CB R01\Source Data\Bovine_experiment\Calibration_Bovine_Serghei\Bovine_234567cm_calibration\Calibration_Xcoeffs\';
not_done = [1,3,8,9,13,15,17,18,22,25,30];          %note from UCSF

exLIST = [80,137,150,184,205];    %missing both CC and ML annotations 4.12.2018

%~~~~~~~~~~~~~~~~~~~~~      PART     I     ~~~~~~~~~~~~~~~~~~~~~~~%
fprintf('Enter PART I\n')
for ik=[4]    %patient errors: 20, %stopped at 78 (completed successfully) 4.12.2018
    if find(exLIST==ik)             % todo: ,198,199,209,210,229,230,231
        continue
    end
    
    %spot paddle: 3,4,13,16,29,30,32,37,42,50

    %OLD COMMENT: not_done 174,38,70,112,124;  29 and 41 MLO iswrong  6, 14, 29, 31, 41
    %try
        
        %SEE MOFF_Automatic3C_ERRORS.txt FOR NOTES REGARDING THE COMMENTS
        %BELOW!!!!!!!
        
        %these patients are missing both ML and CC annotations and must be
        %excluded from study
        
        %missing CC & MLO annotations: [80,137,150,184,205]
        
        %testing on 4.12.18 revels that patients             sypks
        %CC: starts at 1 and ends at 228 in annotations directory
        %The following patients have errors
        %CC: [3,29,38,42,46,50,55,80,124,125,135,136,137,1850,168,184,205,221] all have errors see MOFF_Automatic3C_ERRORS.txt
        
        %From the CC error above the following DEFINITELY cannot be resolved
        %missing CC annotations ONLY: [3,125,135]
        
        %testing on 4.13.18 revels that patients             sypks
        %ML: starts at 1 and ends at 228 in annotations directory
        %Excluding the patients missing CC&MLO annotatinos, the following patients have errors
        %ML: [1,2,3,4,38,50,51,55,110,121,126,135,136,138,143,155,163,213,221]
        
        %From the ML error above the following DEFINITELY cannot be resolved
        %missing ML annotations ONLY: [51,121]
        
        %sypks
        
        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~FINISHED~~4.13.18~~~~~~~~~~~~~~~~~~~~~
        
        fprintf('Enter try 1\n')
        root_dir = '\SRL\aaData\Breast Studies\3C_data\RO1_3Cimages\Moffitt';
        pat_dirs = dir(root_dir);
        %OLD COMMENT OUT: parentdir = ['\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF_pilot\3C01',num2str(i,'%03.0f')];
        patient = ['3C02',num2str(ik,'%03.0f')];
        sz_dirs = size(pat_dirs);
        patient_dir = [];
        for ii=1:length(pat_dirs)
            if ~isempty(strfind(pat_dirs(ii).name,patient))
                cur_dir = strcat('\',pat_dirs(ii).name); %correction 3/22
                break;
            end
        end
        if isempty(cur_dir)
            break;
        end
        %SET patient_dir to point to all .png files
        patient_dir = [root_dir, cur_dir,'\png_files\*.png'];
        file_names = dir(patient_dir);
        
        %~~~~~~~~~~~~~~~~~~~~~      PART    II     ~~~~~~~~~~~~~~~~~~~~~~~%
        fprintf('Enter PART II\n')
        %START: get placeholders for graphics objects
        %       if not empty then clear, otherwise continue
        h1 = findobj('tag','hInit')
        if ~isempty(h1)
            for k = 1:length(h1)
                delete(h1(k));
            end
        end
        
        h2 = findobj('tag','h_slope');
        if ~isempty(h2)
            for n = 1:length(h2)
                delete(h2(n));
            end
        end
        %END: get placeholders for graphics objects
        
        %~~~~~~~~~~~~~~~~~~~~~      PART    III    ~~~~~~~~~~~~~~~~~~~~~~~%
        fprintf('Enter PART III\n')
        for i=3:length(file_names)
            %          hnd = get(0,'Children');         OLD COMMENT OUT
            
            %WAS NOT COMMENTED OUT but see no use of it 3/23     fn = file_names(i).name
            %         if  ~(~isempty(strfind(file_names(i).name,'LECC')) | ~isempty(strfind(file_names(i).name,'LEML')) | ~isempty(strfind(file_names(i).name,'Thickness')) | ~isempty(strfind(file_names(i).name,'Density')) | ~isempty(strfind(file_names(i).name,'water')) | ~isempty(strfind(file_names(i).name,'lipid')) | ~isempty(strfind(file_names(i).name,'protein')) | ~isempty(strfind(file_names(i).name,'orig'))) & ~isempty(strfind(file_names(i).name(end-2:end),'png'))
            %             full_filenameLE = [root_dir,cur_dir,'\',file_names(i).name];
            %         end
            %         if  ~(~isempty(strfind(file_names(i).name,'HECC')) | ~isempty(strfind(file_names(i).name,'HEML')) | ~isempty(strfind(file_names(i).name,'Thickness')) | ~isempty(strfind(file_names(i).name,'Density')) | ~isempty(strfind(file_names(i).name,'water')) | ~isempty(strfind(file_names(i).name,'lipid')) | ~isempty(strfind(file_names(i).name,'protein')) | ~isempty(strfind(file_names(i).name,'orig'))) & ~isempty(strfind(file_names(i).name(end-2:end),'png'))
            %             full_filenameHE = [root_dir,cur_dir,'\',file_names(i).name];
            %         end
            %         if ~isempty(strfind(file_names(i).name,'LECC')) & ~isempty(strfind(file_names(i).name(end-2:end),'png')) &  ~(~isempty(strfind(file_names(i).name,'LEML')) | ~isempty(strfind(file_names(i).name,'Thickness')) | ~isempty(strfind(file_names(i).name,'Density')) | ~isempty(strfind(file_names(i).name,'water')) | ~isempty(strfind(file_names(i).name,'lipid')) | ~isempty(strfind(file_names(i).name,'protein')) | ~isempty(strfind(file_names(i).name,'orig')))
            %             full_filenameLE = [root_dir,cur_dir,'\',file_names(i).name];
            %         end          OLD COMMENT OUT
            
            
            %START      Set full_filename PATH for low/high engery views: ML, CC
            if  ~isempty(strfind(file_names(i).name,'LECC')) && ~( ~isempty(strfind(file_names(i).name,'LEML')) || ~isempty(strfind(file_names(i).name,'Thickness')) | ~isempty(strfind(file_names(i).name,'Density')) | ~isempty(strfind(file_names(i).name,'water')) | ~isempty(strfind(file_names(i).name,'lipid')) | ~isempty(strfind(file_names(i).name,'protein')) | ~isempty(strfind(file_names(i).name,'orig'))) & ~isempty(strfind(file_names(i).name(end-2:end),'png'))
                full_filenameLECC = [root_dir,cur_dir,'\png_files\',file_names(i).name]
                view = file_names(i).name(3:4)
            end
            if  ~isempty(strfind(file_names(i).name,'LEML')) && ~( ~isempty(strfind(file_names(i).name,'LECC')) || ~isempty(strfind(file_names(i).name,'Thickness')) | ~isempty(strfind(file_names(i).name,'Density')) | ~isempty(strfind(file_names(i).name,'water')) | ~isempty(strfind(file_names(i).name,'lipid')) | ~isempty(strfind(file_names(i).name,'protein')) | ~isempty(strfind(file_names(i).name,'orig'))) & ~isempty(strfind(file_names(i).name(end-2:end),'png'))
                full_filenameLEML = [root_dir,cur_dir,'\png_files\',file_names(i).name]
                view = file_names(i).name(3:4)
            end
            if  ~isempty(strfind(file_names(i).name,'HECC')) && ~( ~isempty(strfind(file_names(i).name,'HEML')) || ~isempty(strfind(file_names(i).name,'Thickness')) | ~isempty(strfind(file_names(i).name,'Density')) | ~isempty(strfind(file_names(i).name,'water')) | ~isempty(strfind(file_names(i).name,'lipid')) | ~isempty(strfind(file_names(i).name,'protein')) | ~isempty(strfind(file_names(i).name,'orig'))) & ~isempty(strfind(file_names(i).name(end-2:end),'png'))
                full_filenameHECC = [root_dir,cur_dir,'\png_files\',file_names(i).name]
            end
            if  ~isempty(strfind(file_names(i).name,'HEML')) && ~( ~isempty(strfind(file_names(i).name,'HECC')) || ~isempty(strfind(file_names(i).name,'Thickness')) | ~isempty(strfind(file_names(i).name,'Density')) | ~isempty(strfind(file_names(i).name,'water')) | ~isempty(strfind(file_names(i).name,'lipid')) | ~isempty(strfind(file_names(i).name,'protein')) | ~isempty(strfind(file_names(i).name,'orig'))) & contains(file_names(i).name(end-2:end),'png')
                full_filenameHEML = [root_dir,cur_dir,'\png_files\',file_names(i).name]
            end
            %NO DENSITY path for patients < 46
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
            %END        Set full_filename PATH for low/high engery views: ML, CC
            
        end
        % catch
        %    fprintf('Enter PART III catch \n')
        %  init_pat = [init_pat;patient]
        % end
        
        %Everything good until here 3/27/2018
        %~~~~~~~~~~~~~~~~~~~~~      PART     IV    ~~~~~~~~~~~~~~~~~~~~~~~%
        
        try          %try #2 = CC View
            fprintf('Enter PART IV try 2\n')
            if flag.CC == true
                fprintf('CC TRUE\n')
                view = 'CC';
                lehe_fnames.LEfname =  full_filenameLECC;
                lehe_fnames.HEfname =  full_filenameHECC;
                lehe_fnames.mat_annotation = [annot_dir,'\',patient,'_',view,'_annotation.mat']; %added '\' 3/22
                lehe_fnames.Density = full_filenameDensityCC;
                
                calibration_type = 'Breast ZM10new';
                fprintf('OK HERE\n')
                
                %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                %MAJOR ISSUE WITH THIS FUNCTION THROUH its dependencies
                
                %error with funcopenSeleniaDXA_auto --> many other functions
                %---> log_convertDXA_ZM10new (masking) dimensions of images do
                %not match. tried various cases...
                funcopenSeleniaDXA_auto(lehe_fnames, calibration_type);
                %{
           
         a couple examples

 PATIENT #200::::::
 Unable to perform assignment because the size of the left side is 1664-by-1280 and the size of the right side is 1530-by-1196.

Error in log_convertDXA_ZM10new (line 407)
            current_image3(193:1856,1:1280) = current_image2;

Error in funcloadImage (line 237)
                    Result.image2= log_convertDXA_ZM10new(Result.image,Info.mAs,Info.kVp,Info.Alfilter);

Error in funcOpenImage (line 73)
mask=funcloadImage(fname, Option);

Error in funcMenuOpenImage_auto (line 27)
        funcOpenImage(fname,Option);

Error in funcopenSeleniaDXA_auto (line 63)
    funcMenuOpenImage_auto(fname,Option); % open the LE image
           
          
 PATIENT #46:::::
           
Matrix dimensions must agree.

Error in log_convertDXA_ZM10new (line 544)
         I = -log(current_image1./I0LE2);

Error in funcloadImage (line 237)
                    Result.image2= log_convertDXA_ZM10new(Result.image,Info.mAs,Info.kVp,Info.Alfilter);

Error in funcOpenImage (line 73)
mask=funcloadImage(fname, Option);

Error in funcMenuOpenImage_auto (line 27)
        funcOpenImage(fname,Option);

Error in funcopenSeleniaDXA_auto (line 63)
    funcMenuOpenImage_auto(fname,Option); % open the LE image
           
                %}
                %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                %everything below works
                if flag.UHCCrun%modified to include new extension 2019-01-07 sypks
                    mat_thick = ['LE',view,num2str(Info.kVpLE),'raw_Mat_v8.3.mat']
                elseif ik < 46 || ik ==50
                    mat_thick = ['LE',view,'raw_Mat.mat']
                    flag.spot_paddle = true;
                elseif (ik > 45 &  ik < 50) |  (ik > 50 &  ik <= 60)
                    mat_thick = ['LE',view,'raw_Mat_v8.0.mat']
                elseif  ik > 60 & ik < 172
                    mat_thick = ['LE',view,num2str(Info.kVpLE),'raw_Mat_v8.0.mat']
                elseif  ik >=172
                    mat_thick = ['LE',view,num2str(Info.kVpLE),'raw_Mat_v8.1.mat']
                end
                lehe_fnames.mat_thickness = [root_dir,cur_dir,'\png_files\',mat_thick];
                
                Info.type3C ='QUADRATIC'
                %            CalibrationDXA_3C_fat_water_protein('QUADRATIC');
                Xcoef_name = ['XXX_MOFFquadXX_CP51UCSFtoMOFF_',num2str(Info.kVpLE),'kvp.txt'];
                %            Xcoef_name = ['X_BV_60points_',num2str(Info.kVpLE),'kvp.txt'];
                Xcoef_name_full = [Xcoeff_dir,Xcoef_name];
                X = load(Xcoef_name_full, '-ascii');
                Load_thicknessFLIPROIauto(lehe_fnames.mat_thickness);
                %             Image.CTmask3C=Image.Tmask3C(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1);
                im_size = size(ROI.BackGround);
                ROI.columns = im_size(2);
                ROI.rows = im_size(1);
                LoadAnnotation_auto(lehe_fnames.mat_annotation);
                
                
                
                %works until here
                %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                SeleniaDXAFnc('ShowMaterial');
                SeleniaDXAFnc('ShowThirdComponent');
                save_3CResults_auto(lehe_fnames.Density,'moff')
                if DEBUGP
                    ccOK = [ccOK,ik];
                    disp(ccOK)
                end
                
                
                %save_3CResults_auto(...) fails for...
                %{
            
        patient #1,20 throws following error for validateattributes(...)
Error using regionprops
Expected input number 1, L, to be finite.

Error in regionprops (line 198)
    validateattributes(L, supportedTypes, supportedAttributes, ...

Error in save_3CResults_auto (line 153)
 s = regionprops(lesion_ROI,'Area');

Error in Automatic3CAnalysis_MOFF (line 208)
            save_3CResults_auto(lehe_fnames.Density,'moff')
 
        patient #
 
 
                %}
                %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            end
        catch
            %        fprintf('Enter PART IV catch\n')
            %   init_pat1 = [init_pat1;patient];
        end
        
        %~~~~~~~~~~~~~~~~~~~~~      PART     VI     ~~~~~~~~~~~~~~~~~~~~~~~%
        try        %try 3 = MLO view
            fprintf('Enter PART VI try 3\n')
            if  flag.MLO == true
                fprintf('ML TRUE\n')
                view = 'ML';
                lehe_fnames.LEfname =  full_filenameLEML
                lehe_fnames.HEfname =  full_filenameHEML
                lehe_fnames.mat_annotation = [annot_dir,'\',patient,'_',view,'_annotation.mat']
                lehe_fnames.Density = full_filenameDensityML
                calibration_type = 'Breast ZM10new'
                funcopenSeleniaDXA_auto(lehe_fnames, calibration_type)
                if flag.UHCCrun %modified to include new extension 2019-01-07 sypks
                    mat_thick = ['LE',view,num2str(Info.kVpLE),'raw_Mat_v8.3.mat'] 
                elseif ik < 46 || ik ==50
                    mat_thick = ['LE',view,'raw_Mat.mat'];
                elseif (ik > 45 &  ik < 50) |  (ik > 50 &  ik <= 60)
                    mat_thick = ['LE',view,'raw_Mat_v8.1.mat'];
                elseif  ik > 60
                    mat_thick = ['LE',view,num2str(Info.kVpLE),'raw_Mat_v8.1.mat'];
                end
                %           & ik < 172
                %               mat_thick = ['LE',view,num2str(Info.kVpLE),'raw_Mat_v8.0.mat'];
                %             elseif  ik >=172
                %             mat_thick = ['LE',view,'raw_Mat_v8.0.mat'];
                lehe_fnames.mat_thickness = [root_dir,cur_dir,'\png_files\',mat_thick];
                Info.type3C ='QUADRATIC';
                
                %~~~~~~~~~~~~~~~~~~~~~      PART    VII     ~~~~~~~~~~~~~~~~~~~~~~~%
                
                %            CalibrationDXA_3C_fat_water_protein('QUADRATIC');
                %            Xcoef_name = ['X_BV_60points_',num2str(Info.kVpLE),'kvp.txt'];
                Xcoef_name = ['XXX_MOFFquadXX_CP51UCSFtoMOFF_',num2str(Info.kVpLE),'kvp.txt'];   %
                Xcoef_name_full = [Xcoeff_dir,Xcoef_name];
                X = load(Xcoef_name_full, '-ascii');
                Load_thicknessFLIPROIauto(lehe_fnames.mat_thickness);
                im_size = size(ROI.BackGround);
                ROI.columns = im_size(2);
                ROI.rows = im_size(1);
                LoadAnnotation_auto(lehe_fnames.mat_annotation);
                SeleniaDXAFnc('ShowMaterial');
                SeleniaDXAFnc('ShowThirdComponent');
                %           maps.results.Analysis_date	= date;
                % 	        maps.results.Analysis_run = 2;
                save_3CResults_auto(lehe_fnames.Density,'moff')
                if DEBUGP
                    mloOK = [mloOK,ik];
                    disp(mloOK)
                end
            end
            a = 1;
        catch
            %   fprintf('Enter PART VII catch\n')
            %   init_pat2 = [init_pat2;patient];
        end
    end
    a = 1;
    
