%find the name a the filename from the complete path
%authore Lionel HERVE
%creation date 5-21-03

function [filename,path]=funcEndFileName(PathAndFilename);

long=size(PathAndFilename,2);
index=long;
while PathAndFilename(index)~='\' 
    index=index-1;
end

filename=PathAndFilename(index+1:long);
path=PathAndFilename(1:index);