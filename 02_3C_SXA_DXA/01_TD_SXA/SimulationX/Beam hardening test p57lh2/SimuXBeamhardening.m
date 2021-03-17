%beam hardening
%must lauch simulation X/GUI.m 
%Lionel HERVE
%6-30-04
%select Mo anode
%put source filtration 0.0025MO  (cm) 
%put attenuant adipose 1 and glandular 1
% this program will update the value of the adipose and glandular thickness
% from 0 to 8 cm 

%results are save in 'Result' variable.
%Copy the results to excel by typing : "CopyResultsToExcel(Result,{''})" in
%the command line.

cosine=0.95;

if ~exist('RequestedAcq')
    RequestedAcq=''
end

switch RequestedAcq
    case 'ComputeSimuX'
     AdiposeThickness=TempBreastThickness*(1-BreastComposition);
     GlandularThickness=TempBreastThickness*BreastComposition;       
     SimulationX.FiltrationAttenuant{1,3}=AdiposeThickness;
     SimulationX.FiltrationAttenuant{2,3}=GlandularThickness;       
     Compute;delete(figure1);
 otherwise
    RequestedAcq='ComputeSimuX';     
    for Index=1:20;
        BreastThickness=0.2*1.2^Index;

        Result(Index,1)=BreastThickness;
        
        TempBreastThickness=BreastThickness;
        BreastComposition=0.3;SimuXBeamHardening;
        Result(Index,2)= str2num(get(SimulationX.ctrl.result,'string'));

        TempBreastThickness=BreastThickness/cosine;SimuXBeamHardening;
        Result(Index,5)= str2num(get(SimulationX.ctrl.result,'string'));

        TempBreastThickness=BreastThickness;
        BreastComposition=0.0;SimuXBeamHardening;        
        Result(Index,3)= str2num(get(SimulationX.ctrl.result,'string'));

        TempBreastThickness=BreastThickness/cosine;SimuXBeamHardening;
        Result(Index,6)= str2num(get(SimulationX.ctrl.result,'string'));

        TempBreastThickness=BreastThickness;
        BreastComposition=1;SimuXBeamHardening;
        Result(Index,4)= str2num(get(SimulationX.ctrl.result,'string'));

        TempBreastThickness=BreastThickness/cosine;SimuXBeamHardening;
        Result(Index,7)= str2num(get(SimulationX.ctrl.result,'string'));
        
    end
    RequestedAcq='None';    
end