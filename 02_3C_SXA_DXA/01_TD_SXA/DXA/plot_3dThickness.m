function plot_3dThickness()
    global ROI  thickness_mapproj DXAroi_thickness Analysis
     res = Analysis.Filmresolution/10;
     x = (1:3:ROI.columns)*res; %0.014;
     y = (1:3:ROI.rows)*res; %0.014;
     [X,Y] = meshgrid(x,y);
       
     figure;surfl(X,Y,thickness_mapproj(1:3:end,1:3:end)); camlight left; shading interp; colormap(gray); %lighting phong
     figure;surfl(X,Y,DXAroi_thickness(1:3:end,1:3:end)); camlight left; shading interp; colormap(gray);
     diff_thickness = thickness_mapproj(1:3:end,1:3:end) - DXAroi_thickness(1:3:end,1:3:end);
     figure;surfl(X,Y,diff_thickness); camlight left; shading interp; colormap(gray);
     camlight left
     shading interp
     colormap(gray);
     %zlim([0 10]);
     