%saveMat3C - Quick, dirty function that saves calculated 3C data.  The
%function with request a presentation image in png format in addition to
%the data stored in the global.  No checking is done to ensure that there
%is actually data in the global variable from which data is retrieved.
%Frankly, my next programming project involves documenting and programming
%an interface that is less overgrown.
%Syntax:  
%
% Inputs:
%   src - not used
%   event - not used
% Outputs:
%
% Example: 
%    
%
% Other m-files required: none
% Subfunctions:
% MAT-files required:
%
% Author: Fred Duewer
% UCSF
% email: fwduewer@radiology.ucsf.edu 
% Website: http://www.ucsf.edu/bbdg
% March 2010; Last revision: 23-March-2010

%------------- BEGIN CODE --------------
function saveMat3C(src, event)
global fredData ROI
[fileName,pathName]=uigetfile('.png','Please select presentation image to be saved with calculated images.  Otherwise, LE attenuation image will be used.');
if isempty(ROI)
    ROI.ymin=1;
    ROI.xmin=1;
    ROI.rows=2047;
    ROI.columns=1663;
end
%hack
if isnumeric(fileName)
    presentationImage=fredData.LE(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1);
else
    presentationImage=double(imread([pathName,fileName]));
end
waterImage=fredData.water;
lipidImage=fredData.lipid;
proteinImage=fredData.protein;
thicknessImage=fredData.thickness;
leImage=fredData.LE(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1);
heImage=fredData.HE(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1);
if isfield(fredData, 'SXAImage')
    SXAImage=fredData.SXAImage;
else
    SXAImage=1;
end
[fileName,pathName]=uiputfile('.mat','Please choose name for mat file.');
if isnumeric(fileName)
    return
else
    save([pathName,fileName],'presentationImage','waterImage','lipidImage','proteinImage','thicknessImage','leImage','heImage', 'SXAImage');
end
end

