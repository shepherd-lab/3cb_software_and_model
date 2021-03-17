
% batch run of read dicoms

%pathFrom = 'O:\SRL\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\';

pathFrom = 'O:\SRL\aaData\Breast Studies\3C_data\RO1_3Cimages\va_test_run\';

pngFolderName = 'png_files';
matFolderName = 'mat_files';

for CurrentPatient = [1:1]

pathFromLoop = [pathFrom,'3C03',num2str(CurrentPatient,'%03.0f'),'\'];

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

finished = CurrentPatient
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
        name = ['3C03',name];
    end
    % instanceNum = info_dicom.InstanceNumber;
    viewPosition = info_dicom.ViewPosition
    kvp = info_dicom.KVP
    
%     comments = erase(info_dicom.ImageComments,name)
%     if isempty(comments)
%         comments = ['HE',viewPosition]
%     elseif contains(comments,{'CP','FF'})
%         comments = [comments(3:4),comments(1:2)]
%     end
% 
%     if length(comments)>4
%         comments = comments(1:4)
%     end
% 
%     %   adjust naming to include kvp when necessary
%% 
%     if ~contains(comments,{'CPLE','GEN3','FFLE'})
%         kvp='';
%     end
    
    %     png_filenamePng = [pathToPng,name,'_',num2str(instanceNum),'_',num2str(kvp),'_',viewPosition,'_',comments,'.png']
    %     png_filenameMat = [pathToMat,name,'_',num2str(instanceNum),'_',num2str(kvp),'_',viewPosition,'_',comments,'.mat']
    
    % added temp name convention to assign dcm filename to output name
    % 07012019 sypks
    name = split(listing(ii).name,'.');
    name = name{1};
    
    png_filenamePng = [pathToPng,name,num2str(kvp),'raw.png']
    png_filenameMat = [pathToMat,name,num2str(kvp),'raw.mat']
    
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