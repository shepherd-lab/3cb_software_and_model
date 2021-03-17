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
function OutPut=imagemenu(RequestedAction,param,LocalMessage)
global Analysis ctrl Image Result Info Tmask3C patient_ID root_dir ROI

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

    case 'flipH'
        Analysis.OperationList(end+1,:)={'FLIPH',0};                            
        Analysis.Step=1;flag.ROI=false;flag.Phantom=false;    
        Image.image=flipdim(Image.OriginalImage,2);
        Analysis.BackGround=flipdim(Analysis.BackGround,2);        
        imagemenu('FINISHED',0);                
        
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
                if Result.DXASelenia
                    tempimage=Image.HE(p1(2):p1(2)+offset(2),p1(1):p1(1)+offset(1));
                    flatsignal=reshape(tempimage,1,(offset(2)+1)*(offset(1)+1));
                    tempimage2=Image.LE(p1(2):p1(2)+offset(2),p1(1):p1(1)+offset(1));
                    flatsignal2=reshape(tempimage2,1,(offset(2)+1)*(offset(1)+1));
                    if Result.DXASeleniaCalculated
                        if isfield(Image,'RST')
                            tempimage3=Image.RST(p1(2):p1(2)+offset(2),p1(1):p1(1)+offset(1));
                            flatsignal3=reshape(tempimage3,1,(offset(2)+1)*(offset(1)+1));
                        else
                            tempimage3 = [];
                        end
                        if isfield(Image,'material') & ((p1(2)-ROI.ymin) > 0 & (p1(1)-ROI.xmin) > 0 & (p1(1) < ROI.columns))
                           tempimage4=Image.material(p1(2)-ROI.ymin:p1(2)-ROI.ymin+offset(2),p1(1)-ROI.xmin:p1(1)-ROI.xmin+offset(1));
                           %flatsignal4=reshape(tempimage4,1,(offset(2)+1)*(offset(1)+1));
                        else
                           tempimage4 = [];
                        end
                        if isfield(Image,'thickness') & (p1(2)-ROI.ymin) > 0 & (p1(1)-ROI.xmin) > 0 & (p1(1) < ROI.columns)
                           tempimage5=Image.thickness(p1(2)-ROI.ymin:p1(2)-ROI.ymin+offset(2),p1(1)-ROI.xmin:p1(1)-ROI.xmin+offset(1)); 
                           %flatsignal5=reshape(tempimage5,1,(offset(2)+1)*(offset(1)+1));
                        else
                            tempimage5 = [];
                        end 
                        if isfield(Image,'thirdcomponent') & (p1(2)-ROI.ymin) > 0 & (p1(1)-ROI.xmin) > 0 & (p1(1) < ROI.columns)
                           tempimage6=Image.thirdcomponent(p1(2)-ROI.ymin:p1(2)-ROI.ymin+offset(2),p1(1)-ROI.xmin:p1(1)-ROI.xmin+offset(1)); 
                           %flatsignal6=reshape(tempimage6,1,(offset(2)+1)*(offset(1)+1));
                        else                        
                            tempimage6 = [];
                        end 
                        if isfield(Image,'CTmask3C') & (p1(2)-ROI.ymin) > 0 & (p1(1)-ROI.xmin) > 0 & (p1(1) < ROI.columns)
                           tempimage7=Image.CTmask3C(p1(2)-ROI.ymin:p1(2)-ROI.ymin+offset(2),p1(1)-ROI.xmin:p1(1)-ROI.xmin+offset(1)); 
                           %flatsignal7=reshape(tempimage7,1,(offset(2)+1)*(offset(1)+1));
                        elseif isfield(Image,'Tmask3C') & (p1(2)> 0 & (p1(1) > 0 ))
                           tempimage7=Image.Tmask3C(p1(2):p1(2)+offset(2),p1(1):p1(1)+offset(1));    
                        else                        
                            tempimage7 = [];
                        end 
                        
                        
%                         three material
%                            LocalMessage=strcat('Mean LE: ',num2str(mean(mean(tempimage2))),'; Mean HE:  ',num2str(mean(mean(tempimage))),';  Mean Material: ',num2str(mean(mean(tempimage4))),';  Mean Thickness:',num2str(mean(mean(tempimage5)))); %-50
%                            strcat('Mean LE: ',num2str(mean(mean(tempimage2))),'; Mean HE:  ',num2str(mean(mean(tempimage))),'; Mean RST:  ',num2str(mean(mean(tempimage3))),';  Mean Material: ',num2str(mean(mean(tempimage4))),';  Mean Thickness:',num2str(mean(mean(tempimage5))), ';  Mean Third component:',num2str(mean(mean(tempimage6))))
%                            strcat('std LE: ',num2str(std(flatsignal2)),'; std HE:  ',num2str(std(flatsignal)),'; std RST:  ',num2str(std(flatsignal3)),'; std Material:  ',num2str(std(flatsignal4)),'; std Thickness:  ',num2str(std(flatsignal5)),'; std Third component:  ',num2str(std(flatsignal6)))
%                            strcat('variance LE: ',num2str(var(flatsignal2)),'; variance HE:  ',num2str(var(flatsignal)),'; variance RST:  ',num2str(var(flatsignal3)),'variance Material: ',num2str(var(flatsignal4)),'; variance Thickness:  ',num2str(var(flatsignal5)),'; variance Third component:  ',num2str(var(flatsignal6)))
                           
                           %two materials
