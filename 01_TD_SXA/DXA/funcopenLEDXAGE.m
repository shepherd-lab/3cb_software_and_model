function funcopenLEDXAGE()
    global Result Image
    Result.DXAProdigyCalculated = false;
    Result.DXAProdigyBreastCalculated = false;
    Result.flagLE = true;
    Result.flagHE = false;
    Result.DXAProdigy = true;
    Image.centerlistactivated = 12;
    option = Result.DXAProdigy;
    FuncMenuOpenImage(option);
    Result.flagHE = true; 
    option = Result.DXAProdigy;
    FuncMenuOpenImage(option);