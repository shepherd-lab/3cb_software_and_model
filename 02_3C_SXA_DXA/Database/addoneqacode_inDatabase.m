function  addoneqacode_inDatabase(database_name,QAcodeNumber, acq_number)
%global Database
%database_name = 'mammo_CPMC';
%QAcodeNumber = 2;

%acq_idlist = textread('P:\Temp\good films\cancer_qa2.txt','%u'); 
%len = length(acq_idlist)
%count = 0;
%for i = 1:len
  str_acq_number = num2str(acq_number);
  qacodes = mxDatabase(database_name, ['SELECT ALL qa_code_results.QA_Code FROM acquisition,qa_code_results WHERE acquisition.acquisition_id = qa_code_results.acquisition_id  AND acquisition.acquisition_id =',  str_acq_number]);  
  qacodes_array = cell2mat(qacodes);
  index = find(qacodes_array==QAcodeNumber);
    if isempty(index)
      add_recordIN(database_name,'QA_code_results',[{str_acq_number},{num2str(QAcodeNumber)}]);
    end

    %%%%%%%%%-----------------------------------%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function key=find_nextKeyIN(database_name,table)


[a,names]=mxDatabase(database_name,['select * from ',table],1);
content=mxDatabase(database_name,['select ',cell2mat(names(1)),' from ',table,' order by ',cell2mat(names(1)),' DESC;'],1);

if size(content,1)==0  %when the table is empty
    key=1;
else
    key=cell2mat(content)+1;
end

%%%%%%%%%------------------------------------%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [key,error]=add_recordIN(database_name,table,field)
%find the number of column in the table

%[a,ColumName] = mxDatabase(Database.Name,['select * from ',table],1)
[a,ColumName]=mxDatabase(database_name,['select * from ',table],1);
tablesize=size(ColumName,2);

key=find_nextKeyIN(database_name,table);
values=['''',num2str(key),''''];
for index=1:size(field,2)
    values=[values,',''',cell2mat(field(index)),''''];
end
%add some empty field if it lacks some element in field
for index=size(field,2)+2:tablesize
    values=[values,','''''];
end

try 
    mxDatabase(database_name,['insert into ',table,' values(',values,');']);
    error=false;
catch
    error=true;
    'ERROR IN FUNCADDINDATABASE'
    foe=lasterror;foe.message
end
