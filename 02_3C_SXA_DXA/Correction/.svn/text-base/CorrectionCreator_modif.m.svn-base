%create a new film response correction
%Lionel HERVE
%8-2-04
%create a correction of type 4
%- film response with asymetric sigmoid
%- GUI to remember what to do!!

function CorrectionCreator(RequestedAction)
global data CorrectionGUI Image Info Analysis Database ctrl 

if ~exist('RequestedAction')
    RequestedAction='GUI'
end

switch RequestedAction
%% GUI
    case 'GUI'

        CorrectionGUI.figure=figure;

        background=[0.1 0.1 0.4];
        foreground=[1 1 1];

        set(CorrectionGUI.figure,'units','normalized','position',[0.0 0.05 0.3 0.65],'NumberTitle','off','name','Correction GUI','color',background);
        CorrectionGUI.DigitizerWindow=true;
        set(CorrectionGUI.figure,'MenuBar','None');

        buttony=0.85;separation=0.07;heightbox=0.035;
        buttonminx=0.45;buttonsizex=0.50;

        buttonminx2=0.05;buttonsizex2=0.40;
        heightbutton=0.07;

        uicontrol('style','text','string','Film response creator','units','normalized','position',[0,1-heightbox,1,heightbox],'backgroundcolor',[1 0.6 0]);

        %Acquisition Date
        buttony=buttony-heightbox;
        uicontrol('style','text','string','Acquisition Date ','units','normalized','position',[buttonminx2,buttony,buttonsizex2,heightbox],'HorizontalAlignment','right','background',background,'foreground',foreground);
        CorrectionGUI.AcqusitionDate=uicontrol('style','edit','units','normalized','position',[buttonminx,buttony,buttonsizex,heightbox],'HorizontalAlignment','left','background','white','CallBack','CorrectionCreator(''UPDATEFILENAME'')');

        %MachineID
        buttony=buttony-heightbox;
        uicontrol('style','text','string','MachineID ','units','normalized','position',[buttonminx2,buttony,buttonsizex2,heightbox],'backgroundcolor',background,'HorizontalAlignment','right','foreground',foreground);
        CorrectionGUI.location=uicontrol('style','popupmenu','string',data.centerlistname(:,1),'units','normalized','position',[buttonminx,buttony,buttonsizex,heightbox],'HorizontalAlignment','left','Max',1,'Min',1,'value',1,'BackgroundColor','white','CallBack','CorrectionCreator(''UPDATEFILENAME'')');

        %Acquistion selector
        buttony=buttony-heightbox;
        uicontrol('style','text','string','Acquisition selection','units','normalized','position',[buttonminx2,buttony,buttonsizex2,heightbox],'backgroundcolor',background,'HorizontalAlignment','right','foreground',foreground);
        uicontrol('style','pushbutton','string','>>','units','normalized','position',[buttonminx,buttony,buttonsizex,heightbox],'callback','try;RetrieveInDatabase(''ACQUISITIONFROMLIST'');end;CorrectionCreator(''UPDATEDATE'');');

        %save filename
        buttony=buttony-heightbox;
        uicontrol('style','text','string','filename ','units','normalized','position',[buttonminx2,buttony,buttonsizex2,heightbox],'backgroundcolor',background,'HorizontalAlignment','right','foreground',foreground);
        CorrectionGUI.SAveName=uicontrol('style','edit','string','','units','normalized','position',[buttonminx,buttony,buttonsizex,heightbox]);

        %Crop
        buttony=buttony-heightbox;
        uicontrol('style','pushbutton','string','Crop','units','normalized','position',[buttonminx,buttony,buttonsizex,heightbox],'CallBack','CorrectionCreator(''CROP'')');

        %Do it
        buttony=buttony-2*heightbox;
        uicontrol('style','pushbutton','string','Create','units','normalized','position',[buttonminx,buttony,buttonsizex,heightbox],'CallBack','CorrectionCreator(''CREATE'')');
        CorrectionCreator('UPDATEDATE');
                
