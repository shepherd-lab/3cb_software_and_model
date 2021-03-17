function save_homogen()
global Info ROI patient_id Analysis Image thickness_mapproj

[fileNameDensity, fileNameThickness] = genFileNameDenThk(Info.fname, Info.Version);
Analysis.FileNameDensity = fileNameDensity;
Analysis.FileNameThickness = fileNameThickness;
 
imwrite(uint16(Analysis.SXAthickness_mapproj*1000), Analysis.FileNameThickness, 'png');
imwrite(uint16(Analysis.SXADensityImageHomo*100), Analysis.FileNameDensity, 'png');
density_map = Analysis.SXADensityImageCrop;
fNameThick = [Info.fname(1:end-4), '_Thickness', Info.fname(end-3:end)];
szim = size(Image.OriginalImageInit);
thickness_map = zeros(szim);
thickness_map(ROI.ymin+1:ROI.ymin+ROI.rows,ROI.xmin+1:ROI.xmin+ROI.columns)   = thickness_mapproj*1000;
fNamemat = [Info.fname(1:end-4), '_Mat_v',Info.Version(8:end) ,patient_id,'_',num2str(Info.kVp),'.mat', ];
flip_info = [Info.flipH Info.flipV];
ROI.image = [];
version_name = Info.Version;
save(fNamemat, 'thickness_map','ROI','flip_info','density_map','version_name');


end


%%
function [fPathNameDen fPathNameThk] = genFileNameDenThk(fNameRaw, ver);

backSlashPos = strfind(fNameRaw, '\');
fPath = fNameRaw(1:backSlashPos(end));
fName = fNameRaw(backSlashPos(end)+1:end);

verName = ver(8:end);
verName = regexprep(verName, '\.', '_');
fNameDensity = [fName(1:end-4), 'Density', verName, fName(end-3:end)];
fNameThick = [fName(1:end-4), 'Thickness', verName, fName(end-3:end)];
fPathNameDen = [fPath, fNameDensity];
fPathNameThk = [fPath, fNameThick];
end



