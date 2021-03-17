function pregen3_thickness(date_acquisition_num,machine_id, flag)
global Analysis

k= 1.8;

if machine_id == 1
    g=1.9;
    if flag.small_paddle
        
        if date_acquisition_num > datenum('20060101', 'yyyymmdd') & date_acquisition_num <= datenum('20070331', 'yyyymmdd');
            Analysis.error_thickDB =  Analysis.error_thickDB;
            
        elseif date_acquisition_num > datenum('20070331', 'yyyymmdd') & date_acquisition_num <= datenum('20070731', 'yyyymmdd');
            Analysis.error_thickDB =  Analysis.error_thickDB +0.6175;% 1.3*g;
        elseif  date_acquisition_num > datenum('20070731', 'yyyymmdd') & date_acquisition_num <= datenum('20090231', 'yyyymmdd'); %20090731
            Analysis.error_thickDB =  Analysis.error_thickDB +1.52;%2.4*g;
            
        elseif  date_acquisition_num > datenum('20090301', 'yyyymmdd')
            Analysis.error_thickDB =  Analysis.error_thickDB ;
        end
        
    elseif flag.small_paddle == 0
        
        if date_acquisition_num > datenum('20060101', 'yyyymmdd') & date_acquisition_num <= datenum('20070331', 'yyyymmdd');
            Analysis.error_thickDB =  Analysis.error_thickDB +3.915;%2.7*g;
            
        elseif date_acquisition_num > datenum('20070331', 'yyyymmdd') & date_acquisition_num <= datenum('20070731', 'yyyymmdd');
            Analysis.error_thickDB =  Analysis.error_thickDB +1.1*k;%2.7*g;
            
        elseif date_acquisition_num > datenum('20070731', 'yyyymmdd') & date_acquisition_num <= datenum('20071131', 'yyyymmdd');
            Analysis.error_thickDB =  Analysis.error_thickDB +2.35*k;%2.7*g;
            
        elseif date_acquisition_num > datenum('20071131', 'yyyymmdd') & date_acquisition_num <= datenum('20080731', 'yyyymmdd');
            Analysis.error_thickDB =  Analysis.error_thickDB +1.6*k;%2.7*g;

        elseif date_acquisition_num > datenum('20080731', 'yyyymmdd') & date_acquisition_num <= datenum('20090231', 'yyyymmdd');
            Analysis.error_thickDB =  Analysis.error_thickDB +2.3*k;%2.7*g;
            
        elseif date_acquisition_num > datenum('20090231', 'yyyymmdd');
            Analysis.error_thickDB =  Analysis.error_thickDB ;
  
        end
        
    end

elseif machine_id == 2
    g=1.9;
    if flag.small_paddle
        if date_acquisition_num > datenum('20060101', 'yyyymmdd') & date_acquisition_num <= datenum('20080931', 'yyyymmdd');
            Analysis.error_thickDB =  Analysis.error_thickDB -1.6*g;
        elseif  date_acquisition_num > datenum('20080931', 'yyyymmdd') & date_acquisition_num <= datenum('20090731', 'yyyymmdd');
            Analysis.error_thickDB =  Analysis.error_thickDB;
            
        elseif  date_acquisition_num > datenum('20090731', 'yyyymmdd');
            Analysis.error_thickDB =  Analysis.error_thickDB;
        end
    elseif flag.small_paddle == 0
        if date_acquisition_num > datenum('20060101', 'yyyymmdd') & date_acquisition_num <= datenum('20080931', 'yyyymmdd');
            Analysis.error_thickDB =  Analysis.error_thickDB -1.6*g; %1.3
            
        elseif  date_acquisition_num > datenum('20080931', 'yyyymmdd') & date_acquisition_num <= datenum('20090731', 'yyyymmdd');
            Analysis.error_thickDB =  Analysis.error_thickDB;
     
        
        elseif  date_acquisition_num > datenum('20090731', 'yyyymmdd');
            Analysis.error_thickDB =  Analysis.error_thickDB;
        end
    end
    
    
