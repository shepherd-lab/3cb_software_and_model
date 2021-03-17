function funcopenSeleniaDXA(calibration_type)
    global Result Image flag Info Analysis ctrl file SXAAnalysis DXAAnalysis ROI
    if ~exist('Option')
    Option='NULL';
    end
    
    if isfield(Image,'CLE')
        Image = rmfield(Image,'CLE');
     end  
     if isfield(Image,'CHE')
         Image = rmfield(Image,'CHE');
    end  
     if isfield(Image,'CRST')
         Image = rmfield(Image,'CRST');
     end  
     if isfield(Image,'LE')
         Image = rmfield(Image,'LE');
     end  
       if isfield(Image,'HE')
         Image = rmfield(Image,'HE');
       end
      if isfield(Image,'RST')
         Image = rmfield(Image,'RST');
      end
      if isfield(Image,'Tmask3C')
         Image = rmfield(Image,'Tmask3C');
      end
       
    if isfield(Image,'material')
         Image = rmfield(Image,'material');
    end    
    if isfield(Image,'thickness')
         Image = rmfield(Image,'thickness');
    end       
    if isfield(Image,'thirdcomponent')
         Image = rmfield(Image,'thirdcomponent');
    end       
    if isfield(Image,'CTmask3C')
         Image = rmfield(Image,'CTmask3C');
    end
    
    
    
     flag.open_image_file = false;  
    
    Result.calibration_type = calibration_type;
    Info.DigitizerId = 4;
    Analysis.PhantomID = 9;
    flag.Selenia_image = true;
    Info.Database = false;
    flag.RawImage = false;
    Result.DXASeleniaCalculated = false;
    Result.DXASeleniaBreastCalculated = false;
    Result.flagLE = true;
    Result.flagHE = false;
    Result.DXASelenia = true;
    %Image.centerlistactivated = 12;
    Analysis.Filmresolution = 0.14;
    Info.DXAAnalysisRetrieved = false;    
    Option = Result.DXASelenia;
    clear_DXAfields;
    funcMenuOpenImage(Option); % open the LE image
    Result.flagHE = true;
    option = Result.DXASelenia;
    funcMenuOpenImage(option); % open the HE image
    SXAAnalysis = [];
    DXAAnalysis = [];
    MaskROIproj = [];
    BreastMask = [];
    ROI = [];
    set(ctrl.text_zone,'String','Ok');
    
    
    
    
    