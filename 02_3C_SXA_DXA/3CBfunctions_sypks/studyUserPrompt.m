function [ selectedStudy, successful ] = studyUserPrompt()
%studyUserPrompt version 1.0
%   ARGUMENTS
%   input: None
%   output: selectedStudy, successful
%
%   DESRIPTION
%   selectedStudy:  struct variable containing study path variable assignments
%                   for Automatic3CAnalysis execution.
%   successful:     logical variable that is 1 if program executed
%                   properly; 0 otherwise
%
%   Created by sypks 06132018
%
%   Last update: 06142018 fixed small bug that caused non-terminating loop
%   when option to delete a study is selected


% Load mat file with study paths (cell format)
list = {'Create a New Study','Load a Saved Study','Modify a Study', 'Delete a Study'};

if ~exist('studyPath.mat','file')   %if mat file doesn't exist then only option is to create a new study
    [indx,tf] = listdlg('PromptString','What would you like to do?:','SelectionMode','single',...
        'ListString',list{1});
else                                 %mat file exists so all options avaialable
    m = matfile('studyPath.mat');
    
    if isempty(m.savedStudies)
        delete('studyPath.mat');
        [indx,tf] = listdlg('PromptString','What would you like to do?:','SelectionMode','single',...
            'ListString',list{1});
    else
        [indx,tf] = listdlg('PromptString','What would you like to do?:','SelectionMode','single',...
            'ListString',list);
    end
end

selectedStudy = {};

% cancel selected from menu so return control to calling function (this
% might have to be changed later)
if tf == false
    successful = 0;
    return
else
    switch list{indx}
        case 'Create a New Study'
            modifyStudy( 'new' );
            studyUserPrompt();
            successful = 0;
        case 'Load a Saved Study'
            [selectedStudy, successful] = loadStudyPath();
            if ~successful
                studyUserPrompt();
            end
        case 'Modify a Study'
            modifyStudy( 'mod' );
            studyUserPrompt();
            successful = 0;
        case 'Delete a Study'
            modifyStudy( 'del' );
            studyUserPrompt();
            successful = 0;
    end
end
end

function [ successful ] = modifyStudy( type )
%modifyStudy
%   ARGUMENTS
%   input: type
%   output: successful
%   
%   DESRIPTION
%   type:           char string that is user supplied to determine which operation to
%                   conduct. Available options are 
%                       1. 'create' or 'new' study     
%                       2. 'delete' or 'del' an existing study
%                       3. 'modify' or 'mod' an existing study
%   successful:     logical variable that is 1 if program executed
%                   properly; 0 otherwise
%
%   eg. StudyPath = UCSF at some location <studyLocation>
%       annotation = in some folder (hopefully in StudyPath) location
%       <annotationPath>
%       xCoefficientPath = bovine calibration location <xCoefficientPath>

selectNew = {'new','create'};
selectDeleteCurrent = {'delete','del'};
selectModifyCurrent = {'modify','mod'};

if exist('studyPath.mat','file')
    load('studyPath.mat','savedStudies');
    fileExists = true;
else
    savedStudies = struct;
    fileExists = false;
end

