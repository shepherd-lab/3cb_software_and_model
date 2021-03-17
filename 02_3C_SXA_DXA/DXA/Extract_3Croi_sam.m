function Extract_3Croi_sam(src, event)
     global ctrl Image
     
%file_name='\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\AL_SeleniaData\templates\20090122_all_3Conlyfat.txt'
%file_name='\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\AL_SeleniaData\templates\20100205_37_ROI.txt';
%file_name='\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\3C_data\20100309\20100309_37_26_ROI.txt';
[fileName, pathName]=uigetfile('.txt', 'Please select ROI template file.');
coord=load(fullfile(pathName, fileName), '-ascii');   
     
     x_coord(:,1:2) = coord(:,1:2);
     y_coord(:,1:2) = coord(:,3:4);
     
    for i=1:size(coord,1)
           
            

            funcBox(x_coord(i,1),y_coord(i,1),x_coord(i,2),y_coord(i,2),'blue'); 
%             tempimageLE=Image.LE(p1(2):p1(2)+offset(2),p1(1):p1(1)+offset(1));
%             tempimageHE=Image.LE(p1(2):p1(2)+offset(2),p1(1):p1(1)+offset(1));
            tempimageLE=Image.LE(y_coord(i,1):y_coord(i,2),x_coord(i,1):x_coord(i,2));
            tempimageHE=Image.HE(y_coord(i,1):y_coord(i,2),x_coord(i,1):x_coord(i,2));
%             tempimageMat=Image.material(y_coord(i,1)+1:y_coord(i,2)-1,x_coord(i,1)+1:x_coord(i,2)-1);
%             tempimageThic=Image.thickness(y_coord(i,1)+1:y_coord(i,2)-1,x_coord(i,1)+1:x_coord(i,2)-1);
%             tempimageThir=Image.thirdcomponent(y_coord(i,1)+1:y_coord(i,2)-1,x_coord(i,1)+1:x_coord(i,2)-1);
            
            roi3C_LE(i) =  mean(mean(tempimageLE));
            roi3C_HE(i) =  mean(mean(tempimageHE));
%             roi3C_Mat(i) =  mean(mean(tempimageMat));
%             roi3C_Thic(i) =  mean(mean(tempimageThic));
%             roi3C_Thir(i) =  mean(mean(tempimageThir));
          
            
%            roi3C= [ roi3C_LE',roi3C_HE', roi3C_Mat',roi3C_Thic',roi3C_Thir'];
                     roi3C= [ roi3C_LE',roi3C_HE'];
    end
    [fileName, pathName]=uiputfile('.xls', 'Please select file to save ROI values in');
    %  file_name='\\ming\aaDATA\Breast Studies\3C_data\20100311\20100311_37_25_ROIVAL.xls'
        xlswrite(fullfile(pathName, fileName),roi3C);
    
      a=1;
      
  
     