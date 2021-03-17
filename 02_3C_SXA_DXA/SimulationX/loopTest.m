clear resulten;

ThicknessList=1:0.1:8
for indexThickness=1:size(ThicknessList,2)
    Thickness=ThicknessList(indexThickness);
    SimulationX.FiltrationAttenuant(1,3)={Thickness};
    compute;
    close(gcf);
    resulten(indexThickness)=str2num(get(SimulationX.ctrl.result,'string'));
end
resulten=[ThicknessList' resulten']
