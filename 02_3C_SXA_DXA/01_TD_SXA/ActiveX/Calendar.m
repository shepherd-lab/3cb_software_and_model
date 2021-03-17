function Output=Calendar(RequestedAction)
global CalendarData
Output=[];

switch RequestedAction
    case 'DRAW'
        if (~CalendarData.FigureOn)
            CalendarData.figure=figure('deletefcn','CalendarData.FigureOn=false;','units','normalized','position',[0.5 0.5 0.2 0.2],'color',[0.1 0.1 0.4],'name','calendar','NumberTitle','off','MenuBar','none');
            CalendarData.cal = actxcontrol('mscal.calendar', [30 0 200 200],CalendarData.figure,{'AfterUpdate' 'CalendarUpdate'});
            set(CalendarData.cal,'ShowTitle',0);
            CalendarData.FigureOn=true;
        end
    case 'GET'
        Output=[num2str(CalendarData.cal.Month),'-',num2str(CalendarData.cal.Day),'-',num2str(CalendarData.cal.Year)];
    case 'CLOSE'
        if (CalendarData.FigureOn)
            close(CalendarData.figure);
        end
end
    