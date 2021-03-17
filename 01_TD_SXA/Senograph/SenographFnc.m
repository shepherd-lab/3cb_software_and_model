%Lionel HERVE
%7-16-04
function SeleniaDXAFnc(RequestedAction)

global ctrl Senograph Image

if strcmp(RequestedAction,'OpenFlatLE')
    set(ctrl.Cor,'value',false);
    FuncMenuOpenImage;
    Senograph.FlatLE=Image.image;
    Senograph.Flag.LE=false;
elseif strcmp(RequestedAction,'OpenFlatHE')
    set(ctrl.Cor,'value',false);
    FuncMenuOpenImage;
    Senograph.FlatHE=Image.image;
    Senograph.Flag.HE=false;
elseif strcmp(RequestedAction,'OpenLE')
    set(ctrl.Cor,'value',false);
    FuncMenuOpenImage;
    Senograph.LE=Image.image;
    Senograph.Flag.LE=false;
elseif strcmp(RequestedAction,'OpenHE')
    set(ctrl.Cor,'value',false);
    FuncMenuOpenImage;
    Senograph.HE=Image.image;
    Senograph.Flag.HE=false;
elseif strcmp(RequestedAction,'ShowLE')
    Image.OriginalImage=Senograph.LE;
    buttonProcessing('CorrectionAsked');
elseif strcmp(RequestedAction,'ShowHE')
    Image.OriginalImage=Senograph.HE;
    buttonProcessing('CorrectionAsked');
elseif strcmp(RequestedAction,'ShowFlatLE')
    Image.OriginalImage=Senograph.FlatLE;
    buttonProcessing('CorrectionAsked');    
elseif strcmp(RequestedAction,'ShowFlatHE')
    Image.OriginalImage=Senograph.FlatHE;
    buttonProcessing('CorrectionAsked');    
end