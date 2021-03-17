function plot_3dMaterial2()
global ROI DXAroi_material ctrl BreastMask Outline DensityImageSkin
global DensityImageSkin
% thickness_mapproj AND DXAroi_thickness were calculated on
% "MaskROIprojTotal" which is the area delimited by the skin.

x = (1:3:ROI.columns)*0.014;
y = (1:3:ROI.rows)*0.014;

[X,Y] = meshgrid(x,y);

%% DXAroi_material smoothing (or else the noise prevents from seeing anything):
% DXAroi_material2 = medfilt2(DXAroi_material, [8 8]);
H = fspecial('disk',6); % other option for first filter
DXAroi_material2 = imfilter(DXAroi_material,H,'replicate');
DXAroi_material2 = funcGradientGauss(DXAroi_material2,9); % Gaussian Filter

DXAroi_material2= funcclim(DXAroi_material2,0,100);

H = fspecial('disk',6); % other option for first filter
DensityImageSkin2 = imfilter(DensityImageSkin,H,'replicate');
DensityImageSkin2 = funcGradientGauss(DensityImageSkin2,9);

%% if it is a manual rectangular ROI
if ~get(ctrl.CheckAutoROI,'value') % if it is a manual rectangular ROI, ie Auto ROI is UNchecked

    DXAroi_materialROI=DXAroi_material2(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1);
    DensityImageSkinROI= DensityImageSkin2(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1);
    x = (1:3:ROI.columns)*0.014;
    y = (1:3:ROI.rows)*0.014;
    [X,Y] = meshgrid(x,y);

    %% Plot SXA Thickness Map
    figure;surfl(X,Y,DensityImageSkinROI(1:3:end,1:3:end)); title('SXA Material MapROI', 'Fontsize', 14);camlight left; shading interp; colormap(gray); %lighting phong

    % Plot DXA Thickness Map
    figure;surfl(X,Y,DXAroi_materialROI(1:3:end,1:3:end)); title('"Smooth" DXA Material MapROI', 'Fontsize', 14);camlight left; shading interp; colormap(gray);
%     zlim([0 6]);
    % Calculate the difference : SXA Thickness Map - DXA Thickness Map
    diff_thicknessROI = DensityImageSkinROI(1:3:end,1:3:end) - DXAroi_materialROI(1:3:end,1:3:end);

    figure;surfl(X,Y,diff_thicknessROI);
    title('Difference SXA Material MapROI - DXA Material MapROI', 'Fontsize', 14); camlight left; shading interp; colormap(gray);

else
%% if it is a manual ROI drawn by placing points
    if ~get(ctrl.CheckAutoSkin,'value') % if it is a manual ROI where you put points, ie Auto Skin detection is UNchecked

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

        DXAroi_materialROIManual = funcclim(DXAroi_material2.*BreastMaskManual,0,100);
        DensityImageSkinROIManual = funcclim(DensityImageSkin2.*BreastMaskManual,0,100);

        %% Plot SXA material Map
        figure;surfl(X,Y,DensityImageSkinROIManual(1:3:end,1:3:end)); title('SXA material MapROIManual', 'Fontsize', 14);camlight left; shading interp; colormap(gray); %lighting phong

        % Plot DXA material Map
        figure;surfl(X,Y,DXAroi_materialROIManual(1:3:end,1:3:end)); title('"Smooth" DXA material MapROIManual', 'Fontsize', 14);camlight left; shading interp; colormap(gray);
%         zlim([0 6]);
        % Calculate the difference : SXA material Map - DXA material Map
        diff_materialROI = DensityImageSkinROIManual(1:3:end,1:3:end) - DXAroi_materialROIManual(1:3:end,1:3:end);

        figure;surfl(X,Y,diff_materialROI);
        title('Difference SXA material - DXA material MapROIManual', 'Fontsize', 14); camlight left; shading interp; colormap(gray);




%% if it is on the whole breast
    else

        % % Plot current image material Map
        % image=Image.image(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1);
        % figure;surfl(X,Y, image(1:3:end,1:3:end)); title('Current image 3D Map', 'Fontsize', 14);camlight left; shading interp; colormap(gray);



        %% Plot SXA material Map
        figure;surfl(X,Y,DensityImageSkin2(1:3:end,1:3:end)); title('SXA material Map', 'Fontsize', 14);camlight left; shading interp; colormap(gray); %lighting phong

        % Plot DXA material Map
        figure;surfl(X,Y,DXAroi_material(1:3:end,1:3:end)); title('DXA material Map', 'Fontsize', 14);camlight left; shading interp; colormap(gray);
        % zlim([0 6]);
        figure;surfl(X,Y,DXAroi_material2(1:3:end,1:3:end)); title('"Smooth" DXA material Map', 'Fontsize', 14);camlight left; shading interp; colormap(gray);
        % zlim([0 6]);
        % Calculate the difference : SXA material Map - DXA material Map
        diff_Material = DensityImageSkin2(1:3:end,1:3:end) - DXAroi_material2(1:3:end,1:3:end);

        figure;surfl(X,Y,diff_Material);
        title('Difference SXA Material Map - DXA Material Map', 'Fontsize', 14); camlight left; shading interp; colormap(gray);

%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         %%%% The same with CROPPED values
% 
% 
%         %% DXAroi_material smoothing (or else the noise prevents from seeing anything):
%         % DXAroi_material2 = medfilt2(DXAroi_material, [8 8]);
%         H = fspecial('disk',6); % other option for first filter
%         DXAroi_materialCrop2 = imfilter(DXAroi_materialCrop,H,'replicate');
%         DXAroi_materialCrop2 = funcGradientGauss(DXAroi_materialCrop2,9); % Gaussian Filter
% 
% 
%         %% Plot SXA material Map
%         figure;surfl(X,Y,material_mapprojCrop(1:3:end,1:3:end)); title('SXA MaterialCrop Map', 'Fontsize', 14);camlight left; shading interp; colormap(gray); %lighting phong
% 
%         % Plot DXA material Map
%         figure;surfl(X,Y,DXAroi_materialCrop(1:3:end,1:3:end)); title('DXA MaterialCrop Map', 'Fontsize', 14);camlight left; shading interp; colormap(gray);
%         % zlim([0 6]);
%         figure;surfl(X,Y,DXAroi_materialCrop2(1:3:end,1:3:end)); title('"Smooth" DXA MaterialCrop Map', 'Fontsize', 14);camlight left; shading interp; colormap(gray);
%         % zlim([0 6]);
%         % Calculate the difference : SXA material Map - DXA Material Map
%         diff_material = material_mapprojCrop(1:3:end,1:3:end) - DXAroi_materialCrop2(1:3:end,1:3:end);
% 
%         figure;surfl(X,Y,diff_Material);
%         title('Difference SXA MaterialCrop Map - DXA MaterialCrop Map', 'Fontsize', 14); camlight left; shading interp; colormap(gray);


    end
end
end

