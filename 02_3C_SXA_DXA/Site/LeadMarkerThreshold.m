function Threshold=LeadMarkerThreshold(image)


%find a good threshold between the lead marker and the background 
    %For everypoint of the edge, take the minimum and maximum value in a 5x5
    %neighbourhood
    signal=[];
    Imagette=[];
    
    for dx=-2:2
        for dy=-2:2
            index=(dy+2)*5+dx+3;
            tempImage=image(dy+3:end+dy-2,dx+3:end+dx-2);
            Imagette(index,:,:)=tempImage;
            signal(index,:)=squeeze(reshape(tempImage,1,prod(size(tempImage))));
        end
    end
    Edge=edge(squeeze(Imagette(13,:,:)),'log');
    %figure;imagesc(Edge);
    signalEdge=squeeze(reshape(Edge,1,prod(size(Edge))));
    
    mini=mean(nonzeros(min(signal).*signalEdge));
    maxi=mean(nonzeros(max(signal).*signalEdge));
    
    Threshold=mean([mini maxi]);
 