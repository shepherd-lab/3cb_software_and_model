% QCManagement
% the raw QC scans come with the patient ID = '11111111'
% This first program retrieve all these files, detect between
% density step phantom and flat field scan, orientate the film to have the
% tag at the bottom right and mark the film as density step phantom
% (patientID = '111111111112') or FlatField (patientID ='111111111113')


% Lionel HERVE
% 8-3-04


if ~exist('RequestedAction')
    RequestedAction='ROOT';
end

switch RequestedAction
    case 'ROOT'
        
        
        %detect FlatField/Density step Phantom
        %use histogram (8-3-04)
        if sum(Hist.xvalues.*Hist.values)/sum(Hist.xvalues)>30000
            'Flat Field detected'
            %detect Left-Rigth Orientation
            %use Vertical Proj
            signal=mean(Image.image);
            Xvalue=[1:length(signal)];
            if (sum(signal.*Xvalue)/sum(signal))<(size(Analysis.BackGround,2)/2);
                ImageMenu('flipH');
            end
            
            %detect Top-Bottom Orientation
            %Analyze the 200 columns at the right of the image
            %Use High pass image
            tempImage=Image.image(:,end-200:end);
            tempImage2=conv2(tempImage,ones(5),'valid')/25;
            tempImage3=abs(tempImage(3:end-2,3:end-2)-tempImage2);
            signal=mean(tempImage3');
            Yvalue=[1:length(signal)];
            if (sum(signal.*Yvalue)/sum(signal))<(size(Analysis.BackGround,1)/2);
                ImageMenu('flipV');
            end
            
            %cut Top Bottom Left
            RequestedAction='CUTTOPBOTTOMLEFT';QCmanagement;
            
            %find the room
            
            %Mark as density step phantom (patientID = '111111111112')
            %mxDatabase(Database.Name,['update acquisition set patient_id=''111111111112'' where acquisition_id=''',num2str(Info.AcquisitionKey),'''']);
            
            %save the image
            
            
        else
            'Density Step Phantom detected'
            
            %detect Left-Rigth Orientation
            %use x-mean of the backgound
            signal=mean(Analysis.BackGround);
            Xvalue=[1:length(signal)];
            if (sum(signal.*Xvalue)/sum(signal))<(size(Analysis.BackGround,2)/2);
                ImageMenu('flipH');
            end
            %detect Top-Bottom Orientation
            %Analyze the 200 columns at the right of the background image
            tempImage=Analysis.BackGround(:,end-200:end)';
            signal=mean(tempImage);
            Yvalue=[1:length(signal)];
            if (sum(signal.*Yvalue)/sum(signal))>(size(Analysis.BackGround,1)/2);
                ImageMenu('flipV');
            end
            
            %cut Top Bottom Left
            RequestedAction='CUTTOPBOTTOMLEFT';QCmanagement;
            
            %find the room
            
            %Mark as density step phantom (patientID = '111111111112')
            %mxDatabase(Database.Name,['update acquisition set patient_id=''111111111112'' where acquisition_id=''',num2str(Info.AcquisitionKey),'''']);
            
            %save the image
        end
    case 'CUTTOPBOTTOMLEFT'
        RequestedAction='ROOT';
        top=DetectImageEdge(Image.OriginalImage,'TOP');
        ImageMenu('CutTopWithParam',top);
        bottom=DetectImageEdge(Image.OriginalImage,'BOTTOM');
        ImageMenu('CutBottomWithParam',bottom);
        left=DetectImageEdge(Image.OriginalImage,'LEFT');
        ImageMenu('CutLeftWithParam',left);
        
    case 'ORIENTCORRECTLY'        
        RequestedAction='ROOT';
        %detect Left-Rigth Orientation
        %use Vertical Proj
        signal=mean(Image.image);
        Xvalue=[1:length(signal)];
        if (sum(signal.*Xvalue)/sum(signal))<(size(Analysis.BackGround,2)/2);
            ImageMenu('flipH');
        end
        
        %detect Top-Bottom Orientation
        %Analyze the 200 columns at the right of the image
        %Use High pass image
        tempImage=Image.image(:,end-200:end);
        tempImage2=conv2(tempImage,ones(5),'valid')/25;
        tempImage3=abs(tempImage(3:end-2,3:end-2)-tempImage2);
        signal=mean(tempImage3');
        Yvalue=[1:length(signal)];
        if (sum(signal.*Yvalue)/sum(signal))<(size(Analysis.BackGround,1)/2);
            ImageMenu('flipV');
        end
end