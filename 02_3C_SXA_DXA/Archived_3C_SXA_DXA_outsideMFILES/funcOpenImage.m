function  funcOpenImage(fname,Option)
global ctrl Result f0 Analysis Info Image FreeForm flag buttonPressed Hist Threshold file flag X Image_init
%module Open Image
%open the filename fname
%Lionel HERVE
%modification
%10-13-03 do not compute  background now
Result.DXASXA = true;
errorCode=0;
if Result.flagHE == false
Image = [];
 ROI = [];
 Image = Image_init;
end
%noimage_flag = 0;
X =[];
Info.flipH = false;
Info.flipV = false;
f = fname
s=dir (fname);
if ~size(s,1)
    flag.noimage = true;
    Newfilename=[file.RepositoryDrive2,'\DicomImageblinded\',funcEndFileName(fname)];
    s=dir (Newfilename);
    if isempty(s)
        Newfilename=[file.RepositoryDrive3,'\DicomImagesBlinded(digi)\',funcEndFileName(fname)];
        s=dir (Newfilename);
    end
    if ~size(s,1)
        if Info.Analysistype == 5
            flag.noimage = true;
            return
        end
    else
        fname=Newfilename;
        flag.noimage = false;
    end
end
%If you pass a filename not in the current working directory, looks in the
%repository drive, whatever that is

if ~exist('Option')
    Option='NULL';
end

%some initialization
Hist.x0=5;Hist.xmax=95; %init sliders
Threshold.value=0.5; %init threshold

set(ctrl.text_zone,'String','Loading the image');
set(f0.handle,'name',fname);
Analysis.Step=1;Analysis.StepPhantom=1;Analysis.Surface=0;

%some initialization
Result.DXA=false;Info.DXAModeOn=false;
% if exist('FreeForm') & ~isempty(FreeForm)
funcerasefreeforms;
% end

funcEraseChestWall;
set(ctrl.CheckAutoSkin,'value',true);
Threshold.Computed=false;  %to erase the Threshold analysis contour;
Info.PhantomComputed=false;

if Result.flagHE == false
    Info.StepPhantomComputed=false;
end
set(f0.handle,'pointer','watch');
Info.fname = fname;
Analysis.CompleteFileName=fname;
Analysis.filename=funcEndFileName(fname);
%figure; imagesc(Image.LE);colormap(gray);
mask=funcloadImage(fname, Option);
%figure; imagesc(Image.LE);colormap(gray);
%Background
if size(mask,1)
    Info.DXAModeOn=true;
    Analysis.BackGroundComputed=true;  %DXA background
    Analysis.BackGround=mask;
end
%for temporary tranfer up to line 83
%Analysis.CompleteFileName=fname;
%Analysis.filename=funcEndFileName(fname);
%%%%%%%%%%%%%%%%% report item
%commented for reanalysing

ReinitImage(Result.image,'OPTIMIZEHIST');

%figure; imagesc(Image.LE);colormap(gray);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if Result.flagHE == false
    Image.OriginalImageInit = Result.image;
end
%ResizeWindow; %fit to the window

set(f0.handle,'pointer','arrow');
small_LEHEoffsets = load('\SRL\aaData\Breast Studies\3C_data\RO1_3Cimages\Moffitt\Results_Moffitt\LESXA_analysis\NoSXA_calibration\small_LEHEoffsets.txt');
large_LEHEoffsets = load('\SRL\aaData\Breast Studies\3C_data\RO1_3Cimages\Moffitt\Results_Moffitt\LESXA_analysis\NoSXA_calibration\large_LEHEoffsets.txt');

if Result.DXA
    Image.LE=Result.LE;
    Image.HE=Result.HE;
    Image.RST=Result.RST;
    set(ctrl.Cor,'value',false);
    ShowDXAImage('thickness');  %show material image
    Result.image=[];
    funcActivateDeactivateButton;
elseif  Result.DXASelenia
    if Result.flagLE
        if Result.DXASXA
            draweverything; 
%           if (str2double(Info.patinent_id(3:4))== 1) & ( (str2double(Info.patinent_id(5:7)) >=1 & str2double(Info.patinent_id(5:7)) < 46) | str2double(Info.patinent_id(5:7)) == 50)
          Result.sxa_bkgrLE = []; 
          try
            Result.sxa_bkgrLE = [];
%     for FF testing        
            PhantomDetection();             
           Result.sxa_bkgrLE = SXAbackground_calculation()
 %          Result.sxa_bkgrLE = 0;
           
%             Result.sxa_bkgrLE = background_phantomdigital(Image.OriginalImage)+2774;
           catch
               sz  = size(Image.image);
               if sz(2) > 1300 % large paddle
               index=find(large_LEHEoffsets(:,1)==Info.kVp);
               Result.sxa_bkgrLE = large_LEHEoffsets(index,2);
               else
               index=find(small_LEHEoffsets(:,1)==Info.kVp);
               Result.sxa_bkgrLE = small_LEHEoffsets(index,2);    
               end
               
           end
            Image.LE = Result.image - Result.sxa_bkgrLE;
            
        else
        Image.LE=Result.image;
        end
        Image.fnameLE = file.fname;
        Result.flagLE = false;
    else
        Result.DXASeleniaCalculated = true;
        if Result.DXASXA
            draweverything; 
            try
            Result.sxa_bkgrHE = [];   
%            For FF testing
           PhantomDetection(); 
            Result.sxa_bkgrHE = SXAbackground_calculation()
%             Result.sxa_bkgrHE = 0;
%             Result.sxa_bkgrHE = background_phantomdigital(Image.OriginalImage);
            
            catch
                sz  = size(Image.image);
               if sz(2) > 1300 % large paddle
%                index=find(large_LEHEoffsets(:,1)==Info.kVp);
%                Result.sxa_bkgrLE = large_LEHEoffsets(index,3);
                Result.sxa_bkgrHE = 3874; %average for 39 kvp
               else
%                index=find(small_LEHEoffsets(:,1)==Info.kVp);
%                Result.sxa_bkgrHE = small_LEHEoffsets(index,3);
                 Result.sxa_bkgrHE = 4217; %average for 39 kvp
               end
               
            end
            Image.HE = Result.image - Result.sxa_bkgrHE;
            Image.RST = Image.LE./Image.HE;
        else
        Image.HE=Result.image;
        Image.RST=Result.RST;
        end
        set(ctrl.Cor,'value',false);
        ShowDXAImage('LE');
        Result.flagHE = false;
        
        Result.image=[];
    end
    % HistogramManagement('ComputeHistogram');
    funcActivateDeactivateButton;
    %elseif Result.Selenia
    %    ;
else
    if Info.DigitizerId == 1 |  Info.DigitizerId == 3               %Info.DigitizerId ~= 4
        buttonProcessing('CorrectionAsked');  %Corrections; simulate 'Correction' button is pressed
    end
end
if Info.DigitizerId == 1 |  Info.DigitizerId == 3  %Info.DigitizerId ~= 4
    if flag.FileFromDatabase
        %perform basic operations
        try
            %manual analysis
            RetrieveInDatabase('BASICOPERATION');
            imagemenu('AutomaticCrop');
        catch
            errmsg = lasterr
            if(strfind(errmsg, 'Index exceeds matrix dimensions'))
                return;
            end
        end
    end
end

set(ctrl.text_zone,'String','Ok');
flag.action2=0; %skin detection not asked from database
Analysis.OperationList={};
%figure; imagesc(Image.LE);colormap(gray);
Result.image=[];

errorCode=1;
