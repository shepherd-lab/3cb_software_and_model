%thumbnail
%Is called by retrieveInDatabase for when multiple acquisition are selected
%and the operator choose 'thumbnail'.
% can be manual launch to generate the thumbnails by this
% 'thumbnail(0,'GENERATE>',5914)' to create the thumbnail for scan Ids > 5914

function thumbnail(List,option,argument)
global Database dummyuicontrol2 Info file Image

if ~exist('option')
    option='NULL';
end

if strcmp(option,'GENERATE>')
    List=cell2mat(mxDatabase(Database.Name,['select acquisition_id from acquisition where acquisition_id>',num2str(argument)]));
end

BorderX=0.01;BorderY=0.015;
MAXX=12;
MAXY=7;
ScreenX=0.97;
ScreenY=1;

SizeImageX=(ScreenX-((MAXX+1)*BorderX))/MAXX;
SizeImageY=(ScreenY-((MAXY+1)*BorderY))/MAXY;

Thumbnail.figure=figure('units','normalized','position',[0.0 0.05 1 0.9],'color',[0.1 0.1 0.4],'MenuBar','None');
for index=1:MAXX*MAXY
    Xi=mod(index-1,MAXX);X1=(BorderX+SizeImageX)*Xi+BorderX;
    Yi=MAXY-floor((index-1)/MAXX)-1;Y1=(BorderY+SizeImageY)*Yi+BorderY;
    Thumbnail.axis(index)=axes('units','normalized','position',[X1 Y1 SizeImageX SizeImageY],'xtick',[],'ytick',[]);
    Thumbnail.Title(index)=uicontrol('style','text','string','toto','units','normalized','position',[X1 Y1-BorderY SizeImageX BorderY],'foregroundcolor',[1 1 1],'backgroundcolor',[0.1 0.1 0.4]);
end
Thumbnail.After=uicontrol('style','pushbutton','units','normalized','string','+','position',[ScreenX,0.05,1-ScreenX,0.1],'enable','off','callback','NextPatient(1)');
Thumbnail.Before=uicontrol('style','pushbutton','units','normalized','string','-','position',[ScreenX,0.16,1-ScreenX,0.1],'enable','off','callback','NextPatient(2)');
uicontrol('style','pushbutton','units','normalized','string','EXIT','position',[ScreenX,0.27,1-ScreenX,0.05],'callback','global Info;Info.SaveStatus=3;NextPatient(3)');

Offset=0;

