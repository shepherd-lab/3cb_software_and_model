function ry_estimation()
   global ROI BreastMask
   
   
 FractalThreshold=zeros(25);
        fractal_mask_1=zeros(size(BreastMask));
        for  FractalThreshold=[0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.87 0.89 0.91 0.93 0.95 0.97 0.99]
            %         indexFractalThreshold=1:20
            %         FractalThreshold=0.05*(indexFractalThreshold-1);
            
            [~,thresholdindex]=max(Histp>FractalThreshold);
            threshold=bins(thresholdindex);
            image = (FractalCurrentImage>threshold);
            % %  figure;imagesc(image);colormap(gray);
            fractal_mask=image;
            indexFractalThreshold=j;
            fractal_mask_1(:,:,indexFractalThreshold) = image;
            % %          figure;imshow(fractal_mask_1(:,:,indexindexFractalThreshold));
            clear image;
            
            % % %         if Info.classification==true;
            % % %
            % % %             I1=BW.*(~Muscle_mask).*(~classification_Maks);
            % % %             I2=fractal_mask.*(~Muscle_mask).*(~classification_Maks);
            % % %             Density_in=MaskROIproj.*(I2);
            % % %             MaskBreast =MaskROIproj.*(~Muscle_mask).*(~classification_Maks);
            % % %
            % % %         else
            % % %             I1=BW.*(~Muscle_mask);
            I2=fractal_mask.*(~Muscle_mask);
            Density_in=MaskROIproj.*I2;
            MaskBreast =MaskROIproj.*(~Muscle_mask);
            % % %         end
            

[FX,FY] = gradient(F)

end

