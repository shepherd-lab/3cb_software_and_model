%funcShowTable
%display information on the current table
%author Lionel HERVE
%creation date 5-8-2003

function content=funcShowTable(Database,table,listboxhandle);
    [a,names]=mxDatabase(Database.Name,['select * from ',table],1);
    if ~size(a,1)
        for index=1:size(a,2)
            a(1,index)={'No Data'};
        end
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %draw the selection tabular
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %particular case FreeForm and Manualedge to prevent from seeing all the points
    if strcmpi(a(1,1),'No Data')
        content=a;
    elseif strcmpi(table,'ChestWall')
         %count the number of points
         content=mxDatabase(Database.Name,'select ID, count (*) from ChestWall group by ID');
         content(:,3)=content(:,2);  %copy the number of point in point_x 
         content(:,4)=content(:,2);  %copy the number of point in point_y        
    elseif strcmpi(table,'fileoninternaldrive')
         %count the number of points
         content=mxDatabase(Database.Name,'select * from fileoninternaldrive order by r2barcode');
    elseif strcmpi(table,'manualedge')
         %count the number of points
         content=mxDatabase(Database.Name,'select manualedge_id, count (*) from manualedge group by manualedge_id');
         content(:,3)=content(:,2);  %copy the number of point in point_x 
         content(:,4)=content(:,2);  %copy the number of point in point_y        
    elseif strcmpi(table,'freeforms')
         %count the number of points
         content=mxDatabase(Database.Name,'select freeformscluster_id,freeforms_id, count (point_id) from freeforms group by freeformscluster_id,freeforms_id');
         content(:,4)=content(:,3);  %copy the number of point in point_x 
         content(:,5)=content(:,3);  %copy the number of point in point_y          
    else    
         content=mxDatabase(Database.Name,['select * from ',table, ' order by ',cell2mat(names(1))]);
    end
   
    %content=funcconverttostring(content);
    content=funcConvertToString(content);

    for index=1:size(names,2)
          Field(1,index)=names(index);    %name of the column
          FieldSize=size(cell2mat(content(1,index)),2); %width of the column
          Field(2,index)={max(size(cell2mat(Field(1,index)),2),FieldSize)+1};   %size of the column
    end
    
    %draw the legend
    textstring(1,:)=funcConcatenateString(Field);
    title=Field(1,:);

    %draw the selection tabular
    temptextstring='';
    for index=1:size(content,2)
        text=char(content(:,index));
        temptextstring=[temptextstring,text,char(ones(size(content,1),cell2mat(Field(2,index))-size(text,2))*' ')];
        if (cell2mat(Field(2,index))-size(text,2))<0
            'problem' 
            index
        end
    end
    textstring(3:2+size(temptextstring),:)=temptextstring;

    set(listboxhandle,'String',textstring);
