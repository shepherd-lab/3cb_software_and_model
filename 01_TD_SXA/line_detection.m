function line_detection(image)
    %imwrite(image, 'U:\smalkov\GEN3 phantom test\bw.png','png'); 
     %BW = rotI;
    %[H,T,R] = hough(BW);
%    ure;imagesc(image);colormap(gray);
    BW = imclearborder(image);
    
% % %     [H,T,R] = hough(BW,'RhoResolution',2,'Theta',-90:0.1:89);
% % %     P  = houghpeaks(H,5,'threshold',ceil(0.3*max(H(:))));
% % %     x = T(P(:,2)); y = R(P(:,1));
% % %     % Find lines  detection and plot them
% % %     lines = houghlines(BW,T,R,P,'FillGap',15,'MinLength',10);
    
    %[H,T,R] = hough(BW,'RhoResolution',2,'ThetaResolution',0.1);
    
    [H,T,R] = hough(BW,'RhoResolution',2,'ThetaResolution',0.1);
    P  = houghpeaks(H,5,'threshold',ceil(0.3*max(H(:))));
    x = T(P(:,2)); y = R(P(:,1));
    % Find lines  detection and plot them
    lines = houghlines(BW,T,R,P,'FillGap',15,'MinLength',10);
       
    
    handle_phant = findobj('Tag','GEN3');
    figure(handle_phant(end));hold on
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
    figure(handle_phant(end));hold on
     % Find lines using edge detection and plot them
    BW = edge(image,'canny');
   % figure;imagesc(BW);colormap(gray);
   % [H,T,R] = hough(BW);
% % %     [H,T,R] = hough(BW,'RhoResolution',2,'Theta',-90:0.1:89);
% % %     P  = houghpeaks(H,5,'threshold',ceil(0.2*max(H(:))));
% % %     x = T(P(:,2)); y = R(P(:,1));
% % %     lines_2 = houghlines(BW,T,R,P,'FillGap',15,'MinLength',10);
   
    [H,T,R] = hough(BW,'RhoResolution',2,'ThetaResolution',0.1);
    P  = houghpeaks(H,5,'threshold',ceil(0.2*max(H(:))));
    x = T(P(:,2)); y = R(P(:,1));
    % Find lines  detection and plot them
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
    
     %BW = edge(image,'sobel');
     
%     theta = 80:0.1:100;  %Radon transform
%     [Line1,R]=funcRadonDetectMax(BW,theta,DEBUG,'first');
% 
%     if DEBUG display(Line1); end
%     Line1=funcComputeLine(size(tempImage),Line1)
% 
%     %if LINES
%     %h1 = figure;imagesc(BW); colormap(gray); title('Line1');
%     %figure(htemp);imagesc(tempImage); colormap(gray); title('Line1');
%     % hold on; plot([Line1.x1 Line1.x2],[Line1.y1 Line1.y2],'Linewidth',1,'color','b');
%     %end
% 
%     Phantom.Line1=[minX+[Line1.x1 Line1.x2]' minY+[Line1.y1 Line1.y2]'];
% %     
% %     [H,T,R] = hough(BW);
% %     P  = houghpeaks(H,5,'threshold',ceil(0.2*max(H(:))));
% %     x = T(P(:,2)); y = R(P(:,1));
% %    
% %     lines_3 = houghlines(BW,T,R,P,'FillGap',15,'MinLength',10);
% %     max_len = 0;
% %     for k = 1:length(lines_2)
% %        xy = [lines_3(k).point1; lines_3(k).point2];
% %        plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
% % 
% %        % Plot beginnings and ends of lines
% %        plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
% %        plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
% % 
% %        % Determine the endpoints of the longest line segment
% %        len = norm(lines_2(k).point1 - lines_2(k).point2);
% %        if ( len > max_len)
% %           max_len = len;
% %           xy_long = xy;
% %        end
% %     end
% %     
% %      BW = edge(image,'canny');
% %     
% %     [H,T,R] = hough(BW);
% %     P  = houghpeaks(H,5,'threshold',ceil(0.3*max(H(:))));
% %     x = T(P(:,2)); y = R(P(:,1));
% %    
% %     lines_4 = houghlines(BW,T,R,P,'FillGap',15,'MinLength',10);
% %     max_len = 0;
% %     for k = 1:length(lines_2)
% %        xy = [lines_4(k).point1; lines_4(k).point2];
% %        plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
% % 
% %        % Plot beginnings and ends of lines
% %        plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
% %        plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
% % 
% %        % Determine the endpoints of the longest line segment
% %        len = norm(lines_2(k).point1 - lines_2(k).point2);
% %        if ( len > max_len)
% %           max_len = len;
% %           xy_long = xy;
% %        end
% %     end
    % highlight the longest line segment
    plot(xy_long(:,1),xy_long(:,2),'LineWidth',2,'Color','cyan');
    coord_lines = [lines, lines_2];
    QClines_sorting(coord_lines); %sort_lines = 
    a = 1;
    