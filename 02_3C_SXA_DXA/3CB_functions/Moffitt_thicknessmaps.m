%Lionel HERVE
%5-25-04
%retrieve all the SXA analysis
function RecomputeSXA()

global Database Info Image Analysis ctrl ROI FileName_list PathName AutomaticAnalysis corr_value h_init h_slope BreastMask

%content={};
 [FileName,PathName] = uigetfile('\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\Moffitt\*.txt','Select the acquisition list txt-file ');   acqs_filename = [PathName,FileName];     %'\'
 FileName_list =  FileName;
 acqs_filename = [PathName,'\',FileName];
  ACQIDList = textread(acqs_filename,'%u');
AutomaticAnalysis.CharacterRecognitionDone = 0;


RetrieveInDatabaseCounter=0;
CreateReport('NEW',1);
% 
%     h_slope = [];
%     h_init = [];
for RetrieveInDatabaseIndex=1:size(ACQIDList,1)
    hnd = get(0,'Children');
      
    if ~isempty(h_init)
        for i = 1:length(h_init)
            if find(hnd == h_init(i))
                delete(h_init(i));
            end
        end
    end
    if  ~isempty(h_slope)
        for i = 1:length(h_slope)
            if find(hnd == h_slope(i))
                delete(h_slope(i));
            end
        end
    end
    
    all_slopes = findobj('Tag', 'Slope');
    for i = 1:length(all_slopes)
       delete(all_slopes(i));
    end
   % h_slope = [];
   % h_init = [];
    Info.AcquisitionKey=ACQIDList(RetrieveInDatabaseIndex,:);

    
    %put the check mark to auto
    '!!!!!!!!!!!!!!!!! Retrieve in Database modified for SOY analysis !!!!!!!!!!!!!!!!!!!'
    
    
    %set(ctrl.CheckManualPhantom,'value',0);  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SOY ANALYSIS
   % set(ctrl.CheckManualPhantom,'value',1);
  
     Database.Step=2;  
    flag.noimage = false;
    flag.RawImage = false;
   try
       
        RetrieveInDatabase('ACQUISITION'); 
         set(ctrl.CheckAutoROI,'value',false);
         set(ctrl.CheckAutoSkin,'value',false);
         CallBack=get(ctrl.ROI,'callback');
         
        eval(CallBack);
        CallBack=get(ctrl.SkinDetection,'callback');  %press on SkinDection button
        eval(CallBack);
         %SkinDetection;
          body_thickness =cell2mat(mxDatabase(Database.Name,['select Thickness from acquisition where acquisition_id=',num2str(Info.AcquisitionKey)]));
             
               
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
                %imwrite(uint16(Analysis.SXADensityImageCrop*100), Analysis.FileNameDensity, 'png');
                %imwrite(uint16(thickness_mapproj*1000), Analysis.FileNameThickness, 'png');
                fNameThick = [Info.fname(1:end-4), '_Thickness', Info.fname(end-3:end)];
                szim = size(Image.OriginalImage);
                thickness_map = zeros(szim);
                % thickness_map(ROI.ymin+1:ROI.ymin+ROI.rows,ROI.xmin+1:ROI.xmin+ROI.columns)   = thickness_mapproj*1000;
                thickness_map(ROI.ymin+1:ROI.ymin+ROI.rows,ROI.xmin+1:ROI.xmin+ROI.columns)= double(body_thickness)/10*1000;
                               
                imwrite(uint16(thickness_map), Analysis.FileNameThickness, 'png');
                fNamemat = [Info.fname(1:end-4), '_Mat.mat', ];
                flip_info = [Info.flipH Info.flipV];
                ROI.image = [];
                ROI.BreastMask = BreastMask;
                save(fNamemat, 'thickness_map','ROI','flip_info');
                SaveInDatabase('COMMONANALYSIS');
                 CreateReport('ADDCOMMON');
      
        %ComputeDensity;
     
   catch
        errmsg = lasterr
% % %         try
% % %             Message('Creating report...');
% % %             CreateReport('ADDCOMMON');
% % %             CreateReport('SXASPECIFIC');
% % %             CreateReport('QACODES');
% % %             CreateReport('ADDREPORTTEXT');
% % %         catch
% % %             errmsg = lasterr
% % %         end
% % %         continue;
    end
    %Analysis.Step=7;
    msg=get(ctrl.text_zone,'string');
    Message([msg,'   (',num2str(RetrieveInDatabaseIndex),'/',num2str(size( ACQIDList,1)),')']);
    Info.Operator=11;  %use operator: automatic
 
    
       
    
    % if (Info.Analysistype==5) %automatic SXA analysis
    if mod(RetrieveInDatabaseCounter,100)==0 %& Info.SaveStatus ~= 0 50
        if RetrieveInDatabaseCounter %& Info.SaveStatus ~= 0
            try
                CreateReport('SAVECLOSE',Info.AcquisitionKey-1);
            catch
                try
                    CreateReport('SAVECLOSE',Info.AcquisitionKey-1);
                catch
                    errmsg = lasterr
                end
            end

            CreateReport('NEW',Info.AcquisitionKey);
        end
        % CreateReport('NEW',Info.AcquisitionKey);
    end
    RetrieveInDatabaseCounter=RetrieveInDatabaseCounter+1;
end
    

%%
function [fPathNameDen fPathNameThk] = genFileNameDenThk(fNameRaw, ver)

backSlashPos = strfind(fNameRaw, '\');
fPath = fNameRaw(1:backSlashPos(end));
fName = fNameRaw(backSlashPos(end)+1:end);

verName = ver(8:end);
verName = regexprep(verName, '\.', '_');
fNameDensity = [fName(1:end-4), 'Density', verName, fName(end-3:end)];
fNameThick = [fName(1:end-4), 'Thickness', verName, fName(end-3:end)];
fPathNameDen = [fPath, fNameDensity];
fPathNameThk = [fPath, fNameThick];

