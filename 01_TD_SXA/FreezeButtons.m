function FreezeButtons(ctrl,f0,Info)

 %freeze buttons
%to prevent from handling when an action is required

set(ctrl.Cor,'enable','off');
set(ctrl.CheckBreast,'enable','off');
%set(ctrl.CheckChest,'enable','off');
set(ctrl.kVp,'enable','off');
set(ctrl.mAs,'enable','off');
set(ctrl.technique,'enable','off');
set(ctrl.CorrectionButton,'enable','off');
set(ctrl.Center,'enable','off');
set(ctrl.CheckAutoROI,'enable','off');
set(ctrl.ROI,'enable','off');
set(ctrl.CheckAutoSkin,'enable','off');
set(ctrl.SkinDetection,'enable','off');
set(ctrl.SkinModif,'enable','off');
set(ctrl.AddFreeForm,'enable','off');
set(ctrl.DeleteFreeForm,'enable','off');
set(ctrl.ModifyFreeForm,'enable','off');
set(ctrl.ThresholdButton,'enable','off');
set(ctrl.CheckManualPhantom,'enable','off');
set(ctrl.Phantom,'enable','off');
set(ctrl.Density,'enable','off');
set(ctrl.ShowBackGround,'enable','off');
set(ctrl.ShowAL,'enable','off');
set(ctrl.SFLI,'enable','off');
set(ctrl.separatedfigure,'enable','off');
set(ctrl.Debug,'enable','off');
set(ctrl.SaveNextPatient,'enable','off');
set(ctrl.QAreport,'enable','off');
set(ctrl.ChestWallModif,'enable','off');
set(ctrl.ChestWall,'enable','off');
if Info.Database
    set(f0.menu.Database,'enable','off');
end
set(f0.menu.file,'enable','off');
set(f0.menu.image,'enable','off');
set(f0.menu.Analysis,'enable','off');
if Info.DXAOK
    set(f0.menu.DXA,'enable','off');
end
if Info.SenographOK
    set(f0.menu.Senograph,'enable','off');
end
if Info.DigitizerOK
    set(f0.menu.Digitizer,'enable','off');
end
