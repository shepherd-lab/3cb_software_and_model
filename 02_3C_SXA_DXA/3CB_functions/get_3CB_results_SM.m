function [parentDir, patientNums, varargout] = get_3CB_results(varargin)
%%This function gets the specified variables from 3CB analyses.  The user
%%selects a directory, iteratively searches through the folders in the
%%directory in search of the "_3CB_Analysis_Results.mat" file.
%
%       [parentdir, patientNums, out1, out2, ...] = get_3CB_results(var1, var2,...)
%
%       varList = {'CP_phan_coords': the CP phantom coordinates
%           'LesionMaskCheck': lesion mask images
%           'SelectedFiles': files that were selected during processing
%           'lesionROIImg': the annotated, ROI breast LE image
%           'lipidImg': lipid thickness matrix
%           'waterImg: water thickness matrix
%           'proteinImg': protein thickness matrix
%           'lesion_comp': the lesion composition
%           'outer_1_comp': the compos. of the first ring surrounding the lesion
%           'outer_2_comp': the compos. of the second ring surrounding the lesion
%           'outer_3_comp': the compos. of the third ring surrounding the lesion
%           'ROI': the region of interest of the breast
%           'lesion_masks': the logical matrices of the lesion and rings locations
%           }
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%- INPUTS -%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%varargin                       The input string variables that are
%                               requested.  These should match the ones
%                               found in varList.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%- OUTPUTS -%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%parentDir      string          The parent directory of the patients.
%
%patientNums    Mx1 cell        The patient numbers
%
%varargout                      The returned variables that were requested

%% %%%%%%%%%%% - Determine which variables will be retrieved - %%%%%%%%% %%
global debug

varList = {'CP_phan_coords', 'LesionMaskCheck', 'SelectedFiles', 'lesionROIImg', ...
    'lesion_comp', 'lipidImg', 'outer_1_comp' , 'outer_2_comp', ...
    'outer_3_comp',  'proteinImg', 'waterImg', 'ROI', 'lesion_masks', 'kVp'};

%Compare the input variables to varList
[idxVec, bool_Vec, num_bools] = comp_vars_2_varsList(varList, 1, varargin);
    
dir_towrite = '\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\R01_analysis_maps\Run_March2016\';

%% %%%%%%% - Get the 3CB results file names and directories - %%%%%%%%%% %%
%Ask the user to select the parent directory where the dicom files are
%located
if debug
    %parentDir = 'C:\Users\javila\Code\3C SXA DXA\TestFlatFieldImgs\BreastSamples\3C01038';
    parentDir = 'C:\Users\javila\Code\3C SXA DXA\TestFlatFieldImgs\BreastSamples\temp';
    %parentDir = 'C:\Users\javila\Code\3C SXA DXA\TestFlatFieldImgs\BreastSamples'; 
    %parentdir = '\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF';
else
    parentDir = uigetdir('C:\Users\javila\Code\3C SXA DXA\TestFlatFieldImgs\BreastSamples', 'Select the folder where the Patient directories are located');

end
length_dir = numel(parentDir);

%Recursively retreive (look in all subfolders/subdirectories) only .DCM
%files
disp('*******************************************************');
disp('********* - Looking for 3CB Results  - ****************');
disp('*******************************************************');
file_names = fuf(strcat(parentDir,'\*3CBResults*_SM.mat'),1,'detail');
% file_names = file_names(1:41); %remove this
num_files = size(file_names,1);

%% Only for 1-time processing. delete this section after finished processing
%Keep only the file names that were processed with updated version that
%have the lesion_masks in them
%{
strList = {'1030', '1031', '1033', '1034', '1036', '1037', '1039', '1042', '1045' ... 
            '1057', '1058', '1038', '1046', '1053', '1056', '1040', '1043', ... 
            '1047', '1052', '1054', '1055'};
[idxVec1, bool_Vec1, num_bools1] = comp_vars_2_varsList(file_names,0, strList);

file_names = file_names(idxVec1); %keep only the ones found
num_files = size(file_names,1);
%}





%% %%%%%%%%%%%%%%%%%%%%% - Retrieve the variables - %%%%%%%%%%%%%%%%%%%% %%

%create cells that will keep track of variables
masterCell = cell(1, num_bools);
for ii = 1:1:num_bools
    masterCell{ii} =  cell(1,num_files); %Store a cell inside the masterCell
end
patientNums = cell(1,num_files);
%{
CP_phan_coords_cell =  LesionMaskCheck_cell = cell(1,num_files); SelectedFiles_cell = cell(1,num_files); lesionROIImg_cell = cell(1,num_files);
lesion_comp_cell = cell(1,num_files); lipidImg_cell = cell(1,num_files); outer_1_comp_cell = cell(1,num_files); outer_2_comp_cell = cell(1,num_files);
outer_3_comp_cell = cell(1,num_files); proteinImg_cell = cell(1,num_files); waterImg_cell = cell(1,num_files);
%}
for ii = 1:1:num_files
    disp('');
    disp('--------------------------------------------------------');
    disp(['Getting result ' num2str(ii) ' of ' num2str(num_files)]);
    filename = file_names{ii};
     copyfile(filename,dir_towrite);
     
%     %Read the file from the file name list
%     filename = file_names{ii};
%     [pathstr,name,ext] = fileparts(filename); 
%   
%    
%     %Get the patient number using the parent directory
%     %filename_dir = filename(1:length_dir);      %the parsed user-selected directory from the filename
%     filename_end = filename(length_dir+2:end);  %the parsed last part of the filename that excludes the user-selected directory from its name. The first backslash is ommitted.
%     slash_ind = strfind(filename_end, '\');     %find the location of the backslashes in the last part of filename
%     patient_num = filename_end(1:slash_ind-1);
%     disp(['Patient Number: ' patient_num]);
% %     patientNums{ii} = patient_num;
%     filename_towrite = [dir_towrite,patient_num,'_',name(3:4),'_WLP.mat'];
%       copyfile(filename,dir_towrite);
%       
%       fname_oldm = [dir_towrite,name,ext];
%       movefile( fname_oldm, filename_towrite);
%     
    %for loop to retrieve the variable according to the boolean result
%     for jj = 1:1:num_bools
%         %Only store if the corresponding boolean vector is high
%         if bool_Vec(jj) == 1
%             tempCell = masterCell{jj}; %Retrieve the corresponding boolean cell from masterCell
%             
%             %Load the corresponding variable from the matlab file
%             temp_struct = load(filename, varList{jj});
%             temp_var = temp_struct.(varList{jj});
%             
%             %Store in tempCell
%             tempCell{ii} = temp_var;
%             
%             %Store the tempCell in masterCell
%             masterCell{jj} = tempCell;
%         end
%     end
%     
    
    
    
end

%% %%%%%%%% - Sort masterCell to match input variables order - %%%%%%%%% %%

%varargout should equal the number of input variables requested by the user
% nout = nargout - 2;
% 
% for ii = 1:1:nout
%     %get the index of where the first corresponding output variable is
%     %located in masterCell
%     idx = idxVec(ii);
%     
%     %Get the corresponding output from masterCell
%     varargout{ii} = masterCell{idx};
%     
% end

disp('*******************************************************');
disp('********* - Finished getting results - ****************');
disp('*******************************************************');

%
end

