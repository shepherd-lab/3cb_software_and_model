function image_size()

        Database.Name = 'mammo_CPMC';
        acq_list = load('C:\Documents and Settings\smalkov\My Documents\CalibrationFiles\CPMC\step_phantom\Cancer cases\all_cases.txt','%s');
        
        for i = 1:length(acq_list)
            b=mxDatabase(Database.Name,['select * from acquisition where acquisition_id=',num2str(acq_list(i))]);
            fname=strcat(cell2mat(b(17)),'');  
            b =  dir(fname);
            value = b.bytes;
            table = 'acquisition';
            field = 'image_size';
            SQLstatement=['update ', table,  ' set ', field, '=', num2str(value),' where acquisition_id=',num2str(acq_list(i))];
            mxDatabase(Database.Name,SQLstatement); 
              
        end
            
            
            