elseif machine_id == 3
    g=1.9;
    if flag.small_paddle
        
        if date_acquisition_num > datenum('20060101', 'yyyymmdd') & date_acquisition_num <= datenum('20070331', 'yyyymmdd');
            Analysis.error_thickDB =  Analysis.error_thickDB;
            
        elseif date_acquisition_num > datenum('20070331', 'yyyymmdd') & date_acquisition_num <= datenum('20090731', 'yyyymmdd');
            Analysis.error_thickDB =  Analysis.error_thickDB+0.9*k;
            
        elseif  date_acquisition_num > datenum('20090731', 'yyyymmdd')
            Analysis.error_thickDB =  Analysis.error_thickDB;
            
        end
    elseif flag.small_paddle == 0
        if date_acquisition_num > datenum('20060101', 'yyyymmdd') & date_acquisition_num <= datenum('20070331', 'yyyymmdd');
            Analysis.error_thickDB =  Analysis.error_thickDB +0.9*k; %1.4*g;
            
        elseif date_acquisition_num > datenum('20070331', 'yyyymmdd') & date_acquisition_num <= datenum('20070731', 'yyyymmdd');
            Analysis.error_thickDB =  Analysis.error_thickDB +2.1*k;
            
        elseif  date_acquisition_num > datenum('20070731', 'yyyymmdd') & date_acquisition_num <= datenum('20090631', 'yyyymmdd');
            Analysis.error_thickDB =  Analysis.error_thickDB + 4.0192; %2.75*g;
            
        elseif  date_acquisition_num > datenum('20090631', 'yyyymmdd');
            Analysis.error_thickDB =  Analysis.error_thickDB;
        end
        
    end
    
    
    
elseif machine_id == 18
    
    if flag.small_paddle
        if date_acquisition_num < datenum('20070731', 'yyyymmdd');
            Analysis.error_thickDB =  Analysis.error_thickDB +0.25*k;
        elseif  date_acquisition_num >= datenum('20070731', 'yyyymmdd') & date_acquisition_num < datenum('20090701', 'yyyymmdd');
            Analysis.error_thickDB =  Analysis.error_thickDB+0.9*k;
            
        elseif  date_acquisition_num >= datenum('20090701', 'yyyymmdd')
            Analysis.error_thickDB =  Analysis.error_thickDB +0.5*k;
        end
    elseif flag.small_paddle == 0
        if date_acquisition_num < datenum('20070731', 'yyyymmdd');
            Analysis.error_thickDB =  Analysis.error_thickDB +1.9*k;
        elseif  date_acquisition_num >= datenum('20070731', 'yyyymmdd') & date_acquisition_num < datenum('20090701', 'yyyymmdd');
            Analysis.error_thickDB =  Analysis.error_thickDB+2.2*k;
            
        elseif  date_acquisition_num >= datenum('20090701', 'yyyymmdd')
            Analysis.error_thickDB =  Analysis.error_thickDB +0.3*k;
        end
    end
    
elseif machine_id == 19
    
    if flag.small_paddle
        if date_acquisition_num < datenum('20070731', 'yyyymmdd');
            Analysis.error_thickDB =  Analysis.error_thickDB -1.3*k;
        elseif  date_acquisition_num >= datenum('20070731', 'yyyymmdd') & date_acquisition_num < datenum('20080501', 'yyyymmdd');
            Analysis.error_thickDB =  Analysis.error_thickDB -k;
            
              elseif  date_acquisition_num >= datenum('20080501', 'yyyymmdd') & date_acquisition_num < datenum('20090701', 'yyyymmdd');
            Analysis.error_thickDB =  Analysis.error_thickDB -0.92*k;
            
        elseif  date_acquisition_num >= datenum('20090701', 'yyyymmdd')
            Analysis.error_thickDB =  Analysis.error_thickDB -0.08*k;
        end
    elseif flag.small_paddle == 0
        if date_acquisition_num < datenum('20070731', 'yyyymmdd');
            Analysis.error_thickDB =  Analysis.error_thickDB-0.6*k;
        elseif  date_acquisition_num >= datenum('20070731', 'yyyymmdd') & date_acquisition_num < datenum('20090701', 'yyyymmdd');
            Analysis.error_thickDB =  Analysis.error_thickDB-0.65*k;
            
        elseif  date_acquisition_num >= datenum('20090701', 'yyyymmdd')
            Analysis.error_thickDB =  Analysis.error_thickDB;
        end
    end
    
    
