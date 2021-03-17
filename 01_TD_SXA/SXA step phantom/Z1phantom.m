function params = Z1phantom_automatic()
global Info
    % D = 'C:\Documents and Settings\smalkov\My Documents\Programs\'; 
    %D = 'C:\Documents and Settings\smalkov\My Documents\SeleniaImages\Selenia_room116\15May\txt_files\';
    %file_name = [D,num2str(Info.AcquisitionKey),'.txt']; 
    
   % manualbbs_position();
   % sort_coord = load(file_name);
    [sort_coord] = manualbbsZ1_position(); 
    %[sort_coord] = bbs_position_analog();
    params = bbZ1_3Dreconstruction(sort_coord);
    %roi9stepsZETA1_projection();
    
    