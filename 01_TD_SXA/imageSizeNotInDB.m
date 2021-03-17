N = xlsread('P:\aaSTUDIES\Breast Studies\CPMC\Analysis Code\SAS\digiImages\imageSizeNotInDatabase.xls');
for i=3224:length(N)
    try
        filename=cell2mat(mxDatabase('mammo_cpmc',['select filename from acquisition where acquisition_id=',num2str(N(i))]));
        [pathstr,name,ext,versn] = fileparts(filename);
        if length(pathstr)==28
            names=[pathstr, name, ext];
        else
            names=filename;
        end
        files=dir(names);
        filesize=files.bytes;
        mxDatabase('mammo_cpmc',['update acquisition set image_size=',num2str(files.bytes), 'where acquisition_ID=',num2str(N(i))]);
        i
    catch
        lasterr
        i=i+1
    end
end