ContinuOk=true;
Image={};
set(dummyuicontrol2,'value',false);
while ContinuOk
    for index=1:MAXX*MAXY
        axes(Thumbnail.axis(index));
        imagesc(0);colormap(gray);set(Thumbnail.axis(index),'xtick',[],'ytick',[]);
        set(Thumbnail.Title(index),'string','');
    end
    index=1;
    while ((index+Offset)<=size(List,1)&&(index<=MAXX*MAXY));
        if get(dummyuicontrol2,'value')
            set(dummyuicontrol2,'value',false);
            if Info.SaveStatus==3 %exit is pressed during the thumbnailing
                delete(Thumbnail.figure);
                return
            end
        end

              
        b=mxDatabase(Database.Name,['select * from acquisition where acquisition_id=',num2str(List(index+Offset,:))]);     %num2str(Info.AcquisitionKey)]);
        dicom_id = b{1,22};
        bb=mxDatabase(Database.Name,['select StudyDate from dicominfo where dicom_id=',num2str(dicom_id)]);   
        
        if isempty(b) 
            index=index+1;
             continue;
        end
        fname=strcat(cell2mat(b(17)),'');   %erase extra ' '
        %Info.fname = fname;
        %fname(1:2) = [];
        index_slash = find(fname=='\');
        fname = fname(index_slash(end): end);
        str = computer;
        
        %digitizer
        SQLstatement=['select digitizer.digitizer_id,Digitizer_description from acquisition,digitizer where acquisition_id=',num2str(List(index+Offset,:)),' and digitizer.digitizer_id=acquisition.digitalizer_id'];
        
        a=mxDatabase(Database.Name,SQLstatement);
        if isempty(a)  
            index=index+1;
             continue;
        end
        Info.DigitizerId=cell2mat(a(1));
        Info.DigitizerDescription=cell2mat(a(2));
        if ~isempty(cell2mat(b(5)))
            film_identifier = lower(b(5));
            film_identifier = film_identifier{1};
            try
                if film_identifier=='                    '
                    film_identifier = lower(b(2));
                    film_identifier = film_identifier{1};
                end
            end
        else
            film_identifier = 'none';
        end
        Analysis.film_identifier = film_identifier;
        if Info.DigitizerId >= 4 %digital 
            dvd_str = findstr('dvd',film_identifier);
            %date_acq = b{1,6};
            if ~isempty(bb)
                date_acq = bb{1};
            else
                date_acq = b{6};
            end
            if strcmp(film_identifier(1:3),'mgh')
                if strcmp(deblank(film_identifier(5:end)), 'notindatabase')
                    filmdate=datenum(str2num(date_acq(1:4)), str2num(date_acq(5:6)), str2num(date_acq(7:8)));
                else
                    filmdate=datenum(str2num(date_acq(1:4)), str2num(date_acq(5:6)), str2num(date_acq(7:8)));
                end
            end
            folder = [date_acq(1:4),'-',date_acq(5:6)];
            if (strcmp(film_identifier(1),'0')| strcmp(film_identifier(1),'n')| strcmp(film_identifier(1:3),'cpm') | strcmp(film_identifier(1:6),'cpucsf') | strcmp(film_identifier(1:3),'har') | ~isempty(dvd_str) | strcmp(film_identifier(1:3),'not')) %for CPMC
                if strcmp(str,'PCWIN64')
                    %start_dir = 'D:\aaDATA\Breast Studies\CPMC';
                    start_dir = 'E:\aaDATA\Breast Studies\CPMC\DicomImagesBlinded(digi)\';
                    startdir_report = 'E:\aaDATA\Breast Studies\CPMC';
                else
                    start_dir = '\\ming.radiology.ucsf.edu\aaDATA2\Breast Studies\CPMC\DicomImagesBlinded(digi)';
                    startdir_report = '\\ming.radiology.ucsf.edu\aaDATA2\Breast Studies\CPMC';
                end
            elseif strcmp(film_identifier(1:3),'mgh') % for MGH
                if strcmp(str,'PCWIN64')
                    if date_acq < datenum('10/01/2009')
                        start_dir = 'L:\aaDATA6\Breast Studies\MGH\DicomImagesBlinded(digi)';
                        startdir_report = 'L:\aaDATA6\Breast Studies\MGH';
                    else
                        start_dir = 'K:\aaDATA5\Breast Studies\MGH\DicomImagesBlinded(digi)';
                        startdir_report = 'K:\aaDATA5\Breast Studies\MGH';
                    end
                else
                    if filmdate < datenum('10/01/2009')
                        start_dir = '\\ming.radiology.ucsf.edu\aaDATA6\Breast Studies\MGH\DicomImagesBlinded(digi)';
                        startdir_report = '\\ming.radiology.ucsf.edu\aaDATA6\Breast Studies\MGH';
                    else
                        start_dir = '\\ming.radiology.ucsf.edu\aaDATA5\Breast Studies\MGH\DicomImagesBlinded(digi)';
                        startdir_report = '\\ming.radiology.ucsf.edu\aaDATA5\Breast Studies\MGH';
                    end
                end
          %  elseif strcmp(film_identifier(1:3),'mgh') % for MGH
          %      if strcmp(str,'PCWIN64')
          %          start_dir = 'K:\aaDATA5\Breast Studies\MGH\DicomImagesBlinded(digi)';
          %          startdir_report = 'K:\aaDATA5\Breast Studies\MGH';
          %      else
          %          start_dir = '\\ming.radiology.ucsf.edu\aaDATA5\Breast Studies\MGH\DicomImagesBlinded(digi)';
          %          startdir_report = '\\ming.radiology.ucsf.edu\aaDATA5\Breast Studies\MGH';
          %      end
            elseif strcmp(film_identifier(1:3),'uvm')  %for UVM
                if strcmp(str,'PCWIN64')
                    start_dir = 'D:\aaDATA3\Breast Studies\UVM\DicomImagesBlinded(digi)';
                    startdir_report = 'D:\aaDATA3\Breast Studies\UVM';
                else
                    start_dir = '\\researchstg\aaDATA3\Breast Studies\UVM\DicomImagesBlinded(digi)';
                    startdir_report = '\\researchstg\aaDATA3\Breast Studies\UVM';
                end
                folder = [];
            elseif strcmp(film_identifier(1:3),'ucs')  %for UCSF
                    start_dir = '\\researchstg\aaDATA6\Breast Studies\UCSFMedCtr\DicomImagesBlinded(digi)';
                    startdir_report = '\\researchstg\aaDATA6\Breast Studies\UCSFMedCtr';
            elseif strcmp(film_identifier(1:2),'nc')  %for NC
                if strcmp(str,'PCWIN64')
                    start_dir = 'I:\aaData4\Breast Studies\NC\DicomImagesBlinded(digi)';
                    startdir_report = 'I:\aaData4\Breast Studies\NC';
                else
                    start_dir = '\\researchstg\aaDATA4\Breast Studies\NC\DicomImagesBlinded(digi)';
                    startdir_report = '\\researchstg\aaDATA3\Breast Studies\NC';
                end
                folder = [];
            %Case added for Avon, by Song, 1/24/11
            elseif strcmpi(film_identifier(1:3), 'avo')     %for Avon
                if strcmp(str, 'PCWIN64')
                    start_dir = 'I:\aaData4\Breast Studies\Shanghai\DicomImagesBlinded(digi)';
                    startdir_report = 'I:\aaData4\Breast Studies\Shanghai';
                else
                    start_dir = '\\researchstg\aaData4\Breast Studies\Shanghai\DicomImagesBlinded(digi)';
                    startdir_report = '\\researchstg\aaData4\Breast Studies\Shanghai';
                end
                folder = [];
            %End of change by Song, 1/24/11
            %Case added for Marsden, by Song, 1/26/11
            elseif strcmpi(film_identifier(1:3), 'mar')     %for Marsden
                if strcmp(str, 'PCWIN64')
                    start_dir = 'H:\aaData3\Breast Studies\Marsden\DicomImagesBlinded(digi)';
                    startdir_report = 'H:\aaData3\Breast Studies\Marsden';
                else
                    start_dir = '\\researchstg\aaData3\Breast Studies\Marsden\DicomImagesBlinded(digi)';
                    startdir_report = '\\researchstg\aaData3\Breast Studies\Marsden';
                end
                folder = [];
            %End of change by Song, 1/26/11
            end
            %startdir_wfolder = [start_dir,'\',folder];
        elseif Info.DigitizerId <= 3 %analog
            if strcmp(str,'PCWIN64')
                %start_dir = 'D:\aaDATA\Breast Studies\CPMC';
                start_dir = 'D:\aaDATA\Breast Studies\CPMC(analog)\DicomImageBlinded\';
                startdir_report = 'D:\aaDATA\Breast Studies\CPMC(analog)';
            else
                start_dir = '\\researchstg\aaDATA\Breast Studies\CPMC(analog)\DicomImageBlinded';
                startdir_report = '\\researchstg\aaDATA\Breast Studies\CPMC(analog)';
            end
            folder = [];
        end  
        startdir_wfolder = [start_dir,'\',folder];
              
       % fname = [start_dir,'\',fdir_name,fname]; %commented for temporary
       
        filename = [startdir_wfolder,fname];


%         filename=cell2mat(mxDatabase(Database.Name,['select filename from acquisition where acquisition_id=',num2str(List(index+Offset,:))]));
%        
%         [ending,beginning]=funcEndFileName(filename);
%         ThumbnailFileName=[beginning,'thumb_',ending];
        
        
        if (index+Offset)<=length(Image)
        
        elseif true % exist(ThumbnailFileName)
            %{
              Newfilename=[file.RepositoryDrive,'\',funcEndFileName(filename)]; 
               s=dir (Newfilename);
               if isempty(s)
                   Newfilename=[file.RepositoryDrive2,'\DicomImageblinded\',funcEndFileName(fname)]; 
                   s=dir (Newfilename);
                   if isempty(s)
                       Newfilename=[file.RepositoryDrive3,'\DicomImageblinded\',funcEndFileName(fname)]; 
                       s=dir (Newfilename);
                   end
               end
            %}
            try
                im1 = imread(filename);
            catch
                index=index+1;
                errmes = lasterr
                continue;
            end
                %Image.OriginalImage = im1;
                %Image.maximage2 = max(max(im1));
                %imagemenu('flipV');
                %im2imrotate(
               % im2 = log_convert(double(im1(end-500:end,end-500:end)));%,-31);
                im2 = log_convert(double(im1));
                %im2 = imrotate(im2,-90);
                % J = imrotate(b,-31.8,'bilinear','crop');
                clear im1;
                imagette=UnderSamplingN(im2,10);
                %imagette=UnderSamplingN(imread(filename),10);
           % Image(index+Offset)={double(imread(ThumbnailFileName))};
             Image(index+Offset)={imagette};
%         else
            %{
            try
               %{ 
                im1 = imread(filename);
                im2 = im1(1:400,500:end);
                clear im1;
                imagette=UnderSamplingN(im2,10);
                %imagette=UnderSamplingN(imread(filename),10);
                imwrite(uint16(imagette),ThumbnailFileName,'PNG');
               %} 
            catch
                imagette=0;
            end
           
            Image(index+Offset)={imagette};
            %}
        end
        axes(Thumbnail.axis(index));
        imagesc(cell2mat(Image(index+Offset)));colormap(gray);set(Thumbnail.axis(index),'xtick',[],'ytick',[]);
        set(Thumbnail.Title(index),'string',num2str(List(index+Offset,:)));
        pause(0.01);drawnow;
        index=index+1;
    end
    if (index+Offset)<size(List,1)
        set(Thumbnail.After,'enable','on');
    else
        set(Thumbnail.After,'enable','off');
    end
    if Offset>0
        set(Thumbnail.Before,'enable','on');
    else
        set(Thumbnail.Before,'enable','off');
    end
    set(dummyuicontrol2,'value',false);
    if (strcmp(option,'GENERATE>')) %in the generated mode, don't wait for any user input
        if ((index+Offset)>size(List,1))
            ContinuOk=false
        end
        Offset=Offset+MAXX*MAXY;
    else
        waitfor(dummyuicontrol2,'value');
        if Info.SaveStatus==3
            ContinuOk=false;
        elseif Info.SaveStatus==2
            Offset=Offset-MAXX*MAXY;
        else
            Offset=Offset+MAXX*MAXY;
        end
    end
end

delete(Thumbnail.figure);

