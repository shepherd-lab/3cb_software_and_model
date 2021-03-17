
pathFrom = 'O:\SRL\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\';

addpath('O:\SRL\aaStudies\Breast Studies\3CB R01\Analysis Code\Matlab\Developers\sypks\github\shepherd-lab\3cb\00_initialization\DICOM_preprocessing')
cd('O:\SRL\aaStudies\Breast Studies\3CB R01\Analysis Code\Matlab\temporary_UCSF\header')
% % % this = dir();
% % % if sum(contains({this.name},'headerInfo.mat'))~=0
% % %     delete headerInfo.mat
% % % end

fileID = fopen('dicomINFO2.txt','w');

for CurrentPatient = [1:250]
    
    pathFromLoop = [pathFrom,'3C01',num2str(CurrentPatient,'%03.0f'),'\'];
    
    pullDicomHead(pathFromLoop,fileID);
    
    finished = CurrentPatient
end




function [] = pullDicomHead(pathFrom,dafile)

fullfilename_readPres = pathFrom;

listing = dir([fullfilename_readPres,'\*dcm*']);
listingLen = length(listing);


for ii = 1:listingLen
    dirName = dir('C:\Users\SSpencer\Desktop\test_temporary_UCSF\header');
    info_dicom = dicominfo([fullfilename_readPres,'\',listing(ii).name]);
    theNames = [fieldnames(info_dicom)]';
    
    fprintf(dafile,'%s\n',listing(ii).name);
    for jj = 1:length(theNames)
        thisName = theNames(1,jj);
        fprintf(dafile,'%s\t',thisName{1});
    end
    fprintf(dafile,'\n');
    for kk = 1:length(theNames)
        thisDICOM = info_dicom.(theNames{kk});

        if isstruct(thisDICOM)
            fprintf(dafile,'Struct\t');
        else
            thisDICOM = string(thisDICOM);
            if size(thisDICOM,1)~=1
                thisDICOM = 'array';
            end
            thisDICOM = regexprep([thisDICOM],'\s+',' ')
            fprintf(dafile,'%s\t',thisDICOM);
        end
    end
    fprintf(dafile,'\n');
    % get field names
    %%%    namesThisInfoDicom = fieldnames(info_dicom);
    
    % revise name list if necessary
    
    % %     if (sum(contains({dirName.name},'headerInfo.mat'))==0)
    % %         save('headerInfo.mat','info_dicom')
    % %     else
    % %         save('headerInfo.mat','info_dicom','-append')
    % %     end
    clear info_dicom
end
end