elseif machine_id == 20
    
    if flag.small_paddle
        if date_acquisition_num < datenum('20070731', 'yyyymmdd');
            Analysis.error_thickDB =  Analysis.error_thickDB +1.72*k;
        elseif  date_acquisition_num >= datenum('20070731', 'yyyymmdd') & date_acquisition_num < datenum('20080201', 'yyyymmdd');
            Analysis.error_thickDB =  Analysis.error_thickDB +1.6*k;
        elseif  date_acquisition_num >= datenum('20080201', 'yyyymmdd') & date_acquisition_num < datenum('20080731', 'yyyymmdd');
            Analysis.error_thickDB =  Analysis.error_thickDB +1.7*k;
        elseif  date_acquisition_num >= datenum('20080731', 'yyyymmdd') & date_acquisition_num < datenum('20090701', 'yyyymmdd');
            Analysis.error_thickDB =  Analysis.error_thickDB +1.6*k;
            
        elseif  date_acquisition_num >= datenum('20090701', 'yyyymmdd')
            Analysis.error_thickDB =  Analysis.error_thickDB +1.35*k;
        end
    elseif flag.small_paddle == 0
        if date_acquisition_num < datenum('20070731', 'yyyymmdd');
            Analysis.error_thickDB =  Analysis.error_thickDB-1.3*k;
        elseif  date_acquisition_num >= datenum('20070731', 'yyyymmdd') & date_acquisition_num < datenum('20090201', 'yyyymmdd');
            Analysis.error_thickDB =  Analysis.error_thickDB+k;
        elseif  date_acquisition_num >= datenum('20090201', 'yyyymmdd') & date_acquisition_num < datenum('20090701', 'yyyymmdd');
            Analysis.error_thickDB =  Analysis.error_thickDB+k;
        elseif  date_acquisition_num >= datenum('20090701', 'yyyymmdd')
            Analysis.error_thickDB =  Analysis.error_thickDB+0.3*k;
        end
    end
    
        
elseif machine_id == 27
    if flag.small_paddle
        if date_acquisition_num > datenum('20060101', 'yyyymmdd') & date_acquisition_num <= datenum('20080224', 'yyyymmdd');
            Analysis.error_thickDB =  Analysis.error_thickDB  + (1.3+0.68)*k;
        elseif  date_acquisition_num > datenum('20080224', 'yyyymmdd') & date_acquisition_num <= datenum('20080509', 'yyyymmdd');
            Analysis.error_thickDB =  Analysis.error_thickDB  + (2.35+0.68)*k;
        elseif  date_acquisition_num > datenum('20080509', 'yyyymmdd') & date_acquisition_num <= datenum('20081117', 'yyyymmdd');
            Analysis.error_thickDB =  Analysis.error_thickDB  + (1.3+0.68)*k;
        elseif  date_acquisition_num > datenum('20081117', 'yyyymmdd') & date_acquisition_num <= datenum('20090811', 'yyyymmdd');
            Analysis.error_thickDB =  Analysis.error_thickDB +0.68;
        elseif  date_acquisition_num > datenum('20090811', 'yyyymmdd') & date_acquisition_num <= datenum('20110101', 'yyyymmdd');
            Analysis.error_thickDB =  Analysis.error_thickDB ;
        end
    elseif flag.small_paddle == 0
        if date_acquisition_num > datenum('20060101', 'yyyymmdd') & date_acquisition_num <= datenum('20080426', 'yyyymmdd');
            Analysis.error_thickDB =  Analysis.error_thickDB  + 0.55*k;
        elseif  date_acquisition_num > datenum('20080426', 'yyyymmdd') & date_acquisition_num <= datenum('20080809', 'yyyymmdd');
            Analysis.error_thickDB =  Analysis.error_thickDB  + 1.3*k;
        elseif  date_acquisition_num > datenum('20080809', 'yyyymmdd') & date_acquisition_num <= datenum('20110101', 'yyyymmdd');
            Analysis.error_thickDB =  Analysis.error_thickDB;
        end
    end
