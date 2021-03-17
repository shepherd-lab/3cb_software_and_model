%AddFiltration
%Lionel HERVE
%creation date 6-17-03

SimulationX.numbermaterialAttenuant=SimulationX.numbermaterialAttenuant+1;
filtration=SimulationX.FiltrationList(get(SimulationX.ctrl.FiltrationChoiceAttenuant,'value'),:);
thickness=str2num(get(SimulationX.ctrl.FiltrationThicknessAttenuant,'string'));
SimulationX.FiltrationAttenuant(SimulationX.numbermaterialAttenuant,:)=[{[cell2mat(filtration(1)),'(',num2str(thickness),')']} filtration(2) {thickness}];
set(SimulationX.ctrl.FiltrationAttenuantListBox,'string',SimulationX.FiltrationAttenuant(:,1));

clear thickness;
clear filtration;