function CheckKTableGen3

% Check Ktable before going to MachineParametercorrection Table to make
% sure that Algorithm choose the right Thickness Values 

% Amir Pasha M
% 03112014

global Info Database

Ktable_1 = mxDatabase(Database.Name,['select * from kTableGen3 where acquisition_id=',num2str(Info.AcquisitionKey),...
    'order by date_acquisition']);
 
  QCWAX_status=Ktable_1(end);

  if strcmpi(QCWAX_status,'True')
      
      Info.machine_correction=true;
      
  else 

      Info.machine_correction=false;
      Ktable_1 = mxDatabase(Database.Name,['select * from kTableGen3 where (machine_id= ',num2str(Info.centerlistactivated),') ',...
          ' AND (QCWAX_status LIKE ''%True%'') ',...
          'order by date_acquisition']);
      
      sz_corr_K = size(Ktable_1);

for i = 1:sz_corr_K(1)
    Machine_id_Ktable(i) = Ktable_1{i,1};
    acquisition_id(i)=Ktable_1{i,2};
    date_acquisition_num_Ktable(i) = datenum(Ktable_1{i,4}, 'yyyymmdd');
    paddle_size(i)= cellstr(Ktable_1{i,5});
    
end
    
small_index = find(strncmp(paddle_size, 'Small', 5));
big_index = find(strncmp(paddle_size, 'Large', 5));
date_acquisition_num = datenum(Info.date_acq, 'yyyymmdd');
Test1=datestr(date_acquisition_num);


if flag.small_paddle
    start_date_num_small = date_acquisition_num_Ktable(small_index); %paddle_type==1
    acquisition_id_small=acquisition_id(small_index)
% % %     Test2=datestr(start_date_num_small);
    
    dates_max = max(start_date_num_small(start_date_num_small < date_acquisition_num ));
    
    Test3=datestr(dates_max);
    if  ~isempty(start_date_num_small)
        if isempty(dates_max)
            dates_max = min(start_date_num_small);
        end
    end
    
    index_date = find(start_date_num_small == dates_max);
    acquisition_id_K = num2str(acquisition_id_small(index_date));
  
else
    start_date_num_big = date_acquisition_num_Ktable(big_index );
    acquisition_id_big=acquisition_id(big_index);
% % %     Test2=datestr(start_date_num_big);
    
    dates_max = max(start_date_num_big(start_date_num_big < date_acquisition_num ));
    if  ~isempty(start_date_num_big)
        if isempty(dates_max)
            dates_max = min(start_date_num_big);
        end
    end
    index_date = find(start_date_num_big == dates_max);
    acquisition_id_K=num2str(acquisition_id_big(index_date))
end
      
     
SQLstatement = ['SELECT TOP 1 *  FROM kTableGen3',...
    ' WHERE (acquisition_id lIKE ''',acquisition_id_K, '''',')',...
    ' AND (QCWAX_status LIKE ''%True%'') ',...
    ' ORDER BY commonanalysis_id DESC'];  % 'WHERE paddle_size = ''', padSize, '''', ...

kentry_Alt = mxDatabase(Database.Name, SQLstatement);

  end

end

