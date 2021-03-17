function fixed_thickness_map()
global Image Tmask3C
    thickness = 6;
    Tmask3C=ones(size(Image.LE),'double')*thickness;
    Image.Tmask3C = Tmask3C;
    figure;imagesc(Image.Tmask3C);colormap(gray);

end

