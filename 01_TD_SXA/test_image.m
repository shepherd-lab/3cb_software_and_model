function test_image()
    figure;
    I = imread('cameraman.tif');
    subplot(2,2,1); 
    imshow(I); title('Original Image');

    H = fspecial('motion',20,45);
    MotionBlur = imfilter(I,H,'replicate');
    subplot(2,2,2); 
    imshow(MotionBlur);title('Motion Blurred Image');

    H = fspecial('disk',10);
    blurred = imfilter(I,H,'replicate');
    subplot(2,2,3); 
    imshow(blurred); title('Blurred Image');

    H = fspecial('unsharp');
    sharpened = imfilter(I,H,'replicate');
    subplot(2,2,4); 
    imshow(sharpened); title('Sharpened Image');