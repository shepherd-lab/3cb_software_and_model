function dataLoadingSetup()
loadDataSetup(1,1)= {uigetdir('file.start_path','select the hardrive where images are stored')};
loadDataSetup(2,1) = {'\\ming.radiology.ucsf.edu\aaData\Breast Studies\CPMC\'};
loadDataSetup(3,1)= inputdlg('What is the name of the hard drive?');
save('C:\loading.mat','loadDataSetup');