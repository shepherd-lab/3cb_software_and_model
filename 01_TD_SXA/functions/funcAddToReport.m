function [indexreport,reportitem]=funcAddToReport(itemtoadd,reportitem,indexreport)

%funcAddToReport
%Author: Lionel HERVE
%date of creation:4-8-2003


reportitem(indexreport)={itemtoadd};indexreport=indexreport+1;  %%% for the report