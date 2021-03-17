function test_roipoly()
    I = imread('eight.tif');
    c = [222 272 300 270 221 194];
    r = [21 21 75 121 121 75];
    BW = roipoly(I,c,r);
    imshow(I)
    figure, imshow(BW)