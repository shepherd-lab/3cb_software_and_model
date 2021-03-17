function plot_3dMap()
global ROI Image BreastMask ctrl Outline


%% if it is a rectangular ROI
if get(ctrl.CheckAutoSkin,'value') % if it is a rectangular ROI

    image=Image.image(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1);

% x = (1:3:ROI.columns-2)*0.014;
% y = (1:3:ROI.rows-2)*0.014;
x = (1:ROI.columns)*0.014;
y = (1:ROI.rows)*0.014;
    [X,Y] = meshgrid(x,y);

    % image smoothing (or else the noise prevents from seeing anything):
% image = medfilt2(image, [8 8]);
% H = fspecial('disk',9);
%       image = imfilter(image,H,'replicate');
image = funcGradientGauss(image,2);
% image=image(2:ROI.rows-1,2:ROI.columns-1);
image=image(1:ROI.rows,1:ROI.columns);

figure;surfl(Y,X, image(1:end,1:end)); camlight left; shading interp; colormap(gray);
ylabel('cm','fontsize',14);xlabel('cm','fontsize',14);zlabel('cm','fontsize',14);
% zaxis([0 7]);

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
    image = funcclim(Image.image(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1).*BreastMaskManual,-50,200);
    
    H = fspecial('disk',9);
      image = imfilter(image,H,'replicate');
image = funcGradientGauss(image,9);
image=image(1:ROI.rows,1:ROI.columns);
    
x = (1:3:ROI.columns)*0.014;
y = (1:3:ROI.rows)*0.014;
    [X,Y] = meshgrid(x,y);

% image smoothing (or else the noise prevents from seeing anything):
image = medfilt2(image, [8 8]);
% H = fspecial('disk',6);
%       image = imfilter(image,H,'replicate');
image = funcGradientGauss(image,3);


figure;surfl(X,Y, image(1:3:end,1:3:end)); camlight left; shading interp; colormap(gray);
    
end

