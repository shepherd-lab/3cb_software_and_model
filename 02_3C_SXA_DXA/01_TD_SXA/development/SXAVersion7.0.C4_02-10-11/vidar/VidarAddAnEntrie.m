%% VidarAddAnEntrie
% read the field of VidarGUI, save the image and add an entrie in the database
%author Lionel HERVE
%creation date 5-10-03
function VidarAddAnEntrie(Database,vidar,data,DigitalizedImage,ctrl)


if strcmp(vidar.ScanType,'SPINE')
    FileEnding='.dcm';
else
    FileEnding='.tif';
end

filename=[get(vidar.ctrlPathText,'string'),'\',get(vidar.ctrlFileName,'string')];

if ~strcmp(filename(size(filename,2)-3:size(filename,2)),FileEnding)
    filename=[filename,FileEnding];
end
[pathstr,barCode,ext,versn] = fileparts(filename);
if ~exist(filename)
    if strcmp(vidar.ScanType,'SPINE')
        STRING=get(vidar.ctrlView,'string'); %find the view from the drop menu
        VIEW=STRING{get(vidar.ctrlView,'value')};
        
        dicomInfo.ImageType	= 'Vidar';
        dicomInfo.PatientID = get(vidar.ctrlPatient,'string');
        dicomInfo.OtherPatientID = barCode;
        dicomInfo.StudyID = get(vidar.ctrlStudy,'string');
        dicomInfo.CompressionMode = 'JPEG lossless';
        dicomInfo.filename=filename;
        dicomInfo.ScanView=VIEW;
        
        dicomwrite(uint16(DigitalizedImage), filename, dicomInfo);
       % dicomwrite(uint16(DigitalizedImage), filename, 'PatientID',get(vidar.ctrlPatient,'string'),'StudyID',get(vidar.ctrlStudy,'string'),'PatientOrientation',VIEW);

   %     dicomwrite(uint16(DigitalizedImage), filename, 'PatientID',get(vidar.ctrlPatient,'string'),'StudyID',get(vidar.ctrlStudy,'string'),'PatientOrientation',VIEW,'Image Type',);
        QAReport('SAVE','NONE','SPINE');
        QAReport('ERASEMARK');
    else
        imwrite(DigitalizedImage,filename,'tif');
    end
    today=date;
    field{1}=get(vidar.ctrlStudy,'string');
    field{2}=get(vidar.ctrlPatient,'string');
    field{3}=get(vidar.ctrlVisit,'string');
    field{4}=get(vidar.FilmIdentifier,'string');
    field{5}=get(vidar.AcqusitionDate,'string');
    field{6}=num2str(cell2mat(data.centerlistname(get(vidar.ctrllocation,'value'),2)));
    field{7}=num2str(cell2mat(data.view(get(vidar.ctrlView,'value'),2)));
    field{8}=get(vidar.ctrlmAs,'String');
    field{9}=get(vidar.ctrlkVp,'String');
    field{10}=num2str(cell2mat(data.technique(get(vidar.ctrlTechnique,'value'),2)));
    field{11}=num2str(cell2mat(data.phantom(get(vidar.ctrlPhantom,'value'),2)));
    field{12}='1';    %digitizer = VIDAR
    field{13}='150';  %image resolution
    field{14}='16';  %Digitalization depth
    field{15}=today;
    field{16}=filename;
    field{17}='-1';
    [key,error]=funcAddInDatabase(Database,'acquisition',field);
    if ~error
        try
            mxDatabase(Database.Name,['insert into reposition values(''',num2str(key),''',''-'')']);
        end
    end

    if error==1
        delete (filename)
        button = questdlg('There has been a problem! Operation aborted.',...
            'Continue Operation','Continue','Continue');
    else
        set(ctrl.text_zone,'String','Data saved');
    end;
else
    errordlg('Overwrite a file is not alllowed')
end




