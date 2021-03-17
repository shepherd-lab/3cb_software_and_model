function [origDiff, QBBcoord] = QCwax_bbs_position_manual()

%This function calculates displacement of the world origin w.r.t. the
%mid-point of the whole image and coords of the 7-pair BBs on whole image.

    global Image figuretodraw coord Info Analysis Error ROI Database Result Info%h_init 
%At this point, variable 'ROI' refers to the phantom region. (Song Note 1,
%p14)
%     kGE = 0.71;
%     if Info.DigitizerId == 5 | Info.DigitizerId == 6
%         crop_coef = kGE;
%     else
%         crop_coef = 1;
%     end
%         
%     x_width = 690*crop_coef;
%     y_height = 650*crop_coef;
%     machine = Info.centerlistactivated;
%     sz_image = size(Image.image);
%     
%     if Analysis.second_phantom == false
%         rot_image = Image.image(1:y_height,x_width:end);
%         rot_angle = 31.8;%rot_image2
%         ycoord_shift = 0;
%     else
%         rot_image = Image.image(end-y_height:end,x_width:end);
%         rot_angle =  -31.8;
%         ycoord_shift = sz_image(1)-y_height;
%     end

%Original GEN3 ROI detection is replaced by a new algorithm
%     imsz = size(Image.image);
%     x = [500 500];
%     y = [1 imsz(1)];
%     im_profile = improfile(Image.image,x,y);
%     index_bkgr = find(im_profile > Analysis.BackGroundThreshold);
%     ROI.ymin = min(index_bkgr)-25;
%     if ROI.ymin < 0 %JW 6/4/2010 ROI.ymin in some cases negative, will fail at line 39
%         ROI.ymin = 1
%     end
%     ROI.ymax = max(index_bkgr)+50;
%     ROI.xmin = 1;
%     ROI.rows = ROI.ymax-ROI.ymin;
%     %Added by Song, 1/25/11
%     if strcmpi(strtrim(Info.StudyID), 'Avon')
%         ROI.columns = 850;
%     else
%         ROI.columns = 1200;
%     end
%     %End of modification
%     ROI.image=Image.image(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1);
%     funcBox(ROI.xmin,ROI.ymin,ROI.xmin+ROI.columns,ROI.ymin+ROI.rows,'b',2); 
%     draweverything;
%End of original GEN3 ROI detection

%New Gen3 ROI detection, by Song, 02-09-11
    [rows, cols] = size(Image.image);
    margin = 25;    %define margin size of GEN III ROI

    %set negative pixel to 0
    image = Image.image;
    image(image < max(Analysis.BackGroundThreshold, 0)) = 0;

    %vertical projection to x-axis
    projX = sum(image(floor(rows/2):end, :), 1);
    ROI.xmin = max(find(projX, 1, 'first') - margin, 1);
    ROI.xmax = min(find(projX, 1, 'last') + margin, cols);

    %horizontal projection to y-axis
    projY = sum(image(:, 30:floor(cols/3)), 2);
%     signal3 = improfile(Image.image,:,floor(cols/3));
    ROI.ymin = max(find(projY, 1, 'first') - margin, 1);
    ROI.ymax = min(find(projY, 1, 'last') + margin, rows);
    ROI.ymax = round(ROI.ymax);
    ROI.ymin = round(ROI.ymin);
    ROI.xmax = round(ROI.xmax);
    ROI.xmin = round(ROI.xmin);
    %calculate number of rows and columns in ROI
    ROI.columns = ROI.xmax - ROI.xmin + 1;
    ROI.rows = ROI.ymax - ROI.ymin + 1;

    %crop for roi image
    ROI.image = Image.image(ROI.ymin:ROI.ymax, ROI.xmin:ROI.xmax);
    funcBox(ROI.xmin, ROI.ymin, ROI.xmax, ROI.ymax, 'b', 2);
%End of change
    
    % rot_image = funcclim(rot_image,0,60000);
     rot_image = ROI.image;
    %figure; imagesc(rot_image); colormap(gray);
    bkgr = background_phantomdigital(rot_image);
    %Analysis.BackGroundThreshold = bkgr;
    % Mask0=~(WindowFiltration2D(Image.OriginalImage==0,5)~=0);
    % Analysis.BackGround = Image.image>Analysis.BackGroundThreshold;
    % Analysis.BackGround=(WindowFiltration2D(Analysis.BackGround,3)>0); 
    
