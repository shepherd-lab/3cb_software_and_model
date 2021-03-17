function plot_3dThickness()
global ROI  thickness_mapproj DXAroi_thickness Image thickness_mapprojCrop DXAroi_thicknessCrop ctrl BreastMask Outline
% thickness_mapproj AND DXAroi_thickness were calculated on
% "MaskROIprojTotal" which is the area delimited by the skin.

x = (1:3:ROI.columns)*0.014;
y = (1:3:ROI.rows)*0.014;

[X,Y] = meshgrid(x,y);

%% DXAroi_thickness smoothing (or else the noise prevents from seeing anything):
% DXAroi_thickness2 = medfilt2(DXAroi_thickness, [8 8]);
H = fspecial('disk',6); % other option for first filter
DXAroi_thickness2 = imfilter(DXAroi_thickness,H,'replicate');
DXAroi_thickness2 = funcGradientGauss(DXAroi_thickness2,9); % Gaussian Filter


%% if it is a manual rectangular ROI
if ~get(ctrl.CheckAutoROI,'value') % if it is a manual rectangular ROI, ie Auto ROI is UNchecked

    DXAroi_thicknessROI=DXAroi_thickness2(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1);
    thickness_mapprojROI= thickness_mapproj(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1);
    x = (1:3:ROI.columns)*0.014;
    y = (1:3:ROI.rows)*0.014;
    [X,Y] = meshgrid(x,y);

    %% Plot SXA Thickness Map
    figure;surfl(X,Y,thickness_mapprojROI(1:3:end,1:3:end)); title('SXA Thickness MapROI', 'Fontsize', 14);camlight left; shading interp; colormap(gray); %lighting phong

    % Plot DXA Thickness Map
    figure;surfl(X,Y,DXAroi_thicknessROI(1:3:end,1:3:end)); title('"Smooth" DXA Thickness MapROI', 'Fontsize', 14);camlight left; shading interp; colormap(gray);
    zlim([0 6]);
    % Calculate the difference : SXA Thickness Map - DXA Thickness Map
    diff_thicknessROI = thickness_mapprojROI(1:3:end,1:3:end) - DXAroi_thicknessROI(1:3:end,1:3:end);

    figure;surfl(X,Y,diff_thicknessROI);
    title('Difference SXA Thickness MapROI - DXA Thickness MapROI', 'Fontsize', 14); camlight left; shading interp; colormap(gray);

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

        DXAroi_thicknessROIManual = funcclim(DXAroi_thickness2.*BreastMaskManual,-50,200);
        thickness_mapprojROIManual = funcclim(thickness_mapproj.*BreastMaskManual,-50,200);

        %% Plot SXA Thickness Map
        figure;surfl(X,Y,thickness_mapprojROIManual(1:3:end,1:3:end)); title('SXA Thickness MapROIManual', 'Fontsize', 14);camlight left; shading interp; colormap(gray); %lighting phong

        % Plot DXA Thickness Map
        figure;surfl(X,Y,DXAroi_thicknessROIManual(1:3:end,1:3:end)); title('"Smooth" DXA Thickness MapROIManual', 'Fontsize', 14);camlight left; shading interp; colormap(gray);
        zlim([0 6]);
        % Calculate the difference : SXA Thickness Map - DXA Thickness Map
        diff_thicknessROI = thickness_mapprojROIManual(1:3:end,1:3:end) - DXAroi_thicknessROIManual(1:3:end,1:3:end);

        figure;surfl(X,Y,diff_thicknessROI);
        title('Difference SXA Thickness - DXA Thickness MapROIManual', 'Fontsize', 14); camlight left; shading interp; colormap(gray);




%% if it is on the whole breast
    else

        % % Plot current image Thickness Map
        % image=Image.image(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1);
        % figure;surfl(X,Y, image(1:3:end,1:3:end)); title('Current image 3D Map', 'Fontsize', 14);camlight left; shading interp; colormap(gray);



        %% Plot SXA Thickness Map
        figure;surfl(X,Y,thickness_mapproj(1:3:end,1:3:end)); title('SXA Thickness Map', 'Fontsize', 14);camlight left; shading interp; colormap(gray); %lighting phong

        % Plot DXA Thickness Map
        figure;surfl(X,Y,DXAroi_thickness(1:3:end,1:3:end)); title('DXA Thickness Map', 'Fontsize', 14);camlight left; shading interp; colormap(gray);
        % zlim([0 6]);
        figure;surfl(X,Y,DXAroi_thickness2(1:3:end,1:3:end)); title('"Smooth" DXA Thickness Map', 'Fontsize', 14);camlight left; shading interp; colormap(gray);
        % zlim([0 6]);
        % Calculate the difference : SXA Thickness Map - DXA Thickness Map
        diff_thickness = thickness_mapproj(1:3:end,1:3:end) - DXAroi_thickness2(1:3:end,1:3:end);

        figure;surfl(X,Y,diff_thickness);
        title('Difference SXA Thickness Map - DXA Thickness Map', 'Fontsize', 14); camlight left; shading interp; colormap(gray);

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%% The same with CROPPED values


        %% DXAroi_thickness smoothing (or else the noise prevents from seeing anything):
        % DXAroi_thickness2 = medfilt2(DXAroi_thickness, [8 8]);
        H = fspecial('disk',6); % other option for first filter
        DXAroi_thicknessCrop2 = imfilter(DXAroi_thicknessCrop,H,'replicate');
        DXAroi_thicknessCrop2 = funcGradientGauss(DXAroi_thicknessCrop2,9); % Gaussian Filter


        %% Plot SXA Thickness Map
        figure;surfl(X,Y,thickness_mapprojCrop(1:3:end,1:3:end)); title('SXA ThicknessCrop Map', 'Fontsize', 14);camlight left; shading interp; colormap(gray); %lighting phong

        % Plot DXA Thickness Map
        figure;surfl(X,Y,DXAroi_thicknessCrop(1:3:end,1:3:end)); title('DXA ThicknessCrop Map', 'Fontsize', 14);camlight left; shading interp; colormap(gray);
        % zlim([0 6]);
        figure;surfl(X,Y,DXAroi_thicknessCrop2(1:3:end,1:3:end)); title('"Smooth" DXA ThicknessCrop Map', 'Fontsize', 14);camlight left; shading interp; colormap(gray);
        % zlim([0 6]);
        % Calculate the difference : SXA Thickness Map - DXA Thickness Map
        diff_thickness = thickness_mapprojCrop(1:3:end,1:3:end) - DXAroi_thicknessCrop2(1:3:end,1:3:end);

        figure;surfl(X,Y,diff_thickness);
        title('Difference SXA ThicknessCrop Map - DXA ThicknessCrop Map', 'Fontsize', 14); camlight left; shading interp; colormap(gray);


    end
end
end
