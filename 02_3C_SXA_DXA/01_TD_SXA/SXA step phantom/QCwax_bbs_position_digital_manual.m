function [origDiff, BBcoord] = QCwax_bbs_position_digital_manual()

%This function is equivalent to the automatic version of GEN III BBs
%detections, execpt the BBs will be manully selected.

global Image Analysis ROI Info
%At this point, variable 'ROI' refers to the phantom region. (Song Note 1,
%p14)

[rows, cols] = size(Image.image);

sql = ['SELECT * FROM GEN3BBcoord WHERE acquisition_id = ', ...
       num2str(Info.AcquisitionKey)];
entryRead = mxDatabase('mammo_cpmc', sql);

%if the information is not in database, do computation
if isempty(entryRead)
    margin = 25;    %define margin size of 20 pixel around GEN III

    %set negative pixel to 0
    image = Image.image;
    image(image < max(Analysis.BackGroundThreshold, 0)) = 0;

    %vertical projection to x-axis
    projX = sum(image(floor(rows/2):end, :), 1);
    ROI.xmin = max(find(projX, 1, 'first') - margin, 1);
    ROI.xmax = min(find(projX, 1, 'last') + margin, cols);

    %horizontal projection to y-axis
    projY = sum(image(:, 1:floor(cols/2)), 2);
    ROI.ymin = max(find(projY, 1, 'first') - margin, 1);
    ROI.ymax = min(find(projY, 1, 'last') + margin, rows);

    %calculate number of rows and columns in ROI
    ROI.columns = ROI.xmax - ROI.xmin + 1;
    ROI.rows = ROI.ymax - ROI.ymin + 1;

    %crop for roi image
    ROI.image = Image.image(ROI.ymin:ROI.ymax, ROI.xmin:ROI.xmax);
    funcBox(ROI.xmin, ROI.ymin, ROI.xmax, ROI.ymax, 'b', 2);
    % draweverything;

    %display the roi image
    h_phant = figure('Tag', 'QC_phant');
    imagesc(ROI.image);
    colormap(gray);
    maxFigWindow(h_phant);
    figure(h_phant);

    %manually select BBs
    [x, y, pVal] = impixel;
    BBcoordPR_unorder = [x, y];

    %group each pair of BBs
    [BBgroups, BBcoordPR] = groupBBs(BBcoordPR_unorder);

    %sort BBs and determine the world coord orgin w.r.t. fild mid point
    origDiff = calcWorldOrig(BBgroups);

    %convert from Phantom Region coord to Film coord
    BBcoord = toFilmMidCoord(BBcoordPR, ROI.xmin, ROI.ymin, rows);

    %save ROI info and BB position in ROI to database
    sql = 'INSERT INTO GEN3BBcoord VALUES (';
    sql = [sql, num2str(Info.centerlistactivated), ', '];
    sql = [sql, num2str(Info.AcquisitionKey), ', '];
    sql = [sql, '''', date, ''', '];
    sql = [sql, '''', strtrim(datestr(rem(now, 1))), ''', '];
    sql = [sql, num2str(ROI.xmin), ', ', num2str(ROI.xmax), ', ', ...
                num2str(ROI.ymin), ', ', num2str(ROI.ymax), ', '];
    for i = 1:size(BBcoordPR, 1)
        sql = [sql, num2str(BBcoordPR(i, 1)), ', ', num2str(BBcoordPR(i, 2)), ', '];
    end
    sql = [sql(1:end-2), ')'];
    mxDatabase('mammo_cpmc', sql);
else
    ROI.xmin = entryRead{5};
    ROI.xmax = entryRead{6};
    ROI.ymin = entryRead{7};
    ROI.ymax = entryRead{8};
    ROI.columns = ROI.xmax - ROI.xmin + 1;
    ROI.rows = ROI.ymax - ROI.ymin + 1;
    ROI.image = Image.image(ROI.ymin:ROI.ymax, ROI.xmin:ROI.xmax);
    funcBox(ROI.xmin, ROI.ymin, ROI.xmax, ROI.ymax, 'b', 2);
    
    BBcoordPR = reshape(cell2mat(entryRead(9:end)), 2, []);
    BBcoordPR = BBcoordPR';

    %display the roi image
    h_phant = figure('Tag', 'QC_phant');
    imagesc(ROI.image);
    colormap(gray);
    figure(h_phant);
    hold on;
    scatter(BBcoordPR(:, 1), BBcoordPR(:, 2), '.r');
    pause(1);
    hold off;
    
    %group each pair of BBs
    [BBgroups, BBcoordPR] = groupBBs(BBcoordPR);
    
    %sort BBs and determine the world coord orgin w.r.t. fild mid point
    origDiff = calcWorldOrig(BBgroups);
    
    %convert from Phantom Region coord to Film coord
    BBcoord = toFilmMidCoord(BBcoordPR, ROI.xmin, ROI.ymin, rows);
end


%%
function filmMidCoord = toFilmMidCoord(coordPR, ROIxmin, ROIymin, filmRows)

x_shift = ROIxmin - 1;      %ROI w.r.t. mid-point
mid_y = filmRows/2;
y_shift = (ROIymin - 1) - mid_y;

filmMidCoord(:, 1) = coordPR(:, 1) + x_shift;
filmMidCoord(:, 2) = coordPR(:, 2) + y_shift;
