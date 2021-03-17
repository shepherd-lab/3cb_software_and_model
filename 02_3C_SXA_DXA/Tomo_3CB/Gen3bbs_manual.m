function coord=Gen3bbs_manual (image)
   scrsz = get(0,'ScreenSize');
  h_init = figure; imagesc(image); colormap(gray); title('Now, you can select 14 points');hold on;
     set(h_init,'Position',[1 scrsz(4)*1/8 scrsz(3)*7/8 scrsz(4)*7/8]);
     
     %set(ctrl.text_zone,'String','Now, you can select the first set of coordinates');   
    m = 14;
    [x1,y1] = ginput(m);
%     a1 = [x1,y1]
%     title('Now, you can select the second set of coordinates');hold on; 
%    % set(ctrl.text_zone,'String','Now, you can select the first set of coordinates');  
%      [x2,y2] = ginput(m);
%      a2 = [x2,y2]
%      title('Now, you can select the third set of coordinates');hold on;
%      %set(ctrl.text_zone,'String','Now, you can select the first set of coordinates');  
%      [x3,y3] = ginput(m);
    coord  = [x1,y1]