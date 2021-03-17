%AutomaticSXAAnalysis
%Do the SXA analysis Sequence
%Lionel HERVE
%6-17-04

function Gen3_Analysis()

global   Info  Analysis Error  QCAnalysisData figuretodraw flag ROI Image ctrl MachineParams Database
global refDSPtoWAX

Error.DENSITY=false;
SaveBool= true;
Info.ReportCreated = false;
Error.SkinEdgeFailed = false;
flag.EdgeMode='Auto';

Info.StudyID = 'UCSF';
Analysis.Filmresolution = 0.2;
%% Automatic ROI and Skin detection
%  try
     bkgr = background_phantomdigital(Image.OriginalImage);
     Image.image = Image.OriginalImage - bkgr;
      ReinitImage(Image.image,'OPTIMIZEHIST');
%      draweverything;
%  catch
%      imagemenu('flipV');
%      imagemenu('flipH');
%      imagemenu('AutomaticCrop');
%      try
%         PhantomDetection();
%      catch
%         SaveInDatabase('QACODES');
%         nextpatient(0);
%         return;
%      end 
%  end
      set(ctrl.Cor,'value',false);
   %   eval(get(ctrl.CorrectionButton,'callback'));  %press on correction button
 %try

%      DensityROIResults = roi_QCDSP7();
%     if strcmpi(strtrim(Info.StudyID), 'avon')
%         [origDiff, QCbbCoord] = QCwax_bbs_position_digital_manual();
%     else
        % Automatically detecting BBs
%         [origDiff, QCbbCoord] = QCwax_bbs_position_digital_v705();
         [origDiff,QCbbCoord] = QCwax_bbs_position_digital_v705();
         sz_image = size(Image.image);
%           origDiff = [0 sz_image(1)/2 - 0];
%           origDiff = [0 0]; 
        if isempty(origDiff)
            % When automatic detections fails, do it manually
            %%%[origDiff, QCbbCoord] = QCwax_bbs_position_digital_manual();
            %%%temp JW
            ;
        end            
%     end
        %origDiff: world origin displacement from the mid-point of film
        %QCbbCoord: coord of QC BBs w.r.t. to the mid-point of film
        %both are in the unit of pixels
     
     %Image.image(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1) = Analysis.BackGroundThreshold;
% % %      
     [MachineParams, Gen3posWld] = calcSrcHBuckD_v705(origDiff, QCbbCoord, Info.StudyID, Analysis.Filmresolution)
% % %      SQLstatement = ['SELECT dark_counts ', ...
% % %                      'FROM MachineParameters ', ...
% % %                      'WHERE machine_id = ', num2str(Info.centerlistactivated)];
% % % 	 entryRead = mxDatabase(Database.Name, SQLstatement);
% % %      MachineParams.dark_counts = entryRead{1};
% % %      
% % %      if Image.columns < 1350
% % %          MachineParams.padSize = 'Small';
% % %      else
% % %          MachineParams.padSize = 'Large';
% % %      end
% % % 
% % %      %Calculate th_correction, rx_correction, ry_correction
% % %      QCPhantomDetection(Gen3posWld);
% % %      
% % %      %Calculate k table
% % %      draweverything;
% % %      [DensityROIResults, DensityROIResultsCorr] = roi_QCWAX();
% % % %      Analysis.roi_DSP7values = DensityROIResults(2, :);
% % % %      Analysis.density_DSP7 = DensityROIResults(1, :);
% % %      Analysis.density_WAX = DensityROIResults(1, :);
% % %      Analysis.densityWaxRoiCorr = DensityROIResultsCorr;
% % %      
% % %      %convert Analysis.density_DSP7 to wax-water scale
% % %      %Analysis.density_WAX = Analysis.density_DSP7 * (80 - refDSPtoWAX)/80 + refDSPtoWAX;
% % %      
% % % % catch
% % % % 
% % % %     Error.SkinEdgeFailed = true;
% % % %     errmsg = lasterr
% % % % 
% % % %     try
% % % %         SaveInDatabase('QACODES');
% % % %     catch
% % % %         errmsg = lasterr
% % % %         try
% % % %             SaveInDatabase('QACODES');
% % % %         catch
% % % %             errmsg = lasterr
% % % %             nextpatient(0);
% % % %             return;
% % % %         end
% % % %     end
% % % %     nextpatient(0);
% % % %     return;
% % % % end
% % % 
% % % 
% % % %% Report creation
% % % 
% % % if SaveBool
% % %     %% Add QA codes
% % %     try
% % %         SaveInDatabase('QACODES');
% % %     catch
% % %         errmsg = lasterr
% % %         try
% % %             SaveInDatabase('QACODES');
% % %         catch
% % %             errmsg = lasterr
% % %             nextpatient(0);
% % %             return;
% % %         end
% % %     end
% % %       
% % % end
% % %    figure(figuretodraw);
% % %   % pause(1);
% % %    %
% % %    set(QCAnalysisData.MainBox,'xdata',0,'ydata',0);
% % %    for index=1:QCAnalysisData.Draw.Compartments
% % %       set(QCAnalysisData.Box(index),'xdata',0,'ydata',0);
% % %    end
% % %   %}
% % %   
% % %  catch
% % %       errmsg = lasterr
% % %       nextpatient(0);
% % %       return;
% % %  end
% % % %% Go to next patient
% % % % save if the analysis was ok otherwise choose nextpatient
% % % 
% % % if (Error.DENSITY &(SaveBool)) %
% % %     nextpatient(0);
% % % else
% % %     nextpatient(1); %0 is for temporary
% % % end

