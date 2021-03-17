function vidarinitialize
global vidar

set(vidar.checkbox1,'value',false);
drawnow;

vidar.continu=true;
while vidar.continu
    vidar.error=0;
    try
        Initialize(vidar.activex,char(0))
    catch
        vidar.error=1;
        pause(0.1)
    end
    if vidar.error==0
        vidar.continu=false;
    end
end

vidar.continu=true;
while vidar.continu
    vidar.error=0;
    try
        set(vidar.activex,'bitsperpixel',char(16))
    catch
        vidar.error=1;
        pause(0.1);
    end
    if vidar.error==0
        vidar.continu=false;
    end
end

vidar.continu=true;
while vidar.continu
    vidar.error=0;
    try
        set(vidar.activex,'resolution',150);
    catch
        vidar.error=1;
        pause(0.1);
    end
    if vidar.error==0
        vidar.continu=false;
    end
end

vidar.continu=true;
while vidar.continu
    vidar.error=0;
    try
        set(vidar.activex,'ScanStageMode','STAGE_AUTO')
    catch
        vidar.error=1;
        pause(0.1);
    end
    if vidar.error==0
        vidar.continu=false;
    end
end
set(vidar.checkbox1,'value',true);