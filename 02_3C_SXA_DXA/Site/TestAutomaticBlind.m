% Test automatic blind image
%retrieve all the CPMC scans and test if the algorithm is fine enough
%Lionel HERVE 6-17-04

global Database Image ctrl Info 
global figuretodraw

powerpointOn=0;
RetrieveFreeForm=1;

 
    if powerpointOn
        %invoke the activex server
        HandlePPT = actxserver('PowerPoint.Application');
        HandlePPT.Visible = 1;
        HandlePPTOp = invoke(HandlePPT.Presentations,'Add');
    end 

    
    %obtain the list of all selected acquisition
    SQLstatement=['select acquisition_id,patient_id from acquisition'];
    SQLstatement=[SQLstatement,' order by patient_id,visit_id,view_id'];
    a=mxDatabase(Database.Name,SQLstatement);
    acqID=a(:,1);
    PatientID=a(:,2);

    for indexacq=size(PatientID,1)-100:size(PatientID,1)-100
        %open the acquisition
        Info.AcquisitionKey=cell2mat(acqID(indexacq));
        RetrieveInDatabase('ACQUISITION');         

        set(ctrl.separatedfigure,'value',true);
        draweverything;
        AutomaticBlindTag(Image.image);
        
        if powerpointOn        
            % Get current number of slides:
            PowerPointReport.slide_count = get(HandlePPTOp.Slides,'Count');
             
            % Add a new slide:
            HandleSlide = invoke(HandlePPTOp.Slides,'Add',PowerPointReport.slide_count+1,12);
            
            % Get height and width of slide:
            PowerPointReport.slide_H = HandlePPTOp.PageSetup.SlideHeight;
            PowerPointReport.slide_W = HandlePPTOp.PageSetup.SlideWidth;
            
            % Capture current figure into clipboard:
            print -r100 -dmeta 
            
            % Paste the contents of the Clipboard:
            Temphandle1 = invoke(HandleSlide.Shapes,'Paste');
                        
            % put picture in the left side:
            set(Temphandle1,'Left',0);
            set(Temphandle1,'Top',0);
            set(Temphandle1,'LockAspectRatio','msoFalse')
            set(Temphandle1,'Height',PowerPointReport.slide_H);
            set(Temphandle1,'Width',PowerPointReport.slide_W/2);
           
            delete(figuretodraw);
        end
    end

