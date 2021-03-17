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
dicomTagsKeep={'AnodeTargetMaterial'
    'BitDepth'
    'BitsAllocated' 
    'BitsStored'
    'CalibrationImage'
    'ColorType'
    'Columns'
    'CompressionForce'
    'DetectorActiveDimensions'
    'DetectorActiveShape'
    'DetectorConditionsNominalFlag'
    'DetectorConfiguration'
    'DetectorTemperature'
    'DetectorType'
    'DistanceSourceToDetector'
    'DistanceSourceToPatient'
    'EntranceDose'
    'EntranceDoseInmGy'
    'EstimatedRadiographicMagnificationFactor'
    'Exposure'
    'ExposureControlMode'
    'ExposureControlModeDescription'
    'ExposureInuAs'
    'ExposureStatus'
    'ExposureTime'
    'FieldOfViewHorizontalFlip'
    'FieldOfViewOrigin'
    'FieldOfViewRotation'
    'FieldOfViewShape'
    'FileSize'
    'FilterMaterial'
    'FilterThicknessMaximum'
    'FilterThicknessMinimum'
    'FocalSpot'
    'Format'
    'FormatVersion'
    'Grid'
    'GridPeriod'
    'HalfValueLayer'
    'Height'
    'HighBit'
    'ImageLaterality'
    'ImageType'
    'ImagerPixelSpacing'
    'ImagesInAcquisition'
    'ImplantPresent'
    'KVP'
    'Laterality'
    'LossyImageCompression'
    'ModalitiesInStudy'
    'Modality'
    'OrganDose'
    'OrganExposed'
    'PartialView'
    'PartialViewDescription'
    'PatientOrientation'
    'PhotometricInterpretation'
    'PixelAspectRatio'
    'PixelIntensityRelationship'
    'PixelIntensityRelationshipSign'
    'PixelRepresentation'
    'PixelSpacing'
    'PositionerPrimaryAngle'
    'PositionerSecondaryAngle'
    'PositionerType'
    'PresentationIntentType'
    'PresentationLUTShape'
    'RelativeXrayExposure'
    'RescaleIntercept'
    'RescaleSlope'
    'RescaleType'
    'Rows'
    'SamplesPerPixel'
    'SOPClassUID'
    'SpecificCharacterSet'
    'ViewPosition'
    'Width'
    'WindowCenter'
    'WindowWidth'
    'XrayTubeCurrent'};
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
            
    
    