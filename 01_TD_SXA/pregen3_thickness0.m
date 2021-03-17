function pregen3_thickness(date_acquisition_num,machine_id, flag)
global Analysis 

 if machine_id == 27
        if flag.small_paddle
            if date_acquisition_num > datenum('20060101', 'yyyymmdd') & date_acquisition_num <= datenum('20080224', 'yyyymmdd')
                Analysis.error_thickDB =  Analysis.error_thickDB  + 1.3;
            elseif  date_acquisition_num > datenum('20080224', 'yyyymmdd') & date_acquisition_num <= datenum('20080509', 'yyyymmdd')
                Analysis.error_thickDB =  Analysis.error_thickDB  + 2.35;
            elseif  date_acquisition_num > datenum('20080509', 'yyyymmdd') & date_acquisition_num <= datenum('20110101', 'yyyymmdd')
                Analysis.error_thickDB =  Analysis.error_thickDB  + 1.3;
            end
        elseif flag.small_paddle == 0
            if date_acquisition_num > datenum('20060101', 'yyyymmdd') & date_acquisition_num <= datenum('20080426', 'yyyymmdd')
                Analysis.error_thickDB =  Analysis.error_thickDB  + 0.55;
            elseif  date_acquisition_num > datenum('20080426', 'yyyymmdd') & date_acquisition_num <= datenum('20080809', 'yyyymmdd')
                Analysis.error_thickDB =  Analysis.error_thickDB  + 1.3;
            elseif  date_acquisition_num > datenum('20080809', 'yyyymmdd') & date_acquisition_num <= datenum('20110101', 'yyyymmdd')
                Analysis.error_thickDB =  Analysis.error_thickDB;
            end
        end
    elseif machine_id == 28
        if flag.small_paddle
            if date_acquisition_num > datenum('20060101', 'yyyymmdd') & date_acquisition_num <= datenum('20080420', 'yyyymmdd')
                Analysis.error_thickDB =  Analysis.error_thickDB;
            elseif  date_acquisition_num > datenum('20080420', 'yyyymmdd') & date_acquisition_num <= datenum('20080925', 'yyyymmdd')
                Analysis.error_thickDB =  Analysis.error_thickDB  + 1.3;
            elseif  date_acquisition_num > datenum('20080925', 'yyyymmdd') & date_acquisition_num <= datenum('20110101', 'yyyymmdd')
                Analysis.error_thickDB =  Analysis.error_thickDB;
            end
        elseif flag.small_paddle == 0
            if date_acquisition_num > datenum('20060101', 'yyyymmdd') & date_acquisition_num <= datenum('20080329', 'yyyymmdd')
                Analysis.error_thickDB =  Analysis.error_thickDB - 1.5;
            elseif  date_acquisition_num > datenum('20080329', 'yyyymmdd') & date_acquisition_num <= datenum('20110101', 'yyyymmdd')
                Analysis.error_thickDB =  Analysis.error_thickDB;
            end
        end
    elseif machine_id == 29
        if flag.small_paddle
            if date_acquisition_num > datenum('20060101', 'yyyymmdd') & date_acquisition_num <= datenum('20080408', 'yyyymmdd')
                Analysis.error_thickDB =  Analysis.error_thickDB - 2.3;
            elseif  date_acquisition_num > datenum('20080408', 'yyyymmdd') & date_acquisition_num <= datenum('20090926', 'yyyymmdd')
                Analysis.error_thickDB =  Analysis.error_thickDB  - 1.3;
            elseif  date_acquisition_num > datenum('20090926', 'yyyymmdd') & date_acquisition_num <= datenum('20110101', 'yyyymmdd')
                Analysis.error_thickDB =  Analysis.error_thickDB;
            end
        elseif flag.small_paddle == 0
            if date_acquisition_num > datenum('20060101', 'yyyymmdd') & date_acquisition_num <= datenum('20080617', 'yyyymmdd')
                Analysis.error_thickDB =  Analysis.error_thickDB - 1.55;
            elseif  date_acquisition_num > datenum('20080617', 'yyyymmdd') & date_acquisition_num <= datenum('20090702', 'yyyymmdd')
                Analysis.error_thickDB =  Analysis.error_thickDB + 0.8;
            elseif  date_acquisition_num > datenum('20090702', 'yyyymmdd') & date_acquisition_num <= datenum('20091229', 'yyyymmdd')
                Analysis.error_thickDB =  Analysis.error_thickDB - 1.45;
            elseif  date_acquisition_num > datenum('20091229', 'yyyymmdd') & date_acquisition_num <= datenum('20110101', 'yyyymmdd')
                Analysis.error_thickDB =  Analysis.error_thickDB - 2.8;
            end
        end
   elseif machine_id == 30
    if flag.small_paddle
        if date_acquisition_num > datenum('20060101', 'yyyymmdd') & date_acquisition_num <= datenum('20090915', 'yyyymmdd')
            Analysis.error_thickDB =  Analysis.error_thickDB + 0.8;
        elseif  date_acquisition_num > datenum('20090915', 'yyyymmdd') & date_acquisition_num <= datenum('20090923', 'yyyymmdd')
            Analysis.error_thickDB =  Analysis.error_thickDB  - 2.8;
        elseif  date_acquisition_num > datenum('20090923', 'yyyymmdd') & date_acquisition_num <= datenum('20091209', 'yyyymmdd')
            Analysis.error_thickDB =  Analysis.error_thickDB + 0.8;
        elseif  date_acquisition_num > datenum('20091209', 'yyyymmdd') & date_acquisition_num <= datenum('20110101', 'yyyymmdd')
            Analysis.error_thickDB =  Analysis.error_thickDB - 0.85;
        end
    elseif flag.small_paddle == 0
        if date_acquisition_num > datenum('20060101', 'yyyymmdd') & date_acquisition_num <= datenum('20081025', 'yyyymmdd')
            Analysis.error_thickDB =  Analysis.error_thickDB + 2.45;
        elseif  date_acquisition_num > datenum('20081025', 'yyyymmdd') & date_acquisition_num <= datenum('20110101', 'yyyymmdd')
            Analysis.error_thickDB =  Analysis.error_thickDB + 1.6;
        end
    end
