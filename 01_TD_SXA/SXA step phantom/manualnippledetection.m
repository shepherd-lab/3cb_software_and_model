function manualnippledetection(RequestedAction)

global f0 Image Info Database

switch RequestedAction
    case 'find'
        axes(f0.axisHandle);
        Message('Please locate nipple with left-button mouse click or click "nipple location unknown" button..');
        button=uicontrol('style','pushbutton','string','nipple location unknown',...
            'units','normalized','position',[0.08 0.75 0.15 0.05],'callback','manualnippledetection(''notfound'')');

        k = waitforbuttonpress;
        point1 = get(f0.axisHandle,'CurrentPoint');
        if strcmp(get(f0.handle,'SelectionType'),'normal')
            if (flipdim(point1(1,1:2),2)<size(Image.image))&(point1(1,1:2)>0)
                nipplelocation=point1(1,1:2);
                field(1)={num2str(Info.AcquisitionKey)};
                field(2)={num2str(nipplelocation(1))};
                field(3)={num2str(nipplelocation(2))};
                field(4)={date};
                funcAddInDatabase(Database,'NippleInfo',field);
                Message(['Nipple location: (',num2str(nipplelocation(1)),', ',num2str(nipplelocation(2)),'), saved.']);
            elseif point1(1,1)>-700 && point1(1,1)<-200 && point1(1,2)<400 && point1(1,2)>200
                manualnippledetection('notfound');
            else
                manualnippledetection('find');
            end
        end
    case 'notfound'
        Message('Nipple not found.');
end

 button=uicontrol('style','pushbutton','string','',...
            'units','normalized','position',[0.08 0.75 0.15 0.05],'callback','nothing');