% % %     ph_image = rot_image - bkgr;
% % %     max_image = max(max(ph_image))
% % %     a1 = uint8(ph_image/max_image*255); %12600
% % %     %imwrite(rot_image2,'C:\Documents and Settings\smalkov\My Documents\Programs\SXAVersion6.2\phan3_init.tif', 'tif');
% % %    % a = imread('phan3_init.tif', 'tif');
% % %     conn1 = [0 1 0; 0 1 0; 0 1 0];
% % %     %conn1 = conndef(2,'minimal');
% % %    % im_a = imclearborder(a);
% % %     h_phant = figure('Tag','QC_phant');imagesc(a1); colormap(gray);
% % %     sza = size(a1);
% % %   
% % %     %J = imrotate(b,-rot_angle,'bilinear','crop'); %,'crop'28.85 -33,'crop'
% % %     J = rot_image;
% % % %   sza = size(b)
% % %     szJ = size(J)
% % %  
% % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % %  J = rot_image;
% % %     J=a1;
% % % %   sza = size(b)
% % %     szJ = size(J)
% % %       
% % %   
% % %     se5 = strel('disk', 9);
% % %     %se3 = strel('rectangle',[10 9]);%working
% % %     se3 = strel('disk',5);
% % %     %se3 = strel('rectangle',[9 5]);
% % %     %se4 = strel('rectangle',[6 10]);
% % %     %b = imclose(J, se2);
% % %     se2 = strel('rectangle', round([20 40]*crop_coef));
% % %     se22 = strel('rectangle', [40 20]);
% % %     se21 = strel('rectangle', round([100 300]*crop_coef));
% % %     se_1 = round(60*crop_coef);
% % %     se_2 = round(65*crop_coef);
% % %     se = strel('rectangle',[se_1 se_2]);
% % %     J_open = imopen(J,se21); 
% % %     
% % %  %%figure;imagesc(J_open); colormap(gray);
% % %     % hold on;
% % %     
% % %     %Z = imsubtract(J,J_open); %JW replaced with following line
% % %     Z=J; %use original image instead of difference image
% % %       
% % %     se2_1 = round(20*crop_coef);
% % %     se2_2 = round(40*crop_coef);
% % %     se = strel('rectangle',[se2_1 se2_2]);
% % %     
% % %     im_Z = imopen(Z,se2);
% % %     
% % % %  figure;imagesc(im_Z); colormap(gray);
% % %     Zs1 = imsubtract(Z,im_Z);
% % %     
% % % %
% % %     maxz = max(max(Zs1))*0.03; %changed to 0.03 for GE
% % %     bw = Zs1>0.02*max(max(Zs1));
% % %     mm = max(max(Zs1))
% % %     %bw = im2bw(Zs1,0.7);
% % %        
% % %   %imagesc(bw); colormap(gray); 
% % %      se3_1 =  round( 7*crop_coef);%round(7*crop_coef);
% % %      se3 = strel('disk',se3_1);
% % %      BB_image = imerode(bw, se3);
% % %      BB_image2 = imdilate(BB_image, se3);
% % % %   figure;imagesc(BB_image); colormap(gray);
% % %      se3_line = strel('rectangle', round([3 3]*crop_coef));
% % %      %se3 = strel('disk',se3_1);
% % %      bw2 = imerode(bw, se3_line);
% % %      se4 = strel('rectangle', round([20 6]*crop_coef));
% % %      J_open = imopen(bw2,se4); 
% % %      %J_open(:,1:5)=0; %JW remove first 10 columns where lines detected at rear of bookends;
% % %     
% % % %  figure;imagesc(J_open); colormap(gray);
% % %      se3_line = strel('rectangle', round([3 3]*crop_coef));
% % %     % se3_line = strel('disk',  3);
% % %      bw3 = imerode(J_open, se3_line);
% % %      
% % %     
% % %    sz_bw = size(BB_image);
% % %    xmax = sz_bw(2);
% % %    ymax = sz_bw(1);
% % %    sz_origimage = size(Image.image);
% % %    xmax_orig = sz_origimage(2);
% % %    if xmax_orig > 1350
% % %         c = [xmax-150, xmax, xmax];
% % %         r = [1, 1, 150];
% % %         BW_mask = 1-roipoly(bw,c,r);
% % %         %figure;
% % %         %imagesc(BW_mask); colormap(gray)
% % %         BB_image = BB_image.*BW_mask;
% % %    end
% % % 
% % %    % 
% % % % %     figure; imagesc(BB_image); colormap(gray);
% % % %     BB_image = BB_image.*bb_mask;
% % %   % figure; imagesc(BB_image); colormap(gray);
% % %     L = bwlabel(BB_image);
% % %     stats2 = regionprops(L,'all');
% % %     ln = length(stats2)
% % %     figure(h_phant); hold on;
% % %   % axes;
% % % 
% % %   hold on;
% % % 
% % %  Rmin = 4;
% % %   Rmax = 50;
% % %   [centersBright1, radiiBright1, metricBright1] = imfindcircles(Zs1,[Rmin Rmax], ...
% % %                 'ObjectPolarity','bright','Sensitivity',0.85,'EdgeThreshold',0.1)
% % %       
% % %     for i = 1: length(radiiBright1)
% % %         plot(centersBright1(i,1),centersBright1(i,2),'*magenta');
% % %     end    
% % %      
% % % coord = centersBright1;
% % % 
% % % 
% % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % 
% % % 
% % % 
% % % 
% % % 
% % % %by Song: function counting bbs only and ordering them
% % % if size(coord, 1) < 14  %switch to manual selection if BB number < 14
% % %                         %more than 14 BBs may be detected and wrong
% % %                         %detections will be removed by 'findRealBBs( )
% % %     close(h_phant);
% % %     BBcoord = [];
% % %     origDiff = [];
% % % else

   
%%%%%%%% manually put 14 points %%%%%%%%%%%%%%%%%%%%%%
    fname = Info.fname;
    [pathstr,name,ext] = fileparts(fname);
     mat_name = [pathstr,'\coord_bbs_',name(end-3),'.mat']
