function OpenSeleniaRawImage(Option)
    global flag Info Result Image
    if ~exist('Option')
        Option='NULL';
    end
    flag.Selenia_image = false;
    flag.RawImage = true;
    %Info.DigitizerId = 100;
    Result.flagLE = false; 
    Result.flagHE = false; 
    Result.DXAProdigy = false;
    Result.DXASelenia = false;
    Info.Database = false;
    flag.open_image_file = false;
    clear_DXAfields;
    FuncMenuOpenImage(Option);