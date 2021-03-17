global Database;

Database.Name='mammo_DXA'; % this name has to be in Database.choice

% % load('P:\aaSTUDIES\Breast Studies\CPMC\Analysis Code\Matlab\SXAVersion6.4_March12old\loading.mat');
% % directory=cell2mat(loadDataSetup(1,1));
% % destination=[cell2mat(loadDataSetup(2,1))];
% % fileDirectory=[directory,'\*.mat'];
% % files=dir(fileDirectory);

parentdir = uigetdir('L:\Breast Studies\Tlsty_P01_invivo\', 'Select the folder you want to add to the Database'); % displays a dialog box enabling to choose the directory to read the filesfrom.
matdirectory = [parentdir,'\mat_files'];
pngdirectory = [parentdir,'\png_files'];
matfileDirectory=[matdirectory,'\*.mat'];
files=dir(matfileDirectory);

i=1;
errorCount=0;

while i<=length(files)
    try
        source=[matdirectory,'\',files(i).name];
        load(source);
        field{1}='P01DXAinvivo';
%         field{2}=info_dicom_blinded.AdmissionID;
         field{2}=info_dicom.AdmissionID;
        field{3}='';
% %         field{4}=cell2mat(loadDataSetup(3,1));
        field{4}='';
        field{5}=info_dicom.StudyDate;  %date_acquisition
        len=length(info_dicom.StationName);
        room_id=info_dicom.StationName(len);
        len1=length(info_dicom.InstitutionName);
        if len1<2
            room_id1='';
        else
            room_id1=info_dicom.InstitutionName(len1-1:len1);
        end
        if strcmp(room_id,'1')|| strcmp(room_id1,'S1') %room_id
            field{6}='1';
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
        viewPosition=info_dicom.ViewPosition;
        laterality=info_dicom.ImageLaterality;
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
        field{8}=num2str(info_dicom.ExposureInuAs/1000); %mAs
        field{9}=num2str(info_dicom.KVP);    %kvp
        if strcmp(info_dicom.AnodeTargetMaterial,'MOLYBDENUM')&& strcmp(info_dicom.FilterMaterial,'MOLYBDENUM')
            field{10}='1';
        elseif strcmp(info_dicom.AnodeTargetMaterial,'MOLYBDENUM')&& strcmp(info_dicom.FilterMaterial,'RHODIUM')
            field{10}='2';
        else
            field{10}='3';   %Technique_id
        end
        field{11}='9';    %phantom_id
        field{12}='4';    %digitizer = Selenia
        field{13}='140';  %image resolution
        field{14}=num2str(info_dicom.BitDepth);  %Digitalization depth
        field{15}=date;
        [pathstr,name,ext,versn] = fileparts(info_dicom.Filename);
        
% %         newName=[name,'raw']; % ?????
        
        %Filename=[destination,'\',newName,'.png'];
        %Filename=[destination,newName,'.png'];

% %         acq_date = info_dicom.StudyDate;
% %         len = length(acq_date);
% %         year = (acq_date(1,1:(len-4)));
% %         month = (acq_date(1,5:(len-2)));
% %         folder = [year,'-',month];
        
% %         destination1 = [destination,'\',folder];
% %         Filename=[destination1,'\',newName,'.png'];

matFilename = files(i).name;
        len = length(matFilename);
        pngFilename = (matFilename(1,1:(len-4)));

pngname=[pngdirectory,'\',pngFilename,'.png'];
% pngname='\\ming.radiology.edu\aaDATA\Breast Studies\Tlsty_P01_invivo\011208\png_files\DIV028_LE.10.dcmraw.png';
        field{16}=pngname; %filename
        field{17}=num2str(info_dicom.BodyPartThickness); %Thickness
        field{18}=num2str(info_dicom.CompressionForce);  %Force

% %         FilenameOnDVD=[directory,'\',newName,'.png'];
% %         s=dir(FilenameOnDVD);
% %         fid = fopen(FilenameOnDVD);

%         if fid>0
%             FileSize=s.bytes;
%             field{19}=num2str(FileSize);
%             status = fclose(fid);
%         else
            field{19}='';

%         end

        [key,error]=funcAddInDatabase(Database,'acquisition',field);
        
        % %         source1=[directory,'\',name,'.mat'];
        % %         source2=[directory,'\',newName,'.png'];
        % %
        % %         len = length(destination1);
        % %         destination2 = ['e:\',(destination1(27:len))];

        % %         movefile(source1,destination2);
        % %         movefile(source2,destination2); %copyfile to movefile 11/27/07 JW
    catch
        lasterr
        %             movefile(source,'E:\aaDATA\Breast Studies\CPMC\bad header');
        %             [pathstr,name,ext,versn] = fileparts(info_dicom.Filename);
        %             newName=[name,'raw'];
        %             source2=[directory,'\',newName,'.png'];
        %             movefile(source2,'E:\aaDATA\Breast Studies\CPMC\bad header');
        if errorCount==3
%             !C:\Program Files\MATLAB\R2007a\bin\win64\matlab.exe -nosplash -r "cd 'D:\Working_Directory\Projects-Snap\aaSTUDIES\Breast Studies\CPMC\Analysis Code\Matlab\SXAVersion6.4_March12old\'"&
%             exit;
a= 3
        end
        errorCount=errorCount+1;
    end
    i=i+1;
end
