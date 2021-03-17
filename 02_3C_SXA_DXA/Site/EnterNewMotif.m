% Add a lead marker to the motif List
%Lionel HERVE
%8-3-04

button = questdlg('Do you what to add a new motif')
if strcmp(button,'Yes')
    MotifFileName='CPMCMarkers';
    Motif=ImageMenu('zoom');
    
    try 
        load(MotifFileName);
    catch
        ListMotif={};
    end
    
    CurrentThreshold=LeadMarkerThreshold(Motif.Image);
    
    Motif.Image=Motif.Image>CurrentThreshold;
    figure;imagesc(Motif.Image);
    
    Room = str2num(cell2mat(inputdlg('Room')));
    LeadMarker = cell2mat(inputdlg('Lead Marker'));
    
    indexListMotif=size(ListMotif,1)+1;
    ListMotif(indexListMotif,1)={Motif.Image};
    ListMotif(indexListMotif,2)={Motif.x};
    ListMotif(indexListMotif,3)={Motif.y};
    ListMotif(indexListMotif,4)={Room};
    ListMotif(indexListMotif,5)={LeadMarker};
    
    save(MotifFileName,'ListMotif');
end


ConvertMotif