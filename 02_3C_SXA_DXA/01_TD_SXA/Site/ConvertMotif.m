%convert Motifs to TopHat
%Lionel HERVE
% 8-10-04

MotifFileName='CPMCMarkers';
load(MotifFileName);
for index=1:size(ListMotif,1)
   imagette=cell2mat(ListMotif(index,1));
   imagette2=tophat(imagette);
       
   ListMotif(index,1)={imagette2};
   save('CPMCMarkersTopHat','ListMotif');
end
figure;imagesc(imagette2);