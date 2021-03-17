function niceName=name_3C(infoDicom)
%FUNCTION_NAME - One line description of what the function or script performs (H1 line)
%Optional file header info (to give more details about the function than in the H1 line)
%Optional file header info (to give more details about the function than in the H1 line)
%Optional file header info (to give more details about the function than in the H1 line)
%
% Syntax:  [output1,output2] = function_name(input1,input2,input3)
%
% Inputs:
%    input1 - Description
%    input2 - Description
%    input3 - Description
%
% Outputs:
%    output1 - Description
%    output2 - Description
%
% Example: 
%    Line 1 of example
%    Line 2 of example
%    Line 3 of example
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: OTHER_FUNCTION_NAME1,  OTHER_FUNCTION_NAME2

% Author: Fred Duewer
% UCSF
% email: fwduewer@radiology.ucsf.edu 
% Website: http://www.ucsf.edu
% May 2004; Last revision: 12-May-2004

%------------- BEGIN CODE --------------
niceName=[infoDicom.StudyDate,'_AN',infoDicom.StudyID,'_',infoDicom.ViewPosition,'_',int2str(infoDicom.KVP),'KV_',int2str(infoDicom.ExposureInuAs/1000),'mAs.bmp']
