%          File:    UnderSampling
%
%   Description:    divide the number of pixel by 2 for the two axis
%                      
%   Author: Lionel Herve 3-03
%   Revision History:
%      acceleration affect first tempimage before doing calculations!!
%      4-17-03 work on original images - decheck FRC and FFC
%      10-13-03 add Analysis.BackGroundComputed to compel the recomputation
%           of the background afterward
%       8-3-04 add flipH
function OutPut=imagemenu(RequestedAction,param,LocalMessage);
global Analysis ctrl Image Result Info Senograph

if ~exist('LocalMessage')
    LocalMessage='Ok';   
end

OutPut.x=[];

switch RequestedAction
    case 'undersampling'
        Analysis.BackGroundComputed=false;
        Analysis.OperationList(size(Analysis.OperationList,1)+1,:)={'USAM',0};
        Analysis.Step=1;flag.ROI=false;flag.Phantom=false;    
        set(ctrl.text_zone,'String','Perform Under Sampling');
        Image.image=funcUnderSampling(Image.OriginalImage);
        imagemenu('FINISHED',0);
        
    case {'CutLeftMargin','RightMargin','CutTopMargin','BottomMargin'}
        Analysis.Step=1;flag.ROI=false;flag.Phantom=false;    
        set(ctrl.text_zone,'String','Click on the appropriate edge');
        k = waitforbuttonpress;
        point1 = round(get(gca,'CurrentPoint'));  
        switch RequestedAction
            case 'CutLeftMargin'
                param=point1(1,1);                
                imagemenu('CutLeftWithParam',param);
            case 'RightMargin'
                param=point1(1,1);                
                imagemenu('CutRightWithParam',param);
            case 'CutTopMargin'
                param=point1(1,2);                
                imagemenu('CutTopWithParam',param);
            case 'BottomMargin'
                param=point1(1,2);                
                imagemenu('CutBottomWithParam',param);
        end

        
    case 'CutLeftWithParam'
        Analysis.OperationList(end+1,:)={'CUTL',param};            
        Image.image=Image.OriginalImage(:,param:end);
        Analysis.BackGround=Analysis.BackGround(:,param:end);
        imagemenu('FINISHED',0);
    case 'AutomaticCrop'
        top=DetectImageEdge(Image.OriginalImage,'TOP');
        imagemenu('CutTopWithParam',top);
        bottom=DetectImageEdge(Image.OriginalImage,'BOTTOM');
        imagemenu('CutBottomWithParam',bottom);
        left=DetectImageEdge(Image.OriginalImage,'LEFT');
        if left > 50
            left = 10;
        end
        imagemenu('CutLeftWithParam',left);
    case 'CutRightWithParam'        
        if size(Image.OriginalImage,2)>=param
            Analysis.OperationList(end+1,1:2)={'CUTR',param};                    
            Image.image=Image.OriginalImage(:,1:param);
            Analysis.BackGround=Analysis.BackGround(:,1:param);        
            imagemenu('FINISHED',0);
        end

    case 'CutTopWithParam'        
        Analysis.OperationList(end+1,1:2)={'CUTT',param};                    
        Image.image=Image.OriginalImage(param:end,:);
        Analysis.BackGround=Analysis.BackGround(param:end,:);  
        imagemenu('FINISHED',0);
        
    case 'CutBottomWithParam'
        Analysis.OperationList(end+1,1:2)={'CUTB',param};                    
        Image.image=Image.OriginalImage(1:param,:);
        Analysis.BackGround=Analysis.BackGround(1:param,:);
        imagemenu('FINISHED',0);
        
    case 'rotation'
        Analysis.OperationList(end+1,:)={'ROTA',0};                        
        Analysis.Step=1;flag.ROI=false;flag.Phantom=false;    
        Image.image=rot90(Image.OriginalImage);
        Analysis.BackGround=rot90(Analysis.BackGround);
        imagemenu('FINISHED',0,LocalMessage);
    
    case 'flipV'
        Analysis.OperationList(end+1,:)={'FLIP',0};                            
        Analysis.Step=1;flag.ROI=false;flag.Phantom=false;    
        Image.image=flipdim(Image.OriginalImage,1);
        Analysis.BackGround=flipdim(Analysis.BackGround,1);        
        imagemenu('FINISHED',0);   
        Info.flipV = true;

    case 'flipH'
        Analysis.OperationList(end+1,:)={'FLIPH',0};                            
        Analysis.Step=1;flag.ROI=false;flag.Phantom=false;    
        Image.image=flipdim(Image.OriginalImage,2);
        Analysis.BackGround=flipdim(Analysis.BackGround,2);        
        imagemenu('FINISHED',0);       
        Info.flipH = true;
        
    case {'zoom','meanStandarddeviation','HProj'}
        set(ctrl.text_zone,'String','Drag a box');
        k = waitforbuttonpress;
        point1 = get(gca,'CurrentPoint');    % button down detected
        finalRect = rbbox;                   % return figure units
        point2 = get(gca,'CurrentPoint');    % button up detected
        point1 = point1(1,1:2);              % extract x and y
        point2 = point2(1,1:2);
        p1 = round(min(point1,point2));             % calculate locations
        offset = round(abs(point1-point2));         % and dimensions
        funcBox(p1(1),p1(2),p1(1)+offset(1),p1(2)+offset(2),'blue');
        tempimage=Image.image(p1(2):p1(2)+offset(2),p1(1):p1(1)+offset(1));
        OutPut.Image=tempimage;  %for external use
        OutPut.x=p1(1);OutPut.y=p1(2);
        switch RequestedAction
            case 'zoom'
                figure;image((tempimage/Image.maximage*63-Image.color0)/(Image.colormax-Image.color0)*Image.colornumber);colormap(Image.colormap);
            case 'meanStandarddeviation'
                if (Result.DXA==true | Result.DXAProdigyCalculated)
                    tempimage=Image.HE(p1(2):p1(2)+offset(2),p1(1):p1(1)+offset(1));
                    tempimage2=Image.LE(p1(2):p1(2)+offset(2),p1(1):p1(1)+offset(1));
                    tempimage3=Image.RST(p1(2):p1(2)+offset(2),p1(1):p1(1)+offset(1));
                    tempimage4=Image.material(p1(2):p1(2)+offset(2),p1(1):p1(1)+offset(1));
                   % tempimage4=Image.thickness(p1(2):p1(2)+offset(2),p1(1):p1(1)+offset(1));
                    le = [mean(mean(tempimage2))-Result.LE0;mean(mean(tempimage))-Result.HE0]
                   LocalMessage=strcat('Mean LE: ',num2str(mean(mean(tempimage2))-Result.LE0),'- Mean HE :',num2str(mean(mean(tempimage))-Result.HE0),'- Mean RST :',num2str(mean(mean(tempimage3))),'- Mean Material :',num2str(mean(mean(tempimage4)))); %-50
                    set(ctrl.text_zone,'String',LocalMessage);
                else
                    tempimage=Image.image(p1(2):p1(2)+offset(2),p1(1):p1(1)+offset(1));
                    flatsignal=reshape(tempimage,1,(offset(2)+1)*(offset(1)+1));
                    LocalMessage=strcat('Mean : ',num2str(mean(mean(tempimage))),'- std :',num2str(std(flatsignal)));%-50
                    set(ctrl.text_zone,'String',LocalMessage);                
                    try
                        tempimage=log(65536-Senograph.FlatLE(p1(2):p1(2)+offset(2),p1(1):p1(1)+offset(1)))-log(65536-Senograph.LE(p1(2):p1(2)+offset(2),p1(1):p1(1)+offset(1)));
                        tempimage2=log(65536-Senograph.FlatHE(p1(2):p1(2)+offset(2),p1(1):p1(1)+offset(1)))-log(65536-Senograph.HE(p1(2):p1(2)+offset(2),p1(1):p1(1)+offset(1)));
                        set(ctrl.LE,'string',num2str(mean(mean(tempimage))));
                        set(ctrl.HE,'string',num2str(mean(mean(tempimage2))));
 
                    end
                end
                 set(ctrl.text_zone,'String',LocalMessage);
            case 'HProj'
                tempimage=Image.image(p1(2):p1(2)+offset(2),p1(1):p1(1)+offset(1));
             %   tempimage=Image.image(50:350,p1(1):p1(1)+offset(1));
                global signal;
                signal=mean(tempimage');
                figure;plot(signal);       
            end
        
           
    case 'FINISHED'
        Image.OriginalImage=Image.image;     
        [Image.rows,Image.columns] = size(Image.image);
        Image.maximage=max(max(Image.image));
        set(ctrl.Cor,'value',false);
        ResizeWindow; %fit to the screen
        Analysis=ComputeBackGroundV2(Analysis,Image,Info,ctrl);  %compute the background if it has not been already done
        recomputevisu;draweverything;
        FuncActivateDeactivateButton;
        set(ctrl.text_zone,'String',LocalMessage);
end;
