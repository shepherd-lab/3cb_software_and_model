function extract_3Croi()
     global ctrl Image 
     
file_name='\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\AL_SeleniaData\templates\20090122_all_3Conlyfat.txt'
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
            
            size_LE=size(tempimageLE);
            size_Mat=size(tempimageMat);
            flatimageLE=reshape(tempimageLE,1,size_LE(1)*size_LE(2));
            flatimageHE=reshape(tempimageHE,1,size_LE(1)*size_LE(2));
            flatimageMat=reshape(tempimageMat,1,size_Mat(1)*size_Mat(2));
            flatimageThic=reshape(tempimageThic,1,size_Mat(1)*size_Mat(2));
            flatimageThir=reshape(tempimageThir,1,size_Mat(1)*size_Mat(2));
            
            roi3C_LE(i) =  mean(mean(tempimageLE));
            roi3C_HE(i) =  mean(mean(tempimageHE));
            roi3C_Mat(i) =  mean(mean(tempimageMat));
            roi3C_Thic(i) =  mean(mean(tempimageThic));
            roi3C_Thir(i) =  mean(mean(tempimageThir));
            
            STD_LE(i) =  std(flatimageLE);
            STD_HE(i) =  std(flatimageHE);
            STD_Mat(i) =  std(flatimageMat);
            STD_Thic(i) =  std(flatimageThic);
            STD_Thir(i) =  std(flatimageThir);
            
            var_LE(i) =  var(flatimageLE);
            var_HE(i) =  var(flatimageHE);
            var_Mat(i) =  var(flatimageMat);
            var_Thic(i) =  var(flatimageThic);
            var_Thir(i) =  var(flatimageThir);
            
            snr_LE(i) =  STD_LE(i)/roi3C_LE(i)*100;
            snr_HE(i) =  STD_HE(i)/roi3C_HE(i)*100;
            snr_Mat(i) =  STD_Mat(i)/roi3C_Mat(i)*100;
            snr_Thic(i) =  STD_Thic(i)/roi3C_Thic(i)*100;
            snr_Thir(i) =  STD_Thir(i)/roi3C_Thir(i)*100;
          
            
           roi3C= [ roi3C_LE',roi3C_HE', roi3C_Mat',roi3C_Thic',roi3C_Thir',STD_LE',STD_HE',STD_Mat',STD_Thic',STD_Thir',var_LE',var_HE',var_Mat',var_Thic',var_Thir',snr_LE',snr_HE',snr_Mat',snr_Thic',snr_Thir'];
%                      roi3C= [ roi3C_LE',roi3C_HE'];
    end
      file_name='\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\AL_SeleniaData\templates\Results_template_3C_temp.xls'
        xlswrite(file_name,roi3C);
    
      a=1;
      
      
       