%       BBcoord_PR=Gen3bbs_manual (rot_image)
%       save(mat_name,'BBcoord_PR');
     load(mat_name)
     
    [BBcoord_crn,group_crn] = findRealBbs_GE(BBcoord_PR) %within ROI
%     groups = groupingPairs_GE(BBcoord_crn); %coord relative to 0,0 corner
     figure(figuretodraw);
for BBidx = 1:14
    plot(BBcoord_PR(BBidx, 1)+ROI.xmin-1, BBcoord_PR(BBidx, 2)+ROI.ymin-1, '.r', 'MarkerSize', 7);hold on;
    text(BBcoord_PR(BBidx, 1)+ROI.xmin-1, BBcoord_PR(BBidx, 2)+ROI.ymin - 71, num2str(BBidx), 'Color', 'g'); hold on;
end


%     for i = 1:length(group_crn)
%     groups(i).coord = toFilmMidCoord(group_crn(i).coord, ROI.xmin, ROI.ymin, rows);
%     end
    origDiff = QCbbs_sorting_GE(group_crn);
    QBBcoord = toFilmMidCoord(BBcoord_crn, ROI.xmin, ROI.ymin, rows);
% % % end
    %translate the PR coord to the whole film coord with the mid-point of
    %film as the origin


% This part of code is used for viewing the BB finding results
% h_LabelBB = figure('Tag','Labeling_BBs'); imagesc(a1); colormap(gray);
% hold on;
%  figure();imagesc(rot_image);colormap(gray); hold on;
 figure(figuretodraw);
for BBidx = 1:14
    plot(BBcoord_PR(BBidx, 1)+ROI.xmin, BBcoord_PR(BBidx, 2)+ROI.ymin, '.r', 'MarkerSize', 7);hold on;
    text(BBcoord_PR(BBidx, 1)+ROI.xmin, BBcoord_PR(BBidx, 2)+ROI.ymin - 70, num2str(BBidx), 'Color', 'g'); hold on;
end
% pause;
% close(h_LabelBB);
% asdfghkl;   %this will generate error, so stop following analysis and database writing

