% saveImage
%author Lionel HERVE
%date 7-14
% save a Image in .tif format

function saveimage
global file ctrl Image

savFilePath=file.startpath;
    
    [FileName,file.startpath,filterIndex] = uiputfile(strcat(file.startpath,'*.*'));
    fname = strcat(file.startpath,FileName);
    if filterIndex~=-0
            set(ctrl.text_zone,'String','saving the image');
            if fname(size(fname,2)-3:size(fname,2))=='.png' %append '.tif' at the end of the name if needed
            else 
               index_dot = find(fname=='.');
               fname(index_dot(end): end)=[]; 
               %fname = strcat(file.startpath,FileName,'.tif'); 
               fname = strcat(fname,'.png');
            end
            imwrite(uint16(Image.image),fname,'png');
            set(ctrl.text_zone,'String','Ok');
        else
            file.startpath=savFilePath;    
    end