% % %                            LocalMessage=strcat('Mean LE: ',num2str(mean(mean(tempimage2))),'; Mean HE:  ',num2str(mean(mean(tempimage))),';  Mean Material: ',num2str(mean(mean(tempimage4))),';  Mean Thickness:',num2str(mean(mean(tempimage5)))); %-50
% % %                            strcat('Mean LE: ',num2str(mean(mean(tempimage2))),'; Mean HE:  ',num2str(mean(mean(tempimage))),'; Mean RST:  ',num2str(mean(mean(tempimage3))),';  Mean Material: ',num2str(mean(mean(tempimage4))),';  Mean Thickness:',num2str(mean(mean(tempimage5))))
% % %                            strcat('std LE: ',num2str(std(flatsignal2)),'; std HE:  ',num2str(std(flatsignal)),'; std RST:  ',num2str(std(flatsignal3)),'; std Material:  ',num2str(std(flatsignal4)),'; std Thickness:  ',num2str(std(flatsignal5)))
% % %                            strcat('variance LE: ',num2str(var(flatsignal2)),'; variance HE:  ',num2str(var(flatsignal)),'; variance RST:  ',num2str(var(flatsignal3)),'variance Material: ',num2str(var(flatsignal4)),'; variance Thickness:  ',num2str(var(flatsignal5)))
% % %                            
%                            % only LE HE
%                            LocalMessage=strcat('Mean LE: ',num2str(mean(mean(tempimage2))),'; Mean HE:  ',num2str(mean(mean(tempimage)))); %-50
%                            strcat('Mean LE: ',num2str(mean(mean(tempimage2))),'; Mean HE:  ',num2str(mean(mean(tempimage))))
%                            strcat('std LE: ',num2str(std(flatsignal2/1000)),'; std HE:  ',num2str(std(flatsignal/1000)))
%                            strcat('variance LE: ',num2str(var(flatsignal2/1000)),'; variance HE:  ',num2str(var(flatsignal/1000)))
                                             
                              LocalMessage=strcat('Mean LE: ',num2str(mean(mean(tempimage2))),'; Mean HE:  ',num2str(mean(mean(tempimage))),'; Mean RST:  ',num2str(mean(mean(tempimage3))),'; Mean Thickness:  ',num2str(mean(mean(tempimage7))));
                           set(ctrl.text_zone,'String',LocalMessage);
                        LE =  mean(mean(tempimage2));
                        HE =  mean(mean(tempimage));
                        RST =  mean(mean(tempimage3));
                        water =  mean(mean(tempimage4));
                        lipid =  mean(mean(tempimage5));
                        protein =  mean(mean(tempimage6));
                        thickness =  mean(mean(tempimage7));
                        density = (water+protein)/thickness*100;
                        if thickness > 500
                            thickness = thickness/1000;
                        end
                        %figure;imagesc(tempimage4);colormap(gray);
                        if strfind(patient_ID,'CC')
                            vv = 1
                        else
                            vv = 2
                        end
                        pp = str2num(root_dir(end-14:end-10));
                         format short g;
                         wlt = [pp vv water lipid protein thickness]
                         
                         wlt_prc = [water lipid protein]/thickness*100
                         output = [LE HE RST thickness water lipid protein density]'
                        
                    else
                       LocalMessage=strcat('Mean LE: ',num2str(mean(mean(tempimage2))),'- Mean HE :',num2str(mean(mean(tempimage)))); %-50
                    
                       set(ctrl.text_zone,'String',LocalMessage);
                    end
                end
                 tempimage=Image.image(p1(2):p1(2)+offset(2),p1(1):p1(1)+offset(1));
                 flatsignal=reshape(tempimage,1,(offset(2)+1)*(offset(1)+1));
                  LocalMessage=strcat('Mean : ',num2str(mean(flatsignal)),'; Std:  ',num2str(std(flatsignal)));                         
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
        funcActivateDeactivateButton;
        set(ctrl.text_zone,'String',LocalMessage);
end;

