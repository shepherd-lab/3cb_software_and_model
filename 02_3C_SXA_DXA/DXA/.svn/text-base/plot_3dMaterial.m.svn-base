function plot_3dMaterial()
global ROI thickness_mapproj DXAroi_material Image Analysis BreastMask ctrl Outline

x = (1:3:ROI.columns)*0.014;
y = (1:3:ROI.rows)*0.014;

image=Image.image(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1);
[X,Y] = meshgrid(x,y);

%% DXAroi_material smoothing (or else the noise prevents from seeing anything):
DXAroi_material2 = medfilt2(DXAroi_material, [8 8]);
% H = fspecial('disk',9);
%       image = imfilter(image,H,'replicate');
      DXAroi_material2 = funcGradientGauss(DXAroi_material2,9);

%% if it is a rectangular ROI
if get(ctrl.CheckAutoSkin,'value') % if it is a rectangular ROI


%% if there is a manual ROI drawn by placing points    
else 
    BreastMask = [];
    [C,I]=max(Outline.x);
    Npoint=size(Outline.x,2);
    innerline1_x=Outline.x(1:I-1);
    innerline1_y=Outline.y(1:I-1);
    innerline2_x=Outline.x(Npoint:-1:Npoint-I+2);
    innerline2_y=Outline.y(Npoint:-1:Npoint-I+2);

    ImageDensity=0;
    y1=min(innerline2_y,innerline1_y);
    y2=max(innerline2_y,innerline1_y);

    BreastMaskManual=zeros(size(ROI.image));
    for x=1:I-1
        BreastMaskManual(y1(x):y2(x),x)=1;
    end
    
    SXADensityImageTotal = funcclim(Analysis.SXADensityImageTotal.*BreastMaskManual,-50,200);
    DXAroi_material = funcclim(DXAroi_material.*BreastMaskManual,-50,200);
end

% Plot current image Thickness Map
figure;surfl(X,Y, image(1:3:end,1:3:end)); title('Current image 3D Map', 'Fontsize', 14);camlight left; shading interp; colormap(gray);

% Plot SXA Density Map
figure;surfl(X,Y,SXADensityImageTotal(1:3:end,1:3:end)); title('SXA Density Map', 'Fontsize', 14);camlight left; shading interp; colormap(gray); %lighting phong

% Plot DXA Density Map
figure;surfl(X,Y,DXAroi_material(1:3:end,1:3:end)); title('DXA Density Map', 'Fontsize', 14);camlight left; shading interp; colormap(gray);
% zlim([0 6]);
figure;surfl(X,Y,DXAroi_material2(1:3:end,1:3:end)); title('"Smooth" DXA Density Map', 'Fontsize', 14);camlight left; shading interp; colormap(gray);
% zlim([0 6]);
% Calculate the difference : SXA Density Map - DXA Density Map
diff_material = SXADensityImageTotal(1:3:end,1:3:end) - DXAroi_material2(1:3:end,1:3:end);

figure;surfl(X,Y,diff_material);
title('Difference SXA Density Map - DXA Density Map', 'Fontsize', 14); camlight left; shading interp; colormap(gray);





