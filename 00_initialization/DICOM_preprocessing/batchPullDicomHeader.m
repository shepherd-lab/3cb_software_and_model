% batch run of read dicoms

pathFrom = 'O:\SRL\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\';

addpath('O:\SRL\aaStudies\Breast Studies\3CB R01\Analysis Code\Matlab\Developers\sypks\github\shepherd-lab\3cb\00_initialization\DICOM_preprocessing')
cd('C:\Users\SSpencer\Desktop\test_temporary_UCSF\header')
this = dir();
if sum(contains({this.name},'headerInfo.mat'))~=0
    delete headerInfo.mat
end


for CurrentPatient = [1:250]
    
    pathFromLoop = [pathFrom,'3C01',num2str(CurrentPatient,'%03.0f'),'\'];
    
    pullDicomHeader(pathFromLoop);
    
    finished = CurrentPatient
end