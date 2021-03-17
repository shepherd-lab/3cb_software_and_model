function funcopenSeleniaDXA(calibration_type)
    global Result Image flag Info Analysis ctrl file SXAAnalysis DXAAnalysis
    if ~exist('Option')
    Option='NULL';
    end
      
    Result.calibration_type = calibration_type;
    %Info.DigitizerId = 4;
    Analysis.PhantomID = 9;
    flag.Selenia_image = true;
    Info.Database = false;
    Result.DXASeleniaCalculated = false;
    Result.DXASeleniaBreastCalculated = false;
    Result.DXAProdigyCalculated = false;
    Result.DXAProdigyBreastCalculated = false;
    Result.flagLE = true;
    Result.flagHE = false;
    Result.DXASelenia = true;
    %Image.centerlistactivated = 12;
    %Analysis.Filmresolution = 0.14;
    Result.DXAProdigy = false;
        
    Option = Result.DXASelenia;
    FuncMenuOpenImage(Option);
    Result.flagHE = true;
    option = Result.DXASelenia;
    FuncMenuOpenImage(option);
    SXAAnalysis = [];
    DXAAnalysis = [];
    MaskROIproj = [];
    BreastMask = [];
    set(ctrl.text_zone,'String','Ok');
    
    
    
    
    