function  LoadThicknessmap(  )
global  Image Tmask3C
    [fileName, pathName]=uigetfile('\\researchstg\aaStudies\Breast Studies\3CB R01\Source Data\Tissue Homogenization Project\E1111112029L\png_files\*.png', 'Please select thickness map file.');
    thickfile_name = [pathName,fileName];
     Image.Tmask3C = double(imread(thickfile_name))/1000 + 0.2 ;
     Tmask3C = Image.Tmask3C;
     figure;imagesc(Image.Tmask3C);colormap(gray);
    


end

