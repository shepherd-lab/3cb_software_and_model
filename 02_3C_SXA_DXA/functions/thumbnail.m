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

        filename=cell2mat(mxDatabase(Database.Name,['select filename from acquisition where acquisition_id=',num2str(List(index+Offset,:))]));
        %{
        fname = filename;
         s=dir (fname);
         if isempty(s)
            filename=[file.RepositoryDrive2,'\DicomImageblinded\',funcEndFileName(fname)]; 
            s=dir (fname);
            if isempty(s)
                filename=[file.RepositoryDrive3,'\DicomImageblinded\',funcEndFileName(fname)]; 
            end
         end
         %}
        [ending,beginning]=funcEndFileName(filename);
        ThumbnailFileName=[beginning,'thumb_',ending];
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
                im1 = imread(filename);
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
        else
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

