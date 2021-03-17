function plot_3dMaterial()
global ROI thickness_mapproj DXAroi_material DXAroi_materialManual Image Analysis BreastMask ctrl Outline DXAroi_thickness DXAroi_thicknessManual
global BreastMaskManual

x = (1:3:ROI.columns)*0.014;
y = (1:3:ROI.rows)*0.014;

image=Image.image(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1);
[X,Y] = meshgrid(x,y);

    %% DXAroi_material smoothing (or else the noise prevents from seeing anything):
DXAroi_thickness2 = medfilt2(DXAroi_thickness, [8 8]);
% H = fspecial('disk',6);
%       image = imfilter(image,H,'replicate');
      DXAroi_thickness2 = funcGradientGauss(DXAroi_thickness2,9);
% DXAroi_thickness=DXAroi_thickness(4:ROI.rows-3,4:ROI.columns-3);

DXAroi_material2 = medfilt2(DXAroi_material, [8 8]);
% H = fspecial('disk',6);
%       image = imfilter(image,H,'replicate');
      DXAroi_material2 = funcGradientGauss(DXAroi_material2,9);
% DXAroi_material=DXAroi_material(4:ROI.rows-3,4:ROI.columns-3);

%% if it is a rectangular ROI
if get(ctrl.CheckAutoSkin,'value') % if it is a rectangular ROI
  
    SXADensityImage = funcclim(Analysis.SXADensityImageTotal.*BreastMask,-50,200);
    SXADenseVolumeImage = 1/100*SXADensityImage.*thickness_mapproj*(0.014)^2;
    
    DXADenseVolumeImage = 1/100*DXAroi_material .*DXAroi_thickness *(0.014)^2;

%% if there is a manual ROI drawn by placing points    
else 
       
DXAroi_thicknessManual2 = DXAroi_thickness2.*BreastMaskManual;

DXAroi_materialManual2 = DXAroi_material2.*BreastMaskManual;
    
    SXADensityImage = funcclim(Analysis.SXADensityImageTotal.*BreastMaskManual,-50,200);
    SXADenseVolumeImage = 1/100*SXADensityImage.*thickness_mapproj*(0.014)^2;
    sum(sum(SXADenseVolumeImage))
    DXADenseVolumeImage2 = 1/100*DXAroi_materialManual2 .*DXAroi_thicknessManual2 *(0.014)^2;
    sum(sum(DXADenseVolumeImage2))
end

%% Plot current image Thickness Map
figure;surfl(X,Y, image(1:3:end,1:3:end)); title('Current image 3D Map', 'Fontsize', 14);camlight left; shading interp; colormap(gray);

% Plot SXA Dense Volume Map
figure;surfl(X,Y,SXADenseVolumeImage(1:3:end,1:3:end)); title('SXA Dense Volume Map', 'Fontsize', 14);camlight left; shading interp; colormap(gray); %lighting phong

% Plot DXA Dense Volume Map
% figure;surfl(X,Y,DXADenseVolumeImage(1:3:end,1:3:end)); title('DXA Dense Volume Map', 'Fontsize', 14);camlight left; shading interp; colormap(gray);
% zlim([0 6]);
figure;surfl(X,Y,DXADenseVolumeImage2(1:3:end,1:3:end)); title('"Smooth" DXA Dense Volume Map', 'Fontsize', 14);camlight left; shading interp; colormap(gray);
% zlim([0 6]);
% Calculate the difference : SXA Dense Volume Map - DXA Dense Volume Map
diff_densevolume = SXADenseVolumeImage(1:3:end,1:3:end) - DXADenseVolumeImage2(1:3:end,1:3:end);

% Calculate the difference : SXA Density Map - DXA  Density Map
diff_material = SXADensityImage(1:3:end,1:3:end) - DXAroi_materialManual2(1:3:end,1:3:end);

% Calculate the difference : SXA thickness Map - DXA  thickness Map
diff_thickness = thickness_mapproj(1:3:end,1:3:end).*BreastMaskManual(1:3:end,1:3:end) - DXAroi_thicknessManual2(1:3:end,1:3:end);

figure;surfl(X,Y,diff_densevolume);
title('Difference SXA Dense Volume Map - DXA Dense Volume Map', 'Fontsize', 14); camlight left; shading interp; colormap(gray);

figure;surfl(X,Y,diff_material);
title('Difference SXA density Map - DXA density Volume Map', 'Fontsize', 14); camlight left; shading interp; colormap(gray);

figure;surfl(X,Y,diff_thickness);
title('Difference SXA thickness Map - DXA thickness Map', 'Fontsize', 14); camlight left; shading interp; colormap(gray);




