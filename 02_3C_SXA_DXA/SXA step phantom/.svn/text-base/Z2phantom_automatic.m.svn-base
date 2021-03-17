function params = Z2phantom_automatic()
global Info params Error 
    % D = 'C:\Documents and Settings\smalkov\My Documents\Programs\'; 
    %D = 'C:\Documents and Settings\smalkov\My Documents\SeleniaImages\Selenia_room116\15May\txt_files\';
    %file_name = [D,num2str(Info.AcquisitionKey),'.txt']; 
    
   % manualbbs_position();
   % sort_coord = load(file_name);
   [sort_coord] = bbs_position_digital();
    
    if length(sort_coord(:,1)) < 6
        Error.StepPhantomBBsFailure = true;
        stop;
    else
        params = bbZ2_3Dreconstruction(sort_coord);
    
    end
   
    %roi9stepsZETA1_projection();
    ;
    