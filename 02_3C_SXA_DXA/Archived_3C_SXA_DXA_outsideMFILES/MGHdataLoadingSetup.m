function MGHdataLoadingSetup()
%loadDataSetup(1,1)= {uigetdir('file.start_path','select the hardrive where images are stored')};
loadDataSetup(1,1) = {uigetdir('\\researchstg\aadata8\Lucyz-Desktop\newest_images_receiving\Edge-Marin General\DicomImageBlinded\')};
loadDataSetup(2,1) = {'\\researchstg\aaData\Breast Studies\MGH\DicomImagesBlinded(digi)\'};
loadDataSetup(3,1)= inputdlg('What is the name of the hard drive?'); %format like CPMC_04-04-2007 date of population
loadDataSetup(4,1) = {'\\researchstg\aaData5\Breast Studies\MGH\DicomImagesBlinded(digi)\'};
loadDataSetup(5,1)= {'\\researchstg\aadata8\Lucyz-Desktop\Breast Studies\MGH\DicomImagesBlinded(digi)'};
save('\\researchstg\Working_Directory\Projects-Snap\aaSTUDIES\Breast Studies\BCSC\Analysis Code\Matlab\Versions\SXAVersion6.4_AddImagesToDatabase\MGHloading.mat','loadDataSetup');