function  funcOpenImage(fname,Option)
global ctrl Result f0 Analysis Info Image FreeForm flag buttonPressed Hist Threshold file Error Image_init
%module Open Image
%open the filename fname
%Lionel HERVE
%modification
%10-13-03 do not compute  background now
errorCode=0;
%noimage_flag = 0;
Image = [];
 ROI = [];
 Image = Image_init;
%flag.Selenia_image = false;
Info.flipH = false;
Info.flipV = false;
f = fname
s=dir (fname);
Result.DXAProdigyCalculated = false;
Result.DXAProdigyBreastCalculated = false;
% StudyID=Info.StudyID;

if ~size(s,1) 
       flag.noimage = true;
       %Newfilename=[file.RepositoryDrive,'\',funcEndFileName(fname)]; 
       %s=dir (Newfilename);
          %if isempty(s)
          % Newfilename=[file.RepositoryDrive2,'\DicomImagesBlinded(digi)\',funcEndFileName(fname)]; 
          
           Newfilename=[file.RepositoryDrive2,'\DicomImageblinded\',funcEndFileName(fname)]; 
           s=dir (Newfilename);
           if isempty(s)
               
               Newfilename=[file.RepositoryDrive3,'\DicomImagesBlinded(digi)\',funcEndFileName(fname)]; 
              % Newfilename=[file.RepositoryDrive3,'\DicomImageblinded\',funcEndFileName(fname)]; 
               s=dir (Newfilename);
           end
           %end
           
           if isempty(s)   % AM 10162013
                
               if findstr(Info.StudyID,'UCSF') %#ok<FSTR>
               start_dirUCSF = '\\researchstg\aaData6\Breast Studies\UCSFMedCtr\found';
               Newfilename=[start_dirUCSF,'\',funcEndFileName(fname)]; 
              % Newfilename=[file.RepositoryDrive3,'\DicomImageblinded\',funcEndFileName(fname)]; 
               s=dir (Newfilename);
               end
           end
               

       if ~size(s,1)
           if Info.Analysistype == 5
              flag.noimage = true;
       
               
           end
           %{
           [fname,errorCode]=EnterTheRepositionFileDlg(fname);
           if ~errorCode
               flag.noimage = true;
               return;
           end
           %}
       else 
               fname=Newfilename;
               flag.noimage = false;
       end
end    



%{    
if ~exist('Option')
    Option='NULL';
    Result.flagLE = false; 
    Result.flagHE = false; 
    Result.DXAProdigy = false;
    Result.DXASelenia = false;
else
    if (Option == false | Option=='NULL') 
       Result.flagLE = false; 
       Result.flagHE = false; 
       Result.DXAProdigy = false;
       Result.DXASelenia = false;
    end
end
%}
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
funcErasefreeforms;
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
mask=funcloadImage(fname);
% % % figure; imagesc(Image.LE);colormap(gray);
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
%Result.image = Result.image + 1100;
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
    FuncActivateDeactivateButton;
   % set(ctrl.text_zone,'String','Ok');
elseif  Result.DXAProdigy | Result.DXASelenia
    if Result.flagLE
      % Image.LE=Result.LE;
       Image.LE=Result.image;
              
       Result.flagLE = false;
    else
       %Image.HE=Result.HE;
       Result.DXASeleniaCalculated = true;
       Image.HE=Result.image;
       Image.RST=Result.RST;
       set(ctrl.Cor,'value',false);
       %ShowDXAImage('MATERIAL');  %show material image
       %ShowDXAImage('RST'); 
       ShowDXAImage('LE'); 
       Result.flagHE = false;
       if Result.DXAProdigy == true
          Result.DXAProdigyCalculated = true;
       end
       Result.DXAProdigy = false;
       %Result.DXASelenia = false
       
       Result.image=[];
    end
   % HistogramManagement('ComputeHistogram');
     FuncActivateDeactivateButton;
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
