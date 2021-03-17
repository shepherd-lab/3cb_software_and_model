function openSeleniaDXAMAT(src, event)
global Result Image flag Info Analysis ctrl file SXAAnalysis DXAAnalysis ROI
if ~exist('Option')
    Option='NULL';
end
flag.open_image_file = false;
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
Analysis.Filmresolution = 0.14;
Info.DXAAnalysisRetrieved = false;
Option = Result.DXASelenia;
clear_DXAfields;
funcMenuOpenMAT(Option); % open the LE image
Result.flagHE = true;
option = Result.DXASelenia;
funcMenuOpenMAT(option); % open the HE image
SXAAnalysis = [];
DXAAnalysis = [];
MaskROIproj = [];
BreastMask = [];
ROI = [];
set(ctrl.text_zone,'String','Ok');




