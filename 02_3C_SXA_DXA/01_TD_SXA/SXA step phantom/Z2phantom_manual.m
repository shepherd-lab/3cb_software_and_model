function params = Z2phantom_manual()
global Info params Error h_init Database
     
     [sort_coord] = manualbbsZ2_position(); 
    %[sort_coord] = bbs_position_analog();
    if length(sort_coord(:,1)) < 6
        Error.StepPhantomBBsFailure = true;
        stop;
    else
          params = bbZ2_3Dreconstruction(sort_coord);
    end
          
    
 