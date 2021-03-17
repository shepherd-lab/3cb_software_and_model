%Lionel HERVE
%7-16-04
function SeleniaDXAFnc(RequestedAction)

global ctrl  Image flag
 set(ctrl.Cor,'value',false);
 
 % flag.ShowMaterial=false;
 % flag.ShowThickness=false;
if strcmp(RequestedAction,'ShowLE')
    
    %ReinitImage(Image.LE,'OPTIMIZEHIST');
    ShowDXAImage('LE');
elseif strcmp(RequestedAction,'ShowHE')
   
    %ReinitImage(Image.HE,'OPTIMIZEHIST');
     ShowDXAImage('HE');
elseif strcmp(RequestedAction,'ShowRST')
   
       %ShowDXAImage('MATERIAL');  %show material image
       ShowDXAImage('RST'); 
  % ReinitImage(Image.RST,'OPTIMIZEHIST');
elseif strcmp(RequestedAction,'ShowMaterial')
   %ReinitImage(Image.Material,'OPTIMIZEHIST');
    ShowDXAImage('MATERIAL'); 
elseif strcmp(RequestedAction,'ShowThickness')
   %ReinitImage(Image.Material,'OPTIMIZEHIST');
    ShowDXAImage('THICKNESS'); 
end
set(ctrl.text_zone,'String','Ok');

draweverything;