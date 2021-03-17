%add the text in a powerpoint slide
%activex server already opened
% Lionel HERVE
%9-3-2003

function funcAddTextPowerPoint(slide,text,x,y,dx,dy,varargin);
title=invoke(slide.Shapes,'Addtextbox',1,x,y,dx,dy);
title.TextFrame.TextRange.text=text;

for index=1:floor(length(varargin)/2)
    switch cell2mat(varargin(index*2-1))
        case 'bold'
            set(title.TextFrame.TextRange.Font,'Bold',cell2mat(varargin(index*2)));
        case 'underlined'
            set(title.TextFrame.TextRange.Font,'Underline',cell2mat(varargin(index*2)));
        case 'fontsize'
            set(title.TextFrame.TextRange.Font,'size',cell2mat(varargin(index*2)));
        case 'color'
            switch cell2mat(varargin(index*2))
                case 'red'
                    title.TextFrame.TextRange.Font.Color.RGB=13311;
                case 'green'
                    title.TextFrame.TextRange.Font.Color.RGB=3407718;
                case 'blue'
                    title.TextFrame.TextRange.Font.Color.RGB=16737792;                    
            end
        case 'ERROR'  %underline the ERROR messages
            if cell2mat(varargin(index*2))
                title.TextFrame.TextRange.Font.Color.RGB=13311;
                set(title.TextFrame.TextRange.Font,'Bold',true);
            end
    end
end

release(title);