elseif machine_id == 31
    if flag.small_paddle
        if date_acquisition_num > datenum('20060101', 'yyyymmdd') & date_acquisition_num <= datenum('20080408', 'yyyymmdd')
            Analysis.error_thickDB =  Analysis.error_thickDB + 2.35;
        elseif  date_acquisition_num > datenum('20080408', 'yyyymmdd') & date_acquisition_num <= datenum('20090304', 'yyyymmdd')
            Analysis.error_thickDB =  Analysis.error_thickDB + 3.45;
        elseif  date_acquisition_num > datenum('20090304', 'yyyymmdd') & date_acquisition_num <= datenum('20110101', 'yyyymmdd')
            Analysis.error_thickDB =  Analysis.error_thickDB + 1.3;
        end
    elseif flag.small_paddle == 0
        if date_acquisition_num > datenum('20060101', 'yyyymmdd') & date_acquisition_num <= datenum('20080414', 'yyyymmdd')
            Analysis.error_thickDB =  Analysis.error_thickDB;
        elseif  date_acquisition_num > datenum('20080414', 'yyyymmdd') & date_acquisition_num <= datenum('20081111', 'yyyymmdd')
            Analysis.error_thickDB =  Analysis.error_thickDB + 0.8;
        elseif  date_acquisition_num > datenum('20081111', 'yyyymmdd') & date_acquisition_num <= datenum('20110101', 'yyyymmdd')
            Analysis.error_thickDB =  Analysis.error_thickDB - 1.3;
        end
    end


end

