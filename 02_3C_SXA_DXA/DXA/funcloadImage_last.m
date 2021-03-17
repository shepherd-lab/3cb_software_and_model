function mask=funcloadImage(fname,Option)  
     global Result Info flag Image  MachineParams Analysis root_dir patient_ID

 Info.DICOMfile=0;  %default value for this flag
 Info.Alfilter = true;
 

%%%%%%%%%% extraction of room name as global variable Info.centerlistactivated %%%%%%%%%%%%%%%
  
Info.type3C = [];
maxsignalDXA=2000; 
mask=[];
if ~exist('Option')
    Option='NONE';
end
%initialization
%selenia DXA file
[pathstr,name,ext] = fileparts(fname) %,versn
root_dir = pathstr;
len = length(name);
if len < 7
    patient_ID = name
else
patient_ID = name(1:7);
end
%fmat_name = [pathstr(1:end-9),'\mat_files\',name,'.mat']
fmat_name = [pathstr(1:end-10),'\mat_files\',name,'.mat'] % change SM for file open presentation/Selenia raw
s=dir (fmat_name);
if ~isempty(s)
    load(fmat_name);
    if exist('info_dicom_blinded', 'var')
        info_dicom=info_dicom_blinded;
    end
else
    fmat_name = [pathstr,'\',name(1:end),'.mat']  %-3
    load(fmat_name);
    info_dicom = info_dicom;  %_blinded
end

if isfield(info_dicom, 'StationName')
    room_name = info_dicom.StationName;
else
    room_name = 'none';
end

Info.Position = info_dicom.ViewPosition;
Info.Laterality = info_dicom.ImageLaterality;
Info.orientation = info_dicom.PatientOrientation;

if ~isfield(info_dicom,'ManufacturerModelName')
     info_dicom.ManufacturerModelName = info_dicom.ManufacturersModelName;  
end

if ~isfield(info_dicom,'ExposureInuAs')
     info_dicom.ExposureInuAs = info_dicom.ExposureinuAs;  
end


if ~isempty(strfind(lower(info_dicom.ManufacturerModelName),lower('Selenia')))
    Info.DigitizerId = 4;
    Analysis.Filmresolution = 0.14;
else
    Info.DigitizerId = 4;
    Analysis.Filmresolution = 0.14;
end
if Info.Database == false
    if strcmp(room_name,'cpbmam1')
        Info.centerlistactivated = 1;
    elseif strcmp(room_name,'cpbmam2')
        Info.centerlistactivated = 2;
    elseif strcmp(room_name,'cpbmam3')
        Info.centerlistactivated = 3;
    elseif strcmp(room_name,'cpbmam4')
        Info.centerlistactivated = 4;
    elseif strcmp(room_name,'cpbmam5')
        Info.centerlistactivated = 5;
    elseif strcmp(room_name,'cpbmam6')
        Info.centerlistactivated = 6;
    elseif strcmp(room_name,'cpbmam7')
        Info.centerlistactivated = 7;
    elseif strcmp(room_name,'UCSF-ZM10')
        Info.centerlistactivated = 39; %116
    else
        Info.centerlistactivated = 39;  %if unknown 116
    end
else
    if Info.DigitizerId < 4
        MachineParams.dark_counts = 0;
    else
        RetrieveInDatabase('MACHINEPARAMETERS'); % for temporary
        % dark_counts =MachineParams.dark_counts;
    end
end
%what the heck is centerlist
if (Info.DigitizerId >= 4 | flag.Selenia_image == true) & flag.RawImage == false
    if Result.DXASelenia == true & Info.Database == false
        Info.kVp = info_dicom.KVP;
        Info.mAs = info_dicom.ExposureInuAs/1000;
        Info.thickness = info_dicom.BodyPartThickness;
        Info.comments = info_dicom.ImageComments;
        
        if Info.kVp < 38
            Info.kVpLE = info_dicom.KVP;
            Info.mAsLE = info_dicom.ExposureInuAs/1000;
        end     
    end
    Result.image=double(imread(fname));%-64-70 -62   %%%%%%%%%%%%%%%%%%%%%%%%%%%
    Result.image = Result.image.*(Result.image>0)+1;
    vv = mean(Result.image(5,:));
    Result.image(1:4,:) = vv;
    Result.image(end-3:end,:) = vv;
    hv = mean(Result.image(:,2));
    Result.image(:,1) = hv;
    if ~isempty(Result.image)
        if Result.DXASelenia == true
            %% image flip dependent on room (CPMC or our machine)
            %% to comment if needed
            %                                   if Info.centerlistactivated ~= 116
            %                                      if  Info.Database == false
            %                                          if (strcmp(Info.Position,'CC') & strcmp(Info.Laterality,'L'))
            %                                            Result.image=flipdim(Result.image,2); %horizontal flip
            %                                          elseif strcmp(Info.Position,'CC') & strcmp(Info.Laterality,'R')
            %                                            Result.image=flipdim(Result.image,1); %vertical flip
            %                                          end
            %                                      else  %database
            %                                          if Info.ViewId==2
            %                                              a = 1;
            %                                              %imagemenu('flipV');
            %                                              Result.image=flipdim(Result.image,1); %vertical flip
            %                                          elseif Info.ViewId==3
            %                                              Result.image=flipdim(Result.image,2); %horizontal flip
            %                                              %imagemenu('flipH');
            %                                              a = 1;
            %                                          end
            %                                      end
            %                                   elseif  Info.centerlistactivated == 116
            %                                       %both flips
            %                                        Result.image=flipdim(Result.image,2);
            %                                        Result.image=flipdim(Result.image,1);
            %                                   end
            
            
            
            if  (~isempty(strfind(Info.orientation,'A\F')))
                if ~isempty(strfind(Info.orientation,'A\FR'))
                    Result.image=flipdim(Result.image,1); %vertical flip %imagemenu('flipV');
                end
            elseif (~isempty(strfind(Info.orientation,'A\L')))
                Result.image=flipdim(Result.image,1); %vertical flip %imagemenu('flipV');
            elseif (~isempty(strfind(Info.orientation,'P\F')))
                if (~isempty(strfind(Info.orientation,'P\FL')))
                    Result.image=flipdim(Result.image,1); %vertical flip %imagemenu('flipV');
                    Result.image=flipdim(Result.image,2); %horizontal flip  %imagemenu('flipH');
                else
                    Result.image=flipdim(Result.image,2); %horizontal flip %imagemenu('flipH');
                     Result.image=flipdim(Result.image,1); % CAHNGE FOR 3c
                end
            elseif (~isempty(strfind(Info.orientation,'P\H')))
                Result.image=flipdim(Result.image,2); %horizontal flip %imagemenu('flipH');
            elseif (~isempty(strfind(Info.orientation,'P\L')))
                Result.image=flipdim(Result.image,2); %horizontal flip %imagemenu('flipH');
                Result.image=flipdim(Result.image,1); %vertical flip  %imagemenu('flipV');
            elseif (~isempty(strfind(Info.orientation,'P\R')))
                Result.image=flipdim(Result.image,2); %horizontal flip %imagemenu('flipH');
            elseif (~isempty(strfind(Info.orientation,'A\H'))) %A\H and A\R are not required any flipping
                ;
            elseif (~isempty(strfind(Info.orientation,'A\R')))
                ;
            elseif (~isempty(strfind(Info.orientation,'film')))
                ;
            end
             
            % figure;imagesc(Result.image);colormap(gray);
            
            switch Result.calibration_type
                case 'Breast ZM10new'
                    Result.image2= log_convertDXA_ZM10new(Result.image,Info.mAs,Info.kVp,Info.Alfilter);
                case 'AutoDXA'
                    Result.image2= log_convertDXA_ZM10_AUTO(Result.image,Info.mAs,Info.kVp,Info.Alfilter);
                case 'Auto3CB'
                    Result.image2= log_convertDXA_ZM10new(Result.image,Info.mAs,Info.kVp,Info.Alfilter);    
                    %log_convertDXA_afterp171_AUTO(Result.image,Info.mAs,Info.kVp,Info.Alfilter);
                otherwise
                    Message('Wrong DXA Calibration type...');
            end
        elseif Result.DXASelenia == false
            %Result.image2= log_convert(Result.image);
            if Info.Database == false %& Info.nomatfile == false
                [pathstr,name,ext] = fileparts(fname)  %,versn
                fmat_name = [pathstr(1:end-9),'mat_files\',name,'.mat'];
                s=dir (fmat_name);
                if isempty(s)
                    Result.image2= log_convert(Result.image-MachineParams.dark_counts);
                else
                    load(fmat_name);
                    
                    %only for 26April
                    %{
                                   Info.kVp = info.KVP;
                                   Info.mAs = info.ExposureInuAs/1000;
                                   Info.View = info.SeriesDescription;
                    %}
                    %for recent files
                    %
                    Info.kVp = info_dicom.KVP;
                    
                    Info.mAs = info_dicom.ExposureInuAs/1000;
                    Info.View = info_dicom.SeriesDescription;
                    %}
                    %Info.thickness = info_dicom.BodyPartThickness;
                    
                    
                    %Result.image2= log_convertSXA(Result.image,Info.mAs,Info.kVp);
                end
            end
            if Info.kVp > 34
                Info.kVp = 34;
            end
            if Info.kVp < 24
                Info.kVp = 24;
            end
            if Info.Database == false
                RetrieveInDatabase('MACHINEPARAMETERS');
                Result.image= log_convertSXA(Result.image-MachineParams.dark_counts,Info.mAs,Info.kVp);
                %figure;imagesc(Result.image);colormap(gray);
               %temporary 
%                Info.orientation = 'none';
                if  (~isempty(strfind(Info.orientation,'A\F')))
                    if isempty(strfind(Info.orientation,'A\FR'))
                        Result.image2=flipdim(Result.image,1); %vertical flip %imagemenu('flipV');
                    end
                elseif (~isempty(strfind(Info.orientation,'A\L')))
                    Result.image2=flipdim(Result.image,1); %vertical flip %imagemenu('flipV');
                elseif (~isempty(strfind(Info.orientation,'P\F')))
                    if (~isempty(strfind(Info.orientation,'P\FL')))
                        Result.image2=flipdim(Result.image,1); %vertical flip %imagemenu('flipV');
                        Result.image2=flipdim(Result.image2,2); %horizontal flip  %imagemenu('flipH');
                    else
                        Result.image2=flipdim(Result.image,2); %horizontal flip %imagemenu('flipH');
                    end
                elseif (~isempty(strfind(Info.orientation,'P\H')))
                    Result.image2=flipdim(Result.image,2); %horizontal flip %imagemenu('flipH');
                elseif (~isempty(strfind(Info.orientation,'P\L')))
                    Result.image2=flipdim(Result.image,2); %horizontal flip %imagemenu('flipH');
                    Result.image2=flipdim(Result.image2,1); %vertical flip  %imagemenu('flipV');
                elseif (~isempty(strfind(Info.orientation,'P\R')))
                    Result.image2=flipdim(Result.image,2); %horizontal flip %imagemenu('flipH');
                elseif (~isempty(strfind(Info.orientation,'A\H'))) %A\H and A\R are not required any flipping
                    Result.image2=Result.image;
                elseif (~isempty(strfind(Info.orientation,'A\R')))
                    Result.image2=Result.image;
                elseif (~isempty(strfind(Info.orientation,'film')))
                    Result.image2=Result.image;
%                  elseif (~isempty(strfind(Info.orientation,'none')))
%                      Result.image2=Result.image;
                end
                
                
                %                                if Info.centerlistactivated ~= 116
                %                                   if (strcmp(Info.Position,'CC') & strcmp(Info.Laterality,'L'))
                %                                     Result.image2=flipdim(Result.image,2); %horizontal flip
                %                                   elseif strcmp(Info.Position,'CC') & strcmp(Info.Laterality,'R')
                %                                     Result.image2=flipdim(Result.image,1); %vertical flip
                %                                   end
                %                                elseif  Info.centerlistactivated == 116
                %                                   %both flips
                %                                   %
                %                                   Result.image2=flipdim(Result.image,2);
                %                                   Result.image2=flipdim(Result.image2,1);
                %                                   %}
                %                                end
            elseif Info.DigitizerId >= 4
                Result.image2= log_convertSXA(Result.image-MachineParams.dark_counts,Info.mAs,Info.kVp);
            elseif Info.DigitizerId < 4
                Result.image2=Result.image;
            end
            
            
            % Result.image2=Result.image;
        end
        
    else
        Result.image2 =  Result.image;
    end
    max_image = max(max(Result.image2));
    min_image = min(min(Result.image2));
    % Image.mAs = Info.mAs;
    % Image.kVp = Info.kVp;
    %Result.image2 =  Result.image; % raw image
    %Result.image2=double(imread(fname));
else  %for raw Selenia images
    Result.image=double(imread(fname));
    if  (~isempty(strfind(Info.orientation,'A\F')))
        if ~isempty(strfind(Info.orientation,'A\FR'))
            Result.image2=flipdim(Result.image,1); %vertical flip %imagemenu('flipV');
        else
              Result.image2=Result.image;
        end
    elseif (~isempty(strfind(Info.orientation,'A\L')))
        Result.image2=flipdim(Result.image,1); %vertical flip %imagemenu('flipV');
    elseif (~isempty(strfind(Info.orientation,'P\F')))
        if (~isempty(strfind(Info.orientation,'P\FL')))
            Result.image2=flipdim(Result.image,1); %vertical flip %imagemenu('flipV');
            Result.image2=flipdim(Result.image2,2); %horizontal flip  %imagemenu('flipH');
        else
% % %             Result.image2=flipdim(Result.image,2); %horizontal flip %imagemenu('flipH');
            Result.image2=flipdim(Result.image,1); %vertical flip %imagemenu('flipV');
            Result.image2=flipdim(Result.image2,2); %horizontal flip  %imagemenu('flipH');
        end
    elseif (~isempty(strfind(Info.orientation,'P\H')))
        Result.image2=flipdim(Result.image,2); %horizontal flip %imagemenu('flipH');
    elseif (~isempty(strfind(Info.orientation,'P\L')))
        Result.image2=flipdim(Result.image,2); %horizontal flip %imagemenu('flipH');
        Result.image2=flipdim(Result.image2,1); %vertical flip  %imagemenu('flipV');
    elseif (~isempty(strfind(Info.orientation,'P\R')))
        Result.image2=flipdim(Result.image,2); %horizontal flip %imagemenu('flipH');
    elseif (~isempty(strfind(Info.orientation,'A\H'))) %A\H and A\R are not required any flipping
        Result.image2=Result.image;; % added 02/21/14
    elseif (~isempty(strfind(Info.orientation,'A\R')))
        Result.image2=Result.image;; % added 02/21/14
    elseif (~isempty(strfind(Info.orientation,'film')))
        Result.image2=Result.image;
    end
    %                    if Info.centerlistactivated ~= 116
    %                       if (strcmp(Info.Position,'CC') & strcmp(Info.Laterality,'L'))
    %                         Result.image2=flipdim(Result.image,2); %horizontal flip
    %                       elseif strcmp(Info.Position,'CC') & strcmp(Info.Laterality,'R')
    %                         Result.image2=flipdim(Result.image,1); %vertical flip
    %                       end
    %                    elseif  Info.centerlistactivated == 116
    %                       %both flips
    %                       %
    %                       Result.image2=flipdim(Result.image,2);
    %                       Result.image2=flipdim(Result.image2,1);
    %                       %}
    %                    end
    
    flag.RawImage = false;
end
sz = size(Result.image2)
%figure;
%imagesc(Result.image2); colormap(gray);
if length( Result.image2) > 2
    Result.image(1:sz(1),1:sz(2)) = Result.image2(:, :, 1);
end
%figure;
%imagesc(Result.image); colormap(gray);

if Result.flagHE
    %                 Result.RST = Image.LE./(Result.image+100); %change to avoid negative values
    Result.RST = Image.LE./(Result.image);
end

    