%Create SXA report
%Lionel HERVE
%9-8-04

function Output=PowerPoint(RequestedAction,varargin)
%ADD figure
%Varargin= figure,xmin,ymin,dx,dy


global PowerPointData

try 
    PowerPointData.INIT=PowerPointData.INIT; %at the first call (INIT) PowerPointData doesn't exist
    Output=[];
    text='';
    LEFT=0;
    TOP=0;
    WIDTH=PowerPointData.slide_W;
    HEIGHT=PowerPointData.slide_H;
    PowerPointData.TextSize=PowerPointData.slide_H/50;
    PowerPointData.dy=1.2; %default advancement of the text
    PowerPointData.Color='black'; %possible color = green red blue
    PowerPointData.TextUnderlined=false;
    PowerPointData.TextBold=false;
    PowerPointData.FlagError=false;
    PowerPointData.LockAspectRatio='msoTrue';

    PositionModified=false;
    for index=1:length(varargin)
        if strcmpi(varargin{index},'LockAspectRatio')
            if ~varargin{index+1}
                PowerPointData.LockAspectRatio='msoFalse';
            end
            index=index+1;
        elseif strcmpi(varargin{index},'Position')
            PositionModified=true;
            Position=varargin{index+1};
            try if Position(1)>=0 LEFT=Position(1)*PowerPointData.slide_W;end;end
            try if Position(2)>=0 TOP=Position(2)*PowerPointData.slide_H; end;end
            try if Position(3)>=0 WIDTH=Position(3)*PowerPointData.slide_W;end;end
            try if Position(4)>=0 HEIGHT=Position(4)*PowerPointData.slide_H;end;end
            index=index+1;
        elseif strcmpi(varargin{index},'text')
            text=varargin{index+1};index=index+1;
        elseif strcmpi(varargin{index},'bold')
            PowerPointData.TextBold=varargin{index+1};index=index+1;
        elseif strcmpi(varargin{index},'underlined')
            PowerPointData.TextUnderlined=varargin{index+1};index=index+1;
        elseif strcmpi(varargin{index},'fontsize')
            PowerPointData.TextSize=varargin{index+1}*PowerPointData.TextSize;index=index+1;
        elseif strcmpi(varargin{index},'color')
            PowerPointData.Color=varargin{index+1};index=index+1;
        elseif strcmpi(varargin{index},'ERROR')
            PowerPointData.FlagError=varargin{index+1};
            if PowerPointData.FlagError
                title.TextFrame.TextRange.Font.Color.RGB=13311;
                set(title.TextFrame.TextRange.Font,'Bold',true);
            end
            index=index+1;
        elseif strcmpi(varargin{index},'carriage')
            PowerPointData.dy=varargin{index+1};index=index+1;
        end
    end
end

RequestedAction=lower(RequestedAction);
switch RequestedAction
    case 'init'
        PowerPointData.ppt = actxserver('PowerPoint.Application');
        PowerPointData.ppt.Visible = 1;
        PowerPointData.op = invoke(PowerPointData.ppt.Presentations,'Add');
        PowerPointData.Texty0=0;
        PowerPointData.Textx0=0;
        PowerPointData.INIT=true;

    case 'copypastefigure'
        %Capture current figure into clipboard:
        print -r100 -dmeta
        PowerPointData.pic1 = invoke(PowerPointData.new_slide.Shapes,'Paste');
        % put picture in the left side:
        set(PowerPointData.pic1,'LockAspectRatio',PowerPointData.LockAspectRatio,'Left',LEFT,'Top',TOP,'Height',HEIGHT,'Width',WIDTH);

    case 'addslide'
        % Get current number of slides:
        PowerPointData.slide_count = get(PowerPointData.op.Slides,'Count');

        % Add a new slide:
        PowerPointData.new_slide = invoke(PowerPointData.op.Slides,'Add',PowerPointData.slide_count+1,12);

        % Get height and width of slide:
        PowerPointData.slide_H = PowerPointData.op.PageSetup.SlideHeight;
        PowerPointData.slide_W = PowerPointData.op.PageSetup.SlideWidth;


    case 'addtext'
        % Add text
        %acquisition description
        fontheight=PowerPointData.slide_H/50;
        if PositionModified
            PowerPointData.Textx0=LEFT;
            PowerPointData.Texty0=TOP;
        end
        funcAddTextPowerPoint(PowerPointData.new_slide,text,PowerPointData.Textx0,PowerPointData.Texty0,...
            PowerPointData.slide_W-PowerPointData.Textx0,PowerPointData.TextSize,'fontsize',PowerPointData.TextSize,...
            'bold',PowerPointData.TextBold,'underlined',PowerPointData.TextUnderlined,'color',PowerPointData.Color,...
            'ERROR',PowerPointData.FlagError);
        PowerPointData.Texty0=PowerPointData.Texty0+PowerPointData.dy*PowerPointData.TextSize;

    case 'saveclose'
        invoke(PowerPointData.op,'saveas',text)
        invoke(PowerPointData.op,'close')
    case 'gettextposition'
        Output=[PowerPointData.Textx0/PowerPointData.slide_W PowerPointData.Texty0/PowerPointData.slide_H];
end