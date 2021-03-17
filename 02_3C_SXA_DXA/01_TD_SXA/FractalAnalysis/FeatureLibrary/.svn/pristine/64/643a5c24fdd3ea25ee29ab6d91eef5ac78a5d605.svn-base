function result = waveFeature(image, mask, iter)
%waveFeature computes the wavelet features

% %crop the original image to the masked region
% xmin = maskObj.minRect(1);
% ymin = maskObj.minRect(2);
% xmax = maskObj.minRect(3);
% ymax = maskObj.minRect(4);
% image = imageObj.image(ymin:ymax, xmin:xmax);
% mask = maskObj.image(ymin:ymax, xmin:xmax);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Need to handle non-retangular region %%%%%%
imageMasked = image .* mask;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%wavelet transform by 'iter' levels
[C, S] = wavedec2(imageMasked, iter, 'sym12');    %C, S are conventions from Matlab
n = length(C);

%inverse transform starting from level 1
idx2 = n;   %pointing to the end of a vector
counter = 0;
result = zeros(1, 2*3*iter);
for i = 1:iter
    rows = S(end - i, 1);
    cols = S(end - i, 2);
    for j = 1:3;
        idx1 = idx2 - rows * cols;  %pointing to one before the begin of a vector
        Ctemp = zeros(size(C));
        Ctemp(idx1+1:idx2) = C(idx1+1:idx2);
        imgRec = waverec2(Ctemp, S, 'sym12');
        
        counter = counter + 1;
        result(2*counter - 1) = moment(imgRec(:), 2);
        result(2*counter) = moment(imgRec(:), 4);
        
        idx2 = idx1;
    end
end