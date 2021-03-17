function manual_SXAanalysis()
global ctrl AutomaticAnalysis Info Analysis ROI Error Image thickness_mapproj
SaveInDatabase('COMMONANALYSIS');
 SaveInDatabase('SXASTEPANALYSIS');
AutomaticAnalysis.Step=6;
            
% %         
% %             CallBack=get(ctrl.Density,'callback');  %press on Density button
% %             eval(CallBack); %call Computedensity
            if ~Error.DENSITY
                [fileNameDensity, fileNameThickness] = genFileNameDenThk(Info.fname, Info.Version);
                Analysis.FileNameDensity = fileNameDensity;
                Analysis.FileNameThickness = fileNameThickness;
                %Commented by Song, 07-27-10 (need to save the output files to another new
                %directory)
                %                 Analysis.FileNameDensity = [Info.fname(1:end-4),'Density',Info.fname(end-3:end) ];
                %                 Analysis.FileNameThickness = [Info.fname(1:end-4),'Thickness',Info.fname(end-3:end)];
                %                 densfile_name = Analysis.FileNameDensity;
                %dens_image = uint16(Analysis.DensityImage*100);
                % temporary only for fat angle fitting

                %%%JW temp coded out, MING storage space issues, Sept 2011
             

                if Info.study_3C == true
                    Analysis.FileNameDensity2 = [Analysis.FileNameDensity(1:end-4),'SXA.png'];
                    Analysis.FileNameThickness2 = [Analysis.FileNameThickness(1:end-4),'SXA.png'];
                    imwrite(uint16(Analysis.SXADensityImageCrop*100), Analysis.FileNameDensity2, 'png');
                    imwrite(uint16(Analysis.SXAthickness_mapproj*1000), Analysis.FileNameThickness2, 'png');
                    %%%%%%%%%%%%% 3C Study  %%%%%%%%%%%%%
                    density_map = Analysis.SXADensityImageCrop;
                    fNameThick = [Info.fname(1:end-4), '_Thickness', Info.fname(end-3:end)];
                    szim = size(Image.OriginalImage);
                    thickness_map = zeros(szim);
                    thickness_map(ROI.ymin+1:ROI.ymin+ROI.rows,ROI.xmin+1:ROI.xmin+ROI.columns)   = thickness_mapproj*1000;
                    imwrite(uint16(thickness_map), Analysis.FileNameThickness, 'png');
                    fNamemat = [Info.fname(1:end-4), '_Mat_v',Info.Version(8:end) ,'.mat', ];
                    flip_info = [Info.flipH Info.flipV];
                    ROI.image = [];
                    version_name = Info.Version;
                    save(fNamemat, 'thickness_map','ROI','flip_info','density_map','version_name');
                    % % % %                 SaveInDatabase('COMMONANALYSIS');
                    %%%%%%%%%%%%%  end of 3C study  %%%%%%%%%%%%%%%%%%%%
                end

                % imwrite(Analysis.DensityImage,densfile_name,'png');
                % imwrite(Analysis.ThicknessImage,Analysis.FileNameThickness,'png');
                %figure;imagesc(uint16(Analysis.DensityImage*100)); colormap(gray);
                %figure;imagesc(uint16(Analysis.ThicknessImage*1000)); colormap(gray);
% %                 len_c = round(length(signal1)*0.65);
% %                 signal_fit = signal1(1:len_c);
% %                 x_fit = (1:len_c)';
% %                 % Xcoord = 1:x_ROI;
% % 
% %                 results = fit(x_fit,signal_fit, 'poly1');
% %                 slope = results.p1;
% %                 offset = results.p2;
% %                 signal4 = slope * x_fit + offset;
% % 
% %                 %ln = (1:length(signal1)) * Analysis.Filmresolution ; %Xcoord
% %                 %ln_size = size(ln)
% % 
% %                 X_position = Analysis.params(5);
% %                 %Xcoord_ROI =  repmat(Xcoord, y_ROI,1);
% %                 X = (X_position-x_fit*Analysis.Filmresolution*0.1);
% %                 results_thick = fit(X,signal_fit, 'poly1');
% %                 slope_thick = results_thick.p1;
% %                 offset_thick = results_thick.p2;
% %                 alfa = atan(slope_thick/Analysis.ph_afat_lin)*180/pi;
% %                 Analysis.alfa = alfa;
% %                 %thickness_profile = Analysis.ph_thickness + X*tan(alfa*pi/180);
% %                 %signal4 = Analysis.ph_afat_lin * thickness_profile + Analysis.ph_bfat_lin;
% %                 signal4(len_c+1:length(signal1)) = Analysis.BackGroundThreshold;
% %                 Analysis.signal = [Analysis.signal, signal4];
                          
            end
            
       
             Error.Density = true;
              if Info.study_3C == true
                    [fileNameDensity, fileNameThickness] = genFileNameDenThk(Info.fname, Info.Version);
               
                Analysis.FileNameThickness = fileNameThickness;            
  
                    Analysis.FileNameThickness2 = [Analysis.FileNameThickness(1:end-4),'SXA.png'];
                     imwrite(uint16(Analysis.SXAthickness_mapproj*1000), Analysis.FileNameThickness2, 'png');
                    %%%%%%%%%%%%% 3C Study  %%%%%%%%%%%%%
                     fNameThick = [Info.fname(1:end-4), '_Thickness', Info.fname(end-3:end)];
                    szim = size(Image.OriginalImage);
                    thickness_map = zeros(szim);
                    thickness_map(ROI.ymin+1:ROI.ymin+ROI.rows,ROI.xmin+1:ROI.xmin+ROI.columns)   = thickness_mapproj*1000;
                    imwrite(uint16(thickness_map), Analysis.FileNameThickness, 'png');
                    fNamemat = [Info.fname(1:end-4), '_Mat_v',Info.Version(8:end) ,'.mat', ];
                    flip_info = [Info.flipH Info.flipV];
                    ROI.image = [];
                    version_name = Info.Version;
                    save(fNamemat, 'thickness_map','ROI','flip_info','version_name');
                    % % % %                 SaveInDatabase('COMMONANALYSIS');
                    %%%%%%%%%%%%%  end of 3C study  %%%%%%%%%%%%%%%%%%%%
                
             end
% %              errmsg = lasterr
% %              multiWaitbar( 'CloseAll' );
% %              try
% %                  SaveInDatabase('QACODES');
% %              catch
% %                  errmsg = lasterr
% %                  multiWaitbar( 'CloseAll' );
% %              end 
           
%%
function [fPathNameDen fPathNameThk] = genFileNameDenThk(fNameRaw, ver);

backSlashPos = strfind(fNameRaw, '\');
fPath = fNameRaw(1:backSlashPos(end));
fName = fNameRaw(backSlashPos(end)+1:end);

verName = ver(8:end);
verName = regexprep(verName, '\.', '_');
fNameDensity = [fName(1:end-4), 'Density', verName, fName(end-3:end)];
fNameThick = [fName(1:end-4), 'Thickness', verName, fName(end-3:end)];
fPathNameDen = [fPath, fNameDensity];
fPathNameThk = [fPath, fNameThick];



