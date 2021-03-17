function runLenMatObj = calcRunLenMat(image, mask, dir, numGray)
%This function calculates the run-length matrix based on the image and
%associated mask
% %image: image object
% %mask: mask object
%dir: direction defined by angle, ie 0, 45, 90, or 135
%the returned value is a run-length matrix object, which contains the min
%and max gray levels

global runLenMatrix;    %shared with functions in this file only
if isempty(find(~ismember(dir, [0 45 90 135]), 1))
%     %Crop the patient and mask images to roi, defined by mask.minRect
%     roiImage = image.image(mask.minRect(2):mask.minRect(4), mask.minRect(1):mask.minRect(3));
%     roiMask = mask.image(mask.minRect(2):mask.minRect(4), mask.minRect(1):mask.minRect(3));
% %     roiImageMasked = roiImage.*roiMask;
g_05 = round(quantile(image(mask ~= 0), 0.05));
g_95 = round(quantile(image(mask ~= 0), 0.95));
deltaG=g_95-g_05;
g_05=g_05-0.3*deltaG;
g_95=g_95+0.3*deltaG;
%modify the mask to exclude the pixels further than 30% from the middle 90%
mask = (image >=g_05 & image <=g_95 & mask ~= 0);
image=round(((image-g_05+0.01)/(g_95-g_05+0.01)).*numGray);
image(image>numGray)=numGray;
image(image<1)=1;
    roiImage = image;
    roiMask = mask;    
    rows = numGray;
    cols = max(size(roiMask, 1), size(roiMask, 2));
%     cols = max(mask.minRect(3)-mask.minRect(1), mask.minRect(4)-mask.minRect(2)) + 1;
    pages = length(dir);
    runLenMatrix = zeros(rows, cols, pages);
    runLenMax = 1;
    
    for k = 1:pages
        switch dir(k)
            case 0
                vectStart = [1, 1];
                vectDir = [0, 1];
                vectMove = [1, 0];
            case 45
                vectStart = [1, 1];
                vectDir = [-1, 1];
                vectMove = [1, 0; 0, 1];
            case 90
                vectStart = [1, 1];
                vectDir = [1, 0];
                vectMove = [0, 1];
            case 135
                vectStart = [1, size(roiMask,2)];%Changed because it crashed for square matrices FD 10/19/2011
                vectDir = [1, 1];
                vectMove = [0, -1; 1, 0];
        end

        for vectMvDir = 1:size(vectMove, 1)
            while (vectStart(1) >0 && vectStart(1) <= size(roiImage, 1) && ...
                   vectStart(2) >0 && vectStart(2) <= size(roiImage, 2))
                %extract vectors from roi_image and roi_mask
                imgVect = extractVect(roiImage, vectStart, vectDir);
                maskVect = extractVect(roiMask, vectStart, vectDir);
                runLenMax = runLenMatrixUpdate(imgVect, maskVect, 1, runLenMax);
                vectStartPrev = vectStart;
                vectStart = nextVectStart(vectStart, vectMove(vectMvDir, :));
            end
            %when vector moves out of the image
            if vectMvDir < size(vectMove, 1)
                vectStart = nextVectStart(vectStartPrev, vectMove(vectMvDir+1, :));
            end
        end
    end
    runLenMatObj = runLenMat(runLenMatrix(:, 1:runLenMax), 1, numGray, runLenMax);
else
    error('Direction can only take values of 0, 45 90, and 135.');
end

%% find the min and max gray level in the masked region of an image
function [min, max] = getGrayLevel(image, mask)

[m, n] = size(image);
[rowIdx, colIdx] = find(mask, 1);
min = image(rowIdx, colIdx);
max = min;
for i = 1:m
    for j = 1:n
        if mask(i, j) == 1
            if image(i, j) < min
                min = image(i, j);
            elseif image(i, j) > max
                max = image(i, j);
            end
        end
    end
end

%% retunrs a vector defined by vStart and vDir from a matrix
function vect = extractVect(mat, vStart, vDir)

[m, n] = size(mat);
vect = zeros(1, max(m, n)); %vector initialized as max length
idxCurr = vStart;
count = 0;

while (idxCurr(1) > 0 && idxCurr(1) <= m && ...
       idxCurr(2) > 0 && idxCurr(2) <= n)
    count = count + 1;
    vect(count) = mat(idxCurr(1), idxCurr(2));
    idxCurr = idxCurr + vDir;
end

vect(count+1:end) = [];

%% update the run-length matrix
function runLenMax = runLenMatrixUpdate(imgVect, maskVect, glevelMin, runLenMax)

global runLenMatrix;
ptr1 = 1;
vLen = length(imgVect);

while ptr1 <= vLen
    %find the continuous masked region
    %find the first pixel in the masked region
    while (ptr1 <= vLen && maskVect(ptr1) == 0)
        ptr1 = ptr1 + 1;
    end
    %if the image vector contains a masked region
    if ptr1 <= vLen
        ptr2 = ptr1 + 1;
        %find the last pixel in the masked region
        while (ptr2 <= vLen && maskVect(ptr2) == 1)
            ptr2 = ptr2 + 1;
        end
        ptr2 = ptr2 - 1;
        maskedImgVect = imgVect(ptr1:ptr2);

        %calculate run-length matrix based on the masked image vector
        ptrNew1 = 1;
        ptrNew2 = ptrNew1 + 1;
        mivLen = length(maskedImgVect);
        while (ptrNew1 <= mivLen)
            while (ptrNew2 <= mivLen && ...
                   maskedImgVect(ptrNew2) == maskedImgVect(ptrNew1))
                ptrNew2 = ptrNew2 + 1;
            end
            %ptrNew2 points to the index after the run
            runLen = ptrNew2 - ptrNew1;
            if runLen > runLenMax
                runLenMax = runLen;
            end

            %update run-length matrix
            rowIdx = maskedImgVect(ptrNew1) - glevelMin + 1;
            colIdx = runLen;
            runLenMatrix(rowIdx, colIdx) = runLenMatrix(rowIdx, colIdx) + 1;
            ptrNew1 = ptrNew2;
            ptrNew2 = ptrNew1 + 1;
        end
        ptr1 = ptr2 + 1;
    end
end

%% calculate the next vector start index
function nextStart = nextVectStart(currStart, moveDir)

nextStart = currStart + moveDir;
