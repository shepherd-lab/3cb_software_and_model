function mask=funcloadimage(fname,Option)  
     global Result Info flag Image  MachineParams Analysis 

 Info.DICOMfile=0;  %default value for this flag
 Info.Alfilter = true;

%%%%%%%%%% extraction of room name as global variable Info.centerlistactivated %%%%%%%%%%%%%%%
  if Info.Database == false 
     [pathstr,name,ext,versn] = fileparts(fname)
     fmat_name = [pathstr(1:end-9),'mat_files\',name,'.mat']
     load(fmat_name);
     room_name = info_dicom.StationName;
     Info.Position = info_dicom.ViewPosition;
     Info.Laterality = info_dicom.ImageLaterality;
     resolution = info_dicom.PixelSpacing;
     Analysis.Filmresolution = resolution(1)*2;

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
         Info.centerlistactivated = 116;
     else
         Info.centerlistactivated = 116;  %if unknown
     end
     
  else
      RetrieveInDatabase('MACHINEPARAMETERS'); % for temporary
     % dark_counts =MachineParams.dark_counts;
    
  end

maxsignalDXA=2000; 
mask=[];
if ~exist('Option')
    Option='NONE';
end

        if fname(size(fname,2)-3:size(fname,2))=='.mat'     %test image type
            temp=Result;
            load(fname);
            Result.DXA=temp.DXA;
        elseif ((fname(size(fname,2)-3:size(fname,2))=='.bmp')|fname(size(fname,2)-3:size(fname,2))=='.tif'|fname(size(fname,2)-3:size(fname,2))=='.png'|fname(size(fname,2)-3:size(fname,2))=='.gif')     %test image type
%           if  flag.RawImage == true
%               Result.image=double(imread(fname)); 
%           else    
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
                   
                   %{
                   if ~isempty(Info.comments)
                       alpart = Info.comments(end-5:end-4);
                       if strcmp(alpart, 'Al')
                           Info.Alfilter = true;
                       end
                   end
                   %}
                    
                end 
               %if Info.kVp == 39
                   Result.image=double(imread(fname));%-64-70 -62   %%%%%%%%%%%%%%%%%%%%%%%%%%%%
                   
               %else
                %   Result.image=double(imread(fname)-64); %16384- %-80-64-60
               %end
               
              % Result.image = medfilt2(Result.image, [5 5]);        %for temporary
               %Result.image = funcGradientGauss(Result.image,9);
               Result.image = Result.image.*(Result.image>0)+1;
               vv = mean(Result.image(5,:)); 
               Result.image(1:4,:) = vv;
               Result.image(end-3:end,:) = vv;
               hv = mean(Result.image(:,2));
               Result.image(:,1) = hv;
               
              % Result.image2 =  Result.image; % raw image
               %figure;
               %imagesc(Result.image); colormap(gray); hold off;
               if ~isempty(Result.image)
                 %Result.image = medfilt2(Result.image, [3 3]);
                 %Result.image = funcGradientGauss(I,3);
                   if Result.DXASelenia == true
                     %% image flip dependent on room (CPMC or our machine)
                     %% to comment if needed
                              if Info.centerlistactivated ~= 116
                                 if  Info.Database == false 
                                     if (strcmp(Info.Position,'CC') & strcmp(Info.Laterality,'L'))
                                       Result.image=flipdim(Result.image,2); %horizontal flip
                                     elseif strcmp(Info.Position,'CC') & strcmp(Info.Laterality,'R')
                                       Result.image=flipdim(Result.image,1); %vertical flip
                                     end
                                 else  %database
                                     if Info.ViewId==2
                                         a = 1;
                                         %imagemenu('flipV');
                                         Result.image=flipdim(Result.image,1); %vertical flip
                                     elseif Info.ViewId==3
                                         Result.image=flipdim(Result.image,2); %horizontal flip
                                         %imagemenu('flipH');
                                         a = 1;
                                     end
                                 end
                              elseif  Info.centerlistactivated == 116 
                                  %both flips
                                   Result.image=flipdim(Result.image,2);
                                   Result.image=flipdim(Result.image,1);
                              end
                            
                              
                              
                          % figure;imagesc(Result.image);colormap(gray); 
                                                   
                       switch Result.calibration_type
                          case 'Slice'
                              Result.image2= log_convertDXA_bfp55(Result.image,Info.mAs,Info.kVp,Info.Alfilter); % log image
                          case 'Breast ref Air in the image'
                              Result.image2= log_convertDXA_refair(Result.image,Info.mAs,Info.kVp,Info.Alfilter); % log image
                          case 'Breast25'
                              Result.image2= log_convertDXA_p72al2_25(Result.image,Info.mAs,Info.kVp,Info.Alfilter); % log image
                          case 'Breast29'
                              Result.image2= log_convertDXA_cube(Result.image,Info.mAs,Info.kVp,Info.Alfilter); % log image
                          case 'BreastCPMC'
                              Result.image2= log_convertDXA_cpmcDXA(Result.image,Info.mAs,Info.kVp,Info.Alfilter);
                          case 'BreastCPMC after p171'
                              Result.image2= log_convertDXA_cpmcDXA_afterp171(Result.image,Info.mAs,Info.kVp,Info.Alfilter);
                           case 'BreastCPMC DC map'
                              Result.image2= log_convertDXA_cpmcDXA_DCmap(Result.image,Info.mAs,Info.kVp,Info.Alfilter);                                 
                           case 'AutoDXA'
                              Result.image2= log_convertDXA_afterp171_AUTO(Result.image,Info.mAs,Info.kVp,Info.Alfilter);
                           otherwise
                              Message('Wrong DXA Calibration type...');
                       end    
                     
                    % Result.image2= log_convert(Result.image);
                     %Result.image2=Result.image;
                   elseif Result.DXASelenia == false
                    %Result.image2= log_convert(Result.image);
                       if Info.Database == false %& Info.nomatfile == false   
                           [pathstr,name,ext,versn] = fileparts(fname)
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
                           if Info.centerlistactivated ~= 116
                              if (strcmp(Info.Position,'CC') & strcmp(Info.Laterality,'L'))
                                Result.image2=flipdim(Result.image,2); %horizontal flip
                              elseif strcmp(Info.Position,'CC') & strcmp(Info.Laterality,'R')
                                Result.image2=flipdim(Result.image,1); %vertical flip
                              end
                           elseif  Info.centerlistactivated == 116 
                              %both flips 
                              %
                              Result.image2=flipdim(Result.image,2);
                              Result.image2=flipdim(Result.image2,1);
                              %}
                           end
                       else
                          Result.image2= log_convertSXA(Result.image-MachineParams.dark_counts,Info.mAs,Info.kVp);
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
               if Info.centerlistactivated ~= 116
                  if (strcmp(Info.Position,'CC') & strcmp(Info.Laterality,'L'))
                    Result.image2=flipdim(Result.image,2); %horizontal flip
                  elseif strcmp(Info.Position,'CC') & strcmp(Info.Laterality,'R')
                    Result.image2=flipdim(Result.image,1); %vertical flip
                  end
               elseif  Info.centerlistactivated == 116 
                  %both flips 
                  %
                  Result.image2=flipdim(Result.image,2);
                  Result.image2=flipdim(Result.image2,1);
                  %}
               end
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
           %end     %figure;
            %imagesc(Result.image); colormap(gray); 
        elseif (fname(size(fname,2)-3:size(fname,2))=='.dcm')|(strcmp(Option,'DICOM'))     %DICOM
            Info.DICOMfile=1;
            Result.image=dicomread(fname,'dictionary','dicom-dict.txt');            
            Info.DICOMinfo=dicominfo(fname,'dictionary','dicom-dict.txt');
            Result.image=double(Result.image);
        elseif fname(size(fname,2)-3:size(fname,2))=='.hdr'     %test image type  R2 type .hdr is the header and .img is the image
            fid = fopen(fname,'r','b');
            header=fscanf(fid,'%c');
            line='';beginingline=1;indexline=1;
            for i=1:size(header,2)
                if header(i)==10
                    headerline(indexline)={header(beginingline:i-1)};
                    beginingline=i+1;
                    indexline=indexline+1;
                end
            end
            %search width and height
            for index=1:size(headerline,2)
                temp=cell2mat(headerline(index));
                if strcmp(temp(1:5),'Width')
                    Width=str2num(temp(7:size(temp,2)));
                elseif strcmp(temp(1:6),'Height')
                    Height=str2num(temp(8:size(temp,2)));
                end
            end
            fclose(fid);
            fid = fopen([fname(1:size(fname,2)-4),'.img'],'r','l');
            A = double(fread(fid,Width*Height,'uint16'));
            A=reshape(A,Width,Height);
            Result.image=rot90(rot90(rot90(funcUnderSampling(funcUnderSampling(A)))));
            fclose(fid);
        %%%%%%%%%%    PRODIGY BONE DENSITOMETER  %%%%%%%%%%%%%%%% file
        %%%%%%%%%%    extension is ".img"
        elseif fname(size(fname,2)-3:size(fname,2))=='.img'     %test image type
            % bit conversion and image extraction
            fid = fopen(fname,'r','b');
            c1 = fread(fid, 252, 'uint8');          
            t1 = fread(fid, 1, 'uint8');
            t2 = fread(fid, 1, 'uint8');
            t3 = fread(fid, 1, 'uint8');
            t4 = fread(fid, 1, 'uint8');
            % time_t1  
            time_t2 = t1 + t2*256 + t3 * 256 * 256 + t4 *256 * 256 * 256;
            date_str = datestr(time_t2/60/60/24 + 719529);
            tp = fread(fid, 2, 'uint8');
            f1 = fread(fid,1,'uint8');
            f2 = fread(fid,1,'uint8');
            nrows 	= f1 + f2*256;
            f3 = fread(fid,1,'uint8');
            f4 = fread(fid,1,'uint8');
            ncols      =  f3 +f4*256;    
            c2 = fread(fid, 250, 'uint8');
            
            for i = 1:ncols*nrows
                B1 = fread(fid,1,'uint8');
                B2 = fread(fid,1,'int8');
                B(i) = B1 + B2 * 256;
            end    
            C1=reshape(B,[ ncols,nrows]);  
              C=rot90(C1);  
              clear C1;
              mmax = max(max(C));
              mmin = min(min(C));
             
              %  low energy  image      
             if Result.flagLE
                G =  (flipdim(C,1));
                szG = size(G)
                G1 = medfilt2(G, [3 3]);
                Result.LE =  G1;
                clear G;
                Result.date_str = datestr(time_t2/60/60/24 + 719529);
                clear G1;
                Result.filenameLE_str = fname;
                index = max(find(fname == '\'))
                Result.acqid_str = fname(index+1:end-6);
                %finding LE background 
                H = fspecial('disk',5);
                LE1 = imfilter(Result.LE,H,'replicate');
                LEsm = funcGradientGauss(LE1,5);
                histogram=histc(reshape(LEsm,1,nrows*ncols),-2000:0);
                [C,I]=max(histogram(1:round(size(histogram,2)/2)));
                Ibkg = I - 2000;
                Result.LE0 = Ibkg;
                %LE image creation
                Result.LE = Result.LE - Result.LE0;
                Result.image = Result.LE;
                mmin = min(min(Result.image));
                mmax = max(max(Result.image));
                
              % high energy image  
             elseif Result.flagHE
                G =  (flipdim(C,1));  
                G1 = medfilt2(G, [3 3]);
                clear G;
                Result.HE = G1; %funcGradientGauss(G1,3);
                clear G1;
                %finding HE background 
                H = fspecial('disk',5);
                HE1 = imfilter(Result.HE,H,'replicate');
                HEsm = funcGradientGauss(HE1,5);
                histogram=histc(reshape(HEsm,1,nrows*ncols),0:2000);
                [C,I]=max(histogram(1:round(size(histogram,2)/2)));
                Result.HE0 = I;
                %HE and RST image creation
                Result.HE = Result.HE - Result.HE0;
                Result.RST= Result.LE./Result.HE;  
                Result.image = Result.HE;
                mmin = min(min(Result.image));
                mmax = max(max(Result.image));
                Result.filenameHE_str = fname;
             else
                G =  (flipdim(C,1));  
                G1 = medfilt2(G, [3 3]);
                clear G;
                Result.image = G1; 
                clear G1;
             end
             fclose(fid);   
             
        elseif fname(size(fname,2)-3:size(fname,2)-2)=='.A'     %test image type 'A-file'
                fid = fopen(fname,'r','l');
                fseek(fid, 0, 'eof');
                filesize = ftell(fid);
                position=fseek(fid, 0, 'bof');
                while position<filesize
                    fseek(fid,position,'bof');
                    recordname=fread(fid,1,'uint16');
                    recordlength=fread(fid,1,'uint32');
                    record=fread(fid,recordlength-6,'uint8');
                    position=position+recordlength;
                       
                    if (recordname==57)  %line y size
                        linesize=char(record');
                    elseif (recordname==56)  %line x size
                        pointsize=char(record');
                    elseif (recordname==58)  %points per phase
                        phasenumber=(record(2)*256+record(1));
                    elseif (recordname==59)  %number of lines
                        rows=(record(2)*256+record(1));
                    elseif (recordname==222)  %raw data
                        data=double(record);
                    else
                        recordname;
                    end
                end

                Dilatation=4;
                
                %HE-LE extraction
                sizedata=size(data,1)/2;
                data2=reshape(data,2,sizedata);
                data3=data2(1,:)+data2(2,:)*256;
                columns=size(data3,2)/rows/6;
                data4=reshape(data3,columns,rows*6);
                for index=1:rows
                    data5LE(:,index)=data4(:,index*6-4);                    
                    data5HE(:,index)=data4(:,index*6-5);
                end
                data6LE=zeros(size(data5LE).*[Dilatation 1]);
                data6HE=zeros(size(data5HE).*[Dilatation 1]);                
                for index=1:columns-1
                    for index2=1:Dilatation
                        data6LE((index-1)*Dilatation+index2,:)=data5LE(index,:)+(data5LE(index+1,:)-data5LE(index,:))*(index2-1)/(Dilatation-1);
                        data6HE((index-1)*Dilatation+index2,:)=data5HE(index,:)+(data5HE(index+1,:)-data5HE(index,:))*(index2-1)/(Dilatation-1);                        
                    end
                end
                LE=funcclim(rot90(flipdim(data6LE,1)),0,maxsignalDXA);              
                HE=funcclim(rot90(flipdim(data6HE,1)),0,maxsignalDXA);
                
                %detect the value of the background and compute LE0
                histogram=histc(reshape(LE,1,Dilatation*rows*columns),1:2000);
                [C,I]=max(histogram(1:round(size(histogram,2)/2)));
                mask=(LE>(I-5))&(LE<(I+5));
                
                LE0=sum(LE.*mask)/sum(mask)
                %compute HE0
                HE0=sum(HE.*mask)/sum(mask)
                
                %interpolation of LE on HE grid
                LE=funcAddImage(LE,+1/6*diff(LE));
                
                %correction by HE0 and LE0
                Result.DXA=true;
                Result.LE=LE-LE0;
                Result.HE=HE-HE0;
                Result.image=Result.LE;
                %figure;
                %imagesc(Result.image); colormap(gray);
                
                %Result.RST=(LE-237)./(HE-111);
                Result.RST=Result.LE./Result.HE;     
               %  figure;
               % imagesc(Result.RST); colormap(gray);
                fclose(fid);                
        else
         
            % Read the Header of the Lumisys image
            fid = fopen(fname,'r','b');
            lumiscan.dummy      = fread(fid,804,'char');    % Internal Use Only. Do not use
            lumiscan.n_images   = fread(fid,1,'short');     % number of images
            lumiscan.ncols    	= fread(fid,1,'short');     % pixels per line
            lumiscan.nrows      = fread(fid,1,'short');     % lines per image
            lumiscan.bpp        = fread(fid,1,'short');     % Bits per Pixel
            lumiscan.window     = fread(fid,1,'short');     % Window values range example is 4095, range is from 0 to 65535 (those values imply not used )   

            lumiscan.level      = fread(fid,1,'short');     % Level value example 2048. 0,65535 imply not used.
            lumiscan.filename   = fread(fid,15,'char');     % Filename. max bytes is 14
            lumiscan.date       = fread(fid,14,'char');    % Where image came from such as the device.    
            lumiscan.comment    = fread(fid,80,'char');     % Comment
            lumiscan.desc       = fread(fid,31,'char');     % System Description such as the model number
            lumiscan.headerID   = fread(fid,10,'char');     % Header ID Needs to be "LUMISIS" exactly
            lumiscan.version    = fread(fid,8,'char');      % version ID needs to be "Hdr_Ver" exactly
            lumiscan.version    = fread(fid,1,'short');     % Version number 4 signifies version 4.
            lumiscan.byte_order = fread(fid,1,'short');     % Byte order, 0=LSB, 1=MSB, 2=?SB
            lumiscan.dummy2     = fread(fid,1064,'char');   % Internal Use Only. Don't Use.
            % Now read Lumisys Image
            A = fread(fid,lumiscan.nrows*lumiscan.ncols,'unsigned short');
            if (lumiscan.nrows*lumiscan.ncols)~=size(A,1)
                lumiscan.nrows=floor(size(A,1)/lumiscan.ncols);
                A=A(1:lumiscan.nrows*lumiscan.ncols,1);
                'pb in the loading'
            end
            lumiscan.img = reshape(A,[lumiscan.ncols,lumiscan.nrows]);
            lumiscan.img = rot90(lumiscan.img);
            lumiscan.img = rot90(lumiscan.img);
            lumiscan.img = rot90(lumiscan.img);
       
            Result.image=lumiscan.img;
            fclose(fid);
        end

        
        
        

        
