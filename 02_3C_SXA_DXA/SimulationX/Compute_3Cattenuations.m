%must lauch simulation simux.m 
%Lionel HERVE
%6-30-04
%select Mo anode
%put source filtration 0.003MO  (cm) 
%put ATTENUANTS as Water, Fat and Protein
% this program will update the value of the Water, Fat and Protein
% thicknesses % from 0 to 8 cm 
% put RESULTS as Detector spectrum

%results are save in 'Result' variable.
%Copy the results to excel by typing : "CopyResultsToExcel(Result,{''})" in
%the command line.
cosine=0.95;
filename = '\\researchstg\Working_Directory\Shepherd Shared Folders\Publications-Presentations\2008\Papers\3C Breast\thickness_3C_for_mucoef.txt';
filename =  '\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\Results\Txt_files\Calibration51point_CPLE26kVp.txt';
Thickness_3C = load(filename,'-ascii')/10;
sz = size(Thickness_3C);
for i =1:sz(1)
    WaterThickness = Thickness_3C(i,1);
    FatThickness = Thickness_3C(i,2); 
    ProteinThickness = Thickness_3C(i,3); 
    SimulationX.FiltrationAttenuant{1,3}=WaterThickness;
    SimulationX.FiltrationAttenuant{2,3}=FatThickness;  
    SimulationX.FiltrationAttenuant{3,3}=ProteinThickness; 
    Compute;
    delete(figure1);
    Result(i,1)= str2num(get(SimulationX.ctrl.result,'string'));
    OutputResults{i,1} = Result(i,1)*10000;
 end
  LE = Result(:,1);
            
  Excel('INIT');
  Excel('TRANSFERT',OutputResults);
%{
cosine=0.95;

if ~exist('RequestedAcq')
    RequestedAcq=''
end

switch RequestedAcq
    case 'ComputeSimuX'
     WaterThickness = TempBreastThickness*(1-BreastComposition);
     FatThickness = TempBreastThickness*BreastComposition; 
     ProteinThickness = 
     SimulationX.FiltrationAttenuant{1,3}=AdiposeThickness;
     SimulationX.FiltrationAttenuant{2,3}=GlandularThickness;       
     Compute;delete(figure1);
 otherwise
    RequestedAcq='ComputeSimuX';     
    for Index=1:20;
        BreastThickness=0.2*1.2^Index;

        Result(Index,1)=BreastThickness;
        
        TempBreastThickness=BreastThickness;
        BreastComposition=0.3;
        SimuXBeamHardening_protein;
        Result(Index,2)= str2num(get(SimulationX.ctrl.result,'string'));

        TempBreastThickness=BreastThickness/cosine;
        SimuXBeamHardening_protein;
        Result(Index,5)= str2num(get(SimulationX.ctrl.result,'string'));

        TempBreastThickness=BreastThickness;
        BreastComposition=0.0;
        SimuXBeamHardening_protein;        
        Result(Index,3)= str2num(get(SimulationX.ctrl.result,'string'));

        TempBreastThickness=BreastThickness/cosine;
        SimuXBeamHardening_protein;
        Result(Index,6)= str2num(get(SimulationX.ctrl.result,'string'));

        TempBreastThickness=BreastThickness;
        BreastComposition=1;
        SimuXBeamHardening_protein;
        Result(Index,4)= str2num(get(SimulationX.ctrl.result,'string'));

        TempBreastThickness=BreastThickness/cosine;
        SimuXBeamHardening_protein;
        Result(Index,7)= str2num(get(SimulationX.ctrl.result,'string'));
        
    end
    RequestedAcq='None';    
end
%}