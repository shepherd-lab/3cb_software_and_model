function UpdateListBox(listboxhandle,content,names)

if listboxhandle
    if size(content,1)>0
        content=funcconverttostring(content);
    else
        content(1,1:size(content,2))={'No Data'}
    end
    
    
    for index=1:size(names,2)
        Field(1,index)=names(index);    %name of the column
        if size(content,1)>0
            FieldSize=size(cell2mat(content(1,index)),2); %width of the column
        else
            FieldSize=1;
        end
        Field(2,index)={max(size(cell2mat(Field(1,index)),2),FieldSize)+1};   %size of the column
    end
    
    %draw the legend
    textstring(1,:)=funcConcatenateString(Field);
    title=Field(1,:);
    
    %draw the selection tabular
    temptextstring='';
    for index=1:size(content,2)
        text=char(content(:,index));
        sizeBefore=size(temptextstring,2);
        temptextstring=[temptextstring,text,char(ones(size(content,1),cell2mat(Field(2,index))-size(text,2))*' ')];
        sizeAfter=size(temptextstring,2);
    end
    textstring(3:2+size(temptextstring,1),:)=temptextstring;
    
    set(listboxhandle,'String',textstring);
end