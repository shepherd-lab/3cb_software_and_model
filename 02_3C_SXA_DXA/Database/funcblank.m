%create a string with spacenumber space characteres
function s=funcblank(spacenumber);

if spacenumber>0
    s=char(ones(1,spacenumber)*'.');
else
    s='';
end