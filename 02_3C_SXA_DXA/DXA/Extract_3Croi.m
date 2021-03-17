function extract_3Croi()
     global ctrl Image
     
file_name='\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\3C_data\20100216 - A7028613\20100305_37_29_ROI.txt'
coord=load(file_name, '-ascii');   
     
     x_coord(:,1:2) = coord(:,1:2);
     y_coord(:,1:2) = coord(:,3:4);
     
    for i=1:size(coord,1)
           
            

            funcBox(x_coord(i,1),y_coord(i,1),x_coord(i,2),y_coord(i,2),'blue'); 
%             tempimageLE=Image.LE(p1(2):p1(2)+offset(2),p1(1):p1(1)+offset(1));
%             tempimageHE=Image.LE(p1(2):p1(2)+offset(2),p1(1):p1(1)+offset(1));
            tempimageLE=Image.LE(y_coord(i,1):y_coord(i,2),x_coord(i,1):x_coord(i,2));
            tempimageHE=Image.HE(y_coord(i,1):y_coord(i,2),x_coord(i,1):x_coord(i,2));
            tempimageMat=Image.material(y_coord(i,1)+1:y_coord(i,2)-1,x_coord(i,1)+1:x_coord(i,2)-1);
            tempimageThic=Image.thickness(y_coord(i,1)+1:y_coord(i,2)-1,x_coord(i,1)+1:x_coord(i,2)-1);
            tempimageThir=Image.thirdcomponent(y_coord(i,1)+1:y_coord(i,2)-1,x_coord(i,1)+1:x_coord(i,2)-1);
            
            roi3C_LE(i) =  mean(mean(tempimageLE));
            roi3C_HE(i) =  mean(mean(tempimageHE));
            roi3C_Mat(i) =  mean(mean(tempimageMat));
            roi3C_Thic(i) =  mean(mean(tempimageThic));
            roi3C_Thir(i) =  mean(mean(tempimageThir));
          
            
           roi3C= [ roi3C_LE',roi3C_HE', roi3C_Mat',roi3C_Thic',roi3C_Thir'];
%                      roi3C= [ roi3C_LE',roi3C_HE'];
    end
      file_name='\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\AL_SeleniaData\templates\20100205_36_Results_template_3C_temp.xls'
        xlswrite(file_name,roi3C);
    
      a=1;
      
      
       