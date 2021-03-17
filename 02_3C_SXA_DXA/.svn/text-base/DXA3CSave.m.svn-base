

function DXA3CSave(RequestedAction)
global Info Image ROI MaskROIproj ROI

FileName3CWaterThickness = [Info.fname(1:end-4),'3CWaterThickness',Info.fname(end-3:end)];
FileName3CFatThickness = [Info.fname(1:end-4),'3CFatThickness',Info.fname(end-3:end)];
FileName3CProtThickness = [Info.fname(1:end-4),'3CProtThickness',Info.fname(end-3:end)];


% save the density and thickness images
imwrite(uint16(Image.material(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1).*MaskROIproj*1000),FileName3CWaterThickness,'png');
imwrite(uint16(Image.thickness(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1).*MaskROIproj*1000),FileName3CFatThickness,'png');
imwrite(uint16(Image.thirdcomponent(ROI.ymin:ROI.ymin+ROI.rows-1,ROI.xmin:ROI.xmin+ROI.columns-1).*MaskROIproj*1000),FileName3CProtThickness,'png');

% if strcmp(RequestedAction,'WatFatProtThicknesses') 
% 
% savFilePath=file.startpath;
%     
%     [FileName,file.startpath,filterIndex] = uiputfile(strcat(file.startpath,'*'));
%     fname = strcat(file.startpath,FileName);
%     if filterIndex~=-0
%             set(ctrl.text_zone,'String','saving the image');
%             if fname(size(fname,2)-3:size(fname,2))=='.png' %append '.tif' at the end of the name if needed
%             else 
%                fname = strcat(file.startpath,FileName,'.png'); 
%             end
%             imwrite(uint16(Image.image*1000),fname,'png');
%             set(ctrl.text_zone,'String','Ok');
%         else
%             file.startpath=savFilePath;    
%     end