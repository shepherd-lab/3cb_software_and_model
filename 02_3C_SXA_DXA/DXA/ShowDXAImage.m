function ShowDXAImage(ImageType)
global Image Info Result X flag XX
global buttonPressed  Tmaskones Tmask3C
global Analysis ROI fredData Database MaskROI_breast file root_dir

CP_phantom = false;
Cadaver_breast = true;

thickness = 4;

% What is XX?
% X= XX

if ~(strcmp(ImageType,'LE') |  strcmp(ImageType,'HE') | strcmp(ImageType,'RST'))
    %%% temporary
    % % CallBack=get(ctrl.ROI,'callback');
    % %   eval(CallBack);
    
    % Tmask3C = 4;
    %  Image.CHE= Image.HE;
    %  Image.CRST= Image.RST;
    if CP_phantom == false & Cadaver_breast == false
        Database.Name = 'mammo_CPMC';
        % % % for real breast analysis: !! this mask is created in the SXA analysis !!
        % % % if isfield(Analysis,'SXAThicknessImageTotal')
        % % %     Tmask3C=Analysis.SXAThicknessImageTotal-1; %in cm
        % % % end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SXA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % %  Image.CHE= Image.HE;
        % %  Image.CRST= Image.RST;
        ROI = [];
        crop_coef = 1.5
        roi_params  = [];  %
        patientid = '%3C02058%';
        fname = '%LECC%';
        SQLStatement = ['SELECT ROI_xmin, ROI_ymin, ROI_columns, ROI_rows FROM [mammo_CPMC].[dbo].[acquisition], [mammo_CPMC].[dbo].[commonanalysis]   where (patient_id like ''',patientid,''' and fn like ''',fname,''' ) and commonanalysis.acquisition_id = acquisition.acquisition_id'];
        [roi_params] = cell2mat(mxDatabase(Database.Name,SQLStatement))
        
        ROI.xmin = roi_params(end,1);
        ROI.ymin = roi_params(end,2);
        ROI.columns = roi_params(end,3);
        ROI.rows = roi_params(end,4);
        
        %chwall_ids=cell2mat(mxDatabase(Database.Name,SQLstatement));
        Image.CTmask3C = double(imread('\SRL\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\3C01008\png_files\LECCrawThickness7_1.png'))/1000 -0.2 ;       %path edited 4.3.18 sypks to assign path @ UH to LECCrawThickness7_1.png in patient 8
        mn = mean(mean(Image.CTmask3C));
        MaskROI_breast = Image.CTmask3C>(mn/crop_coef);
        %figure;imagesc(MaskROI_breast); colormap(gray);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %temporarily commented for
        % calibration check
        %commented by SM 081913
        % % % % % %
        Image.CHE= Image.HE(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1);  %%%for breast
        Image.CRST=Image.RST(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1);
        
    elseif CP_phantom == true
        
        Image.CHE= Image.HE; % for phantom
        %Tmask3C=ones(size(Image.CHE),'double');
        Image.CRST= Image.RST;
    elseif Cadaver_breast == true
        crop_coef = 1.5
        %for temporary omo
          Image.CTmask3C=Image.Tmask3C(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1);
         %commented because the map was already cropped
         %%%  correction
%          Image.CTmask3C=Image.Tmask3C;
%          figure;imagesc(Image.CTmask3C);colormap(gray);
        
        if  1  %UCSF isempty(strfind(file.startpath,'Moffit'))
%             mn = mean(mean(Image.CTmask3C));
            ind = find(Image.CTmask3C~=0);
            mn = mean(Image.CTmask3C(ind));
%             breast_maskLE = Image.LE>2000;
%             breast_maskCLE = breast_maskLE(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1);
            
            MaskROI_breast = Image.CTmask3C>(mn/crop_coef);
%             MaskROI_breast =   MaskROI_breast.*breast_maskCLE;
        else
            MaskROI_breast = ROI.BreastMask;
        end
        
       
        % Image.CTmask3C=Image.Tmask3C(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1);
        Image.CHE= Image.HE(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1);  %%%for breast
        Image.CRST=Image.RST(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1);
        Image.CLE= Image.LE(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1);  %%%for breas 
        
        
      
        sz_skin = size(MaskROI_breast);
        sz_image = size(Image.CLE);
        if sz_skin(2) < sz_image(2)
            MaskROI_breast(1:sz_image(1),sz_skin(2)+1:sz_image(2)) = zeros(1:sz_image(1),sz_image(2)-sz_skin(2));
        else
            MaskROI_breast = MaskROI_breast(:,1:sz_image(2));
        end
    end
end


% % % Image.CHE= Image.HE; % for phantom
% % % Image.CRST= Image.RST;
% % % Tmask3C=ones(size(Image.CHE),'double')*4.3;

Info.DXAAnalysisRetrieved = false; %to remove

flag.ShowMaterial=false;
flag.ShowThickness=false;
flag.ShowThirdComponent=false;

if strcmp(ImageType,'LE')                     % Show LE
    Image.OriginalImage=Image.LE;
    Image.image=Image.LE;
    %figure;imagesc(Image.image);colormap(gray);
    Image.maximage=max(max(Image.image));
    fredData.LE=Image.LE;
    %% Show HE
elseif strcmp(ImageType,'HE')
    Image.OriginalImage=Image.HE;
    Image.image=Image.HE;
    Image.maximage=max(max(Image.image));
    fredData.HE=Image.HE
    %% Show RST
elseif strcmp(ImageType,'RST')
    Image.OriginalImage=Image.RST;
    Image.image=Image.RST;
    Image.OriginalImage=funcclim(Image.image,0.1,10);
    Image.maximage=max(max(Image.OriginalImage))
    
    %% Show Tmask3C
elseif strcmp(ImageType,'TMASK3C')
    
    %     Image.OriginalImage=Tmaskones;
    %     Image.image=Tmaskones;
    Image.OriginalImage=Tmask3C;
    Image.image=Tmask3C;
    %Image.OriginalImage=funcclim(Image.image,0.1,10);
    Image.maximage=max(max(Image.OriginalImage))
    fredData.thickness=Tmask3C;
    %% Show THICKNESS
elseif strcmp(ImageType,'THICKNESS')
    
    if Info.DXAAnalysisRetrieved == false
        if  Result.DXASeleniaCalculated ==true      % Result.DXASelenia
            
            coef2=X(:,1);  %caution with the order X(:,1)
            coef=X(:,2);   %  2
            
            %% test
            coef2=X(:,2);  %test
            coef=X(:,1);
            %         Image.material= coef(1)+coef(2)*Image.RST+coef(3)*(Image.HE/1000)+coef(4)*Image.RST.^2+coef(5)*(Image.HE/1000).^2+coef(6)*(Image.HE/1000.*Image.RST);%+50;
            %        Image.thickness=coef2(1)+ coef2(2)*Image.RST+coef2(3)*(Image.HE/1000)+coef2(4)*Image.RST.^2+ coef2(5)*(Image.HE/1000).^2+coef2(6)*(Image.HE/1000.*Image.RST);
            
            %
            % Image.thickness=coef2(1) + coef2(2)*(Image.HE/1000) + coef2(3)*Image.RST + T*coef2(4) + coef2(5)*(Image.HE/1000).^2 + coef2(6)*(Image.RST).^2 + T^2*coef2(7) + coef2(8)*((Image.HE/1000).*Image.RST) + coef2(9)*T*(Image.HE/1000) + coef2(10)*T*Image.RST;
            
            %       Image.thickness=coef2(1)+ coef2(2)*(Image.HE/1000)+coef2(3)*Image.RST+6*coef2(4)*...
            %                       +coef2(5)*(Image.HE/1000).^2+coef2(6)*(Image.RST).^2+ 6^2*coef2(7)...
            %                       +coef2(8)*(Image.HE/1000.*Image.RST)+coef2(9)*6*(Image.HE/1000)+coef2(10)*6*Image.RST;  % special 3C
            
            % %             %% special 3C quadratic:
            % %A=[ones(size(Data,1),1) HE R T HE.^2 R.^2 T.^2 HE.*R HE.*T T.*R];
            % Image.material=  coef(1) + coef(2)*(Image.HE/1000) + coef(3)*Image.RST + Tmask3C*coef(4) + coef(5)*(Image.HE/1000).^2 + coef(6)*(Image.RST).^2 + Tmask3C.^2*coef(7) + coef(8)*((Image.HE/1000).*Image.RST) + coef(9)*Tmask3C.*(Image.HE/1000) + coef(10)*Tmask3C.*Image.RST;
            % Image.thickness=coef2(1) + coef2(2)*(Image.HE/1000) + coef2(3)*Image.RST + Tmask3C*coef2(4) + coef2(5)*(Image.HE/1000).^2 + coef2(6)*(Image.RST).^2 + Tmask3C.^2*coef2(7) + coef2(8)*((Image.HE/1000).*Image.RST) + coef2(9)*Tmask3C.*(Image.HE/1000) + coef2(10)*Tmask3C.*Image.RST;
            
            %     %% special 3C CONIC NO crossed term:
            % Image.material=(coef(1) + coef(2)*(Image.HE/1000) + coef(3)*Image.RST + T*coef(4) + coef(5)*(Image.HE/1000).^2 + coef(6)*(Image.RST).^2 + T^2*coef(7))./(1+coef(8)*(Image.HE/1000)+coef(9)*Image.RST+coef(10)*T);
            % Image.thickness=(coef2(1) + coef2(2)*(Image.HE/1000) + coef2(3)*Image.RST + T*coef2(4) + coef2(5)*(Image.HE/1000).^2 + coef2(6)*(Image.RST).^2 + T^2*coef2(7))./(1+coef2(8)*(Image.HE/1000)+coef2(9)*Image.RST+coef2(10)*T);
            
            %     %% special 3C CONIC crossed term:
            % Image.material=(coef(1) + coef(2)*(Image.HE/1000) + coef(3)*Image.RST + T*coef(4) + coef(5)*(Image.HE/1000).^2 + coef(6)*(Image.RST).^2 + T^2*coef(7) + coef(8)*((Image.HE/1000).*Image.RST) + coef(9)*T*(Image.HE/1000) + coef(10)*T*Image.RST)/(1+coef(11)*(Image.HE/1000)+coef(12)*Image.RST+coef(13)*T);
            % Image.thickness=(coef2(1) + coef2(2)*(Image.HE/1000) + coef2(3)*Image.RST + T*coef2(4) + coef2(5)*(Image.HE/1000).^2 + coef2(6)*(Image.RST).^2 + T^2*coef2(7) + coef2(8)*((Image.HE/1000).*Image.RST) + coef2(9)*T*(Image.HE/1000) + coef2(10)*T*Image.RST)/(1+coef2(11)*(Image.HE/1000)+coef2(12)*Image.RST+coef2(13)*T);
            %
            % special 3C cubic
            % A=[ones(size(Data,1),1) HE R T HE.^2 R.^2 T.^2 HE.*R HE.*T T.*R HE.^3 R.^3 T.^3];
            %%%quadratic
            % % %          Image.material= coef(1) + coef(2)*(Image.CHE/1000) + coef(3)*Image.CRST + Tmask3C*coef(4) + coef(5)*(Image.CHE/1000).^2 + coef(6)*(Image.CRST).^2 + Tmask3C.^2*coef(7) + coef(8)*((Image.CHE/1000).*Image.CRST) + coef(9)*Tmask3C.*(Image.CHE/1000) + coef(10)*Tmask3C.*Image.CRST ;
            % % %          Image.thickness= coef2(1) + coef2(2)*(Image.CHE/1000) + coef2(3)*Image.CRST + Tmask3C*coef2(4) + coef2(5)*(Image.CHE/1000).^2 + coef2(6)*(Image.CRST).^2 + Tmask3C.^2*coef2(7) + coef2(8)*((Image.CHE/1000).*Image.CRST) + coef2(9)*Tmask3C.*(Image.CHE/1000) + coef2(10)*Tmask3C.*Image.CRST;
            %%%cubic
            % % %          Image.material= coef(1) + coef(2)*(Image.CHE/1000) + coef(3)*Image.CRST + Tmask3C*coef(4) + coef(5)*(Image.CHE/1000).^2 + coef(6)*(Image.CRST).^2 + Tmask3C.^2*coef(7) + coef(8)*((Image.CHE/1000).*Image.CRST) + coef(9)*Tmask3C.*(Image.CHE/1000) + coef(10)*Tmask3C.*Image.CRST + coef(11)*(Image.CHE/1000).^3 + coef(12)*(Image.CRST).^3 + coef(13)*Image.CTmask3C.^3;
            % % %          Image.thickness= coef2(1) + coef2(2)*(Image.CHE/1000) + coef2(3)*Image.CRST + Tmask3C*coef2(4) + coef2(5)*(Image.CHE/1000).^2 + coef2(6)*(Image.CRST).^2 + Tmask3C.^2*coef2(7) + coef2(8)*((Image.CHE/1000).*Image.CRST) + coef2(9)*Tmask3C.*(Image.CHE/1000) + coef2(10)*Tmask3C.*Image.CRST + coef2(11)*(Image.CHE/1000).^3 + coef2(12)*(Image.CRST).^3 + coef2(13)*Image.CTmask3C.^3;
            % % %
            if strfind(Info.type3C,'QUADRATIC')
                Image.material=  coef(1) + coef(2)*(Image.CHE/1000) + coef(3)*Image.CRST + Image.CTmask3C*coef(4) + coef(5)*(Image.CHE/1000).^2 + coef(6)*(Image.CRST).^2 + Image.CTmask3C.^2*coef(7) + coef(8)*((Image.CHE/1000).*Image.CRST) + coef(9)*Image.CTmask3C.*(Image.CHE/1000) + coef(10)*Image.CTmask3C.*Image.CRST ;
                Image.thickness= coef2(1) + coef2(2)*(Image.CHE/1000) + coef2(3)*Image.CRST + Image.CTmask3C*coef2(4) + coef2(5)*(Image.CHE/1000).^2 + coef2(6)*(Image.CRST).^2 + Image.CTmask3C.^2*coef2(7) + coef2(8)*((Image.CHE/1000).*Image.CRST) + coef2(9)*Image.CTmask3C.*(Image.CHE/1000) + coef2(10)*Image.CTmask3C.*Image.CRST ;
            elseif strfind(Info.type3C,'TWOCOMP')
               
                Image.material=  coef(1) + coef(2)*(Image.CHE/1000) + coef(3)*Image.CRST + coef(4)*(Image.CHE/1000).^2 + coef(5)*(Image.CRST).^2 + coef(6)*((Image.CHE/1000).*Image.CRST);
                Image.thickness= coef2(1) + coef2(2)*(Image.CHE/1000) + coef2(3)*Image.CRST + coef2(4)*(Image.CHE/1000).^2 + coef2(5)*(Image.CRST).^2 + coef2(6)*((Image.CHE/1000).*Image.CRST);    
            elseif strfind(Info.type3C,'LINEAR')
                Image.material=  coef(1) + coef(2)*(Image.CHE/1000) + coef(3)*Image.CRST + Image.CTmask3C*coef(4) ;
                Image.thickness= coef2(1) + coef2(2)*(Image.CHE/1000) + coef2(3)*Image.CRST + Image.CTmask3C*coef2(4) ;
            else
                Image.material=  coef(1) + coef(2)*(Image.CHE/1000) + coef(3)*Image.CRST + Image.CTmask3C*coef(4) + coef(5)*(Image.CHE/1000).^2 + coef(6)*(Image.CRST).^2 + Image.CTmask3C.^2*coef(7) + coef(8)*((Image.CHE/1000).*Image.CRST) + coef(9)*Image.CTmask3C.*(Image.CHE/1000) + coef(10)*Image.CTmask3C.*Image.CRST + coef(11)*(Image.CHE/1000).^3 + coef(12)*(Image.CRST).^3 + coef(13)*Image.CTmask3C.^3;
                Image.thickness= coef2(1) + coef2(2)*(Image.CHE/1000) + coef2(3)*Image.CRST + Image.CTmask3C*coef2(4) + coef2(5)*(Image.CHE/1000).^2 + coef2(6)*(Image.CRST).^2 + Image.CTmask3C.^2*coef2(7) + coef2(8)*((Image.CHE/1000).*Image.CRST) + coef2(9)*Image.CTmask3C.*(Image.CHE/1000) + coef2(10)*Image.CTmask3C.*Image.CRST + coef2(11)*(Image.CHE/1000).^3 + coef2(12)*(Image.CRST).^3 + coef2(13)*Image.CTmask3C.^3;
            end
            
            Image.material = Image.material.*MaskROI_breast;
            Image.thickness=Image.thickness.*MaskROI_breast;
            % % %          Tmask3C = Tmask3C.*MaskROI_breast;
            Image.CTmask3C = Image.CTmask3C.*MaskROI_breast;
            
            fredData.water=Image.material;
            fredData.lipid=Image.thickness;
            %  filterGauss=fspecial('gaussian',[10, 10], 1.5);
            %   Image.thickness=real(ifft2(fft2(Image.thickness).*fft2(filterGauss, size(Image.thickness, 1), size(Image.thickness, 2))));
            %temp blur for noise reduction
            % Image.thickness= medfilt2(Image.thickness, [8 8]);
            % Image.thickness = funcGradientGauss(Image.thickness,4);
            %
            %  Image.thickness=Image.thickness.*Tmaskones; %% for T images !!
            %  figure;imagesc(Image.material);colormap(gray);
            %  figure;imagesc(Image.thickness);colormap(gray);
        end
    end
    Image.OriginalImage=Image.thickness;
    Image.thickness=Image.OriginalImage;
    
    Image.image=Image.thickness;
    %     Image.OriginalImage=funcclim(Image.OriginalImage,-5,25);
    Image.OriginalImage=funcclim(Image.OriginalImage,-1,10);
    Image.thickness = funcclim(Image.thickness,-1,10);
    Image.maximage=max(max(Image.OriginalImage));
    flag.ShowThickness=true;
    
    %% Show MATERIAL
elseif strcmp(ImageType,'MATERIAL')
    if Info.DXAAnalysisRetrieved == false
        if  Result.DXASeleniaCalculated       % Result.DXASelenia
            
            % %             coef2=X(:,1);
            % %             coef=X(:,2);
            
            %% test
            coef2=X(:,2);  %test
            coef=X(:,1);
            
            %             Image.material= coef(1)+coef(2)*Image.RST+coef(3)*(Image.HE/1000)+coef(4)*Image.RST.^2+coef(5)*(Image.HE/1000).^2+coef(6)*(Image.HE/1000.*Image.RST);%+50;
            %             Image.thickness=coef2(1)+ coef2(2)*Image.RST+coef2(3)*(Image.HE/1000)+coef2(4)*Image.RST.^2+ coef2(5)*(Image.HE/1000).^2+coef2(6)*(Image.HE/1000.*Image.RST);%-0.5;%-0.73;%+50;
            %                     Image.densevolume=1/100* Image.material .* Image.thickness *(0.014)^2;
            
            %             %% special 3C quadratic:
            %A=[ones(size(Data,1),1) HE R T HE.^2 R.^2 T.^2 HE.*R HE.*T T.*R];
            %Image.material=  coef(1) + coef(2)*(Image.HE/1000) + coef(3)*Image.RST + Tmask3C*coef(4) + coef(5)*(Image.HE/1000).^2 + coef(6)*(Image.RST).^2 + Tmask3C.^2*coef(7) + coef(8)*((Image.HE/1000).*Image.RST) + coef(9)*Tmask3C.*(Image.HE/1000) + coef(10)*Tmask3C.*Image.RST;
            %Image.thickness=coef2(1) + coef2(2)*(Image.HE/1000) + coef2(3)*Image.RST + Tmask3C*coef2(4) + coef2(5)*(Image.HE/1000).^2 + coef2(6)*(Image.RST).^2 + Tmask3C.^2*coef2(7) + coef2(8)*((Image.HE/1000).*Image.RST) + coef2(9)*Tmask3C.*(Image.HE/1000) + coef2(10)*Tmask3C.*Image.RST;
            % Image.material=  coef(1) + coef(2)*(Image.CHE/1000) + coef(3)*Image.CRST + Tmask3C*coef(4) + coef(5)*(Image.CHE/1000).^2 + coef(6)*(Image.CRST).^2 + Tmask3C.^2*coef(7) + coef(8)*((Image.CHE/1000).*Image.CRST) + coef(9)*Tmask3C.*(Image.CHE/1000) + coef(10)*Tmask3C.*Image.CRST + coef(11)*(Image.CHE/1000).^3 + coef(12)*(Image.CRST).^3 + coef(13)*Tmask3C.^3;
            % Image.thickness= coef2(1) + coef2(2)*(Image.CHE/1000) + coef2(3)*Image.CRST + Tmask3C*coef2(4) + coef2(5)*(Image.CHE/1000).^2 + coef2(6)*(Image.CRST).^2 + Tmask3C.^2*coef2(7) + coef2(8)*((Image.CHE/1000).*Image.CRST) + coef2(9)*Tmask3C.*(Image.CHE/1000) + coef2(10)*Tmask3C.*Image.CRST + coef2(11)*(Image.CHE/1000).^3 + coef2(12)*(Image.CRST).^3 + coef2(13)*Tmask3C.^3;
            
            %     %% special 3C CONIC NO crossed term:
            % Image.material=(coef(1) + coef(2)*(Image.HE/1000) + coef(3)*Image.RST + T*coef(4) + coef(5)*(Image.HE/1000).^2 + coef(6)*(Image.RST).^2 + (T^2)*coef(7))./(1+coef(8)*(Image.HE/1000)+coef(9)*Image.RST+coef(10)*T);
            % Image.thickness=(coef2(1) + coef2(2)*(Image.HE/1000) + coef2(3)*Image.RST + T*coef2(4) + coef2(5)*(Image.HE/1000).^2 + coef2(6)*(Image.RST).^2 + T^2*coef2(7))./(1+coef2(8)*(Image.HE/1000)+coef2(9)*Image.RST+coef2(10)*T);
            
            %figure;imagesc(Tmask3C);colormap(gray);
            %         special 3C cubic
            % A=[ones(size(Data,1),1) HE R T HE.^2 R.^2 T.^2 HE.*R HE.*T T.*R HE.^3 R.^3 T.^3];
            % % % Image.material= coef(1) + coef(2)*(Image.CHE/1000) + coef(3)*Image.CRST + Tmask3C*coef(4) + coef(5)*(Image.CHE/1000).^2 + coef(6)*(Image.CRST).^2 + Tmask3C.^2*coef(7) + coef(8)*((Image.CHE/1000).*Image.CRST) + coef(9)*Tmask3C.*(Image.CHE/1000) + coef(10)*Tmask3C.*Image.CRST ;
            % % % Image.thickness= coef2(1) + coef2(2)*(Image.CHE/1000) + coef2(3)*Image.CRST + Tmask3C*coef2(4) + coef2(5)*(Image.CHE/1000).^2 + coef2(6)*(Image.CRST).^2 + Tmask3C.^2*coef2(7) + coef2(8)*((Image.CHE/1000).*Image.CRST) + coef2(9)*Tmask3C.*(Image.CHE/1000) + coef2(10)*Tmask3C.*Image.CRST;
            
            
            % % Image.material=  coef(1) + coef(2)*(Image.CHE/1000) + coef(3)*Image.CRST + Image.CTmask3C*coef(4) + coef(5)*(Image.CHE/1000).^2 + coef(6)*(Image.CRST).^2 + Image.CTmask3C.^2*coef(7) + coef(8)*((Image.CHE/1000).*Image.CRST) + coef(9)*Image.CTmask3C.*(Image.CHE/1000) + coef(10)*Image.CTmask3C.*Image.CRST + coef(11)*(Image.CHE/1000).^3 + coef(12)*(Image.CRST).^3 + coef(13)*Image.CTmask3C.^3;
            % % Image.thickness= coef2(1) + coef2(2)*(Image.CHE/1000) + coef2(3)*Image.CRST + Image.CTmask3C*coef2(4) + coef2(5)*(Image.CHE/1000).^2 + coef2(6)*(Image.CRST).^2 + Image.CTmask3C.^2*coef2(7) + coef2(8)*((Image.CHE/1000).*Image.CRST) + coef2(9)*Image.CTmask3C.*(Image.CHE/1000) + coef2(10)*Image.CTmask3C.*Image.CRST + coef2(11)*(Image.CHE/1000).^3 + coef2(12)*(Image.CRST).^3 + coef2(13)*Image.CTmask3C.^3;
            
            if strfind(Info.type3C,'QUADRATIC')
                Image.material=  coef(1) + coef(2)*(Image.CHE/1000) + coef(3)*Image.CRST + Image.CTmask3C*coef(4) + coef(5)*(Image.CHE/1000).^2 + coef(6)*(Image.CRST).^2 + Image.CTmask3C.^2*coef(7) + coef(8)*((Image.CHE/1000).*Image.CRST) + coef(9)*Image.CTmask3C.*(Image.CHE/1000) + coef(10)*Image.CTmask3C.*Image.CRST ;
                Image.thickness= coef2(1) + coef2(2)*(Image.CHE/1000) + coef2(3)*Image.CRST + Image.CTmask3C*coef2(4) + coef2(5)*(Image.CHE/1000).^2 + coef2(6)*(Image.CRST).^2 + Image.CTmask3C.^2*coef2(7) + coef2(8)*((Image.CHE/1000).*Image.CRST) + coef2(9)*Image.CTmask3C.*(Image.CHE/1000) + coef2(10)*Image.CTmask3C.*Image.CRST ;
            elseif strfind(Info.type3C,'TWOCOMP')
                Image.material=  coef(1) + coef(2)*(Image.CHE/1000) + coef(3)*Image.CRST + coef(4)*(Image.CHE/1000).^2 + coef(5)*(Image.CRST).^2 + coef(6)*((Image.CHE/1000).*Image.CRST);
                Image.thickness= coef2(1) + coef2(2)*(Image.CHE/1000) + coef2(3)*Image.CRST + coef2(4)*(Image.CHE/1000).^2 + coef2(5)*(Image.CRST).^2 + coef2(6)*((Image.CHE/1000).*Image.CRST);
            elseif strfind(Info.type3C,'LINEAR')
                Image.material=  coef(1) + coef(2)*(Image.CHE/1000) + coef(3)*Image.CRST + Image.CTmask3C*coef(4) ;
                Image.thickness= coef2(1) + coef2(2)*(Image.CHE/1000) + coef2(3)*Image.CRST + Image.CTmask3C*coef2(4) ;
            else
                Image.material=  coef(1) + coef(2)*(Image.CHE/1000) + coef(3)*Image.CRST + Image.CTmask3C*coef(4) + coef(5)*(Image.CHE/1000).^2 + coef(6)*(Image.CRST).^2 + Image.CTmask3C.^2*coef(7) + coef(8)*((Image.CHE/1000).*Image.CRST) + coef(9)*Image.CTmask3C.*(Image.CHE/1000) + coef(10)*Image.CTmask3C.*Image.CRST + coef(11)*(Image.CHE/1000).^3 + coef(12)*(Image.CRST).^3 + coef(13)*Image.CTmask3C.^3;
                Image.thickness= coef2(1) + coef2(2)*(Image.CHE/1000) + coef2(3)*Image.CRST + Image.CTmask3C*coef2(4) + coef2(5)*(Image.CHE/1000).^2 + coef2(6)*(Image.CRST).^2 + Image.CTmask3C.^2*coef2(7) + coef2(8)*((Image.CHE/1000).*Image.CRST) + coef2(9)*Image.CTmask3C.*(Image.CHE/1000) + coef2(10)*Image.CTmask3C.*Image.CRST + coef2(11)*(Image.CHE/1000).^3 + coef2(12)*(Image.CRST).^3 + coef2(13)*Image.CTmask3C.^3;
            end
            
            
            Image.material = Image.material.*MaskROI_breast;
            Image.thickness=Image.thickness.*MaskROI_breast;
            %figure;imagesc(Image.material);colormap(gray);
            Image.CTmask3C = Image.CTmask3C.*MaskROI_breast;
            
            fredData.water=Image.material;
            fredData.lipid=Image.thickness;
            % Image.material= medfilt2(Image.material, [8 8]);
            % Image.material = funcGradientGauss(Image.material,4); %% for T images !!
            
            %   Image.material=Image.material.*Tmaskones; %% for T images !! FD - temp
            %   edit
            
            %     figure;imagesc(Image.material);colormap(gray);
            %     figure;imagesc(Tmaskones);colormap(gray);
            % % %         elseif strcmp(Info.DXACalibration,'lateral')     %calibration Lateral ?
            % % %             %Calibration p161lh1
            % % %             Image.material=-1521.113402+822.6224304*Image.RST-1625.480798*(Image.HE/1000)+363.8522675*Image.RST.^2+20.92057283*(Image.HE/1000).^2+1409.539624*(Image.HE/1000.*Image.RST)+50;
            % % %         else
            % % %             %Calibration p161lh1
            % % %             Image.material=1522.437597-4087.17244*Image.RST-2065.65348*(Image.HE/1000)+2355.784874*Image.RST.^2+29.75419467*(Image.HE/1000).^2+1777.450806*(Image.HE/1000.*Image.RST)+50;
            
        end
    end
    %  filterGauss=fspecial('gaussian',[10, 10], 1.5);
    % Image.material=real(ifft2(fft2(Image.material).*fft2(filterGauss, size(Image.material, 1), size(Image.material, 2))));
    %temp blur to reduce noise
    Image.OriginalImage=Image.material;
    Image.material=Image.OriginalImage;
    Image.image=Image.material;
   % Image.OriginalImage=funcclim(Image.OriginalImage,-5,10);
    Image.OriginalImage=funcclim(Image.OriginalImage,-1,10);
    Image.material = funcclim(Image.material,-1,10);
     Image.thickness = funcclim(Image.thickness,-1,10);
    Image.maximage=max(max(Image.OriginalImage));
    
    flag.ShowMaterial=true;
    
    %% Show Third component
    
elseif strcmp(ImageType,'ThirdComponent')
    
    if  Result.DXASeleniaCalculated       % Result.DXASelenia
        coef2=X(:,1);
        coef=X(:,2);
        %             %% special 3C quadratic:
        %A=[ones(size(Data,1),1) HE R T HE.^2 R.^2 T.^2 HE.*R HE.*T T.*R];
        % Image.material=  coef(1) + coef(2)*(Image.HE/1000) + coef(3)*Image.RST + Tmask3C*coef(4) + coef(5)*(Image.HE/1000).^2 + coef(6)*(Image.RST).^2 + Tmask3C.^2*coef(7) + coef(8)*((Image.HE/1000).*Image.RST) + coef(9)*Tmask3C.*(Image.HE/1000) + coef(10)*Tmask3C.*Image.RST;
        % Image.thickness=coef2(1) + coef2(2)*(Image.HE/1000) + coef2(3)*Image.RST + Tmask3C*coef2(4) + coef2(5)*(Image.HE/1000).^2 + coef2(6)*(Image.RST).^2 + Tmask3C.^2*coef2(7) + coef2(8)*((Image.HE/1000).*Image.RST) + coef2(9)*Tmask3C.*(Image.HE/1000) + coef2(10)*Tmask3C.*Image.RST;
        %
        %                     % special 3C cubic
        % % A=[ones(size(Data,1),1) HE R T HE.^2 R.^2 T.^2 HE.*R HE.*T T.*R HE.^3 R.^3 T.^3];
        % Image.material=  coef(1) + coef(2)*(Image.CHE/1000) + coef(3)*Image.CRST + Tmask3C*coef(4) + coef(5)*(Image.CHE/1000).^2 + coef(6)*(Image.CRST).^2 + Tmask3C.^2*coef(7) + coef(8)*((Image.CHE/1000).*Image.CRST) + coef(9)*Tmask3C.*(Image.CHE/1000) + coef(10)*Tmask3C.*Image.CRST + coef(11)*(Image.CHE/1000).^3 + coef(12)*(Image.CRST).^3 + coef(13)*Tmask3C.^3;
        % Image.thickness= coef2(1) + coef2(2)*(Image.CHE/1000) + coef2(3)*Image.CRST + Tmask3C*coef2(4) + coef2(5)*(Image.CHE/1000).^2 + coef2(6)*(Image.CRST).^2 + Tmask3C.^2*coef2(7) + coef2(8)*((Image.CHE/1000).*Image.CRST) + coef2(9)*Tmask3C.*(Image.CHE/1000) + coef2(10)*Tmask3C.*Image.CRST + coef2(11)*(Image.CHE/1000).^3 + coef2(12)*(Image.CRST).^3 + coef2(13)*Tmask3C.^3;
        % %
        %filterGauss=fspecial('gaussian',[10, 10], 1.5);
        %Image.thirdcomponent=real(ifft2(fft2(Tmask3C-Image.material-Image.thickness).*fft2(filterGauss, size(Image.thickness, 1), size(Image.thickness, 2))));
        Image.thirdcomponent= Image.CTmask3C - Image.material - Image.thickness;%  +0.2;
        Image.thirdcomponent= Image.thirdcomponent.*MaskROI_breast;
        %adding a small blur
        % Image.thirdcomponent= medfilt2(Image.thirdcomponent, [4 4]); %% !!
        % Image.thirdcomponent = funcGradientGauss(Image.thirdcomponent,4); %% for T images !!
    end
    
    
    %      Image.thirdcomponent=Image.thirdcomponent.*Tmaskones; %% for T
    %      images !! - temp edit
    
    Image.OriginalImage=Image.thirdcomponent;
    fredData.protein=Image.thirdcomponent;
    %     Image.thirdcomponent=Image.OriginalImage;
    Image.image=Image.thirdcomponent;
    Image.OriginalImage=funcclim(Image.OriginalImage,-1,10);
    Image.thirdcomponent = funcclim(Image.thirdcomponent,-1,10);% !! GO BACK TO 200
    Image.maximage=max(max(Image.OriginalImage));
    flag.Showthirdcomponent=true;
    
    %% Show DENSEVOLUME
elseif strcmp(ImageType,'DENSEVOLUME')
    
    if  Result.DXASeleniaCalculated       % Result.DXASelenia
        
        Image.densevolume=10000*1/100* Image.material .* Image.thickness.*(0.014)^2;
        
        
    end
    
    Image.OriginalImage=Image.densevolume;
    Image.densevolume=Image.OriginalImage;
    Image.image=Image.densevolume;
    Image.OriginalImage=funcclim(Image.OriginalImage,-50,200);
    Image.maximage=max(max(Image.OriginalImage));
    
    flag.ShowDensevolume=true;
    
    
end

%Image.image=Image.OriginalImage;
%figure;imagesc(Image.OriginalImage); colormap(gray);
ReinitImage(Image.OriginalImage,'OPTIMIZEHIST');
%figure;imagesc(Image.OriginalImage);colormap(gray);
%figure;imagesc(Image.OriginalImage); colormap(gray)
Info.DigitizerDescription='Hologic';
%buttonProcessing('CorrectionAsked');
%HistogramManagement('ComputeHistogram');
draweverything;
%figure;imagesc(Image.image);colormap(gray);
a = 1;