elseif machine_id == 28
    if flag.small_paddle
        if date_acquisition_num > datenum('20060101', 'yyyymmdd') & date_acquisition_num <= datenum('20080420', 'yyyymmdd')
            Analysis.error_thickDB =  Analysis.error_thickDB;
        elseif  date_acquisition_num > datenum('20080420', 'yyyymmdd') & date_acquisition_num <= datenum('20080925', 'yyyymmdd')
            Analysis.error_thickDB =  Analysis.error_thickDB  + 1.6;
        elseif  date_acquisition_num > datenum('20080925', 'yyyymmdd') & date_acquisition_num <= datenum('20110101', 'yyyymmdd')
            Analysis.error_thickDB =  Analysis.error_thickDB;
        end
    elseif flag.small_paddle == 0
        if date_acquisition_num > datenum('20060101', 'yyyymmdd') & date_acquisition_num <= datenum('20080329', 'yyyymmdd')
            Analysis.error_thickDB =  Analysis.error_thickDB - 1.5-0.3*k;
        elseif  date_acquisition_num > datenum('20080329', 'yyyymmdd') & date_acquisition_num <= datenum('20110101', 'yyyymmdd')
            Analysis.error_thickDB =  Analysis.error_thickDB -0.3*k;
        end
    end
elseif machine_id == 29
    if flag.small_paddle
        if date_acquisition_num > datenum('20060101', 'yyyymmdd') & date_acquisition_num <= datenum('20080408', 'yyyymmdd')
            Analysis.error_thickDB =  Analysis.error_thickDB - 4.1;
        elseif  date_acquisition_num > datenum('20080408', 'yyyymmdd') & date_acquisition_num <= datenum('20090926', 'yyyymmdd')
            Analysis.error_thickDB =  Analysis.error_thickDB  - 2.3;
        elseif  date_acquisition_num > datenum('20090926', 'yyyymmdd') & date_acquisition_num <= datenum('20110101', 'yyyymmdd')
            Analysis.error_thickDB =  Analysis.error_thickDB;
        end
    elseif flag.small_paddle == 0
        if date_acquisition_num > datenum('20060101', 'yyyymmdd') & date_acquisition_num <= datenum('20080617', 'yyyymmdd')
            Analysis.error_thickDB =  Analysis.error_thickDB - 2.8;
        elseif  date_acquisition_num > datenum('20080617', 'yyyymmdd') & date_acquisition_num <= datenum('20090702', 'yyyymmdd')
            Analysis.error_thickDB =  Analysis.error_thickDB + 1.4;
        elseif  date_acquisition_num > datenum('20090702', 'yyyymmdd') & date_acquisition_num <= datenum('20091229', 'yyyymmdd')
            Analysis.error_thickDB =  Analysis.error_thickDB - 2.6;
        elseif  date_acquisition_num > datenum('20091229', 'yyyymmdd') & date_acquisition_num <= datenum('20110101', 'yyyymmdd')
            Analysis.error_thickDB =  Analysis.error_thickDB - 4.5;
        end
    end
