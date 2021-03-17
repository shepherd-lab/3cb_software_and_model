%Creation date 5-20-03
%author Lionel HERVE

function Analysis=funcComputeDSPwithGamma(ROI,Image,Analysis);
        %rm = ROI.ymin
        %rrow = ROI.rows
        %rx = ROI.xmin
        %rcol = ROI.columns
       % Fatref_gamma = 46665.24631 / 1.113730602;
       % Leanref_gamma = 76450.63127	 / 1.113730602;
		
        Fatref_gamma =	26115; %26273.8*0.8495;  %* 0.91%* 0.97 %* 0.95     %  * 0.9; %49312.14 * 0.91;
        Leanref_gamma = 55751*1.3591;  %* 0.96  %* 1.17  %85841.12 * 1.15      %82257.72063    %* 1.0;  % 86347.2 * 0.965;
	   
        temproi=Image.image(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1);
        meanroi = mean(mean(temproi))
        Analysis.DensityPercentage = ((meanroi - Fatref_gamma) / (Leanref_gamma - Fatref_gamma)) * 80
        Analysis.Phantomfatlevel = Fatref_gamma;
        Analysis.Phantomleanlevel = Leanref_gamma