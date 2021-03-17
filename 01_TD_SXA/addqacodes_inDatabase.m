function addqacodes_inDatabase
global Database
Database.Name = 'mammo_CPMC';
%qa_code = '9';
acq_idlist = textread('P:\Temp\good films\qa2savelist.txt','%u'); 
len = length(acq_idlist);


for i = 1:len
   str_list = num2str(acq_idlist(i));
   QAcodeNumber = 2;
  % funcaddinDatabase(,'QA_code_results',[{str_list},{'9'}]);
  funcaddinDatabase(Database.Name,'QA_code_results',[{str_list},{num2str(QAcodeNumber)}]);
end

