function varargout = gunzip2(files,dirs)
%GUNZIP Uncompress GNU zip files.
%
%   GUNZIP(FILES) uncompresses GNU zip files from the list of files
%   specified in FILES.  Directories recursively gunzip all of their
%   content.  The output gunzipped files have the same name, excluding the
%   extension '.gz', and are written to the same directory as the input
%   files.
%
%   FILES is a string or cell array of strings that specify the files or
%   directories to be uncompressed.  Individual files that are on the
%   MATLABPATH can be specified as partial pathnames. Otherwise an
%   individual file can be specified relative to the current directory or
%   with an absolute path. Directories must be specified relative to the
%   current directory or with absolute paths.  On UNIX systems, directories
%   may also start with a "~/" or a "~username/", which expands to the
%   current user's home directory or the specified user's home directory,
%   respectively.  The wildcard character '*' may be used when specifying
%   files or directories, except when relying on the MATLABPATH to resolve
%   a filename or partial pathname.
%
%   GUNZIP(FILES, OUTPUTDIR) writes the gunzipped file into the directory
%   OUTPUTDIR. OUTPUTDIR is created if it does not exist.
%
%   GUNZIP(URL, ...) extracts the gzip contents from an Internet URL. The
%   URL must include the protocol type (e.g., "http://"). The URL is
%   downloaded to the temp directory and deleted.
%
%   FILENAMES = GUNZIP(...) gunzips the files and returns the relative path
%   names of the gunzipped files into the string cell array, FILENAMES.
%
%   Examples
%   --------
%   % gunzip all *.gz files in the current directory
%   gunzip('*.gz');
%
%   % gunzip Cleve Moler's Numerical Computing with MATLAB examples
%   % to the output directory 'ncm'.
%   url ='http://www.mathworks.com/moler/ncm.tar.gz';
%   gunzip(url,'ncm')
%   untar('ncm/ncm.tar','ncm')
%
%   See also GZIP, TAR, UNTAR, UNZIP, ZIP.

% Copyright 2004-2006 The MathWorks, Inc.
% $Revision: 1.1.6.2.2.1 $   $Date: 2006/01/21 23:18:21 $

error(nargchk(1,2,nargin,'struct'))
error(nargoutchk(0,1,nargout,'struct'));

% rootDir is always ''
%dirs = {'',varargin{:}};

% Check input arguments.
%{
[files, rootDir, outputDir] = checkFilesDirInputs(mfilename, files, dirs{:});

% Check files input for URL .
[files, url, urlFilename] = checkFilesURLInput(files, {'gz'},'FILES',mfilename);

if ~url
   % Get and gunzip the files
   entries = getArchiveEntries('', files, rootDir, mfilename);
   names = gunzipEntries(entries, outputDir);
else
   % Gunzip the URL
   names = gunzipURL(files{1}, outputDir, urlFilename);
end
%}
names = gunzipEntries(files, dirs);
% Return the names if requested
if nargout == 1
   varargout{1} = names;
end

%----------------------------------------------------------------------
function [files, url, urlFilename] = ...
   checkFilesURLInput(inputFiles, validExtensions, argName, fcnName)

% Assign the default return values
files = inputFiles;  
url = false;
urlFilename = '';

if numel(inputFiles) == 1 && isempty(findstr('*',inputFiles{1})) && ...
    ~isdir(inputFiles{1})

   % Check for a URL in the filename and for the file's existence
   [fullFileName, url] = checkfilename(inputFiles{1}, validExtensions, fcnName, ...
                                argName,true, tempdir);
   if url
     % Remove extension
     [path, urlFilename, ext] = fileparts(inputFiles{1});
     if ~any(strcmp(ext,{'.tgz','.gz'}))
        % Add the extension if the URL file is not .gz or .tgz
        % The URL may not be a GZIPPED file, but let pass
        urlFilename = [urlFilename ext];
     end
     files = {fullFileName};
   end
end


%----------------------------------------------------------------------
function names = gunzipEntries(entries, outputDir)
streamCopier = ...
   com.mathworks.mlwidgets.io.InterruptibleStreamCopier.getInterruptibleStreamCopier;
names = {};
for i=1:numel(entries)
  [path, baseName] = fileparts(entries);
  
  % Set the outputDir to the file's path if outputDir is empty
  % and the path is not the current directory, (since relative
  % paths are returned in names).
  pwdPath = strrep(pwd,'\','/');
  if isempty(outputDir) && ~isequal(path, pwdPath) 
    outputDir = path;
  end
  names{end+1} = gunzipwrite(entries, outputDir, baseName, streamCopier);
end

%----------------------------------------------------------------------
function names = gunzipURL(filename, outputDir, urlFilename)

streamCopier = ...
   com.mathworks.mlwidgets.io.InterruptibleStreamCopier.getInterruptibleStreamCopier;
try
   names{1} = gunzipwrite(filename, outputDir, urlFilename, streamCopier);
   % Filename is temporary for URL
   delete(filename);
catch
   [msg, id] = lasterr;
   if ~isequal('MATLAB:gunzip:notGzipFormat', id)
     delete(filename);
     rethrow(lasterror);
   else
     names{1} = fullfile(outputDir, urlFilename);
     if exist(names{1},'file') == 2
        delete(filename);
        eid = sprintf('MATLAB:%s:urlFileExists',mfilename);
        error(eid,'File "%s" exists and is not overwritten.',names{1});
     else
        copyfile(filename, names{1})
        delete(filename);
     end
   end
end

%----------------------------------------------------------------------
function gunzipFilename = gunzipwrite(gzipFilename, outputDir, baseName, streamCopier)
% GUNZIPWRITE Write a file in GNU zip format.
%
%   GUNZIPWRITE writes the file GZIPFILENAME in GNU zip format. 
%   OUTPUTDIR is the name of the directory for the output file. 
%   BASENAME is the base name of the output file.
%   STREAMCOPIER is a Java copy stream object. 
%
%   The output GUNZIPFILENAME is the full filename of the GNU unzipped file.

% Create the output filename from [outputDir baseName]
%gunzipFilename = fullfile(outputDir,baseName);
gunzipFilename = [outputDir,baseName];

% Create streams
fileInStream = [];

try
   fileInStream = java.io.FileInputStream(java.io.File(gzipFilename));
catch
   % Unable to access file
   if ~isempty(fileInStream)
     fileInStream.close;
   end
   eid = sprintf('MATLAB:%s:javaOpenError',mfilename);
   error(eid,'Could not open file "%s" for reading.',gzipFilename);
end

try
   gzipInStream = java.util.zip.GZIPInputStream( fileInStream );
catch
   % Not in gzip format
   if ~isempty(fileInStream)
     fileInStream.close;
   end
   eid = sprintf('MATLAB:%s:notGzipFormat',mfilename);
   error(eid,'File "%s" is not in GZIP format.',gzipFilename);
end

% gunzip the .gz file
outStream = [];
try
   javaFile  = java.io.File(gunzipFilename);
   outStream = java.io.FileOutputStream(javaFile);
   streamCopier.copyStream(gzipInStream,outStream);
catch
   if ~isempty(outStream)
      outStream.close;
   end
   gzipInStream.close;
   fileInStream.close;
   eid = sprintf('MATLAB:%s:javaOutputOpenError',mfilename);
   error(eid,'Could not open file "%s" for writing.',gunzipFilename);
end

% Cleanup and close the streams
outStream.close;
gzipInStream.close;
fileInStream.close;

if ispc
   gunzipFilename = strrep(gunzipFilename,'\','/');
end
