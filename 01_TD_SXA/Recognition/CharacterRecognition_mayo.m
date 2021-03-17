%%% Charactere recognition
% Lionel HERVE
% 2-10-04
% this program works according to 2 modes: 'CharacterRecognition' or 'CharacterDefinition'

function CharacterRecognition_mayo(ACTION,BRAND);
global TAG Image CurrentMask Image OriginalTag Recognition Error ReportText DEBUG Info 
%% entries gestion
if ~exist('ACTION')
    ACTION='CharacterRecognition';
end

DEBUG1 = 0;

BRAND= 2; %GetBRAND(Info);

%% load the correct file depending on the brand of the mammography machine
if (BRAND==1)
    Filename='CharacterCPMC';
else
    Filename='CharacterCPMC2';
end

%% init values
Error.MAS=false;
Error.KVP=false;
Error.MM=false;
Error.DAN=false;
Error.TECHNIQUE=true;  %default value, change if the detection seems correct
Error.KVPWarning=false;
Recognition.MAS=-1;
Recognition.KVP=-1;
Recognition.MM=-1;
Recognition.DAN=-1;
Recognition.TECHNIQUE='ERROR';

try
    %% EXTRACT the TAG
    [TAG,OriginalTag]=LetterFilter_mayo(Image.OriginalImage,BRAND);
    Recognition.Imagette=OriginalTag;
    origtag_mm = max(max(OriginalTag))
    tag_mm = max(max(TAG))
    if (DEBUG1) figure;imagesc(OriginalTag);title('CharacterRecognition: Original Tag');colormap(gray); end
    if (DEBUG1||strcmp(ACTION,'CharacterDefinition')) figure;imagesc(TAG);title('CharacterRecognition: First filtration');colormap(gray); end
    %% 'CharacterDefinition'
    if strcmp(ACTION,'CharacterDefinition')
        clear Character;
        cd ('Recognition');

        try
            load (Filename);
        catch
        end
        cd ('..');
        set(gcf,'units','normalized','position',[0 0 1 1]);

        CharacterList={0,'Choice';0,'';1,'1';2,'2';3,'3';4,'4';5,'5';6,'6';7,'7';8,'8';9,'9';10,'0';11,'mAs';12,'kVp';13,'MO/MO';14,'mm';15,'MO/RH';16,'LF';17,'RH/RH';18,'daN';19,'kVp 2nd possibility'};
        selection=cell2mat(funcSelectInTable(CharacterList(:,2),'Which character do you want to define',0));

        if BRAND==1
            dy=15;
            dx=12;
            %used to discriminate 3 8 9 0 6 figures
            MaskPower=5;
            SpecialMask=zeros(dy+1,dx+1);
            SpecialMask(5:12,3)=MaskPower;
            SpecialMask(6:11,4)=MaskPower;
            SpecialMask(8:9,5)=MaskPower;
            SpecialMask(8:9,6)=MaskPower;
            SpecialMask(8:9,7)=MaskPower;
            SpecialMask(8:9,8)=MaskPower;
            SpecialMask(6:8,9)=MaskPower;
            SpecialMask(5:8,10)=MaskPower;

            dy=15;
            switch selection
                case 1
                    dx=8;
                case 11
                    dx=40;
                case 12
                    dx=25;
                case 13
                    dx=65;
                case 14
                    dx=23;
                case 15
                    dx=65;
                case 16
                    dx=30;
                case 17
                    dx=65;
                case 18
                    dx=40;
                otherwise
                    dx=12;
            end
        else
            dy=13;
            dx=10;
            %used to discriminate 3 8 9 0 6 figures
            MaskPower=5;
            SpecialMask=zeros(dy+1,dx+1);
            SpecialMask(5:12,3)=MaskPower;
            SpecialMask(6:11,4)=MaskPower;
            SpecialMask(8:9,5)=MaskPower;
            SpecialMask(8:9,6)=MaskPower;
            SpecialMask(8:9,7)=MaskPower;
            SpecialMask(8:9,8)=MaskPower;
            SpecialMask(6:8,9)=MaskPower;
            SpecialMask(5:8,10)=MaskPower;

            switch selection
                case 1
                    dx=8;
                case 11
                    dx=35;
                case 12
                    dx=20;
                case 13
                    dx=25;
                case 14
                    dx=23;
                case 15
                    dx=25;
                case 16
                    dx=30;
                case 17
                    dx=25;
                case 18
                    dx=10;
                case 19
                    dx=25;

                otherwise
                    dx=10;
            end
        end
        Character.Mask(selection)={ones(dy+1,dx+1)};
        if (selection==8)||(selection==9)||(selection==6)||(selection==10)
            Character.Mask(selection)={ones(dy+1,dx+1)+SpecialMask};
        end
        CurrentMask=cell2mat(Character.Mask(selection));
        [x,y]=selectsquare(dx,dy,'ROOT');

        button = questdlg('Is this ok? Shall I replace the file?','Continue Operation','Yes','No','Yes');
        if strcmp(button,'Yes')
            selectsquare(0,0,'DEHIGHLIGHT');
            Character.Image(selection)={TAG(y:y+dy,x:x+dx)};
            %save of the chacters
            cd ('Recognition');
            save(Filename,'Character')
            cd ('..');
        end
        delete(gcf)
    end
    %% 'CharacterRecognition'
    if strcmp(ACTION,'CharacterRecognition')
        load(Filename);
        if BRAND==1

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%% Work on Tag line  %%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            GlobalArray=[];  %matrix that will contain all the detected characters
            [X1,Y1]=findCharacter(TAG,Character,12,'unique');   %find KV
            if length(X1)>0
                GlobalArray=[GlobalArray,[12;2 ;X1;Y1]];
            end
            [X2,Y2]=findCharacter(TAG,Character,11,'unique');    %find MAS
            if length(X2)>0
                GlobalArray=[GlobalArray,[11;2 ;X2;Y2]];
            end

            %determine the technique
            [foeX,foeY,foeP]=findCharacter(TAG,Character,13,'unique');    %find MO/MO
            if length(foeP)>0 X3(1)=foeX;Y3(1)=foeY;P3(1)=foeP; else P3(1)=0; end
            [foeX,foeY,foeP]=findCharacter(TAG,Character,15,'unique');    %find MO/RH
            if length(foeP)>0 X3(2)=foeX;Y3(2)=foeY;P3(2)=foeP; else P3(2)=0; end
            [foeX,foeY,foeP]=findCharacter(TAG,Character,17,'unique');    %find RH/RH
            if length(foeP)>0 X3(3)=foeX;Y3(3)=foeY;P3(3)=foeP; else P3(3)=0; end
            if ~length(P3(1)) P3(1)=0;end
            if ~length(P3(2)) P3(2)=0;end
            if ~length(P3(2)) P3(3)=0;end
            [maxi,indexmax]=max(P3);
            if length(P3(indexmax))>0
                switch indexmax
                    case 1
                        TECHNIQUE='MO/MO';
                    case 2
                        TECHNIQUE='MO/RH';
                    case 3
                        TECHNIQUE='RH/RH';
                end
                GlobalArray=[GlobalArray,[(indexmax-1)*2+13;2 ;X3(indexmax);Y3(indexmax)]];
            end
            Error.TECHNIQUE=false;
            Recognition.TECHNIQUE=TECHNIQUE;

            [X4,Y4]=findCharacter(TAG,Character,16,'unique');    %find LF
            if length(X4)>0
                GlobalArray=[GlobalArray,[16;2 ;X4;Y4]];
            end

            flagcontinue=true;
            if length(Y1)>0
                TAGLINE=TAG(Y1-10:Y1+9,:);   %extract the line containing mAs and kVp
            elseif length(Y2)>0
                TAGLINE=TAG(Y2-10:Y2+9,:);   %extract the line containing mAs and kVp
            elseif length(Y3)>0
                TAGLINE=TAG(Y3-10:Y3+9,:);   %extract the line containing mAs and kVp
            else
                flagcontinue=false;
            end
            if DEBUG1; figure;imagesc(TAGLINE);set(gca,'PlotBoxAspectRatio',[10 1 1]);title('CharacterRecognition: As extracted...');colormap(gray); end


            if flagcontinue
                GlobalArray(4,:)=GlobalArray(4,:)-Y1+10;  %adapt the y coordinate to the extracted Tag Line
                GlobalArray=CorrelateFigures(GlobalArray,Character,TAGLINE);   %% find all the letter. The probleme, some letter have more than 1 possible result: exmaple 8 is close to 3 5 6 8 9 0!!
                if DEBUG1 display(GlobalArray);end
                GlobalArray=SetConflicts(GlobalArray,Character);  %% select the most powerful results
                if DEBUG1 display(GlobalArray);end

                %%%%%%%%%%%%%%%%%%%%%
                %extract MAS and KVP%
                %%%%%%%%%%%%%%%%%%%%%

                %Sort by increases x
                [foe,Indexes]=sort(GlobalArray,2);
                GlobalArray=GlobalArray(:,Indexes(3,:));

                %read the figures before KVP
                [mini,indexKVP]=min(abs((GlobalArray(1,:))-12));
                if (GlobalArray(1,indexKVP-2)<11)&&(GlobalArray(1,indexKVP-1)<11)
                    KVP=mod(GlobalArray(1,indexKVP-2),10)*10+mod(GlobalArray(1,indexKVP-1),10);
                    if DEBUG1 display(KVP);end
                end
                Recognition.KVP=KVP;
                if (Recognition.KVP<24)|(Recognition.KVP>33)
                    Error.KVPWarning=true;
                end

                %read the figures between MAS and KVP
                [mini,indexMAS]=min(abs((GlobalArray(1,:))-11));
                if indexKVP+1<=indexMAS-1
                    MAS=0;
                    for index=indexKVP+1:indexMAS-1
                        MAS=MAS*10+mod(GlobalArray(1,index),10);
                    end
                    if DEBUG1 display(MAS);end
                end
                Recognition.MAS=MAS;
                if DEBUG1 TAGLINE=DrawTheReadTag(GlobalArray,Character,size(TAGLINE));figure;imagesc(TAGLINE);title('CharacterRecognition: As read...');set(gca,'PlotBoxAspectRatio',[10 1 1]);colormap(gray);end
            end

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%% Work mm force Line  %%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            GlobalArray=[];  %matrix that will contain all the detected characters

            [X1,Y1]=findCharacter(TAG,Character,18,'unique');   %find daN
            if length(X1)>0
                GlobalArray=[GlobalArray,[18;2 ;X1;Y1]];
            end
            [X2,Y2]=findCharacter(TAG,Character,14,'unique');    %find mm
            if length(X2)>0
                GlobalArray=[GlobalArray,[14;2 ;X2;Y2]];
            end

            flagcontinue=true;
            if length(Y1)>0
                TAGLINE=TAG(Y1-10:Y1+9,:);   %extract the line containing daN and mm
            elseif length(Y2)>0
                TAGLINE=TAG(Y2-10:Y2+9,:);   %extract the line containing daN and mm
            else
                flagcontinue=false;
                Error.MM=true;
                Error.DAN=true;
            end

            if flagcontinue
                GlobalArray(4,:)=GlobalArray(4,:)-Y1+10;  %adapt the y coordinate to the extracted Tag Line
                GlobalArray=CorrelateFigures(GlobalArray,Character,TAGLINE);
                GlobalArray=SetConflicts(GlobalArray,Character);

                %extract Force and Thickness
                %Sort by increases x
                [foe,Indexes]=sort(GlobalArray,2);
                GlobalArray=GlobalArray(:,Indexes(3,:));

                %read the figures before 'mm'
                [mini,indexMM]=min(abs((GlobalArray(1,:))-14));
                Char=[];DeltaIndex=1;FlagContinue=true;
                while (FlagContinue)&(indexMM-DeltaIndex>0)&(GlobalArray(3,indexMM-DeltaIndex+1)-GlobalArray(3,indexMM-DeltaIndex)<25)   %check the space between the figures
                    Char(DeltaIndex)=GlobalArray(1,indexMM-DeltaIndex);
                    if Char(DeltaIndex)<=10
                        Char(DeltaIndex)=mod(Char(DeltaIndex),10);
                    else
                        Char(DeltaIndex)=0;
                        FlagContinue=false;
                    end
                    DeltaIndex=DeltaIndex+1;
                end
                if DeltaIndex>=2
                    MM=0;
                    for index=1:DeltaIndex-1
                        MM=MM*10+Char(DeltaIndex-index);
                    end
                end
                Recognition.MM=MM;

                %read the figures between 'mm' and 'daN'
                [mini,indexDAN]=min(abs((GlobalArray(1,:))-18));
                if indexMM+1<=indexDAN-1
                    DAN=0;
                    for index=indexMM+1:indexDAN-1
                        DAN=DAN*10+mod(GlobalArray(1,index),10);
                    end
                end
                Recognition.DAN=DAN
              
                if DEBUG1 
                    TAGLINE2=DrawTheReadTag(GlobalArray,Character,size(TAGLINE));
                    figure;imagesc(TAGLINE2);
                    title('CharacterRecognition: Second line as read');
                    set(gca,'PlotBoxAspectRatio',[10 1 1]);colormap(gray);
                end
                
            end

        elseif BRAND==2
            GlobalArray=[];  %matrix that will contain all the detected characters
            [X11,Y11,P11]=findCharacter(TAG,Character,12,'unique');   %find KV
            [X12,Y12,P12]=findCharacter(TAG,Character,19,'unique');   %find KV with the second motif
            if length(P11)>0  %select the KV with the biggest score
                if (length(P12)>0)&&(P12>P11)
                    X1=X12;
                    Y1=Y12;
                else
                    X1=X11;
                    Y1=Y11;
                end
            else
                X1=X12;
                Y1=Y12;
            end
            GlobalArray=[GlobalArray,[12;2 ;X1;Y1]];
            [X2,Y2]=findCharacter(TAG,Character,11,'unique');    %find MAS
            if length(X2)>0
                GlobalArray=[GlobalArray,[11;2 ;X2;Y2]];
            end
            [X3,Y3]=findCharacter(TAG,Character,18,'unique');    %find #
            if length(X3)>0
                GlobalArray=[GlobalArray,[18;2 ;X3;Y3]];
            end

            %determine the technique
            [foeX,foeY,foeP]=findCharacter(TAG,Character,13,'unique');    %find MO/MO
            if length(foeP)>0 X3(1)=foeX;Y3(1)=foeY;P3(1)=foeP; else P3(1)=0; end
            [foeX,foeY,foeP]=findCharacter(TAG,Character,15,'unique');    %find MO/RH
            if length(foeP)>0 X3(2)=foeX;Y3(2)=foeY;P3(2)=foeP; else P3(2)=0; end
            if ~length(P3(1)) P3(1)=0;end
            if ~length(P3(2)) P3(2)=0;end
            [maxi,indexmax]=max(P3);
            if length(P3(indexmax))>0
                switch indexmax
                    case 1
                        TECHNIQUE='MO/MO';
                    case 2
                        TECHNIQUE='MO/RH';
                end
                GlobalArray=[GlobalArray,[(indexmax-1)*2+13;2 ;X3(indexmax);Y3(indexmax)]];
            end
            Error.TECHNIQUE=false;
            Recognition.TECHNIQUE=TECHNIQUE;

            flagcontinue=true;
            if length(Y1)>0
                TAGLINE=TAG(Y1-7:Y1+9,:);   %extract the line containing mAs and kVp   from the knowledge of 'mAs' position
            elseif length(Y2)>0
                TAGLINE=TAG(Y2-7:Y2+9,:);   %extract the line containing mAs and kVp   from the knowledge of 'kVp' position
            elseif length(Y3)>0
                TAGLINE=TAG(Y3-7:Y3+9,:);   %extract the line containing mAs and kVp   from the knowledge of the technique position
            else
                flagcontinue=false;
            end
            if DEBUG1; figure;imagesc(TAGLINE);set(gca,'PlotBoxAspectRatio',[10 1 1]);title('CharacterRecognition: As extracted...');colormap(gray); end

            if flagcontinue
                GlobalArray(4,:)=GlobalArray(4,:)-Y1+10;  %adapt the y coordinate to the extracted Tag Line
                GlobalArray=CorrelateFigures(GlobalArray,Character,TAGLINE);   %% find all the letter. The probleme, some letter have more than 1 possible result: exmaple 8 is close to 3 5 6 8 9 0!!
                if DEBUG1 display(GlobalArray);end
                GlobalArray=SetConflicts(GlobalArray,Character);  %% select the most powerful results
                if DEBUG1 display(GlobalArray);end

                %%%%%%%%%%%%%%%%%%%%%
                %extract MAS and KVP%
                %%%%%%%%%%%%%%%%%%%%%

                %Sort by increases x
                [foe,Indexes]=sort(GlobalArray,2);
                GlobalArray=GlobalArray(:,Indexes(3,:));

                %read the 2 figures before KVP
                [mini,indexKVP]=min(abs((GlobalArray(1,:))-12));
                if (GlobalArray(1,indexKVP-2)<11)&&(GlobalArray(1,indexKVP-1)<11)
                    KVP=mod(GlobalArray(1,indexKVP-2),10)*10+mod(GlobalArray(1,indexKVP-1),10);
                    if DEBUG1 display(KVP);end
                end
                Recognition.KVP=KVP;
                if (Recognition.KVP<24)|(Recognition.KVP>33)
                    Error.KVPWarning=true;
                end

                %read the figures between MAS and KVP
                [mini,indexMAS]=min(abs((GlobalArray(1,:))-11));
                if indexKVP+1<=indexMAS-1
                    MAS=0;
                    for index=indexKVP+1:indexMAS-1
                        MAS=MAS*10+mod(GlobalArray(1,index),10);
                    end
                    if DEBUG1 display(MAS);end
                end
                Recognition.MAS=MAS;

                %read the figures before '#'
                %{
                [mini,indexDAN]=min(abs((GlobalArray(1,:))-18));
                CurrentPos=GlobalArray(3,indexDAN);
                CurrentIndex=indexDAN-1;
                Pound=0;
                while (1)
                    if (indexDAN-CurrentIndex)==1 %allow more space because of the coma for the second position
                        DX=30;
                    else
                        DX=14;
                    end
                    if ((CurrentPos-GlobalArray(3,CurrentIndex))<DX)&&(GlobalArray(1,CurrentIndex)>=0)&&(GlobalArray(1,CurrentIndex)<=10)
                        Pound=Pound+mod(GlobalArray(1,CurrentIndex),10)*10^(indexDAN-1-CurrentIndex);
                        CurrentPos=GlobalArray(3,CurrentIndex);
                        CurrentIndex=CurrentIndex-1;
                    else
                        break;
                    end
                end
                DAN=Pound*4.5359237/9.81;
                if DEBUG1; display(Pound);display(DAN); end
                Recognition.DAN=DAN;

                if DEBUG1 TAGLINE=DrawTheReadTag(GlobalArray,Character,size(TAGLINE));figure;imagesc(TAGLINE);title('CharacterRecognition: As read...');set(gca,'PlotBoxAspectRatio',[10 1 1]);colormap(gray);end
               %}
            end
                
            
            %%%%%%%%%%%%%%%%%%%%%%%%
            %%%% WORK on th CM line
            %%%%%%%%%%%%%%%%%%%%%%%%
            GlobalArray=[];  %matrix that will contain all the detected characters
            
            %Extract the image under TAGLINE
            CmZoneYmin=Y1+9;
            TAG2=TAG(CmZoneYmin:end,:);
            if DEBUG1;figure;imagesc(TAG2);colormap(gray);title('CharacterRecognition: zone where CM is searched');end
            [X1,Y1]=findCharacter(TAG2,Character,14,'unique');   %find daN
            Y1=CmZoneYmin+Y1;
             
            if length(X1)>0
                GlobalArray=[GlobalArray,[14;2 ;X1;Y1]];
            end

            flagcontinue=true;
            if length(Y1)>0
                TAGLINE2=TAG(Y1-10:Y1+9,:);   %extract the line containing cm
            else
                flagcontinue=false;
                Error.MM=true;
            end

            if flagcontinue
                GlobalArray(4,:)=GlobalArray(4,:)-Y1+10;  %adapt the y coordinate to the extracted Tag Line
                GlobalArray=CorrelateFigures(GlobalArray,Character,TAGLINE2);
                X=find((GlobalArray(4,:)<8)|(GlobalArray(4,:)>12));GlobalArray(:,X)=[];   %eliminate odd 9 at the top of the image ??!!
                GlobalArray=SetConflicts(GlobalArray,Character);

                %Sort by increases x
                [foe,Indexes]=sort(GlobalArray,2);
                GlobalArray=GlobalArray(:,Indexes(3,:));

                %read the figures before 'CM'
                [mini,indexMM]=min(abs((GlobalArray(1,:))-14));
                CurrentPos=GlobalArray(3,indexMM);
                CurrentIndex=indexMM-1;
                MM=0;
                while (1)
                    if (indexMM-CurrentIndex)==2 %allow more space because of the coma for the second position
                        DX=30;
                    else
                        DX=20;
                    end
                    if (CurrentIndex>0)&&((CurrentPos-GlobalArray(3,CurrentIndex))<DX)&&(GlobalArray(1,CurrentIndex)>=0)&&(GlobalArray(1,CurrentIndex)<=10)
                        MM=MM+mod(GlobalArray(1,CurrentIndex),10)*10^(indexMM-1-CurrentIndex);
                        CurrentPos=GlobalArray(3,CurrentIndex);
                        CurrentIndex=CurrentIndex-1;
                    else
                        break;
                    end
                end
                if DEBUG1; ;display(MM); end %display(Pound)
                Recognition.MM=MM;
                if DEBUG1 TAGLINE2=DrawTheReadTag(GlobalArray,Character,size(TAGLINE2));figure;imagesc(TAGLINE2);title('CharacterRecognition: Second line as read');set(gca,'PlotBoxAspectRatio',[10 1 1]);colormap(gray);end

            end
        end
    end
catch
    lasterr
    Error.MAS=true;
    Error.KVP=true;
    Error.MM=true;
    Error.DAN=true;
end


if (Recognition.MM<26)||(Recognition.MM>100)
    Error.MM=true
end
r = Recognition