%% Update FilmDate
    case 'UPDATEDATE'
        set(CorrectionGUI.AcqusitionDate,'string',deblank(Info.FilmDate));
        set(CorrectionGUI.location,'value',get(ctrl.Center,'value'))
        CorrectionCreator('UPDATEFILENAME');
        
%% filenamegenerator
    case 'UPDATEFILENAME'
        RoomName=cell2mat(data.centerlistname(get(CorrectionGUI.location,'value'),1));
        FilmDate=get(CorrectionGUI.AcqusitionDate,'string');
        SaveFileName=[deblank(RoomName),'-',deblank(FilmDate)];
        set(CorrectionGUI.SAveName,'string',SaveFileName);

%% Crop
    case 'CROP'
        ImageMenu('AutomaticCrop');

%%
    case 'CREATE'
%% update acquisition table
        filmidentifier=['FF',cell2mat(data.centerlistname(get(CorrectionGUI.location,'value'),1))];
        mxDatabase(Database.Name,['update acquisition set film_identifier=''',filmidentifier,''' where acquisition_id=',num2str(Info.AcquisitionKey)]);
        mxDatabase(Database.Name,['update acquisition set machine_id=''',num2str(get(CorrectionGUI.location,'value')),''' where acquisition_id=',num2str(Info.AcquisitionKey)]);
            %clear global Correction
            Correction.FlatField = 0;  
        Message('Creating Correction ...');
        if Info.DigitizerId==3
            resolution=0.0150;
            Correction.Type=4;Info.Correctiontype=4;
            Correction.coef(1)=62372;
            Correction.coef(2)=14.922;
            Correction.coef(3)=5.1665;
            Correction.coef(4)=0.90103;
            Correction.coef(5)=5500;
            Correction.coef(7)=0; 
            Correction.coef(8)=0; 
            Correction.coef(9)=0; 
            Correction.coef(10)=0; 
             Correction.Digitizer = 0;
            imm = Image
            Correction.Blank = 0;
            figure('Name', 'InitialFFImage');
            imagesc(Image.OriginalImage); colormap(gray);
            
            % film response correction
            %CurrentImage=FilmResponseCorrection(Image,Correction,Analysis,'none',0); 
            CurrentImage = Image.OriginalImage;
            %clear CurrentImage
       %     figure('Name', 'InitialFFImagewith FilmResponse');
       %     imagesc(CurrentImage); colormap(gray);
            
            % Cosine Effect
            units=ones(size(CurrentImage));
            [X,Y]=meshgrid(1:size(Image.image,2),1:size(Image.image,1));
            Y=(Y-size(Y,1)/2)*resolution;
            X=X*resolution;
            CosImage=((60^2+X.^2+Y.^2).^0.5/60).^(-1);                      %60cm is the height of the X-tube
         %  CurrentImage=CosImage.*CurrentImage;          
        else 
            resolution=0.0169;
            %Correction.Type=5;Info.Correctiontype=5;
            Correction.Type=4;Info.Correctiontype=4;
            Correction.coef(1)=61622;
           % Correction.coef(2)=18.84;
           % Correction.coef(3)=2.8145;
           % Correction.coef(4)=0.34672;
           % Correction.coef(5)=13000;  
            
            Correction.coef(2)=30.09;
            Correction.coef(3)=4.359;
            Correction.coef(4)=0.57;
            Correction.coef(5)=12900; 
            
            %bottom saturation
            Correction.coef(7)=244110;    %from p83lh1_pixellaw
            Correction.coef(8)=38940;   %from p83lh1_pixellaw
            Correction.coef(9)=2300; %from p83lh1_pixellaw
            Correction.coef(10)=17.5; %from p83lh1_pixellaw
            Correction.FlatField = 0;  
            Correction.Digitizer = 1;
            Correction.Blank = 1;
            % film response correction
            
          %  figure('Name', 'InitialFFImage');
           % imagesc(Image); colormap(gray);
            
           % CurrentImage=FilmResponseCorrection(Image,Correction,Analysis,'none',0); 
           % CurrentImage = Image;
            CurrentImage = Image.OriginalImage; 
           
            figure('Name', 'InitialFFImagewithFilmResponse');
            imagesc(CurrentImage); colormap(gray);
            
           % CurrentImage=((CurrentImage-Correction.coef(7)+Correction.coef(8)*log(Info.mAs*(Info.kVp-Correction.coef(10))^2))/Correction.coef(9)); %coef are obtain for study p76lh1-pixelLaw
         
            %figure('Name', 'InitialFFImagewithFilmResponsewithCoeffCalc');
            %imagesc(CurrentImage); colormap(gray);
            
            % Cosine Effect
            units=ones(size(CurrentImage));
            [X,Y]=meshgrid(1:size(Image.image,2),1:size(Image.image,1));
            Y=(Y-size(Y,1)/2)*resolution;
            X=X*resolution;
            CosImage=((60^2+X.^2+Y.^2).^0.5/60).^(-1);                      %60cm is the height of the X-tube
            %CurrentImage=CosImage.*CurrentImage;
            
            %figure('Name', 'InitialFFImagewithFilmResponsewithCoeffCalcwithCos');
            %imagesc(CurrentImage); colormap(gray);
            image_mean = mean(mean(CurrentImage(600:800,100:200)))
           % CurrentImage=CurrentImage-mean(mean(CurrentImage(600:800,100:200)));
        end
              
        % generate correction 
     
       % InterpolatedImage1=funcGradientGauss(CurrentImage,10); % smoothing with gauss kernel
        min_corrim = min(min( CurrentImage));
       if min_corrim < 0
         CurrentImage = CurrentImage - min_corrim + 1000;
       end
         min_corrim1 = min(min( CurrentImage))
        Correction.InterpolatedImage1=CurrentImage;
        figure('Name', 'InterpolatedImage1inCorrectionFile');
        imagesc(Correction.InterpolatedImage1); colormap(gray);
        clear CurrentImage
        szinter1 = size(Correction.InterpolatedImage1)
        Correction.CosImage=round(CosImage*10000);
        szcos = size(Correction.CosImage)
        mncreate = min(min(Correction.InterpolatedImage1))
        mxcreate = max(max(Correction.InterpolatedImage1))
        Correction.Blank = 0;
        %add the next line on 05/23/05 to cos correct flat field 
       % Correction.InterpolatedImage1 = Correction.InterpolatedImage1 .* Correction.CosImage/10000;
       % figure('Name', 'Interp1ImageSmoothCos');
       % imagesc(Correction.InterpolatedImage1); colormap(gray);
        
        %% creation of file and database entry        
        FullSaveName=['d:\corrections\',get(CorrectionGUI.SAveName,'string'),'.mat'];
        save(FullSaveName,'Correction');

        %create new database entry
        clear Field;
        Field(1)={get(CorrectionGUI.SAveName,'string')};
        Field(2)={num2str(Info.Operator)};
        Field(3)={'4'};
        Field(4)={num2str(Correction.coef(1))};
        Field(5)={num2str(Correction.coef(2))};
        Field(6)={num2str(Correction.coef(3))};
        Field(7)={num2str(Correction.coef(4))};
        Field(8)={num2str(Correction.coef(5))};
        Field(9)={'0'};
        Field(10)={num2str(Correction.coef(7))};
        Field(11)={num2str(Correction.coef(8))};
        Field(12)={num2str(Correction.coef(9))};
        Field(13)={num2str(Correction.coef(10))};
        Field(14)={'55000'};
        Field(15)={'0'};
        Field(16)={'0'};
        Field(17)={'0'};
        Field(18)={'0'};
        Field(19)={'0'};
        Field(20)={Analysis.filename};
        Field(21)={FullSaveName};
        Field(22)={get(CorrectionGUI.AcqusitionDate,'string')};
        Field(23)={num2str(get(CorrectionGUI.location,'value'))};
        funcAddInDatabase(Database,'correction',Field)
        Message('Done ...');
        
end