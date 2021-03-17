%ActivateDeactivateButton
% author Lionel HERVE
% creation  3 2003
% revision history
% 2-19-04 : wrap in function style


function FuncActivateDeactivateButton
global Info ctrl Analysis f0 Result ChestWallData

%unfreeze
set(ctrl.Cor,'enable','on');
set(ctrl.CheckBreast,'enable','on');
set(ctrl.kVp,'enable','on');
set(ctrl.mAs,'enable','on');
set(ctrl.technique,'enable','on');
set(ctrl.CorrectionButton,'enable','on');
set(ctrl.Center,'enable','on');
set(ctrl.CheckAutoROI,'enable','on');
set(ctrl.CheckAutoSkin,'enable','on');
set(ctrl.SkinDetection,'enable','on');
set(ctrl.SkinModif,'enable','on');
set(ctrl.AddFreeForm,'enable','on');
set(ctrl.DeleteFreeForm,'enable','on');
set(ctrl.ModifyFreeForm,'enable','on');
set(ctrl.ThresholdButton,'enable','on');
set(ctrl.ChestWall,'enable','on');

set(ctrl.CheckManualPhantom,'enable','on');
set(ctrl.Phantom,'enable','on');
set(ctrl.Density,'enable','on');
set(ctrl.ShowBackGround,'enable','on');
set(ctrl.ShowAL,'enable','on');
set(ctrl.SFLI,'enable','on');
set(ctrl.separatedfigure,'enable','on');
set(ctrl.Debug,'enable','on');
if Info.Database
    set(ctrl.QAreport,'enable','on');
end
set(f0.menu.file,'enable','on');
set(f0.menu.image,'enable','on');
set(f0.menu.Analysis,'enable','on');
if Info.DXAOK
    set(f0.menu.DXA,'enable','on');
end
if Info.SenographOK
    set(f0.menu.Senograph,'enable','on');
end
if Info.DigitizerOK
    set(f0.menu.Digitizer,'enable','on');
end
if Info.Database
    set(f0.menu.Database,'enable','on');
end

if get(ctrl.CheckBreast,'Value');
    set(ctrl.CheckAutoROI,'Enable','on');
    set(ctrl.CheckAutoSkin,'Enable','on');
    if Analysis.Step>=1
        set(ctrl.menuZoom,'Enable','on');
        set(ctrl.menuRotate,'Enable','on');
        set(ctrl.ROI,'Enable','on');
        set(ctrl.menuROI,'Enable','on');
        set(ctrl.menuExtract,'Enable','on');
        set(ctrl.HProj,'Enable','on');
        set(ctrl.menuUnderSampling,'Enable','on');
        set(ctrl.menuCutLeft,'Enable','on');
        set(ctrl.menuCutRight,'Enable','on');
        set(ctrl.menuMeanValue,'Enable','on');
        set(ctrl.menuFlip,'Enable','on');
        set(ctrl.menuFreeForm,'Enable','on');
        set(ctrl.ShowBackGround,'Enable','on');
        set(ctrl.menuPhantom,'Enable','on');
        set(ctrl.Phantom,'Enable','on');
    else
        set(ctrl.menuZoom,'Enable','off');
        set(ctrl.menuRotate,'Enable','off');
        set(ctrl.ROI,'Enable','off');
        set(ctrl.menuROI,'Enable','off');
        set(ctrl.menuExtract,'Enable','off');
        set(ctrl.HProj,'Enable','off');
        set(ctrl.menuUnderSampling,'Enable','off');
        set(ctrl.menuCutLeft,'Enable','off');
        set(ctrl.menuCutRight,'Enable','off');
        set(ctrl.menuMeanValue,'Enable','off');
        set(ctrl.menuFlip,'Enable','off');
        set(ctrl.menuFreeForm,'Enable','off');
        set(ctrl.ShowBackGround,'Enable','off');
        set(ctrl.menuPhantom,'Enable','off');
        set(ctrl.Phantom,'Enable','off');
  end

    if Analysis.Step>=1.5
        set(ctrl.SkinDetection,'Enable','on');
        set(ctrl.MenuSkinDetection,'Enable','on');
        set(ctrl.ChestWall,'enable','on');
    else
        set(ctrl.SkinDetection,'Enable','off');
        set(ctrl.MenuSkinDetection,'Enable','off');
        set(ctrl.ChestWall,'enable','off');
    end

    if ChestWallData.Valid
        set(ctrl.ChestWallModif,'enable','on');
    else
        set(ctrl.ChestWallModif,'enable','off');
    end
    
    if Analysis.Step>=3
        set(ctrl.SkinModif,'Enable','on');
        set(ctrl.ThresholdButton,'Enable','on');
        set(ctrl.menuComputeThreshold,'Enable','on');
    else
        set(ctrl.SkinModif,'Enable','off');
        set(ctrl.ThresholdButton,'Enable','off');
        set(ctrl.menuComputeThreshold,'Enable','off');
    end
    %if Info.DigitizerID >= 4
        if (Analysis.Step>=3)&(Info.PhantomComputed) %2.5
            %set(ctrl.menuDensity,'Enable','on');
            set(ctrl.Periphery,'Enable','on');
        else
           % set(ctrl.menuDensity,'Enable','off');
            set(ctrl.Periphery,'Enable','off');
        end


        if (Analysis.Step>=3)&(Info.PeripheryComputed)
            set(ctrl.menuDensity,'Enable','on');
            set(ctrl.Density,'Enable','on');
        else
            set(ctrl.menuDensity,'Enable','off');
            set(ctrl.Density,'Enable','off');
        end
