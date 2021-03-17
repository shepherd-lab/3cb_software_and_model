function dicomread_Site()
global ctrl 

parentdir = uigetdir('Y:\Breast Studies\.'); % displays a dialog box enabling to choose the directory to convert

dirname_toread = parentdir;
dirname_towritepngcut = '\png_files';
dirname_towritematcut = '\mat_files';

mkdir(parentdir,dirname_towritepngcut);  % create the two sub directories "png_files" and "mat_files"
mkdir(parentdir,dirname_towritematcut);

dirname_towritepng = [dirname_toread,'\png_files\'];
dirname_towritemat = [dirname_toread,'\mat_files\'];

file_names = dir(dirname_toread); %returns the list of files in the specified directory
sza = size(file_names);
count = 0;
lenf = sza(1);
warning off;

for k = 3:lenf
    
    filename_read = file_names(k).name;
    index_dots = find(filename_read=='.');

    if isempty(index_dots)& (file_names(k).bytes < 8000000)
        continue;
    end
    if (length(index_dots) > 1  & ~isempty(index_dots)) & (file_names(k).bytes > 8000000)
        num = filename_read(index_dots(end-1)+1:index_dots(end)-1);
    else
        num = [];
    end
    fullfilename_read = [dirname_toread,'\',filename_read];
    [pathstr,name,ext] = fileparts(fullfilename_read); %,versn
    if ( (strcmp(lower(ext), '.dcm') | ~isempty(ext) ) & ~isdir(name)  )
        info_dicom = dicominfo(fullfilename_read);
        inf = info_dicom.ImageComments
        if exist('inf')
            comments = info_dicom.ImageComments;
            index1 = find(comments==','); if ~isempty(index1) comments(index1) = '_'; end
            index2 = find(comments=='/'); if ~isempty(index2) comments(index2) = '-'; end
            index3 = find(comments==' '); if ~isempty(index3) comments(index3) = ''; end
            if ~isempty(comments)
                filename_read = [comments, '.', num2str(num)];
            end
        end
        if 1 
            mat_filename=[dirname_towritemat, filename_read(1:end), 'raw.mat' ];
            png_filename=[dirname_towritepng, filename_read(1:end), 'raw.png' ];
            save(mat_filename, 'info_dicom');
            XX = dicomread(info_dicom);
           
            XX1=round(UnderSamplingN(XX,2)); % downsizing the image
            clear XX;
           
            imwrite(uint16(XX1),png_filename,'PNG');
            count = count + 1
            set(ctrl.text_zone,'String',['Processed Image',num2str(count)]);
        end
    else
        if  ~isdir(fullfilename_read)
           
        end
    end
   
end
