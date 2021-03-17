function  update_ROIorig( )
 clear all;
 count = [];
rootdir=[pwd,'\'];
addpath([rootdir,'3CB_functions']);
parentdir = uigetdir('\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\3CB_maps_wo3CBorig'); %UCSF\3CB_maps_wo3CBorig
files=dir(parentdir);
%% while loop for number of .mat .png pairs
for i=3:length(files)
   maps = [];
   file_name = [parentdir, '\', files(i).name];
   load(file_name);
   if isfield(maps.ROI,'image')
       maps.ROI = rmfield(maps.ROI,'image');
   end
 maps.ROI_orig = convert_ROI(maps.ROI);
 save(file_name,'maps');   
 count = i
  a = 1;
    
end

