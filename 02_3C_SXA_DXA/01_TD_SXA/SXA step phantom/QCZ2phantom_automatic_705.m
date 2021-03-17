function params = QCZ2phantom_automatic(Gen3Pos)
global Error 
    % D = 'C:\Documents and Settings\smalkov\My Documents\Programs\'; 
    %D = 'C:\Documents and Settings\smalkov\My Documents\SeleniaImages\Selenia_room116\15May\txt_files\';
    %file_name = [D,num2str(Info.AcquisitionKey),'.txt']; 
    
   % manualbbs_position();
   % sort_coord = load(file_name);

   [sort_coord] = QCbbs_position_digital();
    
    if length(sort_coord(:,1)) < 6
        Error.StepPhantomBBsFailure = true;
        stop;
    else
        bbReconParams = bbZ2_3Dreconstruction(sort_coord);
        calcMachParamsCorr(bbReconParams, Gen3Pos);
    end
   
    %roi9stepsZETA1_projection();
%     ;

%%
function calcMachParamsCorr(params, Gen3Pos)

global MachineParams Info
site = strtrim(Info.StudyID);

%GEN3 at different sites have different bookend slopes, see Song Note 1, p.22
siteGroup1 = {'CPMC', 'CPUCSF', 'MGH', 'UCSF', 'UVM', 'UVM-Selenia'};   %5 degree
siteGroup2 = {'Avon', 'Marsden', 'NC'};    %1 degree

%get the bookend surface slope
if (sum(strcmpi(site, siteGroup1)))
    BookendSlope = 5;
elseif (sum(strcmpi(site, siteGroup2)))
    BookendSlope = 1;
else
    error('Wrong site name!');
end

x0 = params(1:6);
if sum(strcmpi(site, {'avon', 'marsden', 'ucsf'})) %JW included ucsf, since only LM & JW acquiring images (assume all pass)
    imgValFlag = 9; %image validity is not checked
else
    imgValFlag = checkImgValid(MachineParams.padSize, Info.thickness, Info.force);
end

if imgValFlag ~= 0
    SXAtoBucky = thickMap(Gen3Pos, x0, BookendSlope);
    MachineParams.th_correction = x0(4) - SXAtoBucky;  %this actually is thickness correction
    MachineParams.rx_correction = x0(1);
    MachineParams.ry_correction = x0(2) - BookendSlope;
else
    MachineParams.th_correction = [];
    MachineParams.rx_correction = [];
    MachineParams.ry_correction = [];
end

MachineParams.valFlag = imgValFlag;
        
%%
function flag = checkImgValid(padSize, thickness, force)

if strcmpi(padSize, 'Small')
    padIdx = 1;
elseif strcmpi(padSize, 'Large')
    padIdx = 2;
end

meanThick = [60.25, 59.5];  %in the order of [small paddle, large paddle]
stdThick = [0.5, 0.577];
meanForce = [81.2, 110.1];
stdForce = [2.23, 2.2];

%check image validity
if (thickness > meanThick(padIdx) + 3*stdThick(padIdx) || ...
    thickness < meanThick(padIdx) - 3*stdThick(padIdx) || ...
    force > meanForce(padIdx) + 3*stdForce(padIdx) || ...
    force < meanForce(padIdx) - 3*stdForce(padIdx))
    flag = 0;
else
    flag = 1;
end

%%
function thickness = thickMap(Gen3Pos, SXAparams, BookendSlope)
%Given a point in the world coord, the function calculates its thickness
%based on the position and orientation of the Gen3 phantom.

Gen3Angle = Gen3Pos(4);
refPt.x = Gen3Pos(1);
refPt.y = Gen3Pos(2);
refPt.h = 6.35 - tand(BookendSlope);    %Song Note 1, p.24
SXA.x = -SXAparams(6);    %convert to the world coord, Song Note 1, p.23
SXA.y = SXAparams(5);

%gradient of the thickness field
gradDirection = [sin(Gen3Angle); -cos(Gen3Angle)]; %Song Note 1, p.24
gradH = gradDirection * tand(BookendSlope);

vector = [SXA.x - refPt.x; SXA.y - refPt.y];
thickness = refPt.h + gradH' * vector;

