% Written by Am 
%
% Version:
%   1.0;     12/03/2013 (Original)
%   1.1;     12/17/2013  fixed some minor bugs
% Copyright BBDG.



global Info Phantomless 

try
AcquisitionID=mxDatabase(Database.Name,['select acquisition_id from sxastepanalysis where acquisition_id=',num2str(Info.AcquisitionKey)]);
AcquisitionIDSXA=cell2mat(AcquisitionID(1));
catch 
end


% Extract informaion from Dicom Table

Dicom=mxDatabase(Database.Name,['select  FileSize,	KVP, ExposureInuAs, ExposureTime, DetectorTemperature  from DICOMinfo where DICOM_ID =(select DICOM_id from acquisition where acquisition_id=',num2str(Info.AcquisitionKey),')']);
Info.Phantomless.FileSize=cell2mat(Dicom(1));
Info.Phantomless.kvpDicom=cell2mat(Dicom(2));
Info.Phantomless.mAsDicom=(round(cell2mat(Dicom(3))))/1000;
Info.Phantomless.exposuretime=cell2mat(Dicom(4));
Info.Phantomless.DetectorTemperature=cell2mat(Dicom(5));



%Extract information from acquisition table
Acq=mxDatabase(Database.Name,['select Force, image_size,	Technique_id, thickness, kvp, mAs from acquisition where acquisition_id=',num2str(Info.AcquisitionKey)]);

Info.Phantomless.Force=cell2mat(Acq(1));
Info.Phantomless.image_size=cell2mat(Acq(2));
Info.Phantomless.Technique_id=cell2mat(Acq(3));
Info.Phantomless.thickness=cell2mat(Acq(4));
Info.Phantomless.kvp=cell2mat(Acq(5));
Info.Phantomless.mAs=cell2mat(Acq(6));

if (Info.Phantomless.image_size==0)
    Info.Phantomless.image_size=Info.Phantomless.FileSize;
end
if (Info.Phantomless.thickness==0)
    Info.Phantomless.thicknes=55;
end
if (Info.Phantomless.Force==0)
    Info.Phantomless.Force=50;
end

% use mAs and kVp from Dicom table if mAs or kVp=0
if (Info.Phantomless.mAs==0)||(Info.Phantomless.kvp==0)

    Info.Phantomless.mAs=Info.Phantomless.mAsDicom;
    Info.Phantomless.kVp=Info.Phantomless.kvpDicom;
    
end

% Find breast_area 

SQLstatement1=['select breast_area, commonanalysis_id from commonanalysis where acquisition_id=',num2str(Info.AcquisitionKey),  ' order by commonanalysis_id DESC'];

CommonAnalysis=mxDatabase(Database.Name,SQLstatement1);
CommonAnalysis = CommonAnalysis(1,:);

Info.Phantomless.breast_area=cell2mat(CommonAnalysis(1));
Info.commonanalysis_id=cell2mat(CommonAnalysis(2));
% structure Analysis 

StrucAcquisitionID1=['select CALDWELL, CD_Slope,	FD_TH_15,	FD_TH_25,FD_TH_35,FD_TH_65,	FD_TH_70,FD_TH_75,	FD_TH_85, FT_FD, FT_RMS, FT_SMP,GLCM_Correlation,GLCM_Dissimilarity,GLCM_Mean,GLCM_Variance,HZ_PROJ, Kurtosis, Mean_Gradient, NGTDM_Coarseness,NGTDM_Complexity,	NGTDM_Contrast,	NGTDM_Strength,	Skewness, STD, FT_FMP, FD_TH_20, StructuralAnalysis_id from StructuralAnalysis where acquisition_id=',num2str(Info.AcquisitionKey), ' order by StructuralAnalysis_id DESC'];

StrucAcquisitionID2=mxDatabase(Database.Name,StrucAcquisitionID1);
StrucAcquisitionID = StrucAcquisitionID2(1,:);
Info.Phantomless.CALDWELL=cell2mat(StrucAcquisitionID(1));
Info.Phantomless.CD_Slope=cell2mat(StrucAcquisitionID(2));
Info.Phantomless.FD_TH_15=cell2mat(StrucAcquisitionID(3));
Info.Phantomless.FD_TH_25=cell2mat(StrucAcquisitionID(4));
Info.Phantomless.FD_TH_35=cell2mat(StrucAcquisitionID(5));
Info.Phantomless.FD_TH_65=cell2mat(StrucAcquisitionID(6));
Info.Phantomless.FD_TH_70=cell2mat(StrucAcquisitionID(7));
Info.Phantomless.FD_TH_75=cell2mat(StrucAcquisitionID(8));
Info.Phantomless.FD_TH_85=cell2mat(StrucAcquisitionID(9));
Info.Phantomless.FT_FD=cell2mat(StrucAcquisitionID(10));
Info.Phantomless.FT_RMS=cell2mat(StrucAcquisitionID(11));
Info.Phantomless.FT_SMP=cell2mat(StrucAcquisitionID(12));
Info.Phantomless.GLCM_Correlation=cell2mat(StrucAcquisitionID(13));
Info.Phantomless.GLCM_Dissimilarity=cell2mat(StrucAcquisitionID(14));
Info.Phantomless.GLCM_Mean=cell2mat(StrucAcquisitionID(15));
Info.Phantomless.GLCM_Variance=cell2mat(StrucAcquisitionID(16));
Info.Phantomless.HZ_PROJ=cell2mat(StrucAcquisitionID(17));
Info.Phantomless.Kurtosis=cell2mat(StrucAcquisitionID(18));
Info.Phantomless.Mean_Gradient=cell2mat(StrucAcquisitionID(19));
Info.Phantomless.NGTDM_Coarseness=cell2mat(StrucAcquisitionID(20));
Info.Phantomless.NGTDM_Complexity=cell2mat(StrucAcquisitionID(21));
Info.Phantomless.NGTDM_Contrast=cell2mat(StrucAcquisitionID(22));
Info.Phantomless.NGTDM_Strength=cell2mat(StrucAcquisitionID(23));
Info.Phantomless.Skewness=cell2mat(StrucAcquisitionID(24));
Info.Phantomless.STD=cell2mat(StrucAcquisitionID(25));
Info.Phantomless.FT_FMP=cell2mat(StrucAcquisitionID(26));
Info.Phantomless.FD_TH_20=cell2mat(StrucAcquisitionID(27));
Info.Phantomless.StructuralAnalysis_id=cell2mat(StrucAcquisitionID(28));
Info.StructuralAnalysis_id=Info.Phantomless.StructuralAnalysis_id;