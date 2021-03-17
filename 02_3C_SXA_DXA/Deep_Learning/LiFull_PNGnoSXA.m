function pilot_conversion()
 global Image  Info Analysis Result ctrl
 
 Analysis.PhantomID = 9;
 Info.study_3C = true;
 Result.DXASelenia = false;
%   numrows = 1152;
%  numcols = 832;
 
 init_pat = [];
 count = 0;
%   xls_name = 'F:\Dream_contest2\Training_1\training_files\malignant_filenames.xlsx';
%   [num,txt,raw] = xlsread(xls_name);
  input_dir = 'F:\Dream_contest2\Training_Li\end2end-all-conv-master\full_test_1152x896\pos';      %DICOMS_3CBraw';
  output_dir = 'F:\Dream_contest2\Training_Li\end2end-all-conv-master\full_test_1152x896\pos\new\';
  output_dir_jpg = 'F:\Dream_contest2\Training_Li\end2end-all-conv-master\full_test_1152x896\pos\JPG\';
  
  file_names = dir(input_dir);
  len = length(file_names);
    for i=3:len  
%         try 
          cur_name = file_names(i).name;          
          full_filename = [input_dir,'\',cur_name];
           if ~isdir(full_filename) %& isdicom(full_filename)  %((strcmp(lower(ext), '.dcm') | isempty(ext) ) & ~isdir(name2)) %%~isdir(name2)    % ( (strcmp(lower(ext), '.dcm') | ~isempty(ext) ) & ~isdir(name)  )                          
%                 pres_image=double(dicomread(full_filename));
                pres_image=double(imread(full_filename));
                breast_mask= (pres_image > 10);
                se = strel('disk',3);   
                breast_mask = imdilate(breast_mask,se);
                BW=breast_mask;
                bkBW = ~BW;
                stats1 = regionprops(BW,'centroid','Area','PixelIdxList');
                [maxValue1,index1]  = max([stats1.Area]);
                cent1 = stats1(index1).Centroid;
                 breast_mask = zeros(size(pres_image));
                 breast_mask(stats1(index1).PixelIdxList)=1;
                stats2 = regionprops(bkBW,'centroid','Area','PixelIdxList');
                [maxValue2,index2]  = max([stats2.Area]);
                cent2= stats2(index2).Centroid;  
                pres_image = pres_image.*breast_mask;
    
                if cent1(1) > cent2(1)
                    pres_image =flip(pres_image,2);
                    breast_mask =flip(breast_mask,2);
                end
                
%                 [xmax,ymin,ymax,xmin] = funcROI(breast_mask);
%                 final_image = pres_image(ymin:ymax,xmin:xmax);
%                 final_mask =breast_mask(ymin:ymax,xmin:xmax);
%                 vert_line = final_mask(:,round(xmax*0.14));
%                 vert_index = find(vert_line==1);
%                 ymax = max(vert_index);
%                 ymin = min(vert_index);
%                 size_final = size(final_image);
%                 final_image =final_image(ymin:ymax,1:size_final(2));
%                  image2 = imresize(final_image,[numrows numcols]);

%                  image2 = imresize(pres_image,[numrows numcols]);
                 
                 image2 = pres_image;
                 if cent1(1) > cent2(1)
                    pres_image =flip(image2,2);
%                    flip(breast_mask,2);
                 else
                     pres_image = image2;
                 end
                 png_fname = [output_dir,file_names(i).name(1:end-4),'.png'];
                 imwrite(uint16(pres_image),png_fname);  
                 image3 = imresize(pres_image,[64 64]);
                 jpg_fname = [output_dir_jpg,file_names(i).name(1:end-4),'.jpg'];
                 imwrite(uint8(image3),jpg_fname);
                 count = count + 1                
               
           end
            
%        catch    
%                init_pat = [init_pat;file_names(i).name]
%               
%         end         
    end
    
     

end         
%%
function [xmax,ymin,ymax,xmin] = funcROI(BackGround)
        
        [rows,columns]=size(BackGround);
        
        sm = sum(BackGround);
        sm_index = find(sm~=0);
        xmin = min(sm_index);
        [maxi,pos]=min(sm(xmin:end));        
              
        BackGround(:,pos)=0;  %%the minimum at 0
        convwindow=30;
        %find the shape of the breast
        [C,I]=min(transpose(BackGround(:,xmin:end)));
        I=I+(C==1).*(size(BackGround,2)-I);  %when the line is completly without backgroud, to prevent the result to be equal to 1
        Iconv=WindowFiltration(I,convwindow);
        
        %find the top of the ROI image
        [C,ymin]=min(Iconv(convwindow:round(rows/2)));
        %find the first point that reach the minimum value+10 (to be close of the edge of the breast)
        [C,ymin]=min(Iconv(round(rows/2):-1:convwindow)>(C+10));
        ymin=round(rows/2)-ymin;
        ymin=max(ymin-5,5);
        
        %find the bottom of the ROI image
        [C,ymax]=min(Iconv(round(rows/2):rows-convwindow));
        %find the first point that reach the minimum value+10 (to be close of the edge of the breast)
        [C,ymax]=min(Iconv(round(rows/2):rows-convwindow)>(C+10));
        ymax=round(rows/2)+ymax;
        ymax=min(ymax+5,size(BackGround,1)-5);
        
        %find the the right edge of the breast
        xmax=max(I(ymin:ymax));
    end



