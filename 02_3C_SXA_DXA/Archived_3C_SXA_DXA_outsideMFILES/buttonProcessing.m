%          File:    ButtonProcessing.m
%
%   Description:    Proces the right action when some buttons are pressed
%
%   Author: Lionel HERVE
% date 4-2-03
function ButtonProcessing(ButtonPressed)
global Analysis flag Image Info ctrl Correction Database

switch ButtonPressed
    case 'BreastChecked'
        if Analysis.Step>0
            Analysis.Step=1;
        end
        flag.ROI=false;
        flag.Phantom=false;
        funcActivateDeactivateButton;
    case 'CorrectionAsked'
        if (Analysis.Step>0)
            %retrieve values form GUI
            Image.mAs=str2num(get(ctrl.mAs,'string'));
            Image.kVp=str2num(get(ctrl.kVp,'string'));
            Image.centerlistactivated=get(ctrl.Center,'value');
            
           % Info.FlatFieldCorrectionAsked = true;

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%% CODE ERASED DUE TO DATABASE PROBLEM %%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %flat field Correction
            %[Image,Analysis]=funcFlatFieldCorrections(Image,str2num(get(ctrl.mAs,'string')),str2num(get(ctrl.kVp,'string')),Analysis,Info.FlatFieldCorrectionAsked,ctrl);
       if Info.Database == true
            [Image,Analysis]=funcFlatFieldCorrections(Image,str2num(get(ctrl.mAs,'string')),str2num(get(ctrl.kVp,'string')),Analysis,Info.FlatFieldCorrectionAsked,ctrl,'none');
       end
            flag.Phantom=false;
            flag.ROI=false;
            HistogramManagement('ComputeHistogram',0);
            funcActivateDeactivateButton;
            set(ctrl.text_zone,'String','Ok');
        end
    case 'SaveInfo'
        Center=get(ctrl.Center,'value');
        mxDatabase(Database.Name,['update acquisition set machine_id=''',num2str(Center),''' where acquisition_id=',num2str(Info.AcquisitionKey)]);
        comment=get(ctrl.comment,'string');
        mxDatabase(Database.Name,['update acquisition set film_identifier=''',comment,''' where acquisition_id=',num2str(Info.AcquisitionKey)]);
end


