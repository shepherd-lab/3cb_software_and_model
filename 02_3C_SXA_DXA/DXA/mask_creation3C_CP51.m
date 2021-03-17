function mask_creation3C_ROI()
     global Image Tmask3C Tmaskones
         
   Tmask3C = zeros(size(Image.image));
   Tmaskones= zeros(size(Image.image));
%% input the thicknesses to put in the mask:
%    roi_thickness = [1:0.1:4.9]';
% all:
   roi_thickness = [7.31,6.959,6.661,6.317,4.959,4.661,4.486,4.236,2.486,2.236,6.959,6.661,6.486,6.236,4.661,4.486,4.317,4.159,2.317,2.159,6.486,6.317,6.236,6.099,4.317,4.236,4.159,4.078,2.159,2.078,6.236,6.159,6.099,6.052,4.159,4.099,4.078,4.041,2.078,2.041,4,2];   
   roi_thickness = 0.1* [68.875	73.355	60	64.42	66.67	69.993	60	63.335	60	62.215	64.435	66.67	60	61.14	62.23	63.345	60	45.925	48.87	40	42.965	44.44	46.66	40	42.23	40	41.495	42.96	44.445	40	40.78	41.51	42.23	40	22.985	24.435	20	21.535	22.205	23.405	20	21.175	20	20.83	21.5	22.27	20	20.465	20.83	21.165	20];

   %     roi_thickness =roi_thickness +deltaT;
%      roi_thickness = [4.959,4.486,4.661,4.317,4.317,4.159,4.159,4.078];
% 24inverted:
%   roi_thickness = [4.959,4.661,4.486,4.236,2.486,2.236,4.661,4.486,4.317,4.159,2.317,2.159,4.317,4.236,4.159,4.078,2.159,2.078,4.159,4.099,4.078,4.041,2.078,2.041,4,2];


%% load the template file:
% file_name='\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\AL_SeleniaData\templates\20090122_4cmstep_3C_reduced4.txt'
%file_name='\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\AL_SeleniaData\templates\20090122_all_3Conlyfat.txt'
% % % file_name='\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\AL_SeleniaData\templates\20090122_all_3C.txt'
% % %    coord=load(file_name);   
% % %    
   [FileName,PathName] = uigetfile('\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\*.txt', 'Choose a x,y coord file');
   coord = load([PathName,FileName]);
     
     x_coord(:,1:2) = coord(:,1:2);
     y_coord(:,1:2) = coord(:,3:4);
     
    for i=1:size(coord,1)
        funcBox(x_coord(i,1),y_coord(i,1),x_coord(i,2),y_coord(i,2),'blue'); 
        x_rect = [x_coord(i,1) x_coord(i,2) x_coord(i,2) x_coord(i,1)];
        y_rect = [y_coord(i,1) y_coord(i,1) y_coord(i,2) y_coord(i,2)];
        
        maskones = double(roipoly(Image.image,x_rect,y_rect));
        mask = roipoly(Image.image,x_rect,y_rect)*roi_thickness(i);
        
        Tmask3C = imadd(Tmask3C,mask);
        Tmaskones = xor(Tmaskones,maskones);
        
            end
    
    invertedTmask = ~Tmaskones;
    figure;imagesc(Tmaskones);colormap(gray);title('Tmaskones');
    
%% create a figure with the mask
    png_filename = '\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\CPphantomMask_3C01008.png';
    %imwrite(uint16(Tmask3C),png_filename,'PNG');
    figure;imagesc(Tmask3C);colormap(gray);
    a=1;
     
% Image.thirdcomponent=Image.thirdcomponent.*Tmaskones;
%    figure;imagesc(Image.thirdcomponent);colormap(gray);title('Result');
      
       