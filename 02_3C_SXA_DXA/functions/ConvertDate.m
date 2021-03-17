function Output=ConvertDate(Input)

%Lionel HERVE
%9-7-04
%work on the string to obtain the date 20040605 (05 june 2004) ==> 2004/05/06

year=Input(:,1:4);month=Input(:,5:6);day=Input(:,7:8);separator='-'*ones(size(year,1),1);
Output=datenum([month,separator,day,separator,year]);
