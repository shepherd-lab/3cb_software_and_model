function FireEvent(varargin)
global A dummy y2 vidar;

vidar.VID_OCX_EVENT_SCAN_FILM_STARTED	= 0;
vidar.VID_OCX_EVENT_SCAN_FILM_IN_PROGRESS	= vidar.VID_OCX_EVENT_SCAN_FILM_STARTED + 1;
vidar.VID_OCX_EVENT_SCAN_FILM_DONE	= vidar.VID_OCX_EVENT_SCAN_FILM_IN_PROGRESS + 1;
vidar.VID_OCX_EVENT_SCAN_FILM_ALL_DONE	= vidar.VID_OCX_EVENT_SCAN_FILM_DONE + 1;
vidar.VID_OCX_EVENT_SCAN_FILM_CANCELLED	= vidar.VID_OCX_EVENT_SCAN_FILM_ALL_DONE + 1;
vidar.VID_OCX_EVENT_SCAN_FILM_ERROR	= vidar.VID_OCX_EVENT_SCAN_FILM_CANCELLED + 1;
vidar.VID_OCX_EVENT_SCAN_END	= vidar.VID_OCX_EVENT_SCAN_FILM_ERROR + 1;
vidar.VID_OCX_EVENT_SCAN_START	= vidar.VID_OCX_EVENT_SCAN_END + 1;


%cell2mat(varargin(3));
if vidar.scan
    y2=cell2mat(varargin(8));
    if ((cell2mat(varargin(3))>=vidar.VID_OCX_EVENT_SCAN_FILM_DONE))&((cell2mat(varargin(3))<=vidar.VID_OCX_EVENT_SCAN_FILM_ERROR))
        set(dummy,'value',true);
        %['dummy value: ',num2str(get(dummy,'value'))];
        StopScan(vidar.activex);
        vidar.scan=false;
    elseif ~isnan(cell2mat(varargin(7)))
        A(1,y2.nTotalBytesRead-y2.a_nBytesRead+1:y2.nTotalBytesRead)=y2.varData(1:y2.a_nBytesRead);
    end
end

