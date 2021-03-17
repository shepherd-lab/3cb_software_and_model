function addALLDigiImages3()

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Written by Amir Pasha Mahmoudzadeh on November 1, 2013       %%%%%
%%%%% Function  add new mammograms data to "mammo_CPMC" database %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% load site specific information
global Database ;
Database.Name='mammo_CPMC';
load('\\researchstg\Working_Directory\Projects-Snap\aaSTUDIES\Breast Studies\BCSC\Analysis Code\Matlab\Versions\Development\SXAVersion8.0\Database\ALLdataloadDataSetup.mat');

if verLessThan('images','8.0')
    beep
    disp('SORRY! AddALLDigiImages3 requires Data Toolbox Ver. 8.0 (MATLAB R2012a) or later!');
    return
end



loadDataSetup(11,1)= {uigetdir('','Where are the files located?')};
directory=[cell2mat(loadDataSetup(11,1))]; %#ok<MSNU,NASGU>

% % % loadDataSetup(12,1)= inputdlg('What is the name of the hard drive?');  %format like CPMC_04-04-2007 date of population

% % % UVM_Directory=[cell2mat(loadDataSetup(11,1))];
% % % MGH_Directory=[cell2mat(loadDataSetup(12,1))];
% % % CPMC_Directory=[cell2mat(loadDataSetup(13,1))];


