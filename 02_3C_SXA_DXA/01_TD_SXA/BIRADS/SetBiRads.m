function SetBiRads(ButtonNumber);
global ctrl

for index=1:4
        set(ctrl.BIRADS(index),'value',index==ButtonNumber);
end
    