%     else
%         if (Analysis.Step>=3)&(Info.PhantomComputed) %2.5
%             set(ctrl.menuDensity,'Enable','on');
%             set(ctrl.Periphery,'Enable','off');
%         end
%     end
        
    if Analysis.Step>=8
        set(ctrl.SFLI,'Enable','on');
    else
        set(ctrl.SFLI,'Enable','off');
    end
else
    set(ctrl.SkinModif,'Enable','off');
    set(ctrl.Phantom,'Enable','off');
    set(ctrl.MenuSkinDetection,'Enable','off');
    set(ctrl.SkinDetection,'Enable','off');
    set(ctrl.CheckAutoROI,'Enable','off');
    set(ctrl.CheckAutoSkin,'Enable','off');
    set(ctrl.ThresholdButton,'Enable','off');
    set(ctrl.menuComputeThreshold,'Enable','off');
    if Analysis.Step>=1
        set(ctrl.menuZoom,'Enable','on');
        set(ctrl.menuFlip,'Enable','on');
        set(ctrl.menuRotate,'Enable','on');
        set(ctrl.ROI,'Enable','on');
        set(ctrl.menuROI,'Enable','on');
        set(ctrl.menuPhantom,'Enable','on');
        set(ctrl.Phantom,'Enable','on');
        set(ctrl.menuMeanValue,'Enable','on');
        set(ctrl.menuFreeForm,'Enable','on');
        set(ctrl.ShowBackGround,'Enable','on');
        set(ctrl.menuDensity,'Enable','on');
        set(ctrl.Density,'Enable','on');
     else
        set(ctrl.menuZoom,'Enable','off');
        set(ctrl.menuRotate,'Enable','off');
        set(ctrl.ROI,'Enable','off');
        set(ctrl.menuROI,'Enable','off');
        set(ctrl.menuPhantom,'Enable','off');
        set(ctrl.Phantom,'Enable','off');
        set(ctrl.menuMeanValue,'Enable','off');
        set(ctrl.menuFlip,'Enable','off');
        set(ctrl.menuFreeForm,'Enable','off');
        set(ctrl.ShowBackGround,'Enable','off');
        set(ctrl.menuDensity,'Enable','off');
        set(ctrl.Density,'Enable','off');
    end
    if Analysis.Step>=8
        set(ctrl.SFLI,'Enable','on');
    else
        set(ctrl.SFLI,'Enable','off');
    end
end

if Info.Database
    if Info.MultiCommonAnalysis|Info.MultiAcquisitionAnalysis
        set(f0.menu.DatabaseSave,'enable','off');
        set(ctrl.SaveNextPatient,'enable','on');
    else
        set(ctrl.SaveNextPatient,'enable','off');
        set(f0.menu.DatabaseSave,'enable','on');
    end
end

if Info.DXAOK
    if Result.DXA
        set(ctrl.DXA.showLE,'enable','on');
        set(ctrl.DXA.showHE,'enable','on');
        set(ctrl.DXA.showRst,'enable','on');
        set(ctrl.DXA.showMaterial,'enable','on');
    else
        set(ctrl.DXA.showLE,'enable','off');
        set(ctrl.DXA.showHE,'enable','off');
        set(ctrl.DXA.showRst,'enable','off');
        set(ctrl.DXA.showMaterial,'enable','off');
    end
end
ctrl.HProj

