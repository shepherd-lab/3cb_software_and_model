classdef ImageInfo
    properties
        rows = NaN;
        cols = NaN;
        padSize = [];   %paddle size
        acqId = NaN;    %acquisition id
        site = [];      %site id
        patId = NaN;    %patient id
        acqDate = [];   %acquisition date
        machId = NaN;   %machine id
        mAs = NaN;      %current
        kVp = NaN;      %voltage
        digiId = NaN;   %digitalizer id
        res = NaN;      %resolution
        glevel = NaN;   %gray scale level
        imgPath = NaN;  %path and name of the image file
        thkness = NaN;  %thickness
        force = NaN;    %force
        dicomId = NaN;  %dicomId
        viewPos = NaN;  %CC or MLO
    end
    
    methods
        function obj = ImageInfo(image, acqInfo)
            [obj.rows, obj.cols] = size(image);
            if (obj.cols < 1500)
                obj.padSize = 'small';
            else
                obj.padSize = 'large';
            end
            
            if ~isempty(acqInfo)
                obj.acqId = acqInfo{1};
                obj.site = acqInfo{2};
                obj.patId = acqInfo{3};
                obj.acqDate = acqInfo{4};
                obj.machId = acqInfo{5};
                obj.mAs = acqInfo{6};
                obj.kVp = acqInfo{7};
                obj.digiId = acqInfo{8};
                obj.res = acqInfo{9};
                obj.glevel = 2^acqInfo{10};
                obj.imgPath = acqInfo{11};
                obj.thkness = acqInfo{12};
                obj.force = acqInfo{13};
                obj.dicomId = acqInfo{14};
                obj.viewPos = acqInfo{15};
            end
        end
        
        function disp(obj)
            disp(['rows: ' num2str(obj.rows)]);
            disp(['cols: ' num2str(obj.cols)]);
            disp(['paddleSize: ', obj.padSize]);
            disp(['acqId: ' num2str(obj.acqId)]);
            disp(['site: ' obj.site]);
            disp(['patientId: ' num2str(obj.patId)]);
            disp(['acqDate: ' obj.acqDate]);
            disp(['machineId: ' num2str(obj.machId)]);
            disp(['current(mAs): ' num2str(obj.mAs)]);
            disp(['voltage(kVp): ' num2str(obj.kVp)]);
            disp(['digitalizerId: ' num2str(obj.digiId)]);
            disp(['resolution: ' num2str(obj.res)]);
            disp(['greyLevel: ' num2str(obj.glevel)]);
            disp(['imagePath: ' num2str(obj.imgPath)]);
            disp(['thickness: ' num2str(obj.thkness)]);
            disp(['force: ' num2str(obj.force)]);
            disp(['dicomId: ' num2str(obj.dicomId)]);
            disp(['viewPosition: ' num2str(obj.viewPos)]);
        end
    end
end