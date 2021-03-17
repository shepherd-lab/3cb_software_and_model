function ShawDXAImage2D(ImageType)
global Image Info Result X flag
Image.CHE= Image.HE;
 Image.CRST= Image.RST;

 
 Info.DXAAnalysisRetrieved = false; %to remove
 
flag.ShowMaterial=false;
flag.ShowThickness=false;
flag.ShowThirdComponent=false;

if strcmp(ImageType,'2DMATERIAL')
  
            coef=X(:,2);
            coef2=X(:,1);
            Image.material=  coef(1) + coef(2)*Image.CRST + coef(3)*(Image.CHE/1000) + coef(4)*(Image.CRST).^2  + coef(5)*(Image.CHE/1000).^2 +  coef(6)*((Image.CHE/1000).*Image.CRST) ;
            Image.thickness= coef2(1) + coef2(2)*Image.CRST + coef2(3)*(Image.CHE/1000) + coef2(4)*(Image.CRST).^2  + coef2(5)*(Image.CHE/1000).^2 +  coef2(6)*((Image.CHE/1000).*Image.CRST) ;
%             A=[ones(size(Data,1),1) R HE R.^2 HE.^2 R.*HE];
            Image.OriginalImage=Image.material;
    Image.material=Image.OriginalImage;
    Image.image=Image.material;
%     Image.OriginalImage=funcclim(Image.OriginalImage,-50,200);
      Image.OriginalImage=funcclim(Image.OriginalImage,-10,200);
    Image.maximage=max(max(Image.OriginalImage));

    flag.ShowMaterial=true;

    
%%
elseif strcmp(ImageType,'2DTHICKNESS')
  
            coef=X(:,2);
            coef2=X(:,1);
            Image.material=  coef(1) + coef(2)*Image.CRST + coef(3)*(Image.CHE/1000) + coef(4)*(Image.CRST).^2  + coef(5)*(Image.CHE/1000).^2 +  coef(6)*((Image.CHE/1000).*Image.CRST) ;
            Image.thickness= coef2(1) + coef2(2)*Image.CRST + coef2(3)*(Image.CHE/1000) + coef2(4)*(Image.CRST).^2  + coef2(5)*(Image.CHE/1000).^2 +  coef2(6)*((Image.CHE/1000).*Image.CRST) ;
%             A=[ones(size(Data,1),1) R HE R.^2 HE.^2 R.*HE];
            Image.OriginalImage=Image.thickness;
    Image.thickness=Image.OriginalImage;
    Image.image=Image.thickness;
%     Image.OriginalImage=funcclim(Image.OriginalImage,-50,200);
      Image.OriginalImage=funcclim(Image.OriginalImage,-0.5,3);
    Image.maximage=max(max(Image.OriginalImage));

    flag.ShowMaterial=true;
  

end
ReinitImage(Image.OriginalImage,'OPTIMIZEHIST');
draweverything;
