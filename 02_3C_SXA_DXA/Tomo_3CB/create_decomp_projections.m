function create_decomp_projections()
  dir_lipid = '\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\3CB_TOMO\3CB_projections\Lipid\';
  dir_protein = '\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\3CB_TOMO\3CB_projections\Protein\';
  dir_water = '\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\3CB_TOMO\3CB_projections\Water\';
  dir_proj = '\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\3CB_TOMO\3CB_projections\';
  dir_dicom = '\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\3CB_TOMO\BR3D_60cm\';
 for i=1:9   
  file_proj{i} = [dir_proj,'proj_',num2str(i),'.mat'];
  load(char(file_proj(i)));
  name_struct{i} = ['proj_',num2str(i)];
  dicom_file = [dir_dicom,'IM',num2str(i)]; %,'.dcm'
  info_dicom = dicominfo(dicom_file); 
  name_i = eval(name_struct{i});
  water_raw = uint16(exp(-name_i.water)*10000);
  lipid_raw = uint16(exp(-name_i.lipid)*10000);
  protein_raw = uint16(exp(-name_i.protein)*10000);
%   figure;imagesc(lipid_raw);colormap(gray);
%   figure;imagesc(water_raw);colormap(gray);
%   figure;imagesc(protein_raw);colormap(gray);
% % %   dicomwrite(water_raw,[dir_water,'Water_',num2str(i),'.dcm' ] ,info_dicom,'CreateMode','copy');
% % %   dicomwrite(lipid_raw,[dir_lipid,'Lipid_',num2str(i),'.dcm' ] ,info_dicom,'CreateMode','copy');
  dicomwrite(protein_raw,[dir_protein,'Protein_',num2str(i),'.dcm' ] ,info_dicom,'CreateMode','copy');
end

end

