function Load_thicknessFLIPROI_AUTO()
global  Image Tmask3C ROI flip_info Info
    [fileName, pathName]=uigetfile('\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\*.mat', 'Please select thickness map file.');
    thickfile_name = [Info.fnameLE(end-4:end),'_Mat.mat'];
    load(thickfile_name);
    Image.Tmask3C = double(thickness_map)/1000% + 0.5 for 3C01019;% - 0.7 for  3C01014;
    % Image.Tmask3C = double(imread(thickfile_name))/1000;
     Tmask3C = Image.Tmask3C;
     %figure;imagesc(Image.Tmask3C);colormap(gray);
end

