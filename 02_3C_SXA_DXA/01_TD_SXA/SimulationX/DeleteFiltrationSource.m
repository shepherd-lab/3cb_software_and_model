%AddFiltration
%Lionel HERVE
%creation date 6-17-03

if SimulationX.numbermaterialSource>0;
    SimulationX.numbermaterialSource=SimulationX.numbermaterialSource-1;    
    lineNumber=get(SimulationX.ctrl.FiltrationSourceListBox,'value');
    SimulationX.FiltrationSource(lineNumber,:)=[];
    if get(SimulationX.ctrl.FiltrationSourceListBox,'value')==SimulationX.numbermaterialSource+1;
        set(SimulationX.ctrl.FiltrationSourceListBox,'value',SimulationX.numbermaterialSource);
    end
    if get(SimulationX.ctrl.FiltrationSourceListBox,'value')==0;
        set(SimulationX.ctrl.FiltrationSourceListBox,'value',1);
    end
    if SimulationX.numbermaterialSource==0
        SimulationX.FiltrationSource=[{'None'} {0} {0}];
    end
    set(SimulationX.ctrl.FiltrationSourceListBox,'string',SimulationX.FiltrationSource(:,1));
end

clear lineNumber;
