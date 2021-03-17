function tophatFiltered = TOPHAT()
global Image ROI Analysis R0 thickness_mapproj BreastMask
% original = Image.image.*~Analysis.BackGround;
gamma = 1.4;
mn = mean(mean(thickness_mapproj));
original = Image.image;
MaskROIproj = thickness_mapproj>mn/10;
MaskROIproj2 = thickness_mapproj>mn/1.5;
im_size = size(Image.image);
breast_mask = zeros(im_size);
breast_mask2 = breast_mask;
mask = double(MaskROIproj);
mask2 = double(MaskROIproj2);

% breast_mask(ROI.ymin+1:ROI.ymin+ROI.rows,ROI.xmin+1:ROI.xmin+ROI.columns) = mask;
breast_mask(ROI.ymin+1:ROI.ymin+ROI.rows,ROI.xmin+1:ROI.xmin+ROI.columns) =  BreastMask;
% breast_mask2(ROI.ymin+1:ROI.ymin+ROI.rows,ROI.xmin+1:ROI.xmin+ROI.columns) = mask2;
SE100 =  strel('disk',100);
SE200 =  strel('disk',200);
SE300 =  strel('disk',300);

breast_mask2 = imerode(breast_mask,SE100);
% breast_mask3 = imdilate(breast_mask,SE300);
ima1 = bwdist(breast_mask);
breast_mask3 = ima1<200;

% figure;imagesc(breast_mask2);colormap(gray);
diff_mask = breast_mask.*(~breast_mask2);
% temp =original.*diff_mask;
ind= find(diff_mask==1);
mn = mean(original(ind));

add_mask = breast_mask3.*(~breast_mask);
original2 = original;
original2(add_mask==1)=mn;
% R0 = funcclim(R0,-100,200);
% original = imread('rice.png');
%  figure, imagesc(original2);colormap(gray);

se = strel('disk',100);
se2 = strel('disk',2);

% sz = size(original);
% temp = zeros(sz(1),sz(2)+300);
% temp(:,201:end,:) = original;
% temp(:,1:200) = repmat(original(:,1),1,200);
% temp2 = imtophat(temp,se);
% tophatFiltered = temp2(301:end,:);

tophatFiltered = imtophat(original2,se);

% figure; imagesc(tophatFiltered);colormap(gray);

%do not know why
original3 = tophatFiltered.*breast_mask2;

%% 
% immax = max(max(original2));
%  ImgVector = reshape(original2, 1, []);
 ImgVector = original3(original3~=0);
ImgVector = sortrows(ImgVector);
        %prctile(sorted_array_B,99);
        B= ImgVector;
        %%%%%%%
        [sorted_array_B,posB]= sort(B');
        [sorted_array_BB,posBB]= sort(posB);
        % 99 percentile Intensity of ROI image
        immax = prctile(sorted_array_B,99.99);

%%
tophatFiltered = ((tophatFiltered / immax).^ (1/gamma)) * immax;
% tophatFiltered = tophatFiltered.*~Analysis.BackGround;


 tophatFiltered = imsharpen(tophatFiltered,'Radius',2,'Amount',1);
 tophatFiltered = medfilt2(tophatFiltered, [3 3]);
% tophatFiltered = imopen(tophatFiltered,se2);

tophatFiltered = funcclim(tophatFiltered,0,immax);
tophatFiltered = tophatFiltered.*breast_mask;
tophatFiltered(~breast_mask) = -immax/13.8; % -500;
% Image.image = tophatFiltered;
% draweverything;
% figure; imagesc(tophatFiltered);colormap(gray);
% figure; imagesc(tophatFiltered);colormap(gray);
a = 1;
%imwrite(uint16(tophatFiltered),);
% 
% contrastAdjusted = imadjust(tophatFiltered);
% figure, imagesc(contrastAdjusted);colormap(gray);

%%
% original = imread('rice.png');
% figure, imshow(original)
% se = strel('disk',12);
% 
% tophatFiltered = imtophat(gpuArray(original),se);
% figure, imshow(tophatFiltered)
% contrastAdjusted = imadjust(gather(tophatFiltered));
% figure, imshow(contrastAdjusted)

end

