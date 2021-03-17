function save_GE3Cmaps()
          global Image
          n = 1;
          output_dir = 'Y:\Breast Studies\3C_data\RO1_3Cimages\UCSF\3CB_TOMO\3CB_projections\';
          Image.material = funcclim(Image.material,0,6);
          proj_9.water = Image.material;
          Image.material = funcclim(Image.thickness,0,6);
          proj_9.lipid = Image.thickness;
          Image.thirdcomponent = funcclim(Image.thirdcomponent,0,6);
          proj_9.protein = Image.thirdcomponent;
          save([output_dir,'proj_9.mat']);


end

