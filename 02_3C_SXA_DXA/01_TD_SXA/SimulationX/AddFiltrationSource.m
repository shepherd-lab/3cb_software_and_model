%AddFiltration
%Lionel HERVE
%creation date 6-17-03

SimulationX.numbermaterialSource=SimulationX.numbermaterialSource+1;
filtration=SimulationX.FiltrationList(get(SimulationX.ctrl.FiltrationChoiceSource,'value'),:);
thickness=str2num(get(SimulationX.ctrl.FiltrationThicknessSource,'string'));
SimulationX.FiltrationSource(SimulationX.numbermaterialSource,:)=[{[cell2mat(filtration(1)),'(',num2str(thickness),')']} filtration(2) {thickness}];
set(SimulationX.ctrl.FiltrationSourceListBox,'string',SimulationX.FiltrationSource(:,1));

clear thickness;
clear filtration;