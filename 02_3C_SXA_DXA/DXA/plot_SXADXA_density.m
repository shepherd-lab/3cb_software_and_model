%%%%%%%%% one a single whole breast, plot the SXA %Density as a function of the DXA%Density
%
% Aurelie 04/23/08


global ROI DXAroi_material DXAroi_thickness
global DensityImageSkin thickness_mapproj
global Image BreastMask ctrl Outline

clear SXA_result DXA_result

x = (1:3:ROI.columns)*0.014;
y = (1:3:ROI.rows)*0.014;

image=Image.image(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1);
[X,Y] = meshgrid(x,y);

%% DXAroi_material smoothing (or else the noise prevents from seeing anything):
DXAroi_material2 = medfilt2(DXAroi_material, [8 8]);
DXAroi_material2 = funcGradientGauss(DXAroi_material2,9);
DXAroi_material2= funcclim(DXAroi_material2,-50,200);

H = fspecial('disk',6); % other option for first filter
DXAroi_thickness2 = imfilter(DXAroi_thickness,H,'replicate');
DXAroi_thickness2 = funcGradientGauss(DXAroi_thickness2,9); % Gaussian Filter

H = fspecial('disk',6); % other option for first filter
DensityImageSkin2 = imfilter(DensityImageSkin,H,'replicate');
DensityImageSkin2 = funcGradientGauss(DensityImageSkin2,9);
DensityImageSkin2= funcclim(DensityImageSkin2,-50,200);

%% if it is a  manual rectangular ROI
if ~get(ctrl.CheckAutoROI,'value'); % if it is a manual rectangular ROI, ie Auto ROI is UNchecked
    
    SXA_result= funcclim(DensityImageSkin2(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1),-50,200);
    DXA_result=funcclim(DXAroi_material2(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1),-50,200);
    
    SXA_T_result = thickness_mapproj(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1);
    DXA_T_result = DXAroi_thickness2(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1);
    
    x = (1:3:ROI.columns)*0.014;
    y = (1:3:ROI.rows)*0.014;
    [X,Y] = meshgrid(x,y);


    %% if there is a manual ROI drawn by placing points
else

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
        
        SXA_result = funcclim(DensityImageSkin2.*BreastMaskManual,-50,200);
        DXA_result = funcclim(DXAroi_material2.*BreastMaskManual,-50,200);
        
        SXA_T_result = thickness_mapproj.*BreastMaskManual;
        DXA_T_result = DXAroi_thickness2.*BreastMaskManual;
        

        %% if it is the whole breast with auto ROI and auto skin detection
    else
        SXA_result = funcclim(DensityImageSkin,-50,200);
        DXA_result = funcclim(DXAroi_material2,-50,200);
        
        SXA_T_result = thickness_mapproj;
        DXA_T_result = DXAroi_thickness2;
    end

end

SXA_FV_result = SXA_result.*SXA_T_result.*0.014*0.014;
DXA_FV_result = DXA_result.*DXA_T_result.*0.014*0.014;


%% Plot SXA results as a function of DXA results:
[s1,s2]=size(SXA_result); % resize the images into vectors

SXA_result_vector=reshape(SXA_result,1,s1*s2);
DXA_result_vector=reshape(DXA_result,1,s1*s2);

SXA_T_result_vector=reshape(SXA_T_result,1,s1*s2);
DXA_T_result_vector=reshape(DXA_T_result,1,s1*s2);

SXA_FV_result_vector=reshape(SXA_FV_result,1,s1*s2);
DXA_FV_result_vector=reshape(DXA_FV_result,1,s1*s2);

figure;plot(DXA_result_vector,SXA_result_vector, 'b+');
title('SXA Density versus DXA Density on every pixel', 'Fontsize', 14); camlight left; shading interp; colormap(gray);
xlabel('DXA %Density'); ylabel('SXA %Density')
axis([0 100 0 100]); hold on


%% save results in a text file:
y=[];
y(:,1)=SXA_result_vector;y(:,2)=SXA_T_result_vector;y(:,3)=SXA_FV_result_vector;
y(:,4)=DXA_result_vector;y(:,5)=DXA_T_result_vector;y(:,6)=DXA_FV_result_vector;
save('U:\alaidevant\Reports\Phantom_composition\SXAvsDXA\results.txt', 'y', '-ascii')


