%mxDatabase
%Lionel HERVE
%9-29-04

%due to problem of SQL command no executed (time out when the server is rebooted), do a loop with a pause in case of problem
function [results,columns]=mxDatabase(varargin)
results={};
columns={};
display varargin

if length(varargin)<2
    error('more than 1 entry argument expected')
end

continueLoop=true;
while (continueLoop)
    try
        if strncmpi(cell2mat(varargin(2)),'SELECT',6)
            switch length(varargin)
                case 2
                    [results,columns]=mxDatabase2(varargin{1},varargin{2});
                case 3
                    [results,columns]=mxDatabase2(varargin{1},varargin{2},varargin{3});
            end
        else
            switch length(varargin)
                case 2
                    var1 = varargin{1};
                    var2 = varargin{2};
                    mxDatabase2(varargin{1},varargin{2});
                case 3
                    mxDatabase2(varargin{1},varargin{2},varargin{3});
            end
        end
        continueLoop=false;
    catch
        if length(findstr(lasterr,'Timeout'))
            pause(60);
        else
            error(lasterr);
            pause(1);
            try
                [results,columns]=mxDatabase(varargin); % test only 
            catch
                 error(lasterr);
            end
            
        end
    end
end