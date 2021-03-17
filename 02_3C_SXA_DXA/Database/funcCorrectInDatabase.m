%%% Correct an entree to table pet in Database toto
%author Lionel HERVE
%creation date 5-10-03

function funcCorrectinDatabase(Database,field,line);

key=cell2mat(Database.content(line,1));
[content,Column_Name]=mxDatabase(Database.Name,['select * from ',Database.Table]);

for index=1:size(field,2)
    SQLstatement=['update ',Database.Table,' SET '];    
    SQLstatement=[SQLstatement,cell2mat(Column_Name(index+1)),'=''',cell2mat(field(index)),''' '];
    SQLstatement=[SQLstatement,' where ',cell2mat(Column_Name(1)),'=',num2str(key)];    
    mxDatabase(Database.Name,SQLstatement);
end


