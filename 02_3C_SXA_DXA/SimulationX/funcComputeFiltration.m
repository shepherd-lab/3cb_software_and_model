function Filtration=funcComputeFiltration(numbermaterialAttenuant,AttenuantList,attenuationData,energies0)
    global SimulationX
Filtration=0*energies0;
for index=1:numbermaterialAttenuant
    filtrationID=cell2mat(AttenuantList(index,2));
    thickness=cell2mat(AttenuantList(index,3));
    if filtrationID==1
        Filtration=Filtration+interp1(attenuationData.Adipous(:,1),attenuationData.Adipous(:,2),energies0,'pchip')*thickness*0.95;
    elseif filtrationID==2
        Filtration=Filtration+interp1(attenuationData.Aluminum(:,1),attenuationData.Aluminum(:,2),energies0,'pchip')*thickness*2.669;
    elseif filtrationID==3
        Filtration=Filtration+interp1(attenuationData.Breast(:,1),attenuationData.Breast(:,2),energies0,'pchip')*thickness*1.02;
    elseif filtrationID==4
        Filtration=Filtration+interp1(attenuationData.Molybdenum(:,1),attenuationData.Molybdenum(:,2),energies0,'pchip')*thickness*10.22;
    elseif filtrationID==5
        Filtration=Filtration+interp1(attenuationData.Rhodium(:,1),attenuationData.Rhodium(:,2),energies0,'pchip')*thickness*12.4;
    elseif filtrationID==6
        Filtration=Filtration+interp1(attenuationData.Copper(:,1),attenuationData.Copper(:,2),energies0,'pchip')*thickness*8.96;
    elseif filtrationID==6
        Filtration=Filtration+interp1(attenuationData.Copper(:,1),attenuationData.Copper(:,2),energies0,'pchip')*thickness*8.96;
    elseif filtrationID==7
        Filtration=Filtration+interp1(attenuationData.Water(:,1),attenuationData.Water(:,2),energies0,'pchip')*thickness*SimulationX.rho.Fat;
    elseif filtrationID==8
        Filtration=Filtration+interp1(attenuationData.CorticalBone(:,1),attenuationData.CorticalBone(:,2),energies0,'pchip')*thickness*1.92;
    elseif filtrationID==9
        Filtration=Filtration+interp1(attenuationData.Beryllium(:,1),attenuationData.Beryllium(:,2),energies0,'pchip')*thickness*SimulationX.rho.Beryllium;
    elseif filtrationID==10
        Filtration=Filtration+interp1(attenuationData.PMMA(:,1),attenuationData.PMMA(:,2),energies0,'pchip')*thickness*SimulationX.rho.PMMA;
    elseif filtrationID==11
        Filtration=Filtration+interp1(attenuationData.PE(:,1),attenuationData.PE(:,2),energies0,'pchip')*thickness*SimulationX.rho.PE;
    elseif filtrationID==12
        Filtration=Filtration+interp1(attenuationData.CesiumIodide(:,1),attenuationData.CesiumIodide(:,2),energies0,'pchip')*thickness*SimulationX.rho.CesiumIodide;
    elseif filtrationID==13
        Filtration=Filtration+interp1(attenuationData.Cerium(:,1),attenuationData.Cerium(:,2),energies0,'pchip')*thickness*SimulationX.rho.Cerium;
    elseif filtrationID==14
        Filtration=Filtration+interp1(attenuationData.Polystyrene(:,1),attenuationData.Polystyrene(:,2),energies0,'pchip')*thickness*SimulationX.rho.Polystyrene;
    elseif filtrationID==15
        Filtration=Filtration+interp1(attenuationData.Muscle(:,1),attenuationData.Muscle(:,2),energies0,'pchip')*thickness*SimulationX.rho.Muscle;
    elseif filtrationID==16
        Filtration=Filtration+interp1(attenuationData.PVC(:,1),attenuationData.PVC(:,2),energies0,'pchip')*thickness*SimulationX.rho.PVC;
    elseif filtrationID==17
        Filtration=Filtration+interp1(attenuationData.Sn(:,1),attenuationData.Sn(:,2),energies0,'pchip')*thickness*SimulationX.rho.Sn;
    elseif filtrationID==18
        Filtration=Filtration+interp1(attenuationData.Se(:,1),attenuationData.Se(:,2),energies0,'pchip')*thickness*SimulationX.rho.Se;
    elseif filtrationID==19
        Filtration=Filtration+interp1(attenuationData.Protein(:,1),attenuationData.Protein(:,2),energies0,'pchip')*thickness*SimulationX.rho.Protein;
    elseif filtrationID==20
        Filtration=Filtration+interp1(attenuationData.Fat(:,1),attenuationData.Fat(:,2),energies0,'pchip')*thickness*SimulationX.rho.Fat;
    elseif filtrationID==21
        Filtration=Filtration+interp1(attenuationData.Gold(:,1),attenuationData.Gold(:,2),energies0,'pchip')*thickness*19.3;    
    end
end