elseif machine_id == 30
    if flag.small_paddle
        if date_acquisition_num > datenum('20060101', 'yyyymmdd') & date_acquisition_num <= datenum('20090915', 'yyyymmdd')
            Analysis.error_thickDB =  Analysis.error_thickDB + 1.4;
        elseif  date_acquisition_num > datenum('20090915', 'yyyymmdd') & date_acquisition_num <= datenum('20090923', 'yyyymmdd')
            Analysis.error_thickDB =  Analysis.error_thickDB  - 5;
        elseif  date_acquisition_num > datenum('20090923', 'yyyymmdd') & date_acquisition_num <= datenum('20091209', 'yyyymmdd')
            Analysis.error_thickDB =  Analysis.error_thickDB + 1.4;
        elseif  date_acquisition_num > datenum('20091209', 'yyyymmdd') & date_acquisition_num <= datenum('20110101', 'yyyymmdd')
            Analysis.error_thickDB =  Analysis.error_thickDB - 1.5;
        end
    elseif flag.small_paddle == 0
        if date_acquisition_num > datenum('20060101', 'yyyymmdd') & date_acquisition_num <= datenum('20081025', 'yyyymmdd')
            Analysis.error_thickDB =  Analysis.error_thickDB + 4.45;
        elseif  date_acquisition_num > datenum('20081025', 'yyyymmdd') & date_acquisition_num <= datenum('20110101', 'yyyymmdd')
            Analysis.error_thickDB =  Analysis.error_thickDB + 2.9;
        end
    end
    
elseif machine_id == 31
    if flag.small_paddle
        if date_acquisition_num > datenum('20060101', 'yyyymmdd') & date_acquisition_num <= datenum('20080414', 'yyyymmdd')
            Analysis.error_thickDB =  Analysis.error_thickDB;
        elseif  date_acquisition_num > datenum('20080414', 'yyyymmdd') & date_acquisition_num <= datenum('20081005', 'yyyymmdd')
            Analysis.error_thickDB =  Analysis.error_thickDB + 2*k;
        elseif  date_acquisition_num > datenum('20081005', 'yyyymmdd') & date_acquisition_num <= datenum('20081111', 'yyyymmdd')
            Analysis.error_thickDB =  Analysis.error_thickDB + 2*k - 0.6*k;
        elseif  date_acquisition_num > datenum('20081111', 'yyyymmdd') & date_acquisition_num <= datenum('20110101', 'yyyymmdd')
            Analysis.error_thickDB =  Analysis.error_thickDB - 1.3  - 0.6*k;
        end
    elseif flag.small_paddle == 0
        if date_acquisition_num > datenum('20060101', 'yyyymmdd') & date_acquisition_num <= datenum('20080408', 'yyyymmdd')
            Analysis.error_thickDB =  Analysis.error_thickDB + 1.25*k ;
        elseif  date_acquisition_num > datenum('20080408', 'yyyymmdd') & date_acquisition_num <= datenum('20090304', 'yyyymmdd')
            Analysis.error_thickDB =  Analysis.error_thickDB + 2.35*k;
        elseif  date_acquisition_num > datenum('20090304', 'yyyymmdd') & date_acquisition_num <= datenum('20090612', 'yyyymmdd')
            Analysis.error_thickDB =  Analysis.error_thickDB  ;
        elseif  date_acquisition_num > datenum('20090612', 'yyyymmdd') & date_acquisition_num <= datenum('20110101', 'yyyymmdd')
            Analysis.error_thickDB =  Analysis.error_thickDB + 1.3*k ;
        end
    end
    
elseif machine_id == 32
    if flag.small_paddle
        if date_acquisition_num > datenum('20060101', 'yyyymmdd') & date_acquisition_num <= datenum('20091020', 'yyyymmdd')
            Analysis.error_thickDB =  Analysis.error_thickDB - 2.85*k  ;
        elseif  date_acquisition_num > datenum('20091020', 'yyyymmdd') & date_acquisition_num <= datenum('20090304', 'yyyymmdd')
            Analysis.error_thickDB =  Analysis.error_thickDB ;
        end
    elseif flag.small_paddle == 0
        if date_acquisition_num > datenum('20060101', 'yyyymmdd') & date_acquisition_num <= datenum('20080309', 'yyyymmdd')
            Analysis.error_thickDB =  Analysis.error_thickDB + 1.3*k + 0.68*k;
        elseif  date_acquisition_num > datenum('20080309', 'yyyymmdd') & date_acquisition_num <= datenum('20080516', 'yyyymmdd')
            Analysis.error_thickDB =  Analysis.error_thickDB + 2.35*k + 0.68*k;
        elseif  date_acquisition_num > datenum('20080516', 'yyyymmdd') & date_acquisition_num <= datenum('20081030', 'yyyymmdd')
            Analysis.error_thickDB =  Analysis.error_thickDB +4.6*k + 0.68*k;
        elseif  date_acquisition_num > datenum('20081030', 'yyyymmdd') & date_acquisition_num <= datenum('20090602', 'yyyymmdd')
            Analysis.error_thickDB =  Analysis.error_thickDB + 1.9*k + 0.68*k;
        elseif  date_acquisition_num > datenum('20090602', 'yyyymmdd') & date_acquisition_num <= datenum('20090925', 'yyyymmdd')
            Analysis.error_thickDB =  Analysis.error_thickDB + 1.9*k;
        elseif  date_acquisition_num > datenum('20090925', 'yyyymmdd') & date_acquisition_num <= datenum('20110101', 'yyyymmdd')
            Analysis.error_thickDB =  Analysis.error_thickDB - 1.55*k ;
        end
    end
