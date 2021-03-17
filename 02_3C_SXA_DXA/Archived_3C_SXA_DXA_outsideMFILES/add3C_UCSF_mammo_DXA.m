function add3C_UCSFDigiImages(patients)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% written by Jeff Wang on September 30, 2008                   %%%%%
%%%%% function to add new UCSF mammograms to "mammo_CPMC" database %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%patients = [min max];
%% load site specific information
global Database;
loadDataSetup = [];

Database.Name='mammo_DXA';
load('\\researchstg\Working_Directory\Projects-Snap\aaSTUDIES\Breast Studies\BCSC\Analysis Code\Matlab\Versions\Development\3C SXA DXA\UCSF3Cloading.mat');
directory=cell2mat(loadDataSetup(1,1));
%destination=[cell2mat(loadDataSetup(2,1))];
%directory = 'researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\';


% load('D:\Working_Directory\Projects-Snap\aaSTUDIES\Breast Studies\BCSC\Analysis Code\Matlab\SXAVersion6.4_AddImagesToDatabase\UCSFfiles.mat');
i=1;
j=0;
ik=0;
errorCount=0;

pat_min = patients(1);
pat_max = patients(2);

for pn = pat_min:pat_max
pat_dir = ['\3C01',num2str(pn, '%03i')]; 
patientID = ['3C01',num2str(pn, '%03i')]; ;

