% Compute
%Lionel HERVE
%6-17-03
energies0=[1:0.1:150];

ResultChoice=cell2mat(SimulationX.ResultList(get(SimulationX.ctrl.ResultChoice,'value'),2));

if (ResultChoice==2)|(ResultChoice==3)
    %%%%% ANODE
    kVp=str2num(get(SimulationX.ctrl.AnodekVp,'string'));
    AnodeChoice=cell2mat(SimulationX.AnodeList(get(SimulationX.ctrl.Anode,'value'),2));
    if AnodeChoice==1
        spectre=funcspectre(1,kVp,SimulationX.data.coefMoly,SimulationX.data.energiesMoly);
        energies0=[1:0.1:kVp];
        spectre0=interp1(SimulationX.data.energiesMoly,spectre,energies0,'pchip');
    elseif AnodeChoice==3
        spectre=funcspectre(1,kVp,SimulationX.data.coefRhodium,SimulationX.data.energiesRhodium);
        energies0=[1:0.1:kVp];
        spectre0=interp1(SimulationX.data.energiesRhodium,spectre,energies0,'pchip');
    elseif AnodeChoice==2
        spectre=funcspectre(1,kVp,SimulationX.data.coefTungsten,SimulationX.data.energiesTungsten);
        energies0=[1:0.1:kVp+1];
        spectre0=interp1(SimulationX.data.energiesTungsten,spectre,energies0,'pchip');
    end
    %%%% Source Filtration
    Filtration=funcComputeFiltration(SimulationX.numbermaterialSource,SimulationX.FiltrationSource,SimulationX.data,energies0);
    spectre1=spectre0.*exp(-Filtration);
end
%spectre1=ones(size(energies0))*0.0001;  
%spectre1(191)=1000;

%%%% Attenuant Filtration
Filtration=funcComputeFiltration(SimulationX.numbermaterialAttenuant,SimulationX.FiltrationAttenuant,SimulationX.data,energies0);
if (ResultChoice==3)
    spectre2=spectre1.*exp(-Filtration);
end

%compute the attenuation; assume the detector respons is proportional to the energy
if (ResultChoice==3)
    attenuation=-log(sum(energies0.*spectre2)./sum(energies0.*spectre1));
    set(SimulationX.ctrl.result,'string',num2str(attenuation));
end


figure(figure1);hold on
%figure1=figure;

if ResultChoice==3
    SimulationX.result.energies=energies0;SimulationX.result.title1='Energy(kev)';
    SimulationX.result.variable=spectre2;SimulationX.result.title2='Detector spectrum(a.u.)';
    %SimulationX.result.variable = SimulationX.result.variable / max(SimulationX.result.variable);
    plot(SimulationX.result.energies,SimulationX.result.variable);
    %LE=sum(SimulationX.result.variable.*(SimulationX.result.energies<42))
    %HE=sum(SimulationX.result.variable.*(SimulationX.result.energies>=42))
    ylabel('Intensity (a.u.)');
elseif ResultChoice==2
    SimulationX.result.energies=energies0;SimulationX.result.title1='Energy(kev)';
    SimulationX.result.variable=spectre1;SimulationX.result.title2='Source Spectrum (a.u.)';
    % SimulationX.result.variable = SimulationX.result.variable / max(SimulationX.result.variable);
    plot(SimulationX.result.energies,SimulationX.result.variable);
    ylabel('Intensity (a.u.)');
elseif ResultChoice==1
    SimulationX.result.energies=energies0;SimulationX.result.title1='Energy(kev)';
    SimulationX.result.variable=Filtration;SimulationX.result.title2='Attenuation';
    %SimulationX.result.variable = SimulationX.result.variable / max(SimulationX.result.variable);
    plot(SimulationX.result.energies,SimulationX.result.variable);
    ylabel(SimulationX.result.title2);
    %set(gca,'yscale','log','xscale','log')
    set(gca,'yscale','log');
end
    
    
xlabel('energy (keV)');    
    


clear AnodeChoice;clear Filtration;clear attenuation;clear kVp;clear ResultChoice;
clear index;clear spectre0;%clear spectre;clear spectre1;clear spectre2;clear energies0;