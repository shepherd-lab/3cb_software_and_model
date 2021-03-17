%AddFiltration
%Lionel HERVE
%creation date 6-17-03

if SimulationX.numbermaterialAttenuant>0;
    SimulationX.numbermaterialAttenuant=SimulationX.numbermaterialAttenuant-1;    
    lineNumber=get(SimulationX.ctrl.FiltrationAttenuantListBox,'value');
    SimulationX.FiltrationAttenuant(lineNumber,:)=[];
    if get(SimulationX.ctrl.FiltrationAttenuantListBox,'value')==SimulationX.numbermaterialAttenuant+1;
        set(SimulationX.ctrl.FiltrationAttenuantListBox,'value',SimulationX.numbermaterialAttenuant);
    end
    if get(SimulationX.ctrl.FiltrationAttenuantListBox,'value')==0;
        set(SimulationX.ctrl.FiltrationAttenuantListBox,'value',1);
    end
    if SimulationX.numbermaterialAttenuant==0
        SimulationX.FiltrationAttenuant=[{'None'} {0} {0}];
    end
    set(SimulationX.ctrl.FiltrationAttenuantListBox,'string',SimulationX.FiltrationAttenuant(:,1));
end

clear lineNumber;
