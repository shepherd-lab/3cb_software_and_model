%Calibration DXA Senograph
% from Image SE3\IM1 and SE3\IM2

Data=CalibrationData;
if size(Data,2)<6
	Data(:,5)=log(65536-Data(:,3));
	Data(:,6)=log(65536-Data(:,4));
end

M=[];
for i1=0:DegreCalibration
    for i2=0:DegreCalibration-i1
        M=[M Data(:,5).^i1.*Data(:,6).^i2];
    end
end
Coef=M\Data(:,2);
Coef2=M\Data(:,1);

figure;plot(Data(:,2),M*Coef,'.');


RGland=(Data(1,5)-Data(13,5))/(Data(1,6)-Data(13,6));
RAdipose=(Data(3,5)-Data(15,5))/(Data(3,6)-Data(15,6));
Contrast=RGland/RAdipose
