%programmer: sypks
%date: 20181214
%function name: batchReadDicom_ONsypks_SRL_3CB_RadPub_20181214.m
%description: function purpose and description given in
%ONsypks_SRL_3CB_RadPub_20181204 OneNote 

clc, clear all

%% Set and Add Path
codeparentpath = 'O:\SRL\aaStudies\Breast Studies\3CB R01\Analysis Code\Matlab\Developers\sypks\github\shepherd-lab\3cb\00_initialization\';
codepath = 'O:\SRL\aaStudies\Breast Studies\3CB R01\Analysis Code\Matlab\Developers\sypks\github\shepherd-lab\3cb\00_initialization\DICOM_preprocessing\'
rootpath = 'O:\SRL\';

ucsfpath = 'O:\SRL\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\';
moffpath = 'O:\SRL\aaData\Breast Studies\3C_data\RO1_3Cimages\Moffitt\';
pilotpath = 'O:\SRL\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF_pilot\';
path.ucsf = ucsfpath;
path.moff = moffpath;
path.pilot = pilotpath;

cd(rootpath);
addpath(rootpath,codepath,codeparentpath);
% batch run of read dicoms

pathFrom = 'O:\SRL\aaData\Breast Studies\3C_data\RO1_3Cimages\ONsypks_SRL_3CB_RadPub_20181214\';

pngFolderName = 'png_files';
matFolderName = 'mat_files';

load('O:\SRL\aaData\Breast Studies\3C_data\RO1_3Cimages\ONsypks_SRL_3CB_RadPub_20181214\batch.mat');

%% Run preprocessing to extract header and convert to png
for cc = batch.names
    tempPathFrom = [pathFrom,upper(cc{:}),'\']
    patientList = getfield(batch,cc{:})
for kk = 1:length(patientList)

%pathFromLoop = [pathFrom,'3C01',num2str(CurrentPatient,'%03.0f'),'\'];
pathFromLoop = [tempPathFrom,patientList{kk},'\']

checkPath = dir(pathFromLoop);

if ~(contains({checkPath.name},pngFolderName))
mkdir(pathFromLoop(1:(end-1)),pngFolderName);
end
if ~(contains({checkPath.name},matFolderName))
mkdir(pathFromLoop(1:(end-1)),matFolderName);
end

pathToPng = [pathFromLoop,pngFolderName,'\'];
pathToMat = [pathFromLoop,matFolderName,'\'];
readAllDicomDirectory(pathFromLoop, pathToPng, pathToMat)

finished = patientList{kk}
end
end



function [] = readAllDicomDirectory(pathFrom, pathToPng, pathToMat)

fullfilename_readPres = pathFrom;
orig = pwd;
cd(pathToPng)
delete *.png
cd(pathToMat)
delete *.mat
cd(orig)

listing = dir([fullfilename_readPres,'\*dcm*']);
listingLen = length(listing);

for ii = 1:listingLen
    
    info_dicom = dicominfo([fullfilename_readPres,'\',listing(ii).name]);
    
    % temp workaround to fix naming issues (path) in 02 dry run) sypks
    % 07262018
    name = erase(info_dicom.StudyID,'_')
    name = erase(name,'-')
    name = erase(name,'3C111111')
    if ~contains(name,'3C')
        name = ['3C01',name];
    end
    % instanceNum = info_dicom.InstanceNumber;
    viewPosition = info_dicom.ViewPosition
    kvp = info_dicom.KVP
    comments = erase(info_dicom.ImageComments,name)
    if isempty(comments)
        comments = ['HE',viewPosition]
%     elseif contains(comments,{'CP','FF'})
%         comments = [comments(3:4),comments(1:2)]
    end

%     if length(comments)>6
%         comments = comments((end-6):end)
%     end

    %   adjust naming to include kvp when necessary
    if ~contains(comments,{'CPLE','GEN3','FFLE'})
        kvp='';
    end
    
    %     png_filenamePng = [pathToPng,name,'_',num2str(instanceNum),'_',num2str(kvp),'_',viewPosition,'_',comments,'.png']
    %     png_filenameMat = [pathToMat,name,'_',num2str(instanceNum),'_',num2str(kvp),'_',viewPosition,'_',comments,'.mat']
    
    png_filenamePng = [pathToPng,comments,num2str(kvp),'.png']
    png_filenameMat = [pathToMat,comments,num2str(kvp),'.mat']
    
    save(png_filenameMat,'info_dicom')
    
    %%
    XX = dicomread(info_dicom);
    
    XX1=round(UnderSamplingN(XX,2)); % downsizing the image
    clear XX;
    
    
    imwrite(uint16(XX1),png_filenamePng,'PNG');
ii
end

a = 1
end