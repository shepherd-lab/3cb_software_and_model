function dream_python_pngcreationUCSF()
global Image Info

input_dir = 'F:\Dream_contest2\Training_Nikulin\DDSM_1\src\DICOMS_3CBpres_noSXApng_2';

 png_files = dir(input_dir);
 len = length(png_files);
 %results = zeros(2,len-2);
%  results = cell(len-1,5);
 results{1,1} ='patientId';
 results{1,2} = 'examIndex'; 
 results{1,3} = 'imageView'; 
 results{1,4} = 'imageIndex'; 
 results{1,5} = 'filename';
 pat = [];
 
 for i = 3:len
    png_fname = [png_files(i).folder,'\',png_files(i).name];
    try
       % xx = rand();
       results{i-1,5} = png_files(i).name;
    if isempty(findstr(png_files(i).name,'3C')) 
        results{i-1,1} = png_files(i).name(1:end-4);
        results{i-1,2} = 1;
        if ~isempty(findstr(png_files(i).name(end-6:end-4),'RCC'))
           results{i-1,4} = 1; 
           results{i-1,3} = 'R';
        elseif ~isempty(findstr(png_files(i).name(end-6:end-4),'LCC'))
           results{i-1,4} = 3;
           results{i-1,3} = 'L';
        elseif ~isempty(findstr(png_files(i).name(end-6:end-4),'RML'))
           results{i-1,4} = 2; 
           results{i-1,3} = 'R';
        elseif ~isempty(findstr(png_files(i).name(end-6:end-4),'LML'))
           results{i-1,4} = 4; 
           results{i-1,3} = 'L';
        else
           results{i-1,4} = 5;
           results{i-1,3} = 'R';
           results(i-1,:) = [];
        end
        
    end
    catch
        pat = [pat;png_files(i).name]
    end
        emptycells = cellfun(@isempty, results);    %find empty cells in the whole cell array
       results(any(emptycells(:, [1]), 2), :) = []; %remove rows for which any of column 6 or 9 is empty
 end
  Excel('INIT');
  Excel('TRANSFERT',results);
a = 1;
end