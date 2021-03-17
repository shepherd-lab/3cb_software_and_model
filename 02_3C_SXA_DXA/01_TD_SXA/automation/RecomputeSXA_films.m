%Lionel HERVE
%5-25-04
%retrieve all the SXA analysis
function RecomputeSXA()

global Database Info Image Analysis ctrl ROI FileName_list PathName AutomaticAnalysis corr_value h_init h_slope

%content={};
 [FileName,PathName] = uigetfile('\\ming\aaSTUDIES\Breast Studies\CPMC\Analysis Code\SAS\RO1 CPMC Data analysis\testing_BF.txt','Select the acquisition list txt-file ');   acqs_filename = [PathName,FileName];     %'\'
 FileName_list =  FileName;
 acqs_filename = [PathName,'\',FileName];
  SXAIDList = textread(acqs_filename,'%u');
AutomaticAnalysis.CharacterRecognitionDone = 0;

 fat_gain = 1900;
 lean_gain = 2800;
 fat_ref_corr = 30;
 angle_coeff = 0.7;
 corr_value = 10;
 
RetrieveInDatabaseCounter=0;
CreateReport('NEW',1);
% 
%     h_slope = [];
%     h_init = [];
for RetrieveInDatabaseIndex=1:size(SXAIDList,1)
    hnd = get(0,'Children');
      
    if ~isempty(h_init)
        for i = 1:length(h_init)
            if find(hnd == h_init(i))
                delete(h_init(i));
            end
        end
    end
    if  ~isempty(h_slope)
        for i = 1:length(h_slope)
            if find(hnd == h_slope(i))
                delete(h_slope(i));
            end
        end
    end
    
    all_slopes = findobj('Tag', 'Slope');
    for i = 1:length(all_slopes)
       delete(all_slopes(i));
    end
   % h_slope = [];
   % h_init = [];
    Info.SXAAnalysisKey=SXAIDList(RetrieveInDatabaseIndex,:);

    
    %put the check mark to auto
    '!!!!!!!!!!!!!!!!! Retrieve in Database modified for SOY analysis !!!!!!!!!!!!!!!!!!!'
    set(ctrl.CheckAutoROI,'value',true);
    set(ctrl.CheckAutoSkin,'value',true);
    %set(ctrl.CheckManualPhantom,'value',0);  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SOY ANALYSIS
    set(ctrl.CheckManualPhantom,'value',1);
  
     Database.Step=2;  
    flag.noimage = false;
    flag.RawImage = false;
   try
       
        RetrieveInDatabase('SXAANALYSIS'); 
        set(ctrl.Cor,'value',true);
        ButtonProcessing('CorrectionAsked');
        Analysis.PhantomDistanceFatRef = round(Analysis.PhantomD1) +1;
        Analysis.PhantomFatRefHeight = 1.021 * Analysis.PhantomDistanceFatRef * Analysis.Filmresolution + 33.5
        Info.Operator=11;  %use operator: automatic
        Analysis.AngleHoriz = angle_coeff*Analysis.AngleHorizInit;
         Periphery_calculation;
        X_right = Analysis.coordXFatcenter;
         % vertical profiles
         yc = (ROI.ymax - ROI.ymin) / 2 + ROI.ymin
         yup = yc - (ROI.ymax - ROI.ymin)* 0.35  / 2
         ydown = yc + (ROI.ymax - ROI.ymin)* 0.35  / 2
         xx1 = [1 X_right];
         yy1 = [yc yc];
         xx2 = [1 X_right];
         yy2 = [yup yup];
         xx3 = [1 X_right];
         yy3 = [ydown ydown];            
         
         signal1=improfile(Image.image,xx1,yy1);
         signal2=improfile(Image.image,xx2,yy2);
         signal3=improfile(Image.image,xx3,yy3);
         ln = (1:length(signal1)) * Analysis.Filmresolution ; %Xcoord
         ln_size = size(ln);
         
         Analysis.signal = [ln' signal1 signal2 signal3 ];
         
         szauto = size(Analysis.signal);
         %horizontal profile
         xleft = (ROI.xmax - ROI.xmin) * 0.1; 
         xc = (ROI.xmax - ROI.xmin) * 0.37 ;
         xright = (ROI.xmax - ROI.xmin)* 0.63;
         xx1 = [xleft xleft];
         yy1 = [ROI.ymax ROI.ymin];
         xx2 = [xc xc];
         yy2 = [ROI.ymax ROI.ymin]
         xx3 = [xright xright];
         yy3 =  [ROI.ymax ROI.ymin]           
         
         signal1_horiz=improfile(Image.image,xx1,yy1);
         signal2_horiz=improfile(Image.image,xx2,yy2);
         signal3_horiz=improfile(Image.image,xx3,yy3);
         ln_horiz = (1:length(signal1_horiz)) * Analysis.Filmresolution ; %Xcoord
         ln_size = size(ln)
         Analysis.signal_horiz = [ln_horiz' signal1_horiz signal2_horiz signal3_horiz];
         szauto = size(Analysis.signal_horiz)
       
        %ComputeDensity;
       
        funcComputeBreastDensity_optimization2(fat_gain, lean_gain,fat_ref_corr)
        Analysis.FileNameDensity = [Info.fname(1:end-4),'Density',Info.fname(end-3:end) ]; 
        Analysis.FileNameThickness = [Info.fname(1:end-4),'Thickness',Info.fname(end-3:end)];
        densfile_name = Analysis.FileNameDensity;
        imwrite(uint16(Analysis.SXADensityImageCrop*100),densfile_name,'png');
        imwrite(uint16(Analysis.SXAthickness_mapproj*1000),Analysis.FileNameThickness,'png');
          
   catch
        errmsg = lasterr
        try
            Message('Creating report...');
            CreateReport('ADDCOMMON');
            CreateReport('SXASPECIFIC');
            CreateReport('QACODES');
            CreateReport('ADDREPORTTEXT');
        catch
            errmsg = lasterr
        end
        continue;
    end
    %Analysis.Step=7;
    msg=get(ctrl.text_zone,'string');
    Message([msg,'   (',num2str(RetrieveInDatabaseIndex),'/',num2str(size(SXAIDList,1)),')']);
    Info.Operator=11;  %use operator: automatic
 
    
    try
            Message('Creating report...');
            CreateReport('ADDCOMMON');
            CreateReport('SXASPECIFIC');
            CreateReport('QACODES');
            CreateReport('ADDREPORTTEXT');
            CreateReport('ADDSTEPPOFILES');
    catch
            errmsg = lasterr
    end

    try
        SaveInDatabase('SXAANALYSIS');     
    catch  
        errmsg = lasterr
        try
            SaveInDatabase('SXAANALYSIS');   
        catch
            errmsg = lasterr
            try
                SaveInDatabase('SXAANALYSIS');   
            catch
                errmsg = lasterr
            end
        end
    end

    
    
    % if (Info.Analysistype==5) %automatic SXA analysis
    if mod(RetrieveInDatabaseCounter,50)==0 %& Info.SaveStatus ~= 0 50
        if RetrieveInDatabaseCounter %& Info.SaveStatus ~= 0
            try
                CreateReport('SAVECLOSE',Info.AcquisitionKey-1);
            catch
                try
                    CreateReport('SAVECLOSE',Info.AcquisitionKey-1);
                catch
                    errmsg = lasterr
                end
            end

            CreateReport('NEW',Info.AcquisitionKey);
        end
        % CreateReport('NEW',Info.AcquisitionKey);
    end
    RetrieveInDatabaseCounter=RetrieveInDatabaseCounter+1;
end
    