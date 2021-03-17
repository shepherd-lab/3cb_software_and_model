function [energyRaw, energyNorm] = energyByFreq(fftImage)
%fftFeatures computes the feature values calculated on different
%frequencies

numReg = 40;    %break the fft image into a number of annular regions

%check if fft image is square
[rows, cols] = size(fftImage);
if rows ~= cols
    error('Input image must be square.');
end

%create distance-to-center map
x0 = (cols + 1)/2;
y0 = x0;
[x, y] = meshgrid(1:cols, 1:rows);
distMap = sqrt((x - x0).^2 + (y - y0).^2);

%compute the raw energy for each region
rmax = (rows + 1)/2;
r = linspace(0, rmax, numReg+1);
energyRaw = zeros(1, numReg);
for i = 2:numReg
    region = fftImage(distMap >= r(i) & distMap < r(i+1));
    energyRaw(i - 1) = std(region);
end
%the corner region
region = fftImage(distMap >= r(end));
energyRaw(end) = std(region);

%compute normalized energy
energyNorm = energyRaw/norm(energyRaw, 1);

