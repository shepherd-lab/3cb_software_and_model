function [machParams, phPos] = calcSrcHBuckD(origDiff, bbCoord, studyID, filmRes)
%function returns partial machine parameters including: x0_shift, y0_shift,
%source_height
%phPos stores the position of phantom's reference point and
%the phantom's orientation (Song Note 1, p17)
%filmRes in mm/pixel

machineSite = strtrim(studyID);

machParams.x0_shift = origDiff(1);
machParams.y0_shift = origDiff(2);

bbInPh = getBbPosPh(machineSite);   %get BB positions in GEN3 phantom
bbOnImg = getBbPosImg(origDiff, bbCoord, filmRes);
try
    params = fitBbImg(bbInPh, bbOnImg);
catch
    lasterror
end
phPos = zeros(1, 4);
phPos(1) = params(1);   %x
phPos(2) = params(2);   %y
phPos(3) = params(5);   %z
phPos(4) = params(3);   %theta

machParams.source_height = params(4);
machParams.bucky_distance = params(5);

%%
function bbInPh = getBbPosPh(site)

numBb = 14;
bbInPh(numBb) = struct('x', [], 'y', [], 'z', []);     %initialization
siteGroup1 = {'Avon', 'CPMC', 'CPUCSF', 'MGH', 'NC', 'UCSF'};
siteGroup2 = {'UVM', 'UVM-Selenia', 'Marsden'};    %Song Note 1, p.22

delta = 1;  %cm for all
dh = 4;
if (sum(strcmpi(site, siteGroup1)))
    w = 14.5618;
    if strcmpi(site, 'CPMC')    %more accurate dimension on CPMC GEN III
        w = ([6.537, 6.537, 6.523, 6.523, 6.542, 6.542, 6.518, 6.518, ...
              6.531, 6.531, 6.490, 6.490, 6.512, 6.464] - 0.762)*2.54;
          %see Song Note 1, p.43
    end
elseif (sum(strcmpi(site, siteGroup2)))
    w = 13.96;
else
    error('Wrong site name!');
end
l = w + 2*0.04953;

x = [-1 1 -1 1 -1 1 -1 1 -1 1 -1 1 1 1].*l/2;
y = [zeros(1,4), ones(1,4)*3, ones(1,4)*7, ones(1,2)*10.5];
z = delta + [0 0 dh dh 0 0 dh dh 0 0 dh dh 0 dh];
for i = 1:numBb
    bbInPh(i).x = x(i);
    bbInPh(i).y = y(i);
    bbInPh(i).z = z(i);
end

%%
function bbPosWld = getBbPosImg(wldOrigDiff, bbCoord, filmRes)
%Refer to Song Note I page 22.

pxToCm = filmRes * 0.1;
n = size(bbCoord, 1);
x0_diff = wldOrigDiff(1);
y0_diff = -wldOrigDiff(2);
bbPosWld(n) = struct('x', [], 'y', []);

for i = 1:n
    bbPosWld(i).x = pxToCm*(bbCoord(i, 2) - y0_diff);
    bbPosWld(i).y = pxToCm*(bbCoord(i, 1) - x0_diff);
end

%%
function params = fitBbImg(bbInPh, bbOnImg)
%Refer to Song Note 1, p.17

delta = bbInPh(1).z;
H0 = 66;
tc0 = 2;
x0_0 = (H0 - delta - tc0)/H0 * bbOnImg(1).x - bbInPh(1).x;
y0_0 = (H0 - delta - tc0)/H0 * bbOnImg(1).y - bbInPh(1).y;
theta0 = 0;

params0 = [x0_0, y0_0, theta0, H0, tc0];
params = fminsearch(@(params) sumSqrDist(params, bbInPh, bbOnImg), params0, optimset('TolX', 1e-8, 'MaxFunEvals', 5000));

%%
function chiSqr = sumSqrDist(params, bbInPh, bbOnImg)

n = length(bbInPh);
bbVirtual = calcBbVirtual(params, bbInPh);
chiSqr = 0;

for i = 1:n
    chiSqr = (bbVirtual(i).x - bbOnImg(i).x)^2 + (bbVirtual(i).y - bbOnImg(i).y)^2 + chiSqr;
end

function X = calcBbVirtual(params, bbInPh)
%params has 5 elements: phan_x0, phan_y0, theta, srcH, buckyD

x0 = params(1);
y0 = params(2);
theta = params(3);
H = params(4);
tc = params(5);

n = length(bbInPh);
xPh = zeros(n, 1);
yPh = zeros(n, 1);
zPh = zeros(n, 1);
for i = 1:n
    xPh(i) = bbInPh(i).x;
    yPh(i) = bbInPh(i).y;
    zPh(i) = bbInPh(i).z;
end

X(n) = struct('x', [], 'y', []);

%convert bb position in phantom coord to the world coord
bbInPhWld = zeros(n, 3);
bbInPhWld(:, 1) = xPh.*cos(theta) - yPh.*sin(theta) + x0;
bbInPhWld(:, 2) = xPh.*sin(theta) + yPh.*cos(theta) + y0;
bbInPhWld(:, 3) = zPh + tc;

for i = 1:n
    X(i).x = H/(H - bbInPhWld(i, 3))*bbInPhWld(i, 1);
    X(i).y = H/(H - bbInPhWld(i, 3))*bbInPhWld(i, 2);
end

