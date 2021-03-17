%% for Hologic r file
%% read the header to find the patient name...

function ReadHeader
global file;



flagcontinue=true;

while flagcontinue==true
    
    [FileName,file.startpath] = uigetfile([file.startpath,'*.*']);
    if FileName~=0
        message='';
        fname = [file.startpath,FileName];
            
        fid = fopen(fname,'r','l');
        fseek(fid, 0, 'eof');
        filesize = ftell(fid);
        position=fseek(fid, 0, 'bof');
        while position<filesize
            fseek(fid,position,'bof');
            recordname=fread(fid,1,'uint16');
            recordlength=fread(fid,1,'uint32');
            record=fread(fid,recordlength-6,'uint8');
            position=position+recordlength;
                               
            if (recordname==1002) %ID
                message=[message,char(record')];
            elseif (recordname==1003) %View
                message=[message,char(record')];
            elseif (recordname==1055) %DAte
                message=[message,char(record')];
            end        
        end
        button = questdlg(message,FileName);
        fclose(fid);
    else
        flagcontinue=false;
    end
end