directorymat = [directory,pat_dir,'\mat_files'];
destination = [directory,pat_dir,'\png_files'];
fileDirectory=[directory,pat_dir,'\mat_files\*.mat'];
files=dir(fileDirectory);
%% while loop for number of .mat .png pairs
while i<=length(files)
    source=[directorymat,'\',files(i).name];
    load(source);
     
% % %     if ~exist('info_dicom_blinded')
% % %         continue;
% % %     end
    [pathstr,name,ext] = fileparts(source);
    newName=name;
    %newName=[name,info_dicom_blinded.AcquisitionDate,info_dicom_blinded.AcquisitionTime,'raw'];
    AcquisitionFilenamePart=['%',newName,'%'''];
% % %     alreadyinDB=mxDatabase(Database.Name,['SELECT acquisition_id FROM acquisition WHERE (filename LIKE ''',AcquisitionFilenamePart,')']);
% % %     alreadyinDB=null(1);
% % %     nalreadyinDB=size(alreadyinDB);
    nalreadyinDB=0; %above 3 lines coded out. acq table has begun to timeout continuously.
    if ~nalreadyinDB(1,1) > 0
      
%% pull "parameters" from dicomheader .mat file and add to "DICOMinfo" table
          if ~isfield(info_dicom,'ManufacturerModelName')
             info_dicom.ManufacturerModelName = info_dicom.ManufacturersModelName;
         end
         
         if ~isfield(info_dicom,'ExposureInuAs')
             info_dicom.ExposureInuAs = info_dicom.ExposureinuAs;
         end
        info_dicom_blinded = info_dicom;
         
              
        try       parameter{	1	} = num2str(info_dicom_blinded.AccessionNumber); end
        %	try       parameter{	2	} = num2str(info_dicom_blinded.AcquisitionContextSequence); end
        try       parameter{	3	} = num2str(info_dicom_blinded.AcquisitionDate); end
        try       parameter{	4	} = num2str(info_dicom_blinded.AcquisitionDeviceProcessingCode); end
        try       parameter{	5	} = num2str(info_dicom_blinded.AcquisitionDeviceProcessingDescription); end
        try       parameter{	6	} = num2str(info_dicom_blinded.AcquisitionNumber); end
        try       parameter{	7	} = num2str(info_dicom_blinded.AcquisitionTime); end
        try       parameter{	8	} = num2str(info_dicom_blinded.AdditionalPatientHistory); end
        try       parameter{	9	} = num2str(info_dicom_blinded.AdmissionID); end
        try       parameter{	10	} = num2str(info_dicom_blinded.AdmittingDate); end
        try       parameter{	11	} = num2str(info_dicom_blinded.AdmittingDiagnosesDescription); end
        try       parameter{	12	} = num2str(info_dicom_blinded.AdmittingTime); end
        %	try       parameter{	13	} = num2str(info_dicom_blinded.AnatomicRegionSequence); end
        try       parameter{	14	} = num2str(info_dicom_blinded.AnodeTargetMaterial); end
        try       parameter{	15	} = num2str(info_dicom_blinded.BitDepth); end
        try       parameter{	16	} = num2str(info_dicom_blinded.BitsAllocated); end
        try       parameter{	17	} = num2str(info_dicom_blinded.BitsStored); end
        try       parameter{	18	} = num2str(info_dicom_blinded.BodyPartExamined); end
        try       parameter{	19	} = num2str(info_dicom_blinded.BodyPartThickness); end
        try       parameter{	20	} = num2str(info_dicom_blinded.BurnedInAnnotation); end
        try       parameter{	21	} = num2str(info_dicom_blinded.CalibrationImage); end
        try       parameter{	22	} = num2str(info_dicom_blinded.CollimatorLeftVerticalEdge); end
        try       parameter{	23	} = num2str(info_dicom_blinded.CollimatorLowerHorizontalEdge); end
        try       parameter{	24	} = num2str(info_dicom_blinded.CollimatorRightVerticalEdge); end
        try       parameter{	25	} = num2str(info_dicom_blinded.CollimatorShape); end
        try       parameter{	26	} = num2str(info_dicom_blinded.CollimatorUpperHorizontalEdge); end
        try       parameter{	27	} = num2str(info_dicom_blinded.ColorType); end
        try       parameter{	28	} = num2str(info_dicom_blinded.Columns); end
        try       parameter{	29	} = num2str(info_dicom_blinded.CommentsOnRadiationDose); end
        try       parameter{	30	} = num2str(info_dicom_blinded.CompressionForce); end
        try       parameter{	31	} = num2str(info_dicom_blinded.ContentDate); end
        try       parameter{	32	} = num2str(info_dicom_blinded.ContentTime); end
        try       parameter{	33	} = num2str(info_dicom_blinded.ConversionType); end
        try       parameter{	34	} = num2str(info_dicom_blinded.CurrentPatientLocation); end
        try       parameter{	35	} = num2str(info_dicom_blinded.DateOfLastCalibration); end
        try       parameter{	36	} = num2str(info_dicom_blinded.DateOfLastDetectorCalibration); end
        try       parameter{	37	} = num2str(info_dicom_blinded.DerivationDescription); end
        %	try       parameter{	38	} = num2str(info_dicom_blinded.DetectorActiveDimensions); end
        try       parameter{	39	} = num2str(info_dicom_blinded.DetectorActiveShape); end
        %	try       parameter{	40	} = num2str(info_dicom_blinded.DetectorBinning); end
        try       parameter{	41	} = num2str(info_dicom_blinded.DetectorConditionsNominalFlag); end
        try       parameter{	42	} = num2str(info_dicom_blinded.DetectorConfiguration); end
        try       parameter{	43	} = num2str(info_dicom_blinded.DetectorDescription); end
        %	try       parameter{	44	} = num2str(info_dicom_blinded.DetectorElementPhysicalSize); end
        %	try       parameter{	45	} = num2str(info_dicom_blinded.DetectorElementSpacing); end
        try       parameter{	46	} = num2str(info_dicom_blinded.DetectorID); end
        try       parameter{	47	} = num2str(info_dicom_blinded.DetectorPrimaryAngle); end
        try       parameter{	48	} = num2str(info_dicom_blinded.DetectorTemperature); end
        try       parameter{	49	} = num2str(info_dicom_blinded.DetectorType); end
        try       parameter{	50	} = num2str(info_dicom_blinded.DeviceSerialNumber); end
        try       parameter{	51	} = num2str(info_dicom_blinded.DistanceSourceToDetector); end
        try       parameter{	52	} = num2str(info_dicom_blinded.DistanceSourceToEntrance); end
        try       parameter{	53	} = num2str(info_dicom_blinded.DistanceSourceToPatient); end
        try       parameter{	54	} = num2str(info_dicom_blinded.EntranceDose); end
        try       parameter{	55	} = num2str(info_dicom_blinded.EntranceDoseInmGy); end
        try       parameter{	56	} = num2str(info_dicom_blinded.EstimatedRadiographicMagnificationFactor); end
        try       parameter{	57	} = num2str(info_dicom_blinded.EthnicGroup); end
        try       parameter{	58	} = num2str(info_dicom_blinded.Exposure); end
        try       parameter{	59	} = num2str(info_dicom_blinded.ExposureControlMode); end
        try       parameter{	60	} = num2str(info_dicom_blinded.ExposureControlModeDescription(1,1:128));
%        catch     parameter{	60	} =
%        num2str(info_dicom_blinded.ExposureControlModeDescription); AM
        end
        try       parameter{	61	} = num2str(info_dicom_blinded.ExposureInuAs); end
        try       parameter{	62	} = num2str(info_dicom_blinded.ExposureStatus); end
        try       parameter{	63	} = num2str(info_dicom_blinded.ExposureTime); end
        %	try       parameter{	64	} = num2str(info_dicom_blinded.parameterOfViewDimensions); end
        try       parameter{	65	} = num2str(info_dicom_blinded.parameterOfViewHorizontalFlip); end
        %	try       parameter{	66	} = num2str(info_dicom_blinded.parameterOfViewOrigin); end
        try       parameter{	67	} = num2str(info_dicom_blinded.parameterOfViewRotation); end
        try       parameter{	68	} = num2str(info_dicom_blinded.parameterOfViewShape); end
        try       parameter{	69	} = num2str(info_dicom_blinded.FileMetaInformationGroupLength); end
        %	try       parameter{	70	} = num2str(info_dicom_blinded.FileMetaInformationVersion); end
        try       parameter{	71	} = num2str(info_dicom_blinded.FileModDate); end
        try       parameter{	72	} = num2str(info_dicom_blinded.Filename); end
        try       parameter{	73	} = num2str(info_dicom_blinded.FileSize); end
        %	try       parameter{	74	} = num2str(info_dicom_blinded.FileStruct); end
        try       parameter{	75	} = num2str(info_dicom_blinded.FilterMaterial); end
        try       parameter{	76	} = num2str(info_dicom_blinded.FilterThicknessMaximum); end
        try       parameter{	77	} = num2str(info_dicom_blinded.FilterThicknessMinimum); end
        try       parameter{	78	} = num2str(info_dicom_blinded.FilterType); end
        try       parameter{	79	} = num2str(info_dicom_blinded.FocalSpot); end
        try       parameter{	80	} = num2str(info_dicom_blinded.Format); end
        try       parameter{	81	} = num2str(info_dicom_blinded.FormatVersion); end
        try       parameter{	82	} = num2str(info_dicom_blinded.Grid); end
        try       parameter{	83	} = num2str(info_dicom_blinded.GridPeriod); end
        try       parameter{	84	} = num2str(info_dicom_blinded.HalfValueLayer); end
        try       parameter{	85	} = num2str(info_dicom_blinded.Height); end
        try       parameter{	86	} = num2str(info_dicom_blinded.HighBit); end
        
% % %          try       parameter{	88	} = num2str(info_dicom_blinded.ImageComments(1,1:128));
% % %             catch     parameter{	88	} = num2str(info_dicom_blinded.ImageComments);
% % %             end
% % %             index=find(parameter{	88	}=='''');
% % %             parameter{	88	}(index)=[];
        
        %	try       parameter{	87	} = num2str(info_dicom_blinded.IconImageSequence); end
% % % %         try       parameter{	88	} = num2str(info_dicom_blinded.ImageComments(1,1:128));end
%        catch     parameter{	88	} =num2str(info_dicom_blinded.ImageComments); end;
  %     index=find(parameter{	88	}==''''); %Am 06042013
   %     parameter{	88	}(index)=[];
        try       parameter{	89	} = num2str(info_dicom_blinded.ImageLaterality); end
        %	try       parameter{	90	} = num2str(info_dicom_blinded.ImagerPixelSpacing); end
        try       parameter{	91	} = num2str(info_dicom_blinded.ImagesInAcquisition); end
        try       parameter{	92	} = num2str(info_dicom_blinded.ImageType); end
        try       parameter{	93	} = num2str(info_dicom_blinded.ImplantPresent); end
        try       parameter{	94	} = num2str(info_dicom_blinded.ImplementationClassUID); end
        try       parameter{	95	} = num2str(info_dicom_blinded.ImplementationVersionName); end
        try       parameter{	96	} = num2str(info_dicom_blinded.InstanceNumber); end
        try       parameter{	97	} = num2str(info_dicom_blinded.InstitutionAddress); end
        try       parameter{	98	} = num2str(info_dicom_blinded.InstitutionName); end
        try       parameter{	99	} = num2str(info_dicom_blinded.KVP); end
        try       parameter{	100	} = num2str(info_dicom_blinded.Laterality); end
        try       parameter{	101	} = num2str(info_dicom_blinded.LossyImageCompression); end
        try       parameter{	102	} = num2str(info_dicom_blinded.Manufacturer); end
        try       parameter{	103	} = num2str(info_dicom_blinded.ManufacturerModelName); end
        try       parameter{	104	} = num2str(info_dicom_blinded.MediaStorageSOPClassUID); end
        try       parameter{	105	} = num2str(info_dicom_blinded.MediaStorageSOPInstanceUID); end
        try       parameter{	106	} = num2str(info_dicom_blinded.MedicalRecordLocator); end
        try       parameter{	107	} = num2str(info_dicom_blinded.ModalitiesInStudy); end
        try       parameter{	108	} = num2str(info_dicom_blinded.Modality); end
        %	try       parameter{	109	} = num2str(info_dicom_blinded.NamesOfIntendedRecipientsOfResults); end
        try       parameter{	110	} = num2str(info_dicom_blinded.OperatorName.FamilyName); end
        try       parameter{	111	} = num2str(info_dicom_blinded.OrganDose); end
        try       parameter{	112	} = num2str(info_dicom_blinded.OrganExposed); end
        try       parameter{	113	} = num2str(info_dicom_blinded.OtherPatientID); end
        %	try       parameter{	114	} = num2str(info_dicom_blinded.OtherPatientName); end
        %	try       parameter{	115	} = num2str(info_dicom_blinded.OtherStudyNumbers); end
        try       parameter{	116	} = num2str(info_dicom_blinded.PartialView); end
        try       parameter{	117	} = num2str(info_dicom_blinded.PartialViewDescription); end
        %	try       parameter{	118	} = num2str(info_dicom_blinded.PatientAge); end
        %	try       parameter{	119	} = num2str(info_dicom_blinded.PatientBirthDate); end
        %	try       parameter{	120	} = num2str(info_dicom_blinded.PatientBirthTime); end
        %	try       parameter{	121	} = num2str(info_dicom_blinded.PatientComments); end
        %	try       parameter{	122	} = num2str(info_dicom_blinded.PatientID); end
        %	try       parameter{	123	} = num2str(info_dicom_blinded.PatientName); end
        try       parameter{	124	} = num2str(info_dicom_blinded.PatientOrientation); end
        %	try       parameter{	125	} = num2str(info_dicom_blinded.PatientSex); end
        %	try       parameter{	126	} = num2str(info_dicom_blinded.PatientTransportArrangements); end
        try       parameter{	127	} = num2str(info_dicom_blinded.PerformedProcedureStepDescription); end
        try       parameter{	128	} = num2str(info_dicom_blinded.PerformedProcedureStepID); end
        try       parameter{	129	} = num2str(info_dicom_blinded.PhotometricInterpretation); end
        %	try       parameter{	130	} = num2str(info_dicom_blinded.PhysicianOfRecord); end
        %	try       parameter{	131	} = num2str(info_dicom_blinded.PhysicianReadingStudy); end
        %	try       parameter{	132	} = num2str(info_dicom_blinded.PixelAspectRatio); end
        try       parameter{	133	} = num2str(info_dicom_blinded.PixelIntensityRelationship); end
        try       parameter{	134	} = num2str(info_dicom_blinded.PixelIntensityRelationshipSign); end
        try       parameter{	135	} = num2str(info_dicom_blinded.PixelRepresentation); end
        try       parameter{	136	} = num2str(info_dicom_blinded.PixelSpacing(1)); end
        try       parameter{	137	} = num2str(info_dicom_blinded.PositionerPrimaryAngle); end
        try       parameter{	138	} = num2str(info_dicom_blinded.PositionerSecondaryAngle); end
        try       parameter{	139	} = num2str(info_dicom_blinded.PositionerType); end
        try       parameter{	140	} = num2str(info_dicom_blinded.PresentationIntentType); end
        try       parameter{	141	} = num2str(info_dicom_blinded.PresentationLUTShape); end
        %	try       parameter{	142	} = num2str(info_dicom_blinded.Private_0019_1006); end
        %	try       parameter{	143	} = num2str(info_dicom_blinded.Private_0019_1007); end
        %	try       parameter{	144	} = num2str(info_dicom_blinded.Private_0019_1008); end
        %	try       parameter{	145	} = num2str(info_dicom_blinded.Private_0019_1026); end
        %	try       parameter{	146	} = num2str(info_dicom_blinded.Private_0019_1027); end
        %	try       parameter{	147	} = num2str(info_dicom_blinded.Private_0019_1028); end
        %	try       parameter{	148	} = num2str(info_dicom_blinded.Private_0019_1029); end
        %	try       parameter{	149	} = num2str(info_dicom_blinded.Private_0019_1030); end
        %	try       parameter{	150	} = num2str(info_dicom_blinded.Private_0019_1031); end
        %	try       parameter{	151	} = num2str(info_dicom_blinded.Private_0019_1032); end
        %	try       parameter{	152	} = num2str(info_dicom_blinded.Private_0019_1033); end
        %	try       parameter{	153	} = num2str(info_dicom_blinded.Private_0019_1034); end
        %	try       parameter{	154	} = num2str(info_dicom_blinded.Private_0019_1035); end
        %	try       parameter{	155	} = num2str(info_dicom_blinded.Private_0019_1041); end
        %	try       parameter{	156	} = num2str(info_dicom_blinded.Private_0019_1050); end
        %	try       parameter{	157	} = num2str(info_dicom_blinded.Private_0019_1051); end
        %	try       parameter{	158	} = num2str(info_dicom_blinded.Private_0019_1052); end
        %	try       parameter{	159	} = num2str(info_dicom_blinded.Private_0019_1053); end
        %	try       parameter{	160	} = num2str(info_dicom_blinded.Private_0019_10xx_Creator); end
        %	try       parameter{	161	} = num2str(info_dicom_blinded.Private_0045_101b); end
        %	try       parameter{	162	} = num2str(info_dicom_blinded.Private_0045_1020); end
        %	try       parameter{	163	} = num2str(info_dicom_blinded.Private_0045_1026); end
        %	try       parameter{	164	} = num2str(info_dicom_blinded.Private_0045_1029); end
        %	try       parameter{	165	} = num2str(info_dicom_blinded.Private_0045_102a); end
        %	try       parameter{	166	} = num2str(info_dicom_blinded.Private_0045_102b); end
        %	try       parameter{	167	} = num2str(info_dicom_blinded.Private_0045_1049); end
        %	try       parameter{	168	} = num2str(info_dicom_blinded.Private_0045_1050); end
        %	try       parameter{	169	} = num2str(info_dicom_blinded.Private_0045_1051); end
        %	try       parameter{	170	} = num2str(info_dicom_blinded.Private_0045_10xx_Creator); end
        try       parameter{	171	} = num2str(info_dicom_blinded.ProtocolName); end
        try       parameter{	172	} = num2str(info_dicom_blinded.QualityControlImage); end
        try       parameter{	173	} = num2str(info_dicom_blinded.ReasonForStudy); end
        %	try       parameter{	174	} = num2str(info_dicom_blinded.ReferencedStudySequence); end
        %	try       parameter{	175	} = num2str(info_dicom_blinded.ReferringPhysicianName); end
        try       parameter{	176	} = num2str(info_dicom_blinded.RelativeXrayExposure); end
        %	try       parameter{	177	} = num2str(info_dicom_blinded.RequestAttributesSequence); end
        try       parameter{	178	} = num2str(info_dicom_blinded.RequestedProcedureDescription); end
        try       parameter{	179	} = num2str(info_dicom_blinded.RequestedProcedurePriority); end
        %	try       parameter{	180	} = num2str(info_dicom_blinded.RequestingPhysician); end
        try       parameter{	181	} = num2str(info_dicom_blinded.RescaleIntercept); end
        try       parameter{	182	} = num2str(info_dicom_blinded.RescaleSlope); end
        try       parameter{	183	} = num2str(info_dicom_blinded.RescaleType); end
        try       parameter{	184	} = num2str(info_dicom_blinded.RouteOfAdmissions); end
        try       parameter{	185	} = num2str(info_dicom_blinded.Rows); end
        try       parameter{	186	} = num2str(info_dicom_blinded.SamplesPerPixel); end
        try       parameter{	187	} = num2str(info_dicom_blinded.ScheduledStudyStartDate); end
        try       parameter{	188	} = num2str(info_dicom_blinded.ScheduledStudyStartTime); end
        try       parameter{	189	} = num2str(info_dicom_blinded.SelectedFrames); end
        try       parameter{	190	} = num2str(info_dicom_blinded.Sensitivity); end
        try       parameter{	191	} = num2str(info_dicom_blinded.SeriesDate); end
        try       parameter{	192	} = num2str(info_dicom_blinded.SeriesDescription); end
        try       parameter{	193	} = num2str(info_dicom_blinded.SeriesInstanceUID); end
        try       parameter{	194	} = num2str(info_dicom_blinded.SeriesNumber); end
        try       parameter{	195	} = num2str(info_dicom_blinded.SeriesTime); end
        try       parameter{	196	} = num2str(info_dicom_blinded.SoftwareVersion); end
        try       parameter{	197	} = num2str(info_dicom_blinded.SOPClassUID); end
        try       parameter{	198	} = num2str(info_dicom_blinded.SOPInstanceUID); end
        try       parameter{	199	} = num2str(info_dicom_blinded.SpecificCharacterSet); end
        try       parameter{	200	} = num2str(info_dicom_blinded.StartOfPixelData); end
        try       parameter{	201	} = num2str(info_dicom_blinded.StationName); end
        try       parameter{	202	} = num2str(info_dicom_blinded.StudyComments); end
        try       parameter{	203	} = num2str(info_dicom_blinded.StudyDate); end
        try       parameter{	204	} = num2str(info_dicom_blinded.StudyDescription); end
        try       parameter{	205	} = num2str(info_dicom_blinded.StudyID); end
        try       parameter{	206	} = num2str(info_dicom_blinded.StudyInstanceUID); end
        try       parameter{	207	} = num2str(info_dicom_blinded.StudyPriorityID); end
        try       parameter{	208	} = num2str(info_dicom_blinded.StudyTime); end
        try       parameter{	209	} = num2str(info_dicom_blinded.TimeOfLastCalibration); end
        try       parameter{	210	} = num2str(info_dicom_blinded.TimeOfLastDetectorCalibration); end
        try       parameter{	211	} = num2str(info_dicom_blinded.TransferSyntaxUID); end
        %	try       parameter{	212	} = num2str(info_dicom_blinded.ViewCodeSequence); end
        try       parameter{	213	} = num2str(info_dicom_blinded.ViewPosition); end
        try       parameter{	214	} = num2str(info_dicom_blinded.Width); end
        try       parameter{	215	} = num2str(info_dicom_blinded.WindowCenter); end
        try       parameter{	216	} = num2str(info_dicom_blinded.WindowWidth); end
        try       parameter{	217	} = num2str(info_dicom_blinded.XrayTubeCurrent); end
        %         SELECT MAX(acquisition_id) AS x FROM  DICOMinfo
        %         parameter{    218 } = alreadyinDB(1,1); %acquisition_id - not shown to work yet
        %         parameter{    219 } = 'UCSF'; %study_id
        %         parameter{    220 } = cell2mat(loadDataSetup(3,1)); %film_identifier
        %         parameter{    221 } = date; %digitalization_date
        %         parameter{    222 } = '4'; %digitalizer_id
        %         FilenameOnDVD=[directory,'\',newName,'.png'];
        %         s=dir(FilenameOnDVD);
        %         fid = fopen(FilenameOnDVD);
        %         if fid>0
        %             FileSize=s.bytes;
        %             parameter{    223 } = num2str(FileSize); %image_size
        %             status = fclose(fid);
        %         else
        %             parameter{    223 } = '';
        %         end
        %         len=length(info_dicom_blinded.StationName);
        %         room_id=info_dicom_blinded.StationName(len);
        %         len1=length(info_dicom_blinded.InstitutionName);
        %         if len1<2
        %             room_id1='';
        %         else
        %             room_id1=info_dicom_blinded.InstitutionName(len1-1:len1);
        %         end
        %         if strcmp(room_id,'1')|| strcmp(room_id1,'S1') %machine_id
        %             parameter{    224 } = '1';
        %         elseif strcmp(room_id,'2')|| strcmp(room_id1,'S2')
        %             parameter{    224 } = '2';
        %         elseif strcmp(room_id,'3')|| strcmp(room_id1,' 4')
        %             parameter{    224 } = '4';
        %         elseif strcmp(room_id,'4')|| strcmp(room_id1,'S3')
        %             parameter{    224 } = '3';
        %         elseif strcmp(room_id,'5')|| strcmp(room_id1,' 8')
        %             parameter{    224 } = '5';
        %         elseif strcmp(room_id,'6')|| strcmp(room_id1,' 2')
        %             parameter{    224 } = '6';
        %         else
        %             parameter{    224 } = '7';
        %         end
        %         acq_date = info_dicom_blinded.StudyDate;
        %         len = length(acq_date);
        %         year = (acq_date(1,1:(len-4)));
        %         month = (acq_date(1,5:(len-2)));
        %         folder = [year,'-',month];
        %         destination1 = [destination,folder];
        %         Filename=[destination1,'\',newName,'.png'];
        %         parameter{    225 } = Filename; %modified_filename
        %         parameter{    226 } = '9'; %phantom_id
        %         parameter{    227 } = '140'; %resolution
        %         if strcmp(info_dicom_blinded.AnodeTargetMaterial,'MOLYBDENUM')&& strcmp(info_dicom_blinded.FilterMaterial,'MOLYBDENUM')
        %             parameter{    228 } = '1';
        %         elseif strcmp(info_dicom_blinded.AnodeTargetMaterial,'MOLYBDENUM')&& strcmp(info_dicom_blinded.FilterMaterial,'RHODIUM')
        %             parameter{    228 } = '2';
        %         else
        %             parameter{    228 } = '3'; %Technique_id
        %         end
        %         viewPosition=info_dicom_blinded.ViewPosition;
        %         laterality=info_dicom_blinded.ImageLaterality;
        %         view=[laterality viewPosition];
        %         if strcmp(view,'RCC')
        %             viewID=2;
        %         elseif strcmp(view,'LCC')
        %             viewID=3;
        %         elseif strcmp(view,'RMLO')
        %             viewID=4;
        %         elseif strcmp(view, 'LMLO')
        %             viewID=5;
        %         elseif strcmp(view,'FLATparameter')
        %             viewID=6;
        %         elseif strcmp(view, 'RSMPTE')
        %             viewID=7;
        %         elseif strcmp(view, 'LSMPTE')
        %             viewID=8;
        %         elseif strcmp(view,'PHANTOM')
        %             viewID=9;
        %         elseif strcmp(view, 'LMLOID')
        %             viewID=10;
        %         elseif strcmp(view, 'RMLOID')
        %             viewID=11;
        %         elseif strcmp(view, 'LCCID')
        %             viewID=12;
        %         elseif strcmp(view, 'RCCID')
        %             viewID=13;
        %         elseif strcmp(view, 'CC')
        %             viewID=14;
        %         elseif strcmp(view, 'RLM')
        %             viewID=15;
        %         else
        %             viewID=1;
        %         end
        %         parameter{    228 } = num2str(viewID); %view_id
             %key = [];
         [key,error]=funcAddInDatabasePop(Database,'DICOMinfo',parameter);    

% %         
%% pull "fields" from dicomheader .mat file and add to "acquisition" table
        field{1}='3CUCSF'; %study_id
        field{2}=patientID;         %AdmissionID; %patient_id / MRN
        field{3}=''; %visit_id
        %loaddate=datestr(now,'mm-dd-yyyy');
        %field{4}=['UCSF_',loaddate]; %film_identifier
        field{4}=[cell2mat(loadDataSetup(2,1))];
        field{5}=info_dicom_blinded.AcquisitionDate;  %date_acquisition
%         len=length(info_dicom_blinded.StationName);
%         room_id=info_dicom_blinded.StationName;
%         if strcmp(room_id,'UCSF-ZM1') %room_id
%             field{6}='36';
%         elseif strcmp(room_id,'UCSF-ZM6')
%             field{6}='37';
%         elseif strcmp(room_id,'UCSF-ZM7')
%             field{6}='38';
%         elseif strcmp(room_id,'UCSF-ZM10')
%             field{6}='39';
%         elseif strcmp(room_id,'UCSF-ZM8')
%             field{6}='40';
%         elseif strcmp(room_id,'UCSF-ZM5') || strcmp(room_id,'UCSF_ZM5') 
%             field{6}='41';
%         else
%             field{6}='1';
%         end
        room_id=info_dicom_blinded.DeviceSerialNumber;
        if strcmp(room_id,'H1KRHR83116e41') %room_id
            field{6}='0';
        elseif strcmp(room_id,'H1KRHR84236d49') || strcmp(room_id,'H1KRHR844701e1')
            field{6}='36'; %UCSF-ZM1
        elseif strcmp(room_id,'H1KRHR84584a0a')
            field{6}='37'; %UCSF-ZM8
        elseif strcmp(room_id,'H1KRHR849b9b58')
            field{6}='38'; %UCSF-ZM7
        elseif strcmp(room_id,'H1KRHR8416ac98')||strcmp(room_id,'H1KRHR8416a80b')
            field{6}='39';  %UCSF ZM-10
        elseif strcmp(room_id,'H1KRHR84e30148')||strcmp(room_id,'H1KRHR84e2c662')
            field{6}='40'; %UCSF_ZM6
        elseif strcmp(room_id,'H1KRHR84e2d052')
            field{6}='41'; %UCSF_ZM5
        else
            field{6}='9999';
        end
        viewPosition=info_dicom_blinded.ViewPosition;
        laterality=info_dicom_blinded.ImageLaterality;
        view=[laterality viewPosition];
        if strcmp(view,'RCC')
            viewID=2;
        elseif strcmp(view,'LCC')
            viewID=3;
        elseif strcmp(view,'RMLO')
            viewID=4;
        elseif strcmp(view, 'LMLO')
            viewID=5;
        elseif strcmp(view,'FLATFIELD')
            viewID=6;
        elseif strcmp(view, 'RSMPTE')
            viewID=7;
        elseif strcmp(view, 'LSMPTE')
            viewID=8;
        elseif strcmp(view,'PHANTOM')
            viewID=9;
        elseif strcmp(view, 'LMLOID')
            viewID=10;
        elseif strcmp(view, 'RMLOID')
            viewID=11;
        elseif strcmp(view, 'LCCID')
            viewID=12;
        elseif strcmp(view, 'RCCID')
            viewID=13;
        elseif strcmp(view, 'CC')
            viewID=14;
        elseif strcmp(view, 'RLM')
            viewID=15;
        else
            viewID=1;
        end
        field{7}=num2str(viewID);    %view_id
        
      

        
        field{8}=num2str(info_dicom_blinded.ExposureInuAs/1000); %mAs
        
        field{9}=num2str(info_dicom_blinded.KVP);    %kvp
        if strcmp(info_dicom_blinded.AnodeTargetMaterial,'MOLYBDENUM')&& strcmp(info_dicom_blinded.FilterMaterial,'MOLYBDENUM')
            field{10}='1';
        elseif strcmp(info_dicom_blinded.AnodeTargetMaterial,'MOLYBDENUM')&& strcmp(info_dicom_blinded.FilterMaterial,'RHODIUM')
            field{10}='2';
        else
            field{10}='3';   %Technique_id
        end
        field{11}='9';    %phantom_id
        field{12}='4';    %digitizer = Selenia
        field{13}='140';  %image resolution
        field{14}=num2str(info_dicom_blinded.BitDepth);  %Digitalization depth
        field{15}=date; %digitalization_date
        %[pathstr,name,ext] = fileparts(info_dicom_blinded.Filename);
% %         name = files(i).name;
        acq_date = info_dicom_blinded.StudyDate;
% %         len = length(acq_date);
% %         year = (acq_date(1,1:(len-4)));
% %         month = (acq_date(1,5:(len-2)));
% %         folder = [year,'-',month];
% %         destination1 = [destination,folder];
        %Filename=[destination1,'\',newName,'.png'];
        Filename=[destination,'\',name,'.png'];
        field{16}=Filename; %filename
        field{17}=num2str(info_dicom_blinded.BodyPartThickness); %Thickness
        field{18}=num2str(info_dicom_blinded.CompressionForce);  %Force
        %FilenameOnDVD=[directory,'\',newName,'.png'];
        %FilenameOnDVD=[directory,'\',name,info_dicom_blinded.AcquisitionDate,info_dicom_blinded.AcquisitionTime,'.png'];
        s=dir(Filename);
        fid = fopen(Filename);
        if fid>0
            FileSize=s.bytes;
            field{19}=num2str(FileSize); %filesize
            status = fclose(fid);
        else
            field{19}='';
        end
        [pathstr,name,ext] = fileparts(Filename);
        DC_filename =  [pathstr,'\DCraw.png']; 
        im_dc = imread(DC_filename);
        im_size = size(im_dc);
        Ymin = round(im_size(2)/2 - 250);
        Ymax = round(im_size(2)/2 + 250);
        Xmin = 100;
        Xmax = 600;
        DCLE = round(mean(mean(im_dc(Ymin:Ymax,Xmin:Xmax))));
        DCHE = round(mean(mean(im_dc(Ymin:Ymax,Xmin:Xmax))));
               
        FF_filenameHE = [pathstr,'\FFHEraw.png']; 
        FF_filenameLE = [pathstr,'\FFLE',num2str(info_dicom_blinded.KVP),'raw.png'];  
        Calibration_filename = [pathstr,'\Calibration_',patientID,'_',view(2:3),num2str(info_dicom_blinded.KVP),'kVp']; 
        field{20}= FF_filenameHE;
        field{21}= num2str(DCLE);
        field{22}= num2str(DCHE);
        field{23}= Calibration_filename;
        field{24}= num2str(key); %DICOM_ID
        field{25}=info_dicom_blinded.AcquisitionTime; %AcquisitionTime
        if (~isempty(strfind(name,'LECC')) | ~isempty(strfind(name,'LEML')) | ~isempty(strfind(name,'GEN3')) | ~isempty(strfind(name,'CPLE')) | ~isempty(strfind(name,'FFLE')))
            field{26}= FF_filenameLE;
        else
        field{26}= [];
        end
        
        %field{22}=[name,'raw','.png']; %fn
        field{27}=[name,'.png'];
        [key2,error2]=funcAddInDatabasePop(Database,'acquisition',field);
% %         
%% move sourcefiles to directory storing .png images and .mat info
% % %         %source1=[directory,'\',name,'.mat'];
% % %         %source2=[directory,'\',newName,'.png'];
% % %         source1=[directory,'\',name,info_dicom_blinded.AcquisitionDate,info_dicom_blinded.AcquisitionTime,'.mat'];
% % %         source2=[directory,'\',name,info_dicom_blinded.AcquisitionDate,info_dicom_blinded.AcquisitionTime,'raw.png'];
% % %         %len = length(destination1);
% % %         %destination2 = ['I:\',(destination1(27:len))];
% % %         destination2 = destination1;
% % %         movefile(source1,destination2);
% % %         try
% % %             movefile(source2,destination2); 
% % %         catch
% % %             nopair={lasterr,source2,destination2,'UCSF'};
% % %             save(['Y:\Breast Studies\UCSFMedCtr\problem images\MATwithoutPNG',newName,'.mat'],'nopair');
% % %         end
        i=i+1
        
%% if filename already exists, move duplicate into "duplicate filenames" folder
    else
% % %         [pathstr,name,ext] = fileparts(info_dicom_blinded.Filename);
% % %         %newName=[name,'raw'];
% % %         %source1=[directory,'\',name,'.mat'];
% % %         %source2=[directory,'\',newName,'.png'];
% % %         source1=[directory,'\',name,info_dicom_blinded.AcquisitionDate,info_dicom_blinded.AcquisitionTime,'.mat'];
% % %         source2=[directory,'\',name,info_dicom_blinded.AcquisitionDate,info_dicom_blinded.AcquisitionTime,'raw.png'];
% % %         try
% % %             movefile(source1,'Y:\Breast Studies\UCSFMedCtr\duplicate filenames');
% % %             movefile(source2,'Y:\Breast Studies\UCSFMedCtr\duplicate filenames');
% % %         catch
% % %         end
        ik=ik+1
    end
end
 j = j + 1
end