%KeypressedProcessing
%creation date 4-7-2003
%author Lionel HERVE
%revision history
function keypressedprocessing

global f0 ChestWallData FreeForm key EnterPressedEvent

pressedkey=double(get(f0.handle,'CurrentCharacter'));
if(pressedkey)==127   %mangement of delete; if the Chest wall is in drawing mode, erase it.
    if ChestWallData.DrawingInProgress==2
        ChestWallDrawing('EndManualDrawing',0); %finish the drawing process
        ChestWallData.Valid=0;%invalidate the Chestwall
    else
        FreeForm=funcdeleteFreeForm(FreeForm);
    end
    funcActivateDeactivateButton;
    draweverything;
elseif pressedkey==13
    key.message=key.buffer;
    key.buffer='';
    set(EnterPressedEvent,'value',true);    
else
    key.buffer=[key.buffer char(pressedkey)];
end

