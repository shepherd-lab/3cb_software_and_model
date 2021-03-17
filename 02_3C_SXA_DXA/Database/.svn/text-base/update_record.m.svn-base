%%% add an entrie to table pet in Database toto

function update_record(database_name,table,field, value);
 %global Database
%find the number of column in the table
global Info
    key =   Info.CommonAnalysisKey;
    SQLstatement=['update ', table,  ' set ', field, '=', num2str(value),' where commonanalysis_id=',num2str(Info.CommonAnalysisKey)];
    %mxDatabase(Database.Name,SQLstatement); 
    mxDatabase(database_name,SQLstatement); 
%{
try 
    mxDatabase(Database.Name,['insert into ',table,' values(',values,');']);
    error=false;
catch
    error=true;
    'ERROR IN FUNCADDINDATABASE'
    foe=lasterror;foe.message
end
%}