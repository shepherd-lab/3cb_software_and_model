function dream_python_pngcreationUCSF()
global Image Info
% dicom_fname = 'C:\DREAM_challenge\trainingData_dcm\646660.dcm';
input_dir = '\\researchstg\aaStudies\Breast Studies\3CB R01\Data\From MGH\DICOM_deidentified';
output_dir448 = '\\researchstg\aaData9\Breast_Studies\DREAM\Our_presentation_dicoms\MGH_dream_png\trainingData_png448';
output_dir = '\\researchstg\aaData9\Breast_Studies\DREAM\Our_presentation_dicoms\MGH_dream_png\trainingData_png';

 dcm_files = dir(input_dir);
 len = length(dcm_files);
 %results = zeros(2,len-2);
 results = cell(len-2,2);
 cancer = 1;
 for i = 3:len
     dicom_fname = [dcm_files(i).folder,'\', dcm_files(i).name];
     info_dicom = dicominfo(dicom_fname);
     pres_image = double(dicomread(info_dicom));    
    
    level = graythresh(pres_image)
    BW = imbinarize(pres_image,level);
    bkBW = ~BW;
    
    stats1 = regionprops(BW,'centroid','Area','PixelIdxList');
    [maxValue1,index1]  = max([stats1.Area]);
    cent1 = stats1(index1).Centroid;
    stats2 = regionprops(bkBW,'centroid','Area','PixelIdxList');
    [maxValue2,index2]  = max([stats2.Area]);
    cent2= stats2(index2).Centroid;
    breast_mask = zeros(size(pres_image));
    breast_mask(stats1(index1).PixelIdxList)=1;
    pres_image = pres_image.*breast_mask;
    
    if cent1(1) > cent2(1)
        pres_image =flip(pres_image,2);
        breast_mask =flip(breast_mask,2);
    end
    
    [xmax,ymin,ymax,xmin] = funcROI(breast_mask);
    final_image = pres_image(ymin:ymax,xmin:xmax);
    final_mask =breast_mask(ymin:ymax,xmin:xmax);
    vert_line = final_mask(:,round(xmax*0.14));
    vert_index = find(vert_line==1);
    ymax = max(vert_index);
    ymin = min(vert_index);
    size_final = size(final_image);
    final_image =final_image(ymin:ymax,1:size_final(2));
    final_image2 = uint16(imresize(final_image,[224 224]));
%     final_image2 = entropyfilt(final_image2);    
    filename = [output_dir,'\',dcm_files(i).name,'.png'];
    imwrite(final_image2,filename,'png');
    
    final_image = uint16(imresize(final_image,[448 448]));
%     final_image = entropyfilt(final_image);    
    filename = [output_dir448,'\',dcm_files(i).name,'.png'];
    name = [dcm_files(i).name,'.png'];
    imwrite(final_image,filename,'png');
    results{i-2,1} = dcm_files(i).name;
    results{i-2,2} = cancer;    
    a= 1;
 end
  Excel('INIT');
  Excel('TRANSFERT',results);
a = 1;
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



end