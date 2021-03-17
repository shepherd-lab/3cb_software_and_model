%Draw the 4 radiobtton of the BIRADS analysis
% Lionel HERVE
% 4-2-04
% Called by retrieveInDatabase

function DrawBIRADSButtons(bool)
global ctrl Analysis;

if bool
    for i=1:5
        set(ctrl.BIRADS(i),'value',0,'visible','on','callback',['SetBiRads(',num2str(i),')']);
    end
else
    for i=1:5
        set(ctrl.BIRADS(i),'visible','off','callback',['SetBiRads(',num2str(i),')']);
    end
end

