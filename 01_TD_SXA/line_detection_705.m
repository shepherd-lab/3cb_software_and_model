function line_detection(image)
    BW = image;
    
    %BW = rotI;
    [H,T,R] = hough(BW);
    P  = houghpeaks(H,5,'threshold',ceil(0.2*max(H(:))));
    x = T(P(:,2)); y = R(P(:,1));
  
    % Find lines  detection and plot them
    lines = houghlines(BW,T,R,P,'FillGap',15,'MinLength',10);
    handle_phant = findobj('Tag','QC_phant');
    figure(handle_phant);hold on
    max_len = 0;
    for k = 1:length(lines)
       xy = [lines(k).point1; lines(k).point2];
       plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

       % Plot beginnings and ends of lines
       plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
       plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

       % Determine the endpoints of the longest line segment
       len = norm(lines(k).point1 - lines(k).point2);
       if ( len > max_len)
          max_len = len;
          xy_long = xy;
       end
    end
    figure(handle_phant);hold on
     % Find lines using edge detection and plot them
    %BW = edge(image,'canny');
    BW = image; %JW 6/8/10 UVM images using Delrin in bookends, edge detection not as effective
    
    [H,T,R] = hough(BW);
    P  = houghpeaks(H,5,'threshold',ceil(0.2*max(H(:))));
    x = T(P(:,2)); y = R(P(:,1));
   
    lines_2 = houghlines(BW,T,R,P,'FillGap',15,'MinLength',10);
    max_len = 0;
    for k = 1:length(lines_2)
       xy = [lines_2(k).point1; lines_2(k).point2];
       plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

       % Plot beginnings and ends of lines
       plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
       plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

       % Determine the endpoints of the longest line segment
       len = norm(lines_2(k).point1 - lines_2(k).point2);
       if ( len > max_len)
          max_len = len;
          xy_long = xy;
       end
    end
    
    % highlight the longest line segment
    plot(xy_long(:,1),xy_long(:,2),'LineWidth',2,'Color','cyan');
    coord_lines = [lines, lines_2];
    QClines_sorting(coord_lines); %sort_lines = 
    a = 1;
    