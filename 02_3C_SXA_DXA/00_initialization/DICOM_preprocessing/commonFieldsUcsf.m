
pathFrom = 'O:\SRL\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\';

addpath('O:\SRL\aaStudies\Breast Studies\3CB R01\Analysis Code\Matlab\Developers\sypks\github\shepherd-lab\3cb\00_initialization\DICOM_preprocessing')
cd('O:\SRL\aaStudies\Breast Studies\3CB R01\Analysis Code\Matlab\temporary_UCSF\header')
% % % this = dir();
% % % if sum(contains({this.name},'headerInfo.mat'))~=0
% % %     delete headerInfo.mat
% % % end

 fileID = fopen('commonDicomField.txt','w');
%fileID = fopen('test.txt','w');

 for CurrentPatient = [1:250]
%for CurrentPatient = [1:1]
    
    pathFromLoop = [pathFrom,'3C01',num2str(CurrentPatient,'%03.0f'),'\'];
    
    fullfilename_readPres = pathFromLoop;
    
    listing = dir([fullfilename_readPres,'*dcm*']);
    listingLen = length(listing);
    
    
    for ii = 1:listingLen
        
        dirName = dir('C:\Users\SSpencer\Desktop\test_temporary_UCSF\header');
        info_dicom = dicominfo([fullfilename_readPres,'\',listing(ii).name]);
        if ii==1
            theNames = fieldnames(info_dicom);
        else
            currentDICOM = fieldnames(info_dicom);
            indxContains = contains(theNames,currentDICOM);
            theNames = theNames(indxContains);
        end
        
        
    end
    finished = CurrentPatient
end
for jj = 1:length(theNames)
    toprint = theNames(jj,1);
    fprintf(fileID,'%s\t',toprint{1});
end






