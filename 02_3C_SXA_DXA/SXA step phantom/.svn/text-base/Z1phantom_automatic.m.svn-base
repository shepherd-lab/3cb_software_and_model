function params = Z1phantom_automatic()
global Info params Error Database
    % D = 'C:\Documents and Settings\smalkov\My Documents\Programs\'; 
    %D = 'C:\Documents and Settings\smalkov\My Documents\SeleniaImages\Selenia_room116\15May\txt_files\';
    %file_name = [D,num2str(Info.AcquisitionKey),'.txt']; 
     xm = strmatch('mammo_Marsden', Database.Name, 'exact');
   % manualbbs_position();
   % sort_coord = load(file_name);
   if xm > 0    
      [sort_coord] = bbs_position_analogUK();
   else
      [sort_coord] = bbs_position_analog;
   end
   
   if length(sort_coord(:,1)) < 6 | length(sort_coord(:,1)) > 9
        Error.StepPhantomBBsFailure = true;
        a = 'Manual regime'
        %stop;
    else
       %xm = strmatch('UKMarsden', Info.StudyID, 'exact');
       % xm = strmatch('mammo_Marsden', Database.Name, 'exact');
       if xm > 0         
          params = bbUK_3Dreconstruction(sort_coord);   
       else    
          params = bbZ1_3Dreconstruction(sort_coord);
       end
    end
    %roi9stepsZETA1_projection();
    ;
    