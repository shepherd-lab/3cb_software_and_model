function [Result,mask,Info]=funcloadimage(fname,Result,Info,Option);
Info.DICOMfile=0;  %default value for this flag
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
            Result.image2=double(imread(fname));
            sz = size(Result.image2)
            if length( Result.image2) > 2 
                    Result.image(1:sz(1),1:sz(2)) = Result.image2(:, :, 1);
            end
            figure;
            imagesc(Result.image); colormap(gray); 
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

        elseif fname(size(fname,2)-3:size(fname,2))=='.img'     %test image type
            fid = fopen(fname,'r','b');
            c1 = fread(fid, 258, 'uint16');
            f1 = fread(fid,1,'uint8')
            %f2 = fread(fid,1,'uint8')
            nrows 	= f1 %+ f2*256;
            f3 = fread(fid,1,'uint16')
            %f4 = fread(fid,1,'uint8')
            ncols      =  f3 %+f4*256;    
            
            A = fread(fid,nrows* ncols,'uint16'); 
            %Result.image=reshape(A,[ ncols, nrows]);   
            Result.image=reshape(A,[nrows, ncols ]);  
             figure;
            imagesc(Result.image); colormap(gray);
           % 
            %nrows    	= fread(fid,1,'uint8')+fread(fid,1,'uint8')*256;     % pixels per line
            nrows    	= f1 + f2*256;
            
            f3 = fread(fid,1,'uint8')
            f4 = fread(fid,1,'uint8')
            
            ncols      =  f3+f4*256;     % lines per image
            idl      = fread(fid,1,'uint8')+fread(fid,1,'uint8')*256;     % IDL code
            if idl==1
                A = fread(fid,nrows*ncols,'uint8');    
                Result.image=rot90(reshape(A,[ncols,nrows]));                
            else
                A = fread(fid,nrows*2*ncols,'uint8');                    

                A=rot90(reshape(A,[2*ncols,nrows]));                                
                %invert less significant and most significant byte
                for i=1:ncols
                    A1(:,i)=A(:,i*2-1)+A(:,i*2)*256;
                end
                %obtain the 6 images
                B1=zeros(nrows,ncols/3);
                B2=zeros(nrows,ncols/3);
                for i=1:floor(ncols/6)
                    B2(:,2*i)=A1(:,6*i-4);
                    B1(:,2*i)=A1(:,6*i-5);                    
                end
                HE=B1;
                LE=B2;
                LE=conv2(LE,[1 2 1]/2,'same');
                HE=conv2(HE,[1 2 1]/2,'same');
                
               %detect the value of the background and compute LE0
                histogram=histc(reshape(LE,1,nrows*ncols/3),1:2000);
                [C,I]=max(histogram);
                mask=(LE>(I-5))&(LE<(I+5));
                
                LE0=sum(LE.*mask)/sum(mask)
                %compute HE0
                HE0=sum(HE.*mask)/sum(mask)

                %Result.RST=(LE-237)./(HE-111);
                Result.RST=(LE-LE0)./(HE-HE0);                
                
                Result.DXA=true;
                Result.LE=LE-LE0;
                Result.HE=HE-HE0;
%                Result.RST=(LE-k2)./(HE-k1);
                Result.image=LE-LE0;

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
                
                %Result.RST=(LE-237)./(HE-111);
                Result.RST=Result.LE./Result.HE;                
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

        
        
        

        
