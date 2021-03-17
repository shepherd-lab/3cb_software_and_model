function saveMat3C()
global  ROI Image patient_ID  file 

 pname = file.startpath;
 [pathstr,name,ext] = fileparts(file.fname)
 maps = [];
 fname = ['3CBResults_',patient_ID,'.mat'];
 fname_results = [pname,fname];
 maps.water = Image.material;
 maps.lipid = Image.thickness;
 maps.protein = Image.thirdcomponent;


 %%
  save(fname_results,'maps');
 
 a = 1;


