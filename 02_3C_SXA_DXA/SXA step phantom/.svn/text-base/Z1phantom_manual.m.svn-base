function params = Z1phantom_manual()
global Info params Error h_init Database
     
     [sort_coord] = manualbbsZ1_position(); 
    %[sort_coord] = bbs_position_analog();
    if length(sort_coord(:,1)) < 6
        Error.StepPhantomBBsFailure = true;
        stop;
    else
        %xm = strmatch('UKMarsden', Info.StudyID, 'exact');
         xm = strmatch('mammo_Marsden', Database.Name, 'exact');
       if xm > 0         
          params = bbUK_3Dreconstruction(sort_coord);   
       else    
          params = bbZ1_3Dreconstruction(sort_coord);
       end
       % params = bbUK_3Dreconstruction(sort_coord)
       % params = bbZ1_3Dreconstruction(sort_coord);
    
    end
   % delete(h_init);