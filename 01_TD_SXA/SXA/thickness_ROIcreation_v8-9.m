function thickness_ROI = thickness_ROIcreation(X_angle,Y_angle)
global Analysis  ROI MachineParams Image Info flag AutomaticAnalysis Database

% Analysis.Surface=nnz(Image.BreastMask);

if AutomaticAnalysis.PhantomlessSXA==true
    
    Analysis.rx=[];
    Analysis.ry=[];
    Analysis.rz=[];
    Analysis.tx=[];
    Analysis.ty=[];
    Analysis.tz=[];
   
    kentryRead1=[];
    kentryRead2=[];
    kentryRead3=[];
    kentryRead4=[];
    kentryRead5=[];
    hhh=[];
    BreastArea3=[];
    BreastArea4=[];
    
    BreastArea=Analysis.Surface;
    
    r = mod(Analysis.Surface, 100);
    BreastArea1 = (Analysis.Surface - r);
    
    r1 = mod(Analysis.Surface, 1000);
    BreastArea2 = (Analysis.Surface - r1);
    
    Thickness =Info.Thickness;
    machID=Info.machine_id;
    Manufacturer=Info.Manufacturer;
    
    if isfield(Info,'Manufacturer')
        if strncmp(Manufacturer,'Hologic',7) | strncmp(Manufacturer,'HOLOGIC, Inc.',13)| strncmp(Manufacturer,'LORAD',5)
            manufact_name='Hologic';
        elseif strncmp(Info.Manufacturer,'GE MEDICAL')
            manufact_name='GE';
        else %unknown field value
            manufact_name='Hologic'; %default is Hologic
        end
    else % no field in the header. so choose default
        manufact_name='Hologic'; %default is Hologic
    end
    
    if flag.small_paddle
        
        padSize='S';
    else
        padSize='L';
    end
    
    SQLstatement = ['SELECT * FROM SXA_ROIValue',...
        ' WHERE (paddle_size lIKE ''', padSize, '''',')',...
        ' AND (Manufacturer lIKE ''', manufact_name, '''',')',...
        ' AND (machine_id = ', num2str(machID), ') ',...
        ' AND (breast_area = ',num2str(BreastArea), ') ',...
        ' AND (Thickness = ', num2str(Thickness), ') ',...
        ' ORDER BY acquisition_id DESC'];
    
    kentryRead = mxDatabase(Database.Name, SQLstatement);
    
    
    SQLstatement1 = ['SELECT * FROM SXA_ROIValue',...
        ' WHERE (paddle_size lIKE ''', padSize, '''',')',...
        ' AND (Manufacturer lIKE ''', manufact_name, '''',')',...
        ' AND (machine_id = ', num2str(machID), ') ',...
        ' AND (breast_area100 = ',num2str(BreastArea1), ') ',...
        ' AND (Thickness = ', num2str(Thickness), ') ',...
        ' ORDER BY acquisition_id DESC'];
    
    kentryRead1 = mxDatabase(Database.Name, SQLstatement1);
    
    
    SQLstatement2 = ['SELECT * FROM SXA_ROIValue',...
        ' WHERE (paddle_size lIKE ''', padSize, '''',')',...
        ' AND (Manufacturer lIKE ''', manufact_name, '''',')',...
        ' AND (machine_id = ', num2str(machID), ') ',...
        ' AND (breast_area1000 = ',num2str(BreastArea2), ') ',...
        ' AND (Thickness = ', num2str(Thickness), ') ',...
        ' ORDER BY acquisition_id DESC'];
    
    kentryRead2 = mxDatabase(Database.Name, SQLstatement2);
    
    % if it couldnt find any value in database:
    if isempty(kentryRead) && isempty(kentryRead1) && isempty(kentryRead2)
        
        SQLstatement3 = ['SELECT * FROM SXA_ROIValue',...
            ' WHERE (paddle_size lIKE ''', padSize, '''',')',...
            ' AND (Manufacturer lIKE ''', manufact_name, '''',')',...
            ' AND (machine_id = ', num2str(machID), ') ',...
            ' AND (Thickness = ', num2str(Thickness), ') ',...
            ' ORDER BY acquisition_id DESC'];
        
        kentryRead3 = mxDatabase(Database.Name, SQLstatement3);
        
        if isempty(kentryRead3)
            
             SQLstatement3 = ['SELECT * FROM SXA_ROIValue',...
            ' WHERE (paddle_size lIKE ''', padSize, '''',')',...
            ' AND (Manufacturer lIKE ''', manufact_name, '''',')',...
            ' AND (Thickness = ', num2str(Thickness), ') ',...
            ' ORDER BY acquisition_id DESC'];
        
        kentryRead3 = mxDatabase(Database.Name, SQLstatement3);
            
        end
        
        %if still can not find the results choose the max or min Thickness
        %(This is unusual situation)
        
        if isempty(kentryRead3)
            
            if  Thickness>100
                
                Thickness=119;
            else
                Thickness=15;
            end
            
            SQLstatement3 = ['SELECT * FROM SXA_ROIValue',...
                ' WHERE (paddle_size lIKE ''', padSize, '''',')',...
                ' AND (Manufacturer lIKE ''', manufact_name, '''',')',...
                ' AND (Thickness = ', num2str(Thickness), ') ',...
                ' ORDER BY acquisition_id DESC'];
            
            kentryRead3 = mxDatabase(Database.Name, SQLstatement3);
            
        end
        

        sz_corr = size(kentryRead3);
        
         BreastArea3=zeros(1,sz_corr(1));
        aa=tic
        for i = 1:sz_corr(1)
            
            BreastArea3(i) = kentryRead3{i,27};
            
        end
        bb=toc
        BreastArea4=BreastArea3;
        
        [~, idx] = min(abs(BreastArea4 - BreastArea2));
        BreastArea_Closest = BreastArea4(idx);
        
        
        SQLstatement4 = ['SELECT * FROM SXA_ROIValue',...
            ' WHERE (paddle_size lIKE ''', padSize, '''',')',...
            ' AND (Manufacturer lIKE ''', manufact_name, '''',')',...
            ' AND (machine_id = ', num2str(machID), ') ',...
            ' AND (breast_area100 = ',num2str(BreastArea_Closest), ') ',...
            ' AND (Thickness = ', num2str(Thickness), ') ',...
            ' ORDER BY acquisition_id DESC'];
        
        kentryRead4 = mxDatabase(Database.Name, SQLstatement4);
        
        SQLstatement5 = ['SELECT * FROM SXA_ROIValue',...
            ' WHERE (paddle_size lIKE ''', padSize, '''',')',...
            ' AND (Manufacturer lIKE ''', manufact_name, '''',')',...
            ' AND (machine_id = ', num2str(machID), ') ',...
            ' AND (breast_area1000 = ',num2str(BreastArea_Closest), ') ',...
            ' AND (Thickness = ', num2str(Thickness), ') ',...
            ' ORDER BY acquisition_id DESC'];
        
        kentryRead5 = mxDatabase(Database.Name, SQLstatement5);
        
        
              SQLstatement6 = ['SELECT * FROM SXA_ROIValue',...
            ' WHERE (paddle_size lIKE ''', padSize, '''',')',...
            ' AND (Manufacturer lIKE ''', manufact_name, '''',')',...
            ' AND (breast_area1000 = ',num2str(BreastArea_Closest), ') ',...
            ' AND (Thickness = ', num2str(Thickness), ') ',...
            ' ORDER BY acquisition_id DESC'];
        
        kentryRead6 = mxDatabase(Database.Name, SQLstatement6);
        
        
        
    end
    
    if ~isempty(kentryRead)
        
        
        Coordinate=cell2mat(kentryRead(:, 37:end));
        
        if size(Coordinate,1)==1
            hhh=Coordinate;
        else
            hhh=mean(Coordinate);
        end
        
    elseif ~isempty(kentryRead1)
        
        
        Coordinate=cell2mat(kentryRead1(:, 37:end));
        
        if size(Coordinate,1)==1
            hhh=Coordinate;
        else
            hhh=mean(Coordinate);
        end
        
    elseif ~isempty(kentryRead2)
        
        Coordinate=cell2mat(kentryRead2(:, 37:end));
        
        if size(Coordinate,1)==1
            hhh=Coordinate;
        else
            hhh=mean(Coordinate);
        end
        
        
    elseif ~isempty(kentryRead4)
        
        Coordinate=cell2mat(kentryRead4(:, 37:end));
        
        if size(Coordinate,1)==1
            hhh=Coordinate;
        else
            hhh=mean(Coordinate);
        end
        
    elseif ~isempty(kentryRead5)
        
        Coordinate=cell2mat(kentryRead5(:, 37:end));
        
        if size(Coordinate,1)==1
            hhh=Coordinate;
        else
            hhh=mean(Coordinate);
        end
        
        
    else
        
        Coordinate=cell2mat(kentryRead6(:, 37:end));
        
        if size(Coordinate,1)==1
            hhh=Coordinate;
        else
            hhh=mean(Coordinate);
        end
        
        
    end
    
    Analysis.rx=hhh(1);
    Analysis.ry=hhh(2);
    Analysis.rz=hhh(3);
    tx = hhh(4);
    ty = hhh(5);
    tz = hhh(6);
    Analysis.tx=tx;
    Analysis.ty=ty;
    Analysis.tz=tz;
    Analysis.BBcoord_set=1;
    
    Analysis.error_3Dreconstruction=0.006;
    
    Analysis.params=[Analysis.rx,Analysis.ry,Analysis.rz,Analysis.tz,Analysis.tx,Analysis.ty,Analysis.error_3Dreconstruction];
    
end

if AutomaticAnalysis.PhantomlessSXA==false
    
    tx = Analysis.params(5);    %/0.014); %
    ty = Analysis.params(6);    %/0.014);
    tz = Analysis.params(4);    %/0.014);
    
    Analysis.tx=tx;
    Analysis.ty=ty;
    Analysis.tz=tz;
    
end


if flag.Pectoral_MLOView
    if flag.small_paddle ==  true  %small paddle
        X_angle_calc = (Analysis.rx - MachineParams.rx_correction);
        X_angle = -0.1; %run=17
        if Info.ViewId == 5
            Y_angle = Analysis.ry - MachineParams.ry_correction + X_angle_calc;
        elseif Info.ViewId == 4
            Y_angle = Analysis.ry - MachineParams.ry_correction + X_angle_calc;
        else
            Y_angle = Analysis.ry - MachineParams.ry_correction;
        end
    else
        X_angle_calc = Analysis.rx;% - MachineParams.rx_correction;
        X_angle = -0.1; %run=17
        if Info.ViewId == 5
            Y_angle = Analysis.ry  + X_angle_calc;
        elseif Info.ViewId == 4
            Y_angle = Analysis.ry  + X_angle_calc;
        else
            Y_angle = Analysis.ry;
        end
        
    end
else
    if flag.small_paddle ==  true  %small paddle
        if Info.ViewId == 2
            X_angle_calc = (Analysis.rx - MachineParams.rx_correction) -0.1;
        elseif Info.ViewId == 3
            X_angle_calc = (Analysis.rx - MachineParams.rx_correction) +0.1;
        else
            X_angle_calc = Analysis.rx - MachineParams.rx_correction;
        end
         Y_angle = Analysis.ry  - MachineParams.ry_correction;
        if X_angle_calc > -0.2
            X_angle = -0.2;
            if Y_angle > 8
                Y_angle = 8;
            end
           if Y_angle < 4
                Y_angle = Analysis.ry - MachineParams.ry_correction + X_angle_calc;
           end         
        else
            X_angle = X_angle_calc;
              if Y_angle > 8
                Y_angle = 8;                      
              end             
        end
    else
        if Info.ViewId == 2
            X_angle_calc = (Analysis.rx) -0.1;
        elseif Info.ViewId == 3
            X_angle_calc = (Analysis.rx) +0.1;
        else
            X_angle_calc = Analysis.rx ;
        end
        Y_angle = Analysis.ry;
        if X_angle_calc > -0.2
            X_angle = -0.2;
            if Y_angle > 8
                Y_angle = 8;
            end    
            if Y_angle < 4
                Y_angle = Analysis.ry + X_angle_calc;
            end
        else
            X_angle = X_angle_calc;
             Y_angle = Analysis.ry 
            if Y_angle > 8
                Y_angle = 8;
            end
            
        end
    end
end


x0_shift = -MachineParams.x0_shift;
y0_shift = -MachineParams.y0_shift;

% % if flag.Pectoral_MLOView
% %     sz = size(ROI.image); % 1407 1408
% %     thickness_ROI = zeros(size(ROI.image));
% % else
% %     sz = size(Image.image);
% %     thickness_ROI = zeros(size(Image.image));
% % end

sz = size(ROI.image); % 1407 1408
    thickness_ROI = zeros(size(ROI.image));

x_ROI = sz(2);
y_ROI = sz(1);

% sz = size(Image.OriginalImage); % 1407 1408
xmax_pixels = sz(2);
ymax_pixels = sz(1);

%tz = 5.946;
%resolution = 0.014; %in cm
resolution = Analysis.Filmresolution/10;
% % %  size_ROI = size(ROI.image);
% % % x_ROI = size_ROI(2);
% % % y_ROI = size_ROI(1);

% % x_ROI = ROI.columns; %size_ROI(2)
% % y_ROI = ROI.rows;   %size_ROI(1)
Xcoord = 1:x_ROI;
X_position = tx;
Xcoord_ROI =  repmat(Xcoord, y_ROI,1);
%YXcoord_ROI = thickness;
YXcoord_ROI = Xcoord_ROI;
x_linspace = 1:x_ROI;
y_linspace = ((1:y_ROI)')*resolution;

% calculation of the plane parameters
x_lnsparce = 1:3:x_ROI;
y_lnsparce = ((1:3:y_ROI)')*resolution;  %cm
leny = length(y_lnsparce);
lenx = length(x_linspace);
X = repmat(x_linspace', leny,1);
Y = ones(lenx,1);
for i = 2:leny
    Y = [Y;(3*(i-1)+1)*ones(lenx,1)];
end
Z = ones(lenx*leny, 1)*tz;
%figure; imagesc(Z);colormap(gray);
% Xim_calc(:,1)/k-x0_shift, ymax_pixels/2+y0_shift - Xim_calc(:,2)/k
X = X - x0_shift ;
Y = ymax_pixels/2 + y0_shift  - Y ; %-ROI.ymin
% Y = ymax_pixels/2 + y0_shift  - Y - ROI.ymin; %-ROI.ymin

one_colm = ones(lenx*leny,1);
XYZ_matrix = [[X,Y]*resolution, Z,one_colm];    % in cm
mmax1 = max(XYZ_matrix);
mmin1 = min(XYZ_matrix);
Tx1 = makehgtform('translate',[-tx -ty -tz]);
Tx2 = makehgtform('translate',[tx ty tz]);
%Y_angle = 0;
Ry = makehgtform('yrotate',Y_angle*pi/180);
Rx = makehgtform('xrotate',X_angle*pi/180);
XYZ_trans = Tx2*Ry*Rx*Tx1*XYZ_matrix';
mmax2 = max(XYZ_trans');
mmin2 = min(XYZ_trans');
%figure; imagesc(XYZ_trans);
%xROI_trans = round(XYZ_trans(1:x_ROI,1));
plane_coef = plane_fittting(XYZ_trans'); %*resolution


% % % thickness_ROI = zeros(size(ROI.image));


% thickness_ROI = zeros(sz);
X = X - x0_shift ;
Y = ymax_pixels/2 + y0_shift  - Y ;
% Y = ymax_pixels/2 + y0_shift  - Y- ROI.ymin ;

% in real space
%xmax_pixels = sz(2);
%ymax_pixels = sz(1);
% y_linspace = 1:ymax_pixels;
% % % % % middle = Analysis.ROIbreast_midpoint;
middle =round(y_ROI/2);
% middle = (ROI.ymax-ROI.ymin)/2;
half =  round(ymax_pixels/2);
% % % y_linspace = (1:ROI.xmax) ;
y_linspace = (1:y_ROI) ;
% y_linspace = (1:ROI.rows) + ROI.ymin ;

% modified not confirmed
for i = 1:x_ROI %x_ROI %xmax_pixels
    %middle = round(y_ROI/2)+ROI.ymin;
    %middle =  round(ymax_pixels/2);
    X1 = (i )*resolution;   %remove the coordinate shift x0_shift - x0_shift
    Y1 = (half - y_linspace(1:middle))*resolution ; % + y0_shift
    % X1 = (i- x0_shift + ROI.xmin)*resolution
    % Y1 =  (ymax_pixels/2+y0_shift - ROI.ymin)*resolution - y_linspace(1:middle);
    %Yneg =  (ymax_pixels/2+y0_shift - ROI.ymin)*resolution - y_linspace(middle+1:end);
    %Ypos =  (ymax_pixels/2+y0_shift - ROI.ymin)*resolution - (y_ROI*resolution-y_linspace(middle+1:end));
    Yneg =  (half - y_linspace(middle+1:end))*resolution; %    + y0_shift                (ymax_pixels/2 -y_linspace(middle+1:end))*resolution;
    Ypos =  (half -  y_linspace(middle+1:end))*resolution; %    + y0_shift                       %(ymax_pixels/2-y_linspace(middle+1:end)*resolution;
    %thickness_ROI(1:middle,i) = plane_coef(1)* i*resolution + plane_coef(2)*y_linspace(1:middle) + plane_coef(3);
    
%    if  ~flag.Pectoral_MLOView
    thickness_ROI(1:middle,i) = plane_coef(1)* X1 + plane_coef(2)*Y1 + plane_coef(3);
    if X_angle >= 0
        %thickness_ROI(middle+1:end,i) = plane_coef(1)* i*resolution + plane_coef(2)*(y_ROI*resolution-y_linspace(middle+1:end)) + plane_coef(3);
        thickness_ROI(middle+1:end,i) = plane_coef(1)* X1 + plane_coef(2)*Ypos + plane_coef(3);
    else
        % thickness_ROI(middle+1:end,i) = plane_coef(1)* i*resolution + plane_coef(2)*y_linspace(middle+1:end) + plane_coef(3);
        thickness_ROI(middle+1:end,i) = plane_coef(1)* X1 - plane_coef(2)*Yneg + plane_coef(3)+plane_coef(2)*Y1(end)+plane_coef(2)*Yneg(1);
        %FD 2012/01/12 Corrected discontinuity;
    end
% %    else       
% %        
% %     if X_angle >= 0 & Info.ViewId == 4
% %         %thickness_ROI(middle+1:end,i) = plane_coef(1)* i*resolution + plane_coef(2)*(y_ROI*resolution-y_linspace(middle+1:end)) + plane_coef(3);
% %         thickness_ROI(1:middle,i) = plane_coef(1)* X1 - plane_coef(2)*Y1 + plane_coef(3); 
% %         thickness_ROI(middle+1:end,i) = plane_coef(1)* X1 - plane_coef(2)*Ypos + plane_coef(3);
% %    
% %     elseif X_angle <= 0 & Info.ViewId == 5
% %         % thickness_ROI(middle+1:end,i) = plane_coef(1)* i*resolution + plane_coef(2)*y_linspace(middle+1:end) + plane_coef(3);
% % %         thickness_ROI(1:middle,i) = plane_coef(1)* X1 + plane_coef(2)*Y1 + plane_coef(3);
% %         thickness_ROI(1:middle,i) = plane_coef(1)* X1 - plane_coef(2)*Y1 + plane_coef(3);
% %         thickness_ROI(middle+1:end,i) = plane_coef(1)* X1 - plane_coef(2)*Yneg + plane_coef(3)+plane_coef(2)*Y1(end)+plane_coef(2)*Yneg(1);
% %         %FD 2012/01/12 Corrected discontinuity;
% %     elseif X_angle >= 0 & Info.ViewId == 5
% %          thickness_ROI(1:middle,i) = plane_coef(1)* X1 + plane_coef(2)*Y1 + plane_coef(3);
% %          thickness_ROI(middle+1:end,i) = plane_coef(1)* X1 - plane_coef(2)*Yneg + plane_coef(3)+plane_coef(2)*Y1(end)+plane_coef(2)*Yneg(1);
% %     elseif X_angle >= 0 & Info.ViewId == 4    
% %          thickness_ROI(1:middle,i) = plane_coef(1)* X1 + plane_coef(2)*Y1 + plane_coef(3);
% %          thickness_ROI(middle+1:end,i) = plane_coef(1)* X1 - plane_coef(2)*Yneg + plane_coef(3)+plane_coef(2)*Y1(end)+plane_coef(2)*Yneg(1);
% %     end
% %        
% %    end
end 

%initial version of thickness from v8
% % %   for i = 1:x_ROI %x_ROI %xmax_pixels
% % %        %middle = round(y_ROI/2)+ROI.ymin;  
% % %        %middle =  round(ymax_pixels/2);
% % %        X1 = (i )*resolution;   %remove the coordinate shift x0_shift - x0_shift
% % %        Y1 = (half - y_linspace(1:middle))*resolution ; % + y0_shift
% % %        % X1 = (i- x0_shift + ROI.xmin)*resolution
% % %       % Y1 =  (ymax_pixels/2+y0_shift - ROI.ymin)*resolution - y_linspace(1:middle);
% % %        %Yneg =  (ymax_pixels/2+y0_shift - ROI.ymin)*resolution - y_linspace(middle+1:end);
% % %        %Ypos =  (ymax_pixels/2+y0_shift - ROI.ymin)*resolution - (y_ROI*resolution-y_linspace(middle+1:end));
% % %        Yneg =  (half - y_linspace(middle+1:end))*resolution; %    + y0_shift                (ymax_pixels/2 -y_linspace(middle+1:end))*resolution;
% % %        Ypos =  (half -  y_linspace(middle+1:end))*resolution; %    + y0_shift                       %(ymax_pixels/2-y_linspace(middle+1:end)*resolution;
% % %        %thickness_ROI(1:middle,i) = plane_coef(1)* i*resolution + plane_coef(2)*y_linspace(1:middle) + plane_coef(3);
% % %        thickness_ROI(1:middle,i) = plane_coef(1)* X1 + plane_coef(2)*Y1 + plane_coef(3);
% % %        if X_angle >= 0
% % %           %thickness_ROI(middle+1:end,i) = plane_coef(1)* i*resolution + plane_coef(2)*(y_ROI*resolution-y_linspace(middle+1:end)) + plane_coef(3);
% % %           thickness_ROI(middle+1:end,i) = plane_coef(1)* X1 + plane_coef(2)*Ypos + plane_coef(3);
% % %        else
% % %          % thickness_ROI(middle+1:end,i) = plane_coef(1)* i*resolution + plane_coef(2)*y_linspace(middle+1:end) + plane_coef(3);
% % %           thickness_ROI(middle+1:end,i) = plane_coef(1)* X1 - plane_coef(2)*Yneg + plane_coef(3)+plane_coef(2)*Y1(end)+plane_coef(2)*Yneg(1);
% % %           %FD 2012/01/12 Corrected discontinuity;
% % %        end
% % %     end
    
% end




%{
    for i = 1:x_ROI
       middle = round(y_ROI/2);
       thickness_ROI(1:middle,i) = plane_coef(1)* i*resolution + plane_coef(2)*y_linspace(1:middle) + plane_coef(3);
       if X_angle < 0
          thickness_ROI(middle+1:end,i) = plane_coef(1)* i*resolution + plane_coef(2)*(y_ROI*resolution-y_linspace(middle+1:end)) + plane_coef(3);
       else
          thickness_ROI(middle+1:end,i) = plane_coef(1)* i*resolution + plane_coef(2)*y_linspace(middle+1:end) + plane_coef(3);
       end
    end
%}
%Commented by SM09142916
% % if isempty(MachineParams.bucky_distance)
% %     
% %     MachineParams.bucky_distance=0;
% %     
% % end;
Analysis.X_angle = X_angle;
Analysis.Y_angle = Y_angle;

thickness_ROI = thickness_ROI - MachineParams.bucky_distance;
a = 1;
