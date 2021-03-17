function color_mask()
   global Image
    
    S = Image.image(1:550,690:end);
   % figure;
    % imagesc(I);%colormap(gray);
    
    %S1 = imread('phantom.png');
   % S = im2uint8(I);
    figure;
    imagesc(S);colormap(gray);
    %imshow(S1); hold on;
    
    Sblack = uint8(zeros(20,20,3));
    
    x = [50, 200,150,1];
    y = [1,100,200,100];
    tcolor(1,1,1:3) = [1, 0.5, 1];
    edgecolor = [0, 1, 0];
    transparency = 0.5;
    patch(x,y,'r','FaceAlpha',transparency,'edgecolor',edgecolor);
    %{
    S2 = S;
    S2(1:20,1:20,:) = Sblack;
    imshow(S2);
    %}
    
    Sred = Sblack;
    Sred(:,:,1)=255;
    S2 = S;
    S2(1:20,1:20,:) = Sred;
    figure;
    imshow(S2);