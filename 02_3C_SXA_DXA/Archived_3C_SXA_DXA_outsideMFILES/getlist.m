function getname=getlist()
% first, you have to find the folder
dirname_toread = '\\researchstg\aadata\Kyphosis\Single images';
% get the names of all files. dirListing is a struct array.
dirListing = dir(fullfile(dirname_toread,'*.dcm'))  ;
for d = 1:2%length(dirListing)
      fileName = fullfile(dirname_toread,dirListing(d).name); % use full path because the folder may not be the active path
      [pathstr,name,ext]=fileparts(fullfile(dirname_toread,dirListing(d).name));
        % read dicominfo
        temp_info=dicominfo(fileName);
        data{d,1}=(temp_info.PatientID)
        data{d,2}=(temp_info.PatientName.FamilyName)
        
 end 
        filename = '\\researchstg\aadata\Kyphosis\Single images\patientdata.xlsx';
        %xlsSheet='result';
        %xlswrite(filename,data,xlsSheet,['A1:B',num2str(2)]) 
              xlswrite(filename,data) 
        % Excel('INIT');
        %Excel('TRANSFERT',data);
end
