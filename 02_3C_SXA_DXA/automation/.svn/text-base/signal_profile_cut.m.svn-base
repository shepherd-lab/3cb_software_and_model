function signal_profile()
  global Analysis ROI Image
        if Analysis.PhantomID == 7 | Analysis.PhantomID == 8  | Analysis.PhantomID == 9 
            X_right = ROI.xmax + 50;
        else
            X_right = Analysis.coordXFatcenter
        end
        % vertical profiles
         yc = (ROI.ymax - ROI.ymin) / 2 + ROI.ymin
         yup = yc - (ROI.ymax - ROI.ymin)* 0.35  / 2
         ydown = yc + (ROI.ymax - ROI.ymin)* 0.35  / 2
         xx1 = [ROI.xmin ROI.xmax];
         yy1 = [yc yc];
         %{
         xx2 = [1 X_right];
         yy2 = [yup yup];
         xx3 = [1 X_right];
         yy3 = [ydown ydown];            
         %}
         signal1=improfile(Image.image,xx1,yy1);
         signal2=improfile(Image.image,xx1,yy1);
         signal3=improfile(Image.image,xx1,yy1);
         %signal2=improfile(Image.image,xx2,yy2);
         %signal3=improfile(Image.image,xx3,yy3);
         ln = (1:length(signal1)) * Analysis.Filmresolution ; %Xcoord
         ln_size = size(ln);
         X =  ROI.xmin+3:ROI.xmax;      
         Analysis.signal = [ln' signal1 signal2 signal3 ];
          sz = size(Analysis.signal)
         foe=figure; 
         scrsz = get(0,'ScreenSize');
        % set(h_init,'Position',[1 scrsz(4)*3/8 scrsz(3)*2.5/8 scrsz(4)*3/8]);
        % set(foe, 'Visible','off');
         plot(Analysis.signal(3:end,1)*0.1, Analysis.signal(3:end,2)); hold on; %2:5
        % legend('center', 'upper','down','fit');
         %plot([Analysis.signal(1,1) Analysis.signal(end,1)],[Analysis.Phantomfatlevel  Analysis.Phantomfatlevel ],'Linewidth',1,'color','k'); hold on;
         plot(X*Analysis.Filmresolution*0.1, Analysis.Fat_ref_profile(3:end-1),'-k'); hold on; %'Linewidth',3,'color','m'
         %load('fat_ref_profile2.mat');
         %plot(X*Analysis.Filmresolution*0.1, Fat_ref_profile2(3:end-1),'-r'); hold on;
         % ax1 = gca;
        % set(ax1,'XAxisLocation','top');
         xlabel('chest-nipple profile, cm','FontSize',12);
         ylabel('attenuation, a.u.','FontSize',12);
         plot(X*Analysis.Filmresolution*0.1, Analysis.Lean_ref_profile(3:end-1),'-k');
         xlim([0 8]);
         grid on;
         %ylim([20000 50000]);
           a = 1;
           
           
           