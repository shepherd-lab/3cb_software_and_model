% batch run of read dicoms

pathFrom = 'O:\SRL\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\';

% pathFrom = 'O:\SRL\aaStudies\Breast Studies\3CB R01\Analysis Code\Matlab\temporary_UCSF\';

pngFolderName = 'png_files';
matFolderName = 'mat_files';

for CurrentPatient = [1:250]

pathFromLoop = [pathFrom,'3C01',num2str(CurrentPatient,'%03.0f'),'\'];

checkPath = dir(pathFromLoop);

if ~(contains({checkPath.name},pngFolderName))
mkdir(pathFromLoop(1:(end-1)),pngFolderName);
end
if ~(contains({checkPath.name},matFolderName))
mkdir(pathFromLoop(1:(end-1)),matFolderName);
end

pathToPng = [pathFromLoop,pngFolderName,'\'];
pathToMat = [pathFromLoop,matFolderName,'\'];
readAllDicomDirectory(pathFromLoop, pathToPng, pathToMat)

finished = CurrentPatient
end