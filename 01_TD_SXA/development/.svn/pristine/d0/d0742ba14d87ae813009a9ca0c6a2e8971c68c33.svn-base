global A;           %image (in a array form)
global dummy;       %handle that allows to control the end of the scan
global y2;          %the information that are passed though the event OnStartSCan
global vidar ctrl f0 Threshold Hist Image Analysis flag Info Correction Database
%global LittleGraph; 

VID_OCX_EVENT_SCAN_FILM_STARTED	= 0;
VID_OCX_EVENT_SCAN_FILM_IN_PROGRESS	= VID_OCX_EVENT_SCAN_FILM_STARTED + 1;
VID_OCX_EVENT_SCAN_FILM_DONE	= VID_OCX_EVENT_SCAN_FILM_IN_PROGRESS + 1;
VID_OCX_EVENT_SCAN_FILM_ALL_DONE	= VID_OCX_EVENT_SCAN_FILM_DONE + 1;
VID_OCX_EVENT_SCAN_FILM_CANCELLED	= VID_OCX_EVENT_SCAN_FILM_ALL_DONE + 1;
VID_OCX_EVENT_SCAN_FILM_ERROR	= VID_OCX_EVENT_SCAN_FILM_CANCELLED + 1;
VID_OCX_EVENT_SCAN_END	= VID_OCX_EVENT_SCAN_FILM_ERROR + 1;
VID_OCX_EVENT_SCAN_START	= VID_OCX_EVENT_SCAN_END + 1;
vidar.compteur=0;

dummy=uicontrol('style','checkbox','value',false,'visible','off');
set(vidar.checkbox4,'value',false);

vidar.maxsize=10000000;
A=zeros(1,vidar.maxsize);

vidar.continu=true;
while vidar.continu
    vidar.error=0;
    try
        width=get(vidar.activex,'ImageWidth');
    catch
        vidar.error=1;
        pause(0.1)
    end
    if vidar.error==0
        vidar.continu=false;
    end
end
set(vidar.checkbox4,'value',true);

vidar.scan=true;
StartScan(vidar.activex);

compteur=0;
while ~get(dummy,'value')
    compteur=compteur+1;
    pause(1);
end

if y2.a_nStatus==VID_OCX_EVENT_SCAN_FILM_DONE
    UnloadMedium(vidar.activex);
    set(ctrl.text_zone,'String','Image transfert ...');   drawnow;   
    height=floor(y2.nTotalBytesRead/width/2);
    A2=A(1,1:height*width*2);
    A3=reshape(A2,2,height*width);
    A4=A3(2,:)*256+A3(1,:);
    clear A2;clear A3;

    vidar.DigitalizedImage=reshape(A4,width,height);
    vidar.DigitalizedImage=flipdim(transpose(vidar.DigitalizedImage),1);
    clear A4;
       
    axes(f0.axisHandle);
    imagesc(vidar.DigitalizedImage);
    colormap(gray);
    
    %initialize image    
    Analysis.filename='';
    Analysis.Step=1;Analysis.StepPhantom=1;Analysis.Surface=0;   
    Image.OriginalImage=vidar.DigitalizedImage;
    Image.image=vidar.DigitalizedImage;
    vidar.DigitalizedImage=uint16(vidar.DigitalizedImage);
    Image.maximage=max(max(Image.image));
    [Image.rows,Image.columns] = size(Image.image);

    Image.maximage=max(max(Image.image));   %0.3s
    Image.maxOriginalImage=Image.maximage;
    Hist.values=histc(reshape(Image.image,1,Image.columns*Image.rows),[0:0.01:0.5]*Image.maximage);   %0.4s
    [C,Analysis.BackGroundThreshold]=max(Hist.values); 
    
    
    Analysis.BackGround=zeros(size(Image.image));    
    

    ResizeWindow; %fit to the window
    Hist.x0=0;Hist.xmax=100; %init sliders
    Threshold.value=0.5; %init threshold
    set(ctrl.CheckAutoSkin,'value',true);
    Threshold.Computed=false;     %to erase the Threshold analysis contour;        

    set(ctrl.Cor,'value',false);
    buttonProcessing('CorrectionAsked');   %2s  TO OPTIMIZE
    figure(vidar.figure);
    
    set(ctrl.text_zone,'String','Ok');        

    clear y2;clear dummy;
    end


clear VID_OCX_EVENT_SCAN_FILM_STARTED;
clear VID_OCX_EVENT_SCAN_FILM_IN_PROGRESS;
clear VID_OCX_EVENT_SCAN_FILM_DONE;
clear VID_OCX_EVENT_SCAN_FILM_ALL_DONE;
clear ID_OCX_EVENT_SCAN_FILM_CANCELLED;
clear VID_OCX_EVENT_SCAN_FILM_ERROR;
clear VID_OCX_EVENT_SCAN_END;
clear VID_OCX_EVENT_SCAN_START;
