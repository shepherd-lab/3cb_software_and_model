function dupl_delete()
   output = [];
   count = 0;
   acq = [];
 Database.Name = 'mammo_DXA';
SQLStatement = ['SELECT rfilename FROM dbo.DXAacq GROUP BY rfilename HAVING (COUNT(rfilename) > 1)'];
file_dupl=mxDatabase(Database.Name,SQLStatement);

for index=2:size(file_dupl)
     name = char(file_dupl{index})
     %SQLStatement = ['SELECT * FROM dbo.DXAacq WHERE (rfilename lIKE ''', name(1:12), '''',')', ' AND (dxaacquisition_id > ', num2str(342), ') '];
     SQLStatement = ['delete FROM dbo.DXAacq WHERE (rfilename lIKE ''', name(1:12), '''',')', ' AND (dxaacquisition_id > ', num2str(342), ') '];
     a2 = mxDatabase(Database.Name,SQLStatement);
     %  output = [output;a2(end,:)];
       count = count + 1
       a =1;       
  %  output = [output;a2(end,:)];
% % %    
% % %       if isempty(a2)
% % %             acq = [acq;name(1:12)];
% % %         else
% % %             output = [output;a2(end,:)];
% % %       end
end
   Excel('INIT');
     Excel('TRANSFERT',output);
      a = 1;