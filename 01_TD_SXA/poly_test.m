function poly_test()
    x = [63 186 54 190 63];
    y = [60 60 209 204 60];
    bw = poly2mask(x,y,256,256);
    figure;
    imshow(bw)
    hold on
    plot(x,y,'b','LineWidth',2)
    hold off