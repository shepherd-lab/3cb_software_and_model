function pilot_conversion()
 global Image  Info Analysis Result ctrl Database
 
 Analysis.PhantomID = 9;
 Info.study_3C = false;
 Result.DXASelenia = false;
  numrows = 1152;
 numcols = 832;

 init_pat = [];
 count = 0;
%   xls_name = 'F:\Dream_contest2\Training_1\training_files\malignant_filenames.xlsx';
%   [num,txt,raw] = xlsread(xls_name);
%   input_dir = 'F:\Dream_contest2\Training_Nikulin\DDSM_1\src\DICOMS_3CBpres_noSXA';      %DICOMS_3CBraw';
  input_dir = 'F:\Dream_contest2\Training_Nikulin\DDSM_1\src\DICOMS_3CBpres_noSXApng_3\';
  output_dir = 'F:\Dream_contest2\Training_Nikulin\DDSM_1\src\DICOMS_3CBpres_noSXApng_3\';
 % output_dir_jpg = 'F:\Dream_contest2\Training_Nikulin\DDSM_1\src\DICOMS_3CBpres_noSXApng_2\JPG\';
    png_files = dir(input_dir);
 len = length(png_files);
  
 for i = 3:len
    png_fname = [png_files(i).folder,'\',png_files(i).name];
    
     count2=0;
    for i=1:len        
                  image2 = imresize(pres_image,[numrows numcols]);
                 png_fname = [output_dir,[patient_id,'_',view],'.png'];
                 imwrite(uint16(pres_image),png_fname);               
                 count = count + 1            
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


