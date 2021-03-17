function UCSF_3CdataLoadingSetup()
%loadDataSetup(1,1)= {uigetdir('file.start_path','select the hardrive where images are stored')};
loadDataSetup(1,1) = {uigetdir('O:\SRL\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF')};
%loadDataSetup(1,1) = {uigetdir('O:\SRL\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\')};
%loadDataSetup(2,1) = [];%{'\\researchstg\aaData\Breast Studies\MGH\DicomImagesBlinded(digi)\'};
%loadDataSetup(2,1)= inputdlg('What is the name of the hard drive?'); %format like CPMC_04-04-2007 date of population
loadDataSetup(2,1)= inputdlg('What is the film_identifier (will be 5th column in acquition table)?'); %format like CPMC_04-04-2007 date of population
% % loadDataSetup(4,1) = {'\\researchstg\aaData5\Breast Studies\MGH\DicomImagesBlinded(digi)\'};
% % loadDataSetup(5,1)= {'\\researchstg\aadata8\Lucyz-Desktop\Breast Studies\MGH\DicomImagesBlinded(digi)'};
save('O:\SRL\aaStudies\Breast Studies\3CB R01\Analysis Code\Matlab\Developers\sypks\github\shepherd-lab\3cb\00_initialization\database_loading\UCSF3C_loading.mat','loadDataSetup');