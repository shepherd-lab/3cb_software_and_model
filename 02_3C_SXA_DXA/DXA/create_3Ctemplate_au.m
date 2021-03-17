function create_3Ctemplate()
     global ctrl Image
     
    for i=1:8
            set(ctrl.text_zone,'String',['Drag ',num2str(i),' box on phantom area']);
            k = waitforbuttonpress;
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
            roi3C_HE(i) =  mean(mean(tempimageHE));
            
           coord= [x_coord,y_coord];
           
    end
      file_name='\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\AL_SeleniaData\templates\20090122_4cmstep_3C_test.txt'
         save(file_name,'coord', '-ascii');
    
      a=1;
      
      
       