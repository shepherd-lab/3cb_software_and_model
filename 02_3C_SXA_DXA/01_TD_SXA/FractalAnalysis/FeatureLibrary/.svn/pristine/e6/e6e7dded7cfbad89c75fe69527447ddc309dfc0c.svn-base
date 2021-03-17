classdef Image
    properties %(SetAccess = 'private')
        imageRaw = [];
        imageAtten = [];
        imageThick =[];
        imageDensity=[];
        breastMask = [];
        breastCoord = [];
        resolution = [];%in mm.
        nipplePos =[];
        midnip=[];
        backGround=[];
        
    end
    
    methods
        function obj = Image(SXAInfo, imageRaw, imageAtten, imageThick, imageDensity, breastMask, breastCoord, resolution, backGround)            
            obj.imageRaw = imageRaw;
            obj.imageAtten = imageAtten;
            obj.imageThick = imageThick;
            obj.imageDensity = imageDensity;
            obj.breastMask= breastMask;
            obj.breastCoord = breastCoord;
            obj.resolution=resolution;
            obj.nipplePos=SXAInfo.ROI.nipple_pos;
            obj.midnip=SXAInfo.ROI.midpoint;
            obj.backGround=backGround;
        end
        
        function disp(obj) %#ok<MANU>
        end
        
    end
end