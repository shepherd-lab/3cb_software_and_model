function funcOpenSeleniaImage(Option)
    global flag Analysis Info Result Image
    if ~exist('Option')
    Option='NULL';
    end
    %Info.nomatfile = false;
    Analysis.second_phantom = false;
    flag.Selenia_image = true;
    flag.RawImage = false;
    Info.DigitizerId = 4;
    Info.Database = false;
    Info.centerlistactivated = 1;
    Analysis.PhantomID = 9;
    Analysis.RefFat = 0;
    Analysis.RefGland = 80;
    % only for dxa regime temporary
    Result.DXASelenia = false;
    %Image.centerlistactivated = 12; %12
    Option = true;
    Result.flagLE = true;
    Result.flagHE = false;
    flag.open_image_file = false;
    clear_DXAfields;
   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    funcMenuOpenImage(Option);
    %{
     if Info.DigitizerId == 4 
         if Info.centerlistactivated ~= 116
             if (strcmp(Info.Position,'CC') & strcmp(Info.Laterality,'L'))
                imagemenu('flipH');
             elseif strcmp(Info.Position,'CC') & strcmp(Info.Laterality,'R')
                imagemenu('flipV'); 
             end
         elseif  Info.centerlistactivated == 116 
                imagemenu('flipV');
                imagemenu('flipH'); 
         end
     end
    %}
    %%%%temporary for calibration
    %{
          
     if strcmp(Info.View,'R CC')
        imagemenu('flipV');
     elseif strcmp(Info.View,'L CC')
        imagemenu('flipH'); 
     end
    %}
    %{
    imagemenu('flipV');
    imagemenu('flipH');
    PhantomDetection;
   % SeleniaDXADSP();
    %}
    %PhantomDetection;
    