dirname_towrite =  uigetdir('','Where to  write the DICOM files?');
Destination = [dirname_towrite,'\'];

CPMC_Destination=[cell2mat(loadDataSetup(1,1))]; %#ok<*NASGU>
UVM_Destination=[cell2mat(loadDataSetup(2,1))];
UCSF_Destination=[cell2mat(loadDataSetup(3,1))]; %#ok<NBRAK>
NC_Destination=[cell2mat(loadDataSetup(4,1))] ; 
MGH_Destination=[cell2mat(loadDataSetup(5,1))]; 
 
fileDirectory=[directory,'\*.mat'];
files=dir(fileDirectory);
j=1;
i=1;
errorCount=0;
H=clock;


while  1 % H(4)<18 && H(4) > 8
    %% while loop for number of .mat .png pairs
    while i<=length(files)
        H=clock;
        source=[directory,'\',files(i).name];

        load(source);
   
        [pathstr,name,ext] = fileparts(info_dicom_blinded.Filename); %,versn
        newName=[name,'raw'];
        newName1=[name,'raw.png'];
        AcquisitionFilenamePart=['%',newName1,'%'''];
        % % %         SXAID=mxDatabase(Database.Name,['select * from sxastepanalysis where acquisition_id=',num2str(Info.AcquisitionKey),  ' order by commonanalysis_id DESC']);
% % %         alreadyinDB=mxDatabase(Database.Name,['SELECT * FROM acquisition WHERE fn LIKE ''',newName,'']);
        alreadyinDB=mxDatabase(Database.Name,['SELECT fn FROM acquisition WHERE (fn LIKE ''',AcquisitionFilenamePart,')']);
% % %         xx=mxDatabase(Database.Name,['SELECT fn FROM acquisition']);
% % %         fn=cell2mat(xx(1));
% % %         fn1=fn(1:end-7);
% % %         if strcmp(fn1,name)
% % %             alreadyinDB=true;
% % %         else
% % %             alreadyinDB=false;
% % %         end;
        % % %         alreadyinDB=mxDatabase(Database.Name,['SELECT * FROM acquisition WHERE fn(1:end-7)=','name']);
        
        
        
        nalreadyinDB=size(alreadyinDB);
% % % %                 nalreadyinDB=0;
            %alreadyinDB==false
            if ~nalreadyinDB(1,1) > 0

            %% pull "parameters" from dicomheader .mat file and add to "DICOMinfo" table
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
            catch
                parameter{	60	} = num2str(info_dicom_blinded.ExposureControlModeDescription);
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
            %	try       parameter{	87	} = num2str(info_dicom_blinded.IconImageSequence); end
            try       parameter{	88	} = num2str(info_dicom_blinded.ImageComments(1,1:128));
            catch
                parameter{	88	} = num2str(info_dicom_blinded.ImageComments);
            end
            try index=find(parameter{	88	}=='''');
            parameter{	88	}(index)=[];end
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

            [key,error]=funcAddInDatabasePop(Database,'DICOMinfo',parameter);

            %% pull "fields" from dicomheader .mat file and add to "acquisition" table
            try
                room_id=info_dicom_blinded.DeviceSerialNumber;
                Manufacturer=info_dicom_blinded.Manufacturer;
                ManufacturerModelName= info_dicom_blinded.ManufacturerModelName;
                InstitutionAddress=info_dicom_blinded.InstitutionAddress;
                InstitutionName=info_dicom_blinded.InstitutionName;
                Manufacturer=info_dicom_blinded.Manufacturer;
                ManufacturerModelName= info_dicom_blinded.ManufacturerModelName;
            catch
            end;
            
            
% % %             if (strfind(Manufacturer,'LORAD') || strfind(ManufacturerModelName,'Lorad Selenia') || strfind(ManufacturerModelName,'Hologic Selenia'))
                
                if strfind(InstitutionName,'California Pacific Medical Center') |  strfind(InstitutionAddress,'3698 California')
                    
                    field{1}='CPMC';
                    Study_id='CPMC';
                    
                elseif strfind(InstitutionName,'UCSF') |  strfind(InstitutionAddress,'2356 Sutter Street') | strfind(InstitutionAddress,'1600 Divisadero')
                    
                    field{1}='UCSF';
                    Study_id='UCSF';
                    
                elseif strfind(InstitutionName,'FAHC') |  strfind(InstitutionAddress,'790 COLLEGE')  |  strfind(InstitutionAddress,'111 Colchester') |  strfind(InstitutionAddress,'1 S. PROSPECT')
                    
                    field{1}='UVM';
                    Study_id='UVM';
                    
                elseif  strfind(InstitutionName,'Novato Community Hospital') |   strfind(InstitutionAddress,'1240 S. Eliseo')   |  strfind(InstitutionAddress,'180 Rowland')
                    
                    field{1}='MGH';
                    Study_id='MGH';
                    
                elseif strfind(InstitutionName,'Breast Diagnostic Center of Marin') 
                    field{1}='MGH';
                    Study_id='MGH';
                    
                else
                    
                    beep
                    disp('SORRY! Please Update the InstitutionName !');
                    return
                end;
         
            
            if strfind(Manufacturer,'GE') | strfind(ManufacturerModelName,'Senographe Essential') | strfind(ManufacturerModelName,'Senograph DS')
                
                if strfind(InstitutionName,' Eastern Radiologist') |  strfind(InstitutionAddress,'2101 Arlington');
                    field{1}='NC';
                    Study_id='NC';
                else
                    beep
                    disp('SORRY! Please Update the InstitutionName !');
                    return
                    
                end;
            end;
                
            
            %study_id
            field{2}=info_dicom_blinded.AdmissionID; %patient_id / MRN
            field{3}=''; %visit_id
            
            Info.StudyID = field{1};
            acq_date = info_dicom_blinded.StudyDate;
            %acq_date = info_dicom_blinded.AcquisitionDate;  
            len = length(acq_date);
            year = (acq_date(1,1:(len-4)));
            month = (acq_date(1,5:(len-2)));
            Day=(acq_date(1,7:len));
            DateUSA = [month,'-',Day,'-',year];
            
% % %             film_identifier=cell2mat(loadDataSetup(6,1)); %film_identifier
% % %             film_identifier=cell2mat(loadDataSetup(7,1));
% % %             film_identifier=cell2mat(loadDataSetup(8,1));
% % %             film_identifier=cell2mat(loadDataSetup(9,1));
% % %             film_identifier=cell2mat(loadDataSetup(10,1));
            
            if strfind(Study_id,'CPMC')
                film_identifier= [Study_id,'_',DateUSA];
                field{4}=num2str(film_identifier);
            elseif strfind(Study_id,'UCSF')
                film_identifier= [Study_id,'_',DateUSA];
                field{4}=num2str(film_identifier);
            elseif strfind(Study_id,'MGH')
                film_identifier= [Study_id,'_',DateUSA];
                field{4}=num2str(film_identifier);
            elseif strfind(Study_id,'UVM')
                film_identifier= [Study_id,'_',DateUSA];
                field{4}=num2str(film_identifier);
            elseif strfind(Study_id,'NC')
                film_identifier= [Study_id,'_',DateUSA];
                field{4}=num2str(film_identifier);
            else
                beep
                disp('SORRY! Please Check Study_ID !');
                return
                
            end;
                
                
                
% % %             if strcmp(film_identifier(1:4),'CPMC')
% % %             
% % %                   field{4}='CPMC_11-05-2013';
% % %             
% % %             elseif strcmp(film_identifier(1:3),'MGH')
% % %                 
% % %                   field{4}='MGH_11-05-2013';
% % %              
% % %              elseif strcmp(film_identifier(1:4),'UCSF')
% % %                  
% % %                   field{4}='UCSF_11-05-2013';
% % %              
% % %               elseif strcmp(film_identifier(1:11),'UVM_Selenia')
% % %              
% % %                   field{4}='UVM_Selenia_11-05-2013';
% % %             else 
% % %                 beep
% % %                 disp('SORRY! Please choose the correct Film identifier!');
% % %                 return
% % %              
% % %             end;
             
            field{5}=info_dicom_blinded.AcquisitionDate;  %date_acquisition

            if strcmp(room_id,'H1KRHR83116e41') %room_id
                field{6}='0'; %CPMC StationName: selenia          
            elseif strcmp(room_id,'H1KRHR83cdc51f')|| strcmp(room_id,'H1KRHR8416a717')  
                field{6}='1'; % CPMC StationName: cpbmam1 & selenia_01 % RMS1
            elseif strcmp(room_id,'H1KRHR83cdc510') || strcmp(room_id,'H1KRHR83cdc4ae') || strcmp(room_id,'H1KRHR8416a32b') || strcmp(room_id,'H1KRHR83cdc9fd')
                field{6}='2'; % CPMC StationName: cpbmam2 %RM9????
            elseif strcmp(room_id,'H1KRHR8416a28a') || strcmp(room_id,'H1KRHR8416a617')
                field{6}='3';  %CPMC StationName:cpbmam4 %RMS3
            elseif strcmp(room_id,'H1KRHR83e47c06') || strcmp(room_id,'H1KRHR8416a7cc') || strcmp(room_id,'H1KRHR83d85f55')
                field{6}='4'; %CPMC StationName:cpbmam3 %RM4
            elseif strcmp(room_id,'H1KRHR83e4817c') || strcmp(room_id,'H1KRHR83c4e115')|| strcmp(room_id,'H1KRHR842380ff')
                field{6}='5'; %CPMC StationName: cpbmam5  %RM8 ???
            elseif strcmp(room_id,'H1KRHR84169d45') || strcmp(room_id,'H1KRHR83cdc4bb') || strcmp(room_id,'H1KRHR8416a47a')  ||  strcmp(room_id,'H1KRHR8423727b')
                field{6}='6'; % CPMC StationName:cpbmam6 %RM2
            elseif strcmp(room_id,'H1KRHR8416ad3d')
                field{6}='7'; %CPMC StationName:cpbmam7 %RM6    
 
            elseif strcmp(room_id,'H1KRHR83116e41') %room_id  % should be in CPMC file?
                field{6}='0'; %CPMC % StationName: selenia
            elseif strcmp(room_id,'H1KRHR83cdc4e3') || strcmp(room_id,'H1KRHR83cdc56d') || strcmp(room_id,'H1KRHR8416a1d6')||strcmp(room_id,'H1KRHR83d98cdf')||strcmp(room_id,'H1KRHR83e47ac1')
                field{6}='18'; %MGH % StationName: mgsmammo1
            elseif strcmp(room_id,'H1KRHR83cdc52b') || strcmp(room_id,'H1KRHR836b9f0d')
                field{6}='19'; % MGH % StationName: mgsmammo2
            elseif strcmp(room_id,'H1KRHR8416a0f5') || strcmp(room_id,'H1KRHR84f3b436') 
                field{6}='20'; % Novato % StationName: NVselenia_01
            elseif strcmp(room_id,'H1KRHR84e2e826')
                field{6}='42'; % MGH % StationName:mgsmammo3
            
            elseif strcmp(room_id,'H1KRHR83116e41') %StationName: selenia             
                field{6}='0';
            elseif strcmp(room_id,'H1KRHR849b9ea6') %StationName: FAHSELENIA          
                field{6}='27';   %machine_id / room_id
            elseif strcmp(room_id,'H1KRHR84a1f3a8') || strcmp(room_id,'H1KRHR84a187e2') %StationName:UHCSELENIA11        
                field{6}='28';
            elseif strcmp(room_id,'H1KRHR84a1f712')%StationName:UHCSELENIA13        
                field{6}='29';
            elseif strcmp(room_id,'H1KRHR849ba41a') || strcmp(room_id, 'H1KRHR84e2d16c') %StationName:   UHCSELENIA01        
                field{6}='30';
            elseif strcmp(room_id,'H1KRHR84a1d3ae')%StationName:  ACCSELENIA02            
                field{6}='31';
            elseif strcmp(room_id,'H1KRHR84a1f6e8')%StationName:  ACCSELENIA03         
                field{6}='32';
                
            elseif strcmp(room_id,'H1KRHR83116e41') %room_id
                field{6}='0';
            elseif strcmp(room_id,'H1KRHR84236d49') || strcmp(room_id,'H1KRHR844701e1')
                field{6}='36'; %UCSF-ZM1
            elseif strcmp(room_id,'H1KRHR84584a0a')
                field{6}='37'; %UCSF-ZM8
            elseif strcmp(room_id,'H1KRHR849b9b58')
                field{6}='38'; %UCSF-ZM7
            elseif strcmp(room_id,'H1KRHR8416ac98')||strcmp(room_id,'H1KRHR8416a80b')
                field{6}='39';  %UCSF ZM-10
            elseif strcmp(room_id,'H1KRHR84e30148')||strcmp(room_id,'H1KRHR84e2c662') ||strcmp(room_id,'H1KRHR84e2c2d8')
                field{6}='40'; %UCSF_ZM6
            elseif strcmp(room_id,'H1KRHR84e2d052')
                field{6}='41'; %UCSF_ZM5
                
            else
                beep
                disp('SORRY! Please Update the DeviceSerialNumber!');
                return
            end
            
            try
                viewPosition=info_dicom_blinded.ViewPosition;
                laterality=info_dicom_blinded.ImageLaterality;
                view=[laterality viewPosition];
                description=info_dicom_blinded.PerformedProcedureStepID;
            catch
            end
            
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
                
                % emergency views - non standard
            elseif strcmp(description,'MAMEMU')
                viewID=16;
            elseif strcmp(description,'MAMEMB')
                viewID=17;
            elseif strcmp(description,'ZMAMEMU')
                viewID=18;
            elseif strcmp(description,'ZMAMEMB')
                viewID=19;

                % dx views
            elseif strcmp(description,'MADUD')
                viewID=20;
            elseif strcmp(description,'MADUS')
                viewID=21;
            elseif strcmp(description,'MADBD')
                viewID=22;
            elseif strcmp(description,'MAMSBX')
                viewID=23;
            elseif strcmp(description,'MAMNEL')
                viewID=24;
            elseif strcmp(description,'MAMSPE')
                viewID=25;
            elseif strcmp(description,'ZMADUD')
                viewID=26;
            elseif strcmp(description,'ZUSBRAV1')
                viewID=27;
            elseif strcmp(description,'MGTEST')
                viewID=28;
            
               % screening - additional
            elseif ~strcmp(view,'RCC') && (strcmp(description,'MASCD') || strcmp(description,'MASCL1') || strcmp(description,'MAMADD') || strcmp(description,'MAMAD2') || strcmp(description,'ZMAMADD') || strcmp(description,'ZMAMAD2'))
                viewID=29;
            elseif ~strcmp(view,'LCC') && (strcmp(description,'MASCD') || strcmp(description,'MASCL1') || strcmp(description,'MAMADD') || strcmp(description,'MAMAD2') || strcmp(description,'ZMAMADD') || strcmp(description,'ZMAMAD2'))
                viewID=30;
            elseif ~strcmp(view,'RMLO') && (strcmp(description,'MASCD') || strcmp(description,'MASCL1') || strcmp(description,'MAMADD') || strcmp(description,'MAMAD2') || strcmp(description,'ZMAMADD') || strcmp(description,'ZMAMAD2'))
                viewID=31;
            elseif ~strcmp(view, 'LMLO') && (strcmp(description,'MASCD') || strcmp(description,'MASCL1') || strcmp(description,'MAMADD') || strcmp(description,'MAMAD2') || strcmp(description,'ZMAMADD') || strcmp(description,'ZMAMAD2'))
                viewID=32;

                % screening - emergency
            elseif strcmp(view,'RCC') && (strcmp(description,'MAMEMU') || strcmp(description,'MAMEMB') || strcmp(description,'ZMAMEMU') || strcmp(description,'ZMAMEMB') || strcmp(description,'2MAMEMU') || strcmp(description,'2MAMEMB'))
                viewID=33;
            elseif strcmp(view,'LCC') && (strcmp(description,'MAMEMU') || strcmp(description,'MAMEMB') || strcmp(description,'ZMAMEMU') || strcmp(description,'ZMAMEMB') || strcmp(description,'2MAMEMU') || strcmp(description,'2MAMEMB'))
                viewID=34;
            elseif strcmp(view,'RMLO') && (strcmp(description,'MAMEMU') || strcmp(description,'MAMEMB') || strcmp(description,'ZMAMEMU') || strcmp(description,'ZMAMEMB') || strcmp(description,'2MAMEMU') || strcmp(description,'2MAMEMB'))
                viewID=35;
            elseif strcmp(view,'LMLO') && (strcmp(description,'MAMEMU') || strcmp(description,'MAMEMB') || strcmp(description,'ZMAMEMU') || strcmp(description,'ZMAMEMB') || strcmp(description,'2MAMEMU') || strcmp(description,'2MAMEMB'))
                viewID=36;
                
                
                    % ML & LM - nadditional
            elseif strcmp(view, 'RML') && (strcmp(description,'MASCD') || strcmp(description,'MASCL1') || strcmp(description,'MAMADD') || strcmp(description,'MAMAD2') || strcmp(description,'ZMAMADD') || strcmp(description,'ZMAMAD2'))
                viewID=37;
            elseif strcmp(view, 'LML') && (strcmp(description,'MASCD') || strcmp(description,'MASCL1') || strcmp(description,'MAMADD') || strcmp(description,'MAMAD2') || strcmp(description,'ZMAMADD') || strcmp(description,'ZMAMAD2'))
                viewID=38;
            elseif strcmp(view, 'RLM') && (strcmp(description,'MASCD') || strcmp(description,'MASCL1') || strcmp(description,'MAMADD') || strcmp(description,'MAMAD2') || strcmp(description,'ZMAMADD') || strcmp(description,'ZMAMAD2'))
                viewID=39;
            elseif strcmp(view, 'LLM') && (strcmp(description,'MASCD') || strcmp(description,'MASCL1') || strcmp(description,'MAMADD') || strcmp(description,'MAMAD2') || strcmp(description,'ZMAMADD') || strcmp(description,'ZMAMAD2'))
                viewID=40;

                % other
            elseif strcmp(viewPosition,'FLATFIELD')
                viewID=41;
            elseif strcmp(view, 'RSMPTE')
                viewID=42;
            elseif strcmp(view, 'LSMPTE')
                viewID=43;
            elseif strcmp(viewPosition,'PHANTOM')
                viewID=44;
            else
                viewID=1;
            end
                

            field{7}=num2str(viewID);    %view_id
            
            try field {8}=num2str(info_dicom_blinded.Exposure)
            catch
            field{8}=num2str(info_dicom_blinded.ExposureInuAs/1000);
            end;
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
            field{13}='140';  %image resolution = (70*2) for Hologic Selenia
            field{14}=num2str(info_dicom_blinded.BitDepth);  %Digitalization depth
            field{15}=date; %digitalization_date

            [pathstr,name,ext] = fileparts(info_dicom_blinded.Filename);
            newName=[name,'raw'];
            
            folder = [year,'-',month]; % Create a Folder
          
            [s, mess, messid]=mkdir(Destination,folder);
            
            % Sometimes some images are old in hard drive and we need to
            % check before transfer them to new destination (this happened
            % in 01142014)
            
            date_acq_num = datenum(acq_date, 'yyyymmdd');
            date_driveCPMC = datenum('20130631', 'yyyymmdd');
            
            if date_acq_num>date_driveCPMC
            destination1 = [Destination,folder];
            else
            Destination='\\researchstg\aaData8\Lucyz-Desktop\Breast Studies\CPMC\DicomImagesBlinded(digi)\'
            destination1 = [Destination,folder];
            end;
% % %             if strcmp(studyID,'CPMC') && str2double(acq_date) < 20131231
% % %                 destination1 = [Destination,folder];
% % %             elseif strcmp(studyID,'UCSF') && str2double(acq_date) < 20131231
% % %                 destination1 = [Destination,folder];
% % %             elseif strcmp(studyID,'MGH') && str2double(acq_date) < 20131231
% % %                 destination1 = [Destination,folder];
% % %             elseif strcmp(studyID,'UVM') && str2double(acq_date) < 20131231
% % %                 destination1 = [Destination,folder];
% % %             elseif strcmp(studyID,'NC') && str2double(acq_date) < 20131231
% % %                 destination1 = [Destination,folder];
% % %                 
% % %             else
% % %                 beep
% % %                 disp('SORRY! Please choose the correct Location for Files!');
% % %                 return
% % %             end
            
                
           
            
            Filename=[destination1,'\',newName,'.png'];
            field{16}=Filename; %filename
            field{17}=num2str(info_dicom_blinded.BodyPartThickness); %Thickness
            field{18}=num2str(info_dicom_blinded.CompressionForce);  %Force
            FilenameOnDVD=[directory,'\',newName,'.png'];
            s = dir(FilenameOnDVD);
            fid = fopen(FilenameOnDVD);
            if fid>0
                FileSize = s.bytes;
                field{19}=num2str(FileSize); %filesize
                status = fclose(fid);
            else
                field{19} = '';
            end
            field{20}=info_dicom_blinded.AcquisitionTime; %AcquisitionTime
            field{21}=num2str(key); %DICOM_ID
            field{22}=[name,'raw','.png']; %fn
            [key2,error2]=funcAddInDatabasePop(Database,'acquisition',field);
         
            %%  move sourcefiles to directory storing .png images and .mat info
            source1=[directory,'\',name,'.mat'];
            source2=[directory,'\',newName,'.png'];
            %len = length(destination1);
            %destination2 = ['e:\',(destination1(27:len))];
            destination2 = destination1;
            movefile(source1,destination2);
            try
                movefile(source2,destination2);
            catch
                nopair={lasterr,source2,destination2,'CPMC'};
               % save(['I:\aaData4\Breast Studies\CPMC\new images',newName,'.mat'],'nopair');
                save([directory,newName,'.mat'],'nopair');
                
            end
            i=i+1

            %% if filename already exists, move duplicate into "duplicate filenames" folder
        else
            [pathstr,name,ext] = fileparts(info_dicom_blinded.Filename); %versn
            newName=[name,'raw'];
            source1=[directory,'\',name,'.mat'];

            source2=[directory,'\',newName,'.png'];
            
             [s, mess, messid]=mkdir(Destination,'Duplicate');
              Destination3 = [Destination,'Duplicate'];
            
           %%%%destination3='\\researchstg\aaData\Breast Studies\Breast Studies\UVM\Duplicate';
            try
                movefile(source1,Destination3);
                movefile(source2,Destination3);
            catch
            end
            i=i+1  %Dont Remove this one
            disp ('Already in Database!!!');
            end
% % %        j=j+1
% % %        disp ('Saved to Database!!!');
    end
    
end
disp('Analysis is done!!!','Please Check MATLAB');
send_text_message('937-829-4615','T-Mobile','Analysis is done!!!','Please Check MATLAB');
remaining=length(files)-i+1;
automatic_message=['It is now 6pm. Program ended with ',num2str(remaining),' images remaining, please continue tomorrow.']

