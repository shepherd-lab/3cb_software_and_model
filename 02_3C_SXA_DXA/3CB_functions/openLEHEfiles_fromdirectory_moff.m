function openLEHEfiles_fromdirectory_moff(parentdir,view,option)
global Result ctrl Analysis Image;

% % % fname_LE = [parentdir,'LE', view,'raw.png'];
% % % fname_HE = [parentdir,'HE',view, 'raw.png'];

fname_LEtemp = [parentdir,'LE', view,'*raw.png'];
dd = dir(fname_LEtemp);
len2 = size(dd);
len = len2(1);
if len <= 3
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
funcOpenImage(fname_LE,option); % open the LE image
Result.flagHE = true;
option = Result.DXASelenia;
funcOpenImage(fname_HE,option); % open the HE image
% % SXAAnalysis = [];
% % DXAAnalysis = [];
 MaskROIproj = [];
 BreastMask = [];
 ROI = [];
set(ctrl.text_zone,'String','Ok');


end

