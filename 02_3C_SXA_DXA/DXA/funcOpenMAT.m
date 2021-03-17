function  funcOpenMAT(fname,Option)
global ctrl Result f0 Analysis Info Image FreeForm flag buttonPressed Hist Threshold file flag 
%module Open Image
%open the filename fname
%Lionel HERVE
%modification
%10-13-03 do not compute  background now
errorCode=0;
%noimage_flag = 0;

f = fname

if ~exist('Option')
    Option='NULL';
end

%some initialization
Hist.x0=0;Hist.xmax=100; %init sliders
Threshold.value=0.5; %init threshold

set(ctrl.text_zone,'String','Loading the image');
set(f0.handle,'name',fname);
Analysis.Step=1;Analysis.StepPhantom=1;Analysis.Surface=0;

%some initialization
Result.DXA=false;Info.DXAModeOn=false;
funcerasefreeforms;
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
mask=funcloadMAT(fname, Option);
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
        Image.LE=Result.image;
        Result.flagLE = false;
    else
        Result.DXASeleniaCalculated = true;
        Image.HE=Result.image;
        Image.RST=Result.RST;
        set(ctrl.Cor,'value',false);
%        ShowDXAImage('LE');
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
            ImageMen('AutomaticCrop');
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
