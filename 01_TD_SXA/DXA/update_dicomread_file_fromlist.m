function dicomread_Site()
    global ctrl Database
   
%     parentdir = uigetdir;
%     dirname_toread = parentdir;
%     dirname_towritepngcut = '\png_files';
%     dirname_towritematcut = '\mat_files';
%     
%     mkdir(parentdir,dirname_towritepngcut);
%     mkdir(parentdir,dirname_towritematcut);
% %     
%     dirname_towritepng = [dirname_toread,'\png_files\'];
%     dirname_towritemat = [dirname_toread,'\mat_files\'];
    
    %dirname_toread = 'C:\Documents and Settings\smalkov\My Documents\SeleniaImages\Selenia_room116\New_bars28Febr\';
    %dirname_towrite = 'C:\Documents and Settings\smalkov\My Documents\SeleniaImages\Selenia_room116\New_bars28Febr\png_files\';
    count = 0;
     [FileName,PathName] = uigetfile('P:\aaSTUDIES\Breast Studies\CPMC\Analysis Code\SAS\RO1 CPMC Data analysis\testing_BF.txt','Select the acquisition list txt-file ');   acqs_filename = [PathName,FileName];     %'\'
     fname = [PathName,FileName];
    % FileName_list = FileName;
     fid = fopen(fname,'r','b');
     %fid = fopen('fgetl.m');
    while 1
        filename = fgetl(fid);
        if ~ischar(filename) 
            break;
        end
  
    % filenames=fscanf(fid,'%c');
   
         % try
           
%             index_dots = find(filename=='.');
            
%             if isempty(index_dots)& (file_names(k).bytes < 8000000)
%                 continue;
%             end
%             if (length(index_dots) > 1  & ~isempty(index_dots)) & (file_names(k).bytes > 8000000)         
%                 num = filename_read(index_dots(end-1)+1:index_dots(end)-1);
%             else
%                 num = [];
%             end    
%             fullfilename_read = [dirname_toread,'\',filename_read];
             [pathstr,name,ext,versn] = fileparts(filename);
            if ( (strcmp(lower(ext), '.dcm') | isempty(ext) ) & ~isdir(name)  )
                
               if  ~isempty(ext)
                   filename_short = filename(1:end-4);
                 
%                inf = info_dicom.ImageComments
%               if exist('inf')
%                    comments = info_dicom.ImageComments; 
%                    index1 = find(comments==','); if ~isempty(index1) comments(index1) = '_'; end
%                    index2 = find(comments=='/'); if ~isempty(index2) comments(index2) = '-'; end
%                    index3 = find(comments==' '); if ~isempty(index3) comments(index3) = ''; end
%                    if ~isempty(comments)
%                     filename_read = [comments, '.', num2str(num)];
%                    end
               else
                    filename_short = filename(1:end);
               end
               % info_dicom = dicominfo(filename);
              % if 1 %filename_read(1) == 'r' | filename_read(1) == 'R' | filename_read(1) == 'L' | filename_read(1) == 'H'
                %if filename_read(1) == 'f'
                  % mat_filename=[filename_short, 'raw.mat' ]; 
                    png_filename=[filename_short, 'raw.png' ]; 
%                    save(mat_filename, 'info_dicom');
%                    XX = dicomread(info_dicom); 
%                    %XX = dicomread(fullfilename_read,'Raw', '1');
%                    XX1=round(UnderSamplingN(XX,2));
%                    clear XX;
%                     %mmax = max(max(XX1))
%                     %mmin = min(min(XX1))
%                     %I = -log( XX1 /mmax )* 10000;
%                    imwrite(uint16(XX1),png_filename,'PNG');
                    count = count + 1
                    SQLStatement = ['select acquisition_id from acquisition  where  filename like ''',filename,''''];
                  acq_id = cell2mat(mxDatabase(Database.Name,SQLStatement)); 
                  SQLStatement = ['update acquisition set filename=''',png_filename,'''',' where acquisition_id=',num2str(acq_id)];
                  mxDatabase(Database.Name,SQLStatement); 
                   set(ctrl.text_zone,'String',['Processed Image',num2str(count)]);
               % end
           
            end
       
   end
fclose(fid);
 