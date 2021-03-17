function dicom_deidentify()
%This function deidentifies dicom information from a Hologic mammography
%system quite thoroughly.  Any unidentified dicom information is deleted.
[dicomName,dicomPath]=uigetfile('.dcm','Please select dicom files to be deidentified','MultiSelect','on');
if isnumeric(dicomName)
    return
end
dicomUIPath=uigetdir('Please select path for deidentified files');
if isnumeric(dicomUIPath)
    return
end
if ~iscell(dicomName)
    dicomName={dicomName};
end


info7 = dicominfo('T:\aaData8\unblinded 3c for giger\E3CB011S1I11.dcm');
info6 = dicominfo('T:\aaData8\blinded 3c for giger\BLINDED_3CB001_CC.dcm');
cell_array(:,1) = struct2cell(info7);
cell_array(:,2) = struct2cell(info7);
c6 = struct2cell(info6)
c7 = struct2cell(info7)

 find(cell2mat(cell_array(10,:)) == 190)


for i=1:numel(dicomName)
    info_dicom=dicominfo(fullfile(dicomPath,dicomName{i}));
    if info_dicom.KVP==39
        continue
    else
        imageData=dicomread(fullfile(dicomPath,dicomName{i}));
        figure;imagesc(imageData);axis('image');
        dicomName{i}
        FileName = uiputfile('*.dcm', 'Please choose filename of form 3CBxxx_CC');

        for j=1:numel(dicomTagsKeep)
            if isfield(info_dicom,dicomTagsKeep{j})
                info_dicom2.(dicomTagsKeep{j})=info_dicom.(dicomTagsKeep{j});
            end
        end
        dicomwrite(imageData,fullfile(dicomUIPath,['BLINDED_',FileName]),info_dicom2,'CreateMode','copy');
    end
end
            
    
    