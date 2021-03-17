function OpenImage(RequestAction)
    global flag Info Result Analysis
    if ~exist('Option')
        Option='NULL';
    end
    flag.Selenia_image = false;
    flag.RawImage = false;
    %Info.DigitizerId = 4;
    Result.flagLE = false; 
    Result.flagHE = false; 
    Result.DXAProdigy = false;
    Result.DXASelenia = false;
    Info.Database = false;
    clear_DXAfields;
    flag.open_image_file = true;
    
%     try
       switch RequestAction
         case 'Image' 
            FuncMenuOpenImage(Option);
         case 'Density'
             Analysis.Step=1;
             [FileName,PathName] = uigetfile('\\researchstg\aaDATA\Breast Studies\*.png','Select the density or thickness map file ');
             filename_total = [PathName,'\',FileName]; 
             Image.material = double(imread(filename_total))/100; 
             ReinitImage(Image.material,'OPTIMIZEHIST');
             draweverything;   
         case 'Thickness'
             Analysis.Step=1;
             [FileName,PathName] = uigetfile('\\researchstg\aaDATA\Breast Studies\*.png','Select the density or thickness map file ');
             filename_total = [PathName,'\',FileName]; 
             Image.material = double(imread(filename_total))/1000; 
             ReinitImage(Image.material,'OPTIMIZEHIST');
             draweverything;   
         otherwise
              Message('Can not open image file...');
       end      
          
%     catch
%       flag.open_image_file = false; 
%     end