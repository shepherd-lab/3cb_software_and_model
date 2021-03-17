function UCSFpilot_3CdataLoadingSetup()
%loadDataSetup(1,1)= {uigetdir('file.start_path','select the hardrive where images are stored')};
loadDataSetup(1,1) = {uigetdir('O:\SRL\aaData\Breast Studies\3C_data\RO1_3Cimages\Moffitt')};
%loadDataSetup(2,1) = [];%{'\\researchstg\aaData\Breast Studies\MGH\DicomImagesBlinded(digi)\'};
loadDataSetup(2,1)= inputdlg('What is the name of the hard drive?'); %format like CPMC_04-04-2007 date of population; just a label for uploading sypks not physical, just fills out one column of the DB; able to change and put something more useful
% % loadDataSetup(4,1) = {'\\researchstg\aaData5\Breast Studies\MGH\DicomImagesBlinded(digi)\'};
% % loadDataSetup(5,1)= {'\\researchstg\aadata8\Lucyz-Desktop\Breast Studies\MGH\DicomImagesBlinded(digi)'};
save('O:\SRL\aaStudies\Breast Studies\3CB R01\Analysis Code\Matlab\Developers\sypks\github\shepherd-lab\3cb\00_initialization\database_loading\MOFF3Cloading.mat','loadDataSetup');