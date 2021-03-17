function I = log_convertDXA_ZM10new(image,mAs, kVp, ~)
global flag
flag.SXAphantomDisplay = true;    % true for displaying RIOs
if kVp==39
    [fileName, pathName]=uigetfile('.png', 'Please select HE Flat-Field');
    FF_filename = [pathName, '\',fileName];
else
    [fileName, pathName]=uigetfile('.png', 'Please select LE Flat-Field');
    FF_filename = [pathName, '\',fileName];
end
% % % [fileName,pathName]=uigetfile('.png', 'Please select dark-field image');
% % % DARK_filename=[pathName, '\', fileName];
% % % FFSTRUCT=load(FF_filename);
% % % FLATFIELD=FFSTRUCT.imageData;
FLATFIELD = double(imread( FF_filename));
FLATFIELD=flipdim(FLATFIELD,2);
FLATFIELD=flipdim(FLATFIELD,1); %both flips for MtZion
% % % I0DARKSTRUCT=load(DARK_filename);
% % % IODARK=I0DARKSTRUCT.imageData;
% % % IODARK= double(imread(DARK_filename));
% % % I0DARK=flipdim(IODARK,2);
% % % IODARK=flipdim(I0DARK,1); %both flips for MtZion
voltages = [24, 25, 26,27, 28, 29, 30, 31, 32, 39]; % ZM10
max_counts = [6621.2, 7994.7, 9485.5, 11256.26667, 13120.83333, 15094.4, 17223.33333, 19470.25, 18208.33333, 3440];
mmax = max_counts(find(voltages == kVp));
szz=size(image);
if szz(2) > 1350 %%% to open LARGE PADDLE images
else
    FLATFIELD=FLATFIELD(193:1855,1:1279);
% % %     IODARK=IODARK(193:1855,1:1279);
end
% % % IODARK2 = mean(mean(IODARK));
IODARK2 = 50;
current_image = median(median(FLATFIELD))*(image-IODARK2)./FLATFIELD;
current_image = current_image/mmax*100/mAs;
%%%%%%%%% removing negative values %%%%%%%%%%%%%
index_neg = find(current_image<=0);
current_image(index_neg) = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
I = -log(current_image);
I=I* 10000;
end

%       I0HE= I0HE(193:1855,1:1279); % crop image for small paddle images

