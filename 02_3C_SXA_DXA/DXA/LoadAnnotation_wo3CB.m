function  LoadAnnotation_wo3CB(annofile_name, patient_id)
global  Image ROI flip_info FreeForm   file FreeForm2
    FreeForm2 = FreeForm;
    FreeForm = [];
    image = [];
     FreeForm.FreeFormnumber = 0;
    load(annofile_name);
    
    % figure;imagesc(image);colormap(gray); hold on;
%      plot(FreeForm.FreeFormCluster.face(:,1),FreeForm.FreeFormCluster.face(:,2),'-g');
    %flip_info = [Info.flipH Info.flipV];
 if    ~(~isempty(strfind(lower(file.startpath),'moff')) & str2num(patient_id(5:7)) <= 30)
    if ~isempty(strfind(lower(file.startpath),'ucsf')) | ~isempty(strfind(lower(file.startpath),'moff'))
                
        if flip_info(1) == true & flip_info(2) == true
          for i=1:FreeForm.FreeFormnumber 
              FreeForm.FreeFormCluster(1,i).face = flip_xy(FreeForm.FreeFormCluster(1,i).face, size(image), 'flipH')
             FreeForm.FreeFormCluster(1,i).face = flip_xy(FreeForm.FreeFormCluster(1,i).face, size(image), 'flipV')
          end   
            image=flipdim(image,2);  %Horizontal
             image=flipdim(image,1); %Vertical
        elseif flip_info(1) == true & flip_info(2) == false
          for i=1:FreeForm.FreeFormnumber  
            FreeForm.FreeFormCluster(1,i).face = flip_xy(FreeForm.FreeFormCluster(1,i).face, size(image), 'flipH')
          end  
            image=flipdim(image,2);    
        elseif flip_info(1) == false & flip_info(2) == true
          for i=1:FreeForm.FreeFormnumber  
            FreeForm.FreeFormCluster(1,i).face = flip_xy(FreeForm.FreeFormCluster(1,i).face, size(image), 'flipV')
          end  
            image=flipdim(image,1);    
        elseif flip_info(1) == false & flip_info(2) == false
            ;
        end
    else
        flip_info = [];
    end
 end
    
    Image.LEPresFlipped = image;
    
    clear image;
    % Image.Tmask3C = double(imread(thickfile_name))/1000;
   % figure;imagesc(Image.LEPresFlipped);colormap(gray); hold on;
    %figure;imshow(image);colormap(gray); hold on;
%     figure;imagesc(Image.LEPres);colormap(gray);hold on;
%     plot(FreeForm.FreeFormCluster.face(:,1),FreeForm.FreeFormCluster.face(:,2),'-g');
end