%JW 6/3/10 added to record bb locations in SQL table
% [QCGen3BBlocations_id]=cell2mat(mxDatabase(Database.Name,['SELECT MAX(QCGen3BBlocations_id) AS x FROM dbo.QCGen3BBlocationsNew'],1));
% BBcoordSQL{1}=num2str(QCGen3BBlocations_id+1);
% BBcoordSQL{2}=num2str(Info.AcquisitionKey);
% BBcoordSQL{3}=num2str(BBcoord(1,1));
% BBcoordSQL{4}=num2str(BBcoord(1,2));
% BBcoordSQL{5}=num2str(BBcoord(2,1));
% BBcoordSQL{6}=num2str(BBcoord(2,2));
% BBcoordSQL{7}=num2str(BBcoord(3,1));
% BBcoordSQL{8}=num2str(BBcoord(3,2));
% BBcoordSQL{9}=num2str(BBcoord(4,1));
% BBcoordSQL{10}=num2str(BBcoord(4,2));
% BBcoordSQL{11}=num2str(BBcoord(5,1));
% BBcoordSQL{12}=num2str(BBcoord(5,2));
% BBcoordSQL{13}=num2str(BBcoord(6,1));
% BBcoordSQL{14}=num2str(BBcoord(6,2));
% BBcoordSQL{15}=num2str(BBcoord(7,1));
% BBcoordSQL{16}=num2str(BBcoord(7,2));
% BBcoordSQL{17}=num2str(BBcoord(8,1));
% BBcoordSQL{18}=num2str(BBcoord(8,2));
% BBcoordSQL{19}=num2str(BBcoord(9,1));
% BBcoordSQL{20}=num2str(BBcoord(9,2));
% BBcoordSQL{21}=num2str(BBcoord(10,1));
% BBcoordSQL{22}=num2str(BBcoord(10,2));
% BBcoordSQL{23}=num2str(BBcoord(11,1));
% BBcoordSQL{24}=num2str(BBcoord(11,2));
% BBcoordSQL{25}=num2str(BBcoord(12,1));
% BBcoordSQL{26}=num2str(BBcoord(12,2));
% BBcoordSQL{27}=num2str(BBcoord(13,1));
% BBcoordSQL{28}=num2str(BBcoord(13,2));
% BBcoordSQL{29}=num2str(BBcoord(14,1));
% BBcoordSQL{30}=num2str(BBcoord(14,2));
%[key,error]=funcAddInDatabase(Database,'QCGen3BBlocationsNew',BBcoordSQL);
%asdfjkl;
      
%       if ln > 5 & ln < 10  %len
%         sort_coord = bbs_sortingZ2(coord,machine,Analysis.second_phantom, rot_angle )
%         ln = length(sort_coord(:,1));
%         sort_coord(:,2) = sort_coord(:,2) + ycoord_shift;
%       else  
%          sort_coord = coord;
%          sort_coord(:,3) = (1:ln)';
%          a = 'manual regime'
%          Error.StepPhantomBBsFailure = true;
%          stop;
%       end
%          hold on;
%          figure(figuretodraw);
%          redraw;
%          plot(sort_coord(:,1), sort_coord(:,2),'.r','MarkerSize',7);
%          hold on;
% 
%          for i=1:ln
%              text(sort_coord(i,1),sort_coord(i,2)-20,num2str(sort_coord(i, 3)),'Color', 'y'); 
%          end
%           ;
   % save('coord_BBs6.txt', 'sort_coord', '-ascii');

    
    %{
    sort_coord = bbs_sorting(coord)
     hold on;
     figure(figuretodraw);
     redraw;
     plot(sort_coord(:,1), sort_coord(:,2),'.r','MarkerSize',7);
     hold on;
      for i=1:ln
         text(sort_coord(i,1),sort_coord(i,2)-20,num2str(i),'Color', 'y'); 
      end
    
     figure(h_init); hold on;
    % axes; 
    for i=1:ln
     plot( sort_coord(i,1)-x_width,sort_coord(i,2),'.r','MarkerSize',7); hold on;
     text(sort_coord(i,1)-x_width,sort_coord(i,2)+30,num2str(i),'Color', 'y'); 
    % text(-70,num2str(i),'Color', 'y'); 
    % xy_centroids(i,1:2) = [stats2(i).Centroid(1)+x_width,stats2(i).Centroid(2)-50];
    
    end
    z_column = zeros(ln, 1);
    sort_coord(:,3) = z_column;
    %}
    %D = 'C:\Documents and Settings\smalkov\My Documents\SeleniaImages\Selenia_room116\1June\txt_files\';
    %file_name = [D,'2216078488.729.3326646739.47raw.txt']; 
   
   % D = 'C:\Documents and Settings\smalkov\My Documents\SeleniaImages\Selenia_room116\6June_thicknessangle\txt_files\';
   % file_name = [D,'2216078488.738.3327080834.155raw.txt'];


%%
function filmMidCoord = toFilmMidCoord(PRcoord, ROIxmin, ROIymin, filmRows)

x_shift = ROIxmin; % - 1;      %ROI w.r.t. mid-point
mid_y = filmRows/2;
% y_shift = (ROIymin - 1) - mid_y;
y_shift = (ROIymin) - mid_y;

filmMidCoord(:, 1) = PRcoord(:, 1) + x_shift;
filmMidCoord(:, 2) = PRcoord(:, 2) + y_shift;