elseif machine_id == 36
    if flag.small_paddle
        if date_acquisition_num > datenum('20060101', 'yyyymmdd') & date_acquisition_num <= datenum('20081214', 'yyyymmdd')
            Analysis.error_thickDB =  Analysis.error_thickDB - 1.3*k  ;
        elseif  date_acquisition_num > datenum('20081214', 'yyyymmdd') & date_acquisition_num <= datenum('20090418', 'yyyymmdd')
            Analysis.error_thickDB =  Analysis.error_thickDB - 2.2*k ;
        elseif  date_acquisition_num > datenum('20090418', 'yyyymmdd') & date_acquisition_num <= datenum('20110101', 'yyyymmdd')
            Analysis.error_thickDB =  Analysis.error_thickDB ;
        end
    elseif flag.small_paddle == 0
        if date_acquisition_num > datenum('20060101', 'yyyymmdd') & date_acquisition_num <= datenum('20090622', 'yyyymmdd')
            Analysis.error_thickDB =  Analysis.error_thickDB;
        elseif  date_acquisition_num > datenum('20090622', 'yyyymmdd') & date_acquisition_num <= datenum('20090920', 'yyyymmdd')
            Analysis.error_thickDB =  Analysis.error_thickDB  + 0.8*k;
        elseif  date_acquisition_num > datenum('20090920', 'yyyymmdd') & date_acquisition_num <= datenum('20110101', 'yyyymmdd')
            Analysis.error_thickDB =  Analysis.error_thickDB  - 1.3*k;
        end
    end
elseif machine_id == 37
    if flag.small_paddle
        if date_acquisition_num > datenum('20060101', 'yyyymmdd') & date_acquisition_num <= datenum('20090222', 'yyyymmdd')
            Analysis.error_thickDB =  Analysis.error_thickDB + 0.55*k  ;
        elseif  date_acquisition_num > datenum('20090222', 'yyyymmdd') & date_acquisition_num <= datenum('20090701', 'yyyymmdd')
            Analysis.error_thickDB =  Analysis.error_thickDB + 1.1*k ;
        elseif  date_acquisition_num > datenum('20090701', 'yyyymmdd') & date_acquisition_num <= datenum('20110101', 'yyyymmdd')
            Analysis.error_thickDB =  Analysis.error_thickDB + 0.8*k ;
        end
    elseif flag.small_paddle == 0
        if date_acquisition_num > datenum('20060101', 'yyyymmdd') & date_acquisition_num <= datenum('20090324', 'yyyymmdd')
            Analysis.error_thickDB =  Analysis.error_thickDB - 2.3*k;
        elseif  date_acquisition_num > datenum('20090324', 'yyyymmdd') & date_acquisition_num <= datenum('20090701', 'yyyymmdd')
            Analysis.error_thickDB =  Analysis.error_thickDB  - 1.35*k;
        elseif  date_acquisition_num > datenum('20090701', 'yyyymmdd') & date_acquisition_num <= datenum('20091119', 'yyyymmdd')
            Analysis.error_thickDB =  Analysis.error_thickDB + 0.05*k ;
        elseif  date_acquisition_num > datenum('20091119', 'yyyymmdd') & date_acquisition_num <= datenum('20110101', 'yyyymmdd')
            Analysis.error_thickDB =  Analysis.error_thickDB + 0.55*k ;
        end
    end
