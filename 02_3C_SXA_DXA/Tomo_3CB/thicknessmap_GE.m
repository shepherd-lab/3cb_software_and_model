function  calc_thicknessmap()
global X_angle ROI ROI2  MachineParams Analysis Outline thickness_ROI Info thickness_mapproj  thickness_mapreal breast_Maskcorr PreciseOutline Error
global flag BreastMask Image 

Info.type3C ='QUADRATIC';
prompt = {'Enter thickess of flat breast phantom in cm'};
dlg_title = 'Input';
num_lines = 1;
defaultans = {'20'};
thickness = inputdlg(prompt,dlg_title,num_lines,defaultans);
%  thickness = 6;
 Image.CTmask3C = (1-ROI.BackGround)*thickness.*BreastMask;
 figure;imagesc(Image.CTmask3C);colormap(gray);
 
 
 
 
 %    a = 1;
     
     