switch lower(type)
    case selectNew
        %initialize loop variable
        notDone = true;
        
        while(notDone)
            % prompt user to enter a Study Name
            newStudyWindowPrompt = {'What is the name of the Study?'};
            newStudyNameWindowTitle = 'Create New Study';
            newStudyDefInput = {'please assign a name'};
            studyName = inputdlg(newStudyWindowPrompt,newStudyNameWindowTitle,[1 50],newStudyDefInput);
            
            
            % check to ensure there isn't a naming conflict, if there is throw
            % error and prompt user to re-enter name
            % (convert to lowercase; names are not case-sensitive)
            if isempty(studyName)
                msgbox('Cancel by User or Invalid Name', 'Error','error');
                break
            elseif fileExists&&sum(contains(lower({savedStudies.studyName}),lower(studyName)))
                msgbox('Name Entered Already Exists', 'Error','error');
                continue
            else
                % prompt user for input to define path variables
                newPathSetup = struct;
                newPathSetup.studyName = studyName{1};
                newPathSetup.studyPath = uigetdir('C:\','Specify path to Study Directory');
                if newPathSetup.studyPath == 0              % to handle the event user clicks cancel
                    return
                end
                
                newPathSetup.annotationPath = uigetdir(newPathSetup.studyPath,...
                    'Specify path to Annotations Directory');
                if newPathSetup.annotationPath == 0         % to handle the event user clicks cancel
                    return
                end
                
                newPathSetup.xCoefficientPath = uigetdir('C:\',...
                    'Specify the location of X-Coefficients (Bovine Calibration)');
                if newPathSetup.xCoefficientPath == 0       % to handle the event user clicks cancel
                    return
                end
                
                % determine whether this is a new write or an append to
                % existing studies
                if fileExists
                    savedStudies = [savedStudies, newPathSetup(1)];
                else
                    savedStudies = [newPathSetup(1)];
                end
                
                % save path
                save('studyPath.mat','savedStudies');
                successful = true;
                notDone = false;
            end
        end
        
    case selectDeleteCurrent
        % prompt user to select a study to remove
        [indx,tf] = listdlg('PromptString','Please Select a Study to Delete:','SelectionMode',...
            'single','ListString',{savedStudies.studyName})
        
        if tf == false
            return
        else
            % delete selected study
            savedStudies(indx)=[];
            
            % save path modifications
            if isempty(savedStudies)
                delete('studyPath.mat')
            else
                save('studyPath.mat','savedStudies');
            end
            successful = true;
        end
        
    case selectModifyCurrent
        % prompt user to select a study to modify
        [indx,tf] = listdlg('PromptString','Please Select a Study to Modify:','SelectionMode',...
            'single','ListString',{savedStudies.studyName})
        
        if tf == false
            return
        else
            
            % addition 08-14-18 to allow renaming of a saved study in mod
            % mode
            modStudyWindowPrompt = {'Rename Study?'};
            modStudyNameWindowTitle = 'Create New Study';
            modStudyDefInput = {savedStudies(indx).studyName};
            studyName = inputdlg(modStudyWindowPrompt,modStudyNameWindowTitle,[1 50],modStudyDefInput);
            savedStudies(indx).studyName = studyName{1};
            savedStudies(indx).studyPath = uigetdir(savedStudies(indx).studyPath,...
                'Specify new path to Study Directory');
            % end of addition 08-14-18
           
            if savedStudies(indx).studyPath == 0
                return
            end
            savedStudies(indx).annotationPath = uigetdir(savedStudies(indx).annotationPath,...
                'Specify new path to Annotations Directory');
            if savedStudies(indx).annotationPath == 0
                return
            end
            
            savedStudies(indx).xCoefficientPath = uigetdir(savedStudies(indx).xCoefficientPath,...
                'Specify the new location of X-Coefficients (Bovine Calibration)');
            if savedStudies(indx).xCoefficientPath == 0
                return
            end
            
            % save path modifications
            save('studyPath.mat','savedStudies');
            successful = true;
        end
end
end


function [ loadedStudy, successful ] = loadStudyPath()
%loadStudyPath
%   ARGUMENTS
%   input:  None
%   output: loadedStudy, successful
%
%   DESRIPTION
%   loadedStudy:    struct that contains study name and path variables as
%                   its fields
%   successful:     logical variable that is 1 if program executed
%                   properly; 0 otherwise

% Check if mat file exists if not then proceed to create it
if ~exist('studyPath.mat','file')
    msgbox('Cannot Find Saved Studies Data File studyPath.mat', 'Error','error');
    return
else
    % Load mat file with study paths (cell format)
    load('studyPath.mat','savedStudies');
end

[indx,tf] = listdlg('PromptString','Please Choose a Study to Load:','SelectionMode',...
    'single','ListString',{savedStudies.studyName})
if tf == false
    loadedStudy = [];
    successful = false;
    return
else
    loadedStudy = savedStudies(indx);
    successful = true;
end
end










