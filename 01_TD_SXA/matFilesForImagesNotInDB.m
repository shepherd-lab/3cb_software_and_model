global Database;
Database.Name='mammo_CPMC';
filename=textread('P:\aaSTUDIES\Breast Studies\CPMC\Analysis Code\SAS\RO1 CPMC Data analysis\notInDatabase.txt','%q');
path='D:\DicomImagesBlinded(digi)\';
for i=1:length(filename)
    [pathstr,name,ext,versn] = fileparts(cell2mat(filename(i)));
    filename_mat{i,1}=[path,name(1:length(name)-3),'.mat'];
end
i=4450;
while i<=length(filename_mat)
    load(cell2mat(filename_mat(i)));
    field{1}='CPUCSF';
    field{2}=info_dicom_blinded.AdmissionID;
    field{3}='';
    field{4}='notInDatabase';
    field{5}=info_dicom_blinded.StudyDate;  %date_acquisition
    len=length(info_dicom_blinded.StationName);
    room_id=info_dicom_blinded.StationName(len);
    len1=length(info_dicom_blinded.InstitutionName);
    if len1<2
        room_id1='';
    else
        room_id1=info_dicom_blinded.InstitutionName(len1-1:len1);
    end
    if strcmp(room_id,'1')|| strcmp(room_id1,'S1')
        field{6}='1';   %room_id
    elseif strcmp(room_id,'2')|| strcmp(room_id1,'S2')
        field{6}='2';
    elseif strcmp(room_id,'3')|| strcmp(room_id1,' 4')
        field{6}='4';
    elseif strcmp(room_id,'4')|| strcmp(room_id1,'S3')
        field{6}='3';
    elseif strcmp(room_id,'5')|| strcmp(room_id1,' 8')
        field{6}='5';
    elseif strcmp(room_id,'6')|| strcmp(room_id1,' 2')
        field{6}='6';    
    else
        field{6}='7';
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
    field{15}=date;   
    [pathstr,name,ext,versn] = fileparts(info_dicom_blinded.Filename);
    newName=[name,'raw'];
    Filename=[path,'\',newName,'.png'];
    field{16}=Filename; %filename
    field{17}=num2str(info_dicom_blinded.BodyPartThickness); %Thickness
    field{18}=num2str(info_dicom_blinded.CompressionForce);  %Force
    FilenameOnDVD=[path,newName,'.png'];
    s=dir(FilenameOnDVD);
    fid = fopen(FilenameOnDVD);
    if fid>0
        FileSize=s.bytes;
        field{19}=num2str(FileSize);
        status = fclose(fid);
    else
        filed{19}='';
    end
    [key,error]=funcAddInDatabase(Database,'acquisition',field);
    i=i+1;
end