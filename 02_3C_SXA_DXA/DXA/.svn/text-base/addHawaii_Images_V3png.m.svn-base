% Add Hawaii images parameters to the Database

global Database;

Database.Name='mammo_Hawaii'; % this name has to be in Database.choice

% % load('P:\aaSTUDIES\Breast Studies\CPMC\Analysis Code\Matlab\SXAVersion6.4_March12old\loading.mat');
% % directory=cell2mat(loadDataSetup(1,1));
% % destination=[cell2mat(loadDataSetup(2,1))];
% % fileDirectory=[directory,'\*.mat'];
% % files=dir(fileDirectory);

% parentdir = uigetdir('\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\DXAGirls_Hawaii07\', 'Select the folder you want to add to the Database'); % displays a dialog box enabling to choose the directory to read the filesfrom.

% parentdir = ('\\ming.radiology.ucsf.edu\aaDATA\Breast Studies\DXAGirls_Hawaii07\031408');
lengthparentdir=length(parentdir);
files=dir(fullfile(parentdir,'*.png'));



i=1;
errorCount=0;

while i<=length(files)
    
    img_filename = files(i).name;
    len = length(img_filename);
    selectpatients=[];
    selectpatients=strfind(img_filename,'BTTP');
        if isempty(selectpatients);
    
      
    try
        
        field{1}='DXG Hawaii';
        field{2}=img_filename(1,1:4); %patient_id
        duplicate=img_filename(1,len); %visit_id =duplicate
        if strcmp(duplicate,'2')
            duplicateid=2;
        else
            duplicateid=1;
        end
        field{3}=num2str(duplicateid);
        %mother or daughter M DA DB
        index=find(img_filename=='M');
        if index > 0
            status='M';
        else index=find(img_filename=='A');
            if ~index > 0
            status='DA';
          
       else index=find(img_filename=='B');
            if index > 0
            status='DB';
            
        else index=find(img_filename=='D');
            if index > 0
            status='D';
            end
            end
            end
        end
        field{4}=status; %mother or daughter 
       
        date_acquisition=parentdir(lengthparentdir-6:lengthparentdir);
       
        field{5}=parentdir(lengthparentdir-5:lengthparentdir);  %date_acquisition 
        field{6}='Hawaii';
        view=img_filename(1,index+1);
        if strcmp(view,'R')
            viewID=2;
        elseif strcmp(view,'L')
            viewID=3;
        end
        field{7}=num2str(viewID);    %view_id
        
        field{8}=img_filename(1,7:8);    %kvp
        field{9}='';   %Technique_id
        field{10}='';  %image resolution
        field{11}='';  %Digitalization depth
        path_img_filename=[parentdir,'\',img_filename];
        field{12}=path_img_filename; %filename
        field{13}=''; %imagesize

%         end

        [key,error]=funcAddInDatabase(Database,'acquisition',field);
        
        % %         source1=[directory,'\',name,'.mat'];
        % %         source2=[directory,'\',newName,'.png'];
        % %
        % %         len = length(destination1);
        % %         destination2 = ['e:\',(destination1(27:len))];

        % %         movefile(source1,destination2);
        % %         movefile(source2,destination2); %copyfile to movefile 11/27/07 JW
    catch
        lasterr
        %             movefile(source,'E:\aaDATA\Breast Studies\CPMC\bad header');
        %             [pathstr,name,ext,versn] = fileparts(info_dicom.Filename);
        %             newName=[name,'raw'];
        %             source2=[directory,'\',newName,'.png'];
        %             movefile(source2,'E:\aaDATA\Breast Studies\CPMC\bad header');
        if errorCount==3
%             !C:\Program Files\MATLAB\R2007a\bin\win64\matlab.exe -nosplash -r "cd 'D:\Working_Directory\Projects-Snap\aaSTUDIES\Breast Studies\CPMC\Analysis Code\Matlab\SXAVersion6.4_March12old\'"&
%             exit;
a= 3
        end
        errorCount=errorCount+1;
    end
  
        end
         i=i+1;
    end
