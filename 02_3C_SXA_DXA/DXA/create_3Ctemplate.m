function create_3Ctemplate()
     global ctrl Image
     
    for i=1:51
            set(ctrl.text_zone,'String',['Drag ',num2str(i),' box on phantom area']);
            i
            k = waitforbuttonpress;
            i
            point1 = get(gca,'CurrentPoint');    % button down detected
            finalRect = rbbox;                   % return figure units
            point2 = get(gca,'CurrentPoint');    % button up detected
            point1 = point1(1,1:2);              % extract x and y
            point2 = point2(1,1:2);
            p1 = round(min(point1,point2));             % calculate locations
            offset = round(abs(point1-point2));         % and dimensions

            x_coord(i,1:2) = [p1(1) p1(1)+offset(1)];
            y_coord(i,1:2) = [p1(2) p1(2)+offset(2)];

            funcBox(x_coord(i,1),y_coord(i,1),x_coord(i,2),y_coord(i,2),'blue'); 
%             tempimageLE=Image.LE(p1(2):p1(2)+offset(2),p1(1):p1(1)+offset(1));
%             tempimageHE=Image.LE(p1(2):p1(2)+offset(2),p1(1):p1(1)+offset(1));
            tempimageLE=Image.LE(y_coord(i,1):y_coord(i,2),x_coord(i,1):x_coord(i,2));
            tempimageHE=Image.HE(y_coord(i,1):y_coord(i,2),x_coord(i,1):x_coord(i,2));
            
            roi3C_LE(i) =  mean(mean(tempimageLE));
            roi3C_HE(i) =  mean(mean(tempimageHE))%+3000;
            
           coord= [x_coord,y_coord];
           
    end
% % %       [fileName,pathName]=uiputfile('.txt', 'Please select file to save ROI locations');
% % %       file_name=fullfile(pathName,fileName);
% % %       %file_name='\\ming\aaDATA\Breast Studies\3C_data\20100505\20100505_34_32_ROI.txt'
% % %          save(file_name,'coord', '-ascii');
       roi3C= [ roi3C_LE',roi3C_HE'];
      % file_name='\\ming\aaDATA\Breast Studies\3C_data\20100311\20100311_37_25_ROIVAL.xls'
       % file_name= '\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\Moffitt\Training\3C_test.xls';
       % file_name= '\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\Moffitt\3C02013\Calibration_3C01013.xls';
        file_name= '\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\3C01006\Calibration_3C01006.xls';
        xlswrite(file_name,roi3C);
      a=1;
      
      
       