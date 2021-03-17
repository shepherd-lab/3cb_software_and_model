function openLEHEfiles_fromdirectory(parentdir,parentPresdir,view,option)
global Result ctrl Analysis Image;

% % % fname_LE = [parentdir,'LE', view,'raw.png'];
% % % fname_HE = [parentdir,'HE',view, 'raw.png'];

%% raw image
fname_LEtemp = [parentdir,'LE', view,'*raw.png'];
dd = dir(fname_LEtemp);
len2 = size(dd);
len = len2(1);
if len ==2
    if ~isempty(strfind(dd(1).name,'orig'))
        fname_LEorig = [parentdir, dd(1).name];
        fname_LE = [parentdir, dd(2).name];
    else
        fname_LEorig = [parentdir, dd(2).name];
        fname_LE = [parentdir, dd(1).name];
    end
else
    fname_LE = [parentdir, dd(1).name];
end
Image.fname_LEorig = fname_LEorig;
Image.fname_LE = fname_LE;

%% presentation image
fname_LEPrestemp = [parentPresdir,'LE', view,'*Pres.png'];
dd = dir(fname_LEPrestemp);
len2 = size(dd);
len = len2(1);
if len >=2
    if ~isempty(strfind(dd(1).name,'orig'))
        fname_LEorigPres = [parentPresdir, dd(1).name];
        fname_LEPres = [parentPresdir, dd(2).name];
    else
        fname_LEorigPres = [parentPresdir, dd(2).name];
        fname_LEPres = [parentPresdir, dd(1).name];
    end
else
    fname_LEPres = [parentPresdir, dd(1).name];
end
Image.fname_LEorigPres = fname_LEorigPres;
Image.fname_LEPres = fname_LEPres;



%%
         
% fname_LE = [parentdir,dd.name];

% fname_LEorig = [parentdir,'LE', view,'_origraw.png'];

fname_HEtemp = [parentdir,'HE', view,'*raw.png'];
aa = dir(fname_HEtemp);
fname_HE = [parentdir,aa.name];


option = 'Breast ZM10new';
Result.DXASelenia = true;
Result.DXASeleniaCalculated = false;

Result.flagLE = true;
Result.flagHE = false;

flag.open_image_file = false;

Result.calibration_type = option;
Info.DigitizerId = 4;
Analysis.PhantomID = 9;
flag.Selenia_image = true;
Info.Database = false;
flag.RawImage = false;
Result.DXASeleniaCalculated = false;
Result.DXASeleniaBreastCalculated = false;
Result.flagLE = true;
Result.flagHE = false;
Result.DXASelenia = true;
%Image.centerlistactivated = 12;
Analysis.Filmresolution = 0.14;
Info.DXAAnalysisRetrieved = false;
clear_DXAfields;
% flip_info = [];
funcOpenImage(fname_LE,option); % open the LE image
% flip_info = [Info.flipH Info.flipV];
Result.flagHE = true;
option = Result.DXASelenia;
funcOpenImage(fname_HE,option); % open the HE image
% % SXAAnalysis = [];
% % DXAAnalysis = [];
 MaskROIproj = [];
 BreastMask = [];
 ROI = [];
 Image.fname_LEorig = fname_LEorig;
 Image.fname_LEorigPres = fname_LEorigPres;
 Image.fname_LEPres = fname_LEPres;
 Image.fname_LE = fname_LE;
set(ctrl.text_zone,'String','Ok');


end

