function funcopenLEDXAGE()
%     global Result Image
%     
%     Result.flagLE = true;
%     Result.flagHE = false;
%     Image.centerlistactivated = 12;
%     funcMenuOpenImage(option);
%     Result.flagHE = true; 
%     funcMenuOpenImage(option);
    
     global Result Image
    Result.DXAProdigyCalculated = false;
    Result.DXAProdigyBreastCalculated = false;
    Result.flagLE = true;
    Result.flagHE = false;
    Result.DXAProdigy = true;
    Image.centerlistactivated = 12;
    option = Result.DXAProdigy;
    funcMenuOpenImage(option);
    Result.flagHE = true; 
    option = Result.DXAProdigy;
   funcMenuOpenImage(option);