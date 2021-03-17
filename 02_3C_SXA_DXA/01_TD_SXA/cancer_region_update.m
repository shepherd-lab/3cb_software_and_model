function cancer_region_update()
    global CancerRegionData Info
    [FileName,PathName] = uigetfile('Flowers - Cancer Points.xls','Select the excel file ');   
    filename = [PathName,FileName]; 
    num = xlsread(filename);
    size_num = size(num);
    for i = 2:size_num(1)-1
        num_row = round(num(i,:));
        nan_index = isnan(num_row);
        num_row(nan_index) = [];
        Info.AcquisitionKey = num_row(1);
        CancerRegionData.NumberPoints = round((length(num_row)-1)*0.5);
        CancerRegionData.Group = 1;
        CancerRegionData.Points = reshape(num_row(2:end),2,CancerRegionData.NumberPoints)';
        SaveInDatabase('CancerRegion');
        a =1;
    end
        
    a =1;
        
   