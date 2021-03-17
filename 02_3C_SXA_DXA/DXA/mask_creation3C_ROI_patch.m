function mask_creation3C_ROI()
     global Image Tmask3C Tmaskones ROI
         
   Tmask3C = zeros(size(Image.image));
   Tmaskones= zeros(size(Image.image));
%% input the thicknesses to put in the mask:
roi_thickness = [4.959,4.486,4.661,4.317,4.317,4.159,4.159,4.078];
roi_Twater=[4,2,4,2,4,2,4,2];
roi_Tfat=[0,2,0,2,0,2,0,2];

 
%% load the template file:
file_name='\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\AL_SeleniaData\templates\20090122_4cmstep_3C_reduced4.txt';

coord=load(file_name, '-ascii');  
   t1=[1 221/255 100/255]; %231/255 186/255
   tcolor1 = [t1; t1;t1;t1;t1;t1]; % NavajoWhite1 %% first stack for water
%      [X,Y,Z] = peaks(30);
%      surfc(X,Y,Z);
%      colormap hsv
%      axis([-3 3 -3 3 -10 5])
     x_coord(:,1:2) = (coord(:,1:2)-ROI.xmin)*0.014;
     y_coord(:,1:2) = (coord(:,3:4)-ROI.ymin)*0.014;
     faces_matr = [1 2 6 5; 2 3 7 6;3 4 8 7; 4 1 5 8; 1 2 3 4; 5 6 7 8]; % cube definition
     figure;
    for i=1:size(coord,1)
%         funcbox(x_coord(i,1),y_coord(i,1),x_coord(i,2),y_coord(i,2),'blue
%         '); 
        x_rect = [x_coord(i,1) x_coord(i,2) x_coord(i,2) x_coord(i,1)];
        y_rect = [y_coord(i,1) y_coord(i,1) y_coord(i,2) y_coord(i,2)];
        vertex_matr = [[y_rect';y_rect'],[x_rect';x_rect']];
        vertex_matr(:,3) = [roi_Tfat(i);roi_Tfat(i);roi_Tfat(i);roi_Tfat(i);roi_Twater(i)+roi_Tfat(i);roi_Twater(i)+roi_Tfat(i);roi_Twater(i)+roi_Tfat(i);roi_Twater(i)+roi_Tfat(i)]; % z thickness
        
        patch('Vertices',vertex_matr, 'Faces', faces_matr,'FaceVertexCData',tcolor1,'FaceColor','flat'); hold on;
        ylabel('cm','fontsize',14);xlabel('cm','fontsize',14);zlabel('cm','fontsize',14);
%         axis([ROI.xmin ROI.rows*0.014 0 ROI.columns*0.014 0 5]);
        view(3); 
        view([-37.5 30]);grid('on'); %-37.5 30
        title('Total thickness', 'Fontsize',14);
        
     %         axis square;
    end
   
     tcolor2 = [0 0 1; 0 0 1;0 0 1;0 0 1;0 0 1;0 0 1]; % BLUE %% second stack fat
     t2=[0.7 0.5 0.2 ]; %231/255 186/255
   tcolor2 = [t2; t2;t2;t2;t2;t2]; 
    for i=1:size(coord,1)
            if roi_Tfat(i)~=0;
%             funcbox(x_coord(i,1),y_coord(i,1),x_coord(i,2),y_coord(i,2),'blue'); 
            x_rect = [x_coord(i,1) x_coord(i,2) x_coord(i,2) x_coord(i,1)];
            y_rect = [y_coord(i,1) y_coord(i,1) y_coord(i,2) y_coord(i,2)];
           vertex_matr = [[y_rect';y_rect'],[x_rect';x_rect']];
             vertex_matr(:,3) = [0;0;0;0;2;2;2;2];
            patch('Vertices',vertex_matr, 'Faces', faces_matr,'FaceVertexCData',tcolor2,'FaceColor','flat'); hold on;
            view(3); 
            view([-37.5 30]);grid('on');
        else
        end
    end
    
    tcolor3 = [199 199 199; 199 199 199;199 199 199;199 199 199;199 199 199;199 199 199]; %%% third stack protein
    for i=1:size(coord,1)
%             funcbox(x_coord(i,1),y_coord(i,1),x_coord(i,2),y_coord(i,2),'blue'); 
            x_rect = [x_coord(i,1) x_coord(i,2) x_coord(i,2) x_coord(i,1)];
            y_rect = [y_coord(i,1) y_coord(i,1) y_coord(i,2) y_coord(i,2)];
            vertex_matr = [[y_rect';y_rect'],[x_rect';x_rect']];
             vertex_matr(:,3) = [4;4;4;4;roi_thickness(i);roi_thickness(i);roi_thickness(i);roi_thickness(i)];
            patch('Vertices',vertex_matr, 'Faces', faces_matr,'FaceVertexCData',tcolor3,'FaceColor','flat'); hold on;
            view(3); 
            view([-37.5 30]);grid('on');
        
    end
    %T = view
    view([-50 40]);grid('on');
   
    a = 1;
    
    
      
       