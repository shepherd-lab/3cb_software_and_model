%programmer: sypks
%date: 20181214
%function name: roach.m
%description: function purpose and description given in
%ONsypks_SRL_3CB_RadPub_20181204 OneNote (also name of pathectory used)

clc, clear all

%% Set and Add Path
codepath = 'O:\SRL\aaStudies\Breast Studies\3CB R01\Analysis Code\Matlab\Developers\sypks\github\shepherd-lab\3cb\02_3C_SXA_DXA\3CBfunctions_sypks\';
Imagespath = 'O:\SRL\aaData\Breast Studies\3C_data\RO1_3Cimages\';
rootpath = 'O:\SRL\';
newpath = 'O:\SRL\aaData\Breast Studies\3C_data\RO1_3Cimages\ONsypks_SRL_3CB_RadPub_20181214\';

ucsfpath = 'O:\SRL\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\';
moffpath = 'O:\SRL\aaData\Breast Studies\3C_data\RO1_3Cimages\Moffitt\';
pilotpath = 'O:\SRL\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF_pilot\';
path.ucsf = ucsfpath;
path.moff = moffpath;
path.pilot = pilotpath;

cd(rootpath);
addpath(rootpath,codepath,newpath,Imagespath);

%% Get Participant IDs

datafile = 'O:\SRL\aaData\Breast Studies\3C_data\RO1_3Cimages\ONsypks_SRL_3CB_RadPub_20181214\No3CBFeaturesprior.csv';
dataID = readtable(datafile);
participantID = table2cell(dataID(:,1));
processInd = table2cell(dataID(:,3));
processInd = [processInd{:}];
processInd = isnan(processInd);
participantID = participantID(processInd);

%Split based on cases UCSFpilot "3CB*", UCSF "3C1" , and MOFF "3C2*" 
ucsf = participantID(contains(participantID,{'3C01'}));
moff = participantID(contains(participantID,{'3C02'}));
pilot = participantID(contains(participantID,{'3CB'}));
batch.ucsf = ucsf;
batch.moff = moff;
batch.pilot = pilot;
batch.names = {'ucsf','moff','pilot'};

save('O:\SRL\aaData\Breast Studies\3C_data\RO1_3Cimages\ONsypks_SRL_3CB_RadPub_20181214\batch.mat', 'batch');
%Get size of cases
% ucsfL = length(ucsf);
% moffL = length(moff);
% pilotL = length(pilot);


%% Iterate through cases and copy raw folder contents (create png and mat pathectories as well)
%for each case: navigate to parent path -> access particpant folder and copy
%raw dicom files to ONsypks_SRL_3CB_RadPub_20181204 pathectory. NOTE: pilot
%study seems to be missing raw dicoms... hmmmm...

nofiles = [];

for kk = 1:3
    tempcase = getfield(batch,batch.names{kk});
    tempcasePath = getfield(path,batch.names{kk});
    for gg = 1:length(tempcase)
        newFolder = [newpath,upper(batch.names{kk}),'\',tempcase{gg}];
        try
            copyfile([tempcasePath,tempcase{gg},'\','*.*'],[newFolder,'\'])
            files = dir([newFolder,'\'])
            pathFlags = [files.isdir]
            subfolders = {files(pathFlags).name}
            subfolders = subfolders(~contains(subfolders,{'.'}))
            
            if length(subfolders) > 0
                for qq = 1:length(subfolders)
                    rmdir([newFolder,'\',subfolders{qq}],'s')
                end
            end
        catch
            nofiles = [nofiles, tempcase{gg}];
        end
        
        %get index to files to change extensions
        dcmFiles = dir([newFolder,'\']);
        changeExt = ~contains({dcmFiles.name},{'.dcm'},'IgnoreCase',true)
        dcmrename = {dcmFiles(changeExt).name}
        
        %rename files
        if sum(changeExt)>2   
            for dd = 1:length(dcmrename)
                if dd > 2
                movefile([newFolder,'\',dcmrename{dd}],[newFolder,'\',dcmrename{dd},'.DCM'])
                end
            end
                thisDir = pwd
                cd([newFolder,'\'])
                todelete = ~contains({dcmFiles(changeExt).name},{'.'})
                
                if todelete > 0
                    delete(dcmFiles(todelete).name)
                end
        
                %remove duplicates
                newdcm = dir([newFolder,'\']);
                duplicate = contains({newdcm.name},{'copy'},'IgnoreCase',true)
                if sum(duplicate) > 0
                    delete(newdcm(duplicate).name)
                end
                cd(thisDir)
                delete thisDir
        end
        

        
        mkdir(newFolder)
        mkdir(newFolder,'mat_files')
        mkdir(newFolder,'png_files')
        mkdir(newFolder,'ForPresentation')
    end
end


%done