elseif machine_id == 38
    if flag.small_paddle
        if date_acquisition_num > datenum('20060101', 'yyyymmdd') & date_acquisition_num <= datenum('20090324', 'yyyymmdd')
            Analysis.error_thickDB =  Analysis.error_thickDB - 2.6*k  ;
        elseif  date_acquisition_num > datenum('20090324', 'yyyymmdd') & date_acquisition_num <= datenum('20100123', 'yyyymmdd')
            Analysis.error_thickDB =  Analysis.error_thickDB - 0.95*k ;
        elseif  date_acquisition_num > datenum('20100123', 'yyyymmdd') & date_acquisition_num <= datenum('20110101', 'yyyymmdd')
            Analysis.error_thickDB =  Analysis.error_thickDB + 0.55*k ;
        end
    elseif flag.small_paddle == 0
        if date_acquisition_num > datenum('20060101', 'yyyymmdd') & date_acquisition_num <= datenum('20090920', 'yyyymmdd')
            Analysis.error_thickDB =  Analysis.error_thickDB - 1.4*k;
        elseif  date_acquisition_num > datenum('20090920', 'yyyymmdd') & date_acquisition_num <= datenum('20110101', 'yyyymmdd')
            Analysis.error_thickDB =  Analysis.error_thickDB;
        end
    end
elseif machine_id == 39
    if flag.small_paddle
        if date_acquisition_num > datenum('20060101', 'yyyymmdd') & date_acquisition_num <= datenum('20100118', 'yyyymmdd')
            Analysis.error_thickDB =  Analysis.error_thickDB - 1.1*k  ;
        elseif  date_acquisition_num > datenum('20100118', 'yyyymmdd') & date_acquisition_num <= datenum('20110101', 'yyyymmdd')
            Analysis.error_thickDB =  Analysis.error_thickDB;
        end
    elseif flag.small_paddle == 0
        if date_acquisition_num > datenum('20060101', 'yyyymmdd') & date_acquisition_num <= datenum('20081031', 'yyyymmdd')
            Analysis.error_thickDB =  Analysis.error_thickDB - 1.85*k;
        elseif  date_acquisition_num > datenum('20081031', 'yyyymmdd') & date_acquisition_num <= datenum('20100202', 'yyyymmdd')
            Analysis.error_thickDB =  Analysis.error_thickDB -2.5*k;
        elseif  date_acquisition_num > datenum('20100202', 'yyyymmdd') & date_acquisition_num <= datenum('20110101', 'yyyymmdd')
            Analysis.error_thickDB =  Analysis.error_thickDB;
        end
    end
elseif machine_id == 40
    if flag.small_paddle
        if date_acquisition_num > datenum('20060101', 'yyyymmdd') & date_acquisition_num <= datenum('20110101', 'yyyymmdd')
            Analysis.error_thickDB =  Analysis.error_thickDB ;
        end
    elseif flag.small_paddle == 0
        if date_acquisition_num > datenum('20060101', 'yyyymmdd') & date_acquisition_num <= datenum('20110101', 'yyyymmdd')
            Analysis.error_thickDB =  Analysis.error_thickDB + 0.5*k;
        end
    end
elseif machine_id == 41
    if flag.small_paddle
        if date_acquisition_num > datenum('20060101', 'yyyymmdd') & date_acquisition_num <= datenum('20110101', 'yyyymmdd')
            Analysis.error_thickDB =  Analysis.error_thickDB + 0.95*k ;
        end
    elseif flag.small_paddle == 0
        if date_acquisition_num > datenum('20060101', 'yyyymmdd') & date_acquisition_num <= datenum('20110101', 'yyyymmdd')
            Analysis.error_thickDB =  Analysis.error_thickDB + 1.3*k ;
        end
    end
else
    Analysis.error_thickDB =  Analysis.error_thickDB;
    
end

