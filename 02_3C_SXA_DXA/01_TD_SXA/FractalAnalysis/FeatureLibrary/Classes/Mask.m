classdef Mask
    properties (SetAccess = 'private')
        image = [];
        shape = [];     % as a string
        params = [];    % as a vector
        minRect = [];   % the tangential square, upper-left and lower-right corners
    end
    
    methods
        function obj = Mask(imgToMask, maskShape, maskParams)
            %create a mask having the same size as image
            rows = imgToMask.imageInfo.rows;
            cols = imgToMask.imageInfo.cols;
            obj.image = zeros(rows, cols);
            obj.shape = maskShape;
            obj.params = maskParams;
            switch lower(maskShape)
                case 'circle'
                    %create a circular mask
                    %maskParams has 3 elements: center(x, y), radius
                    x0 = maskParams(1);
                    y0 = maskParams(2);
                    r = maskParams(3);
                    for x = x0-r:x0+r
                        for y = y0-r:y0+r
                            if (sqrt((x-x0)^2+(y-y0)^2) <= r)
                                obj.image(y, x) = 1;
                            end
                        end
                    end
                    obj.minRect = [x0-r, y0-r, x0+r, y0+r];
                case 'square'
                    %create a square mask
                    %maskParams has 3 elements: upper-left corner, length
                    x0 = maskParams(1);
                    y0 = maskParams(2);
                    a = maskParams(3);
                    for x = x0:x0+(a-1)
                        for y = y0:y0+(a-1)
                            obj.image(y, x) = 1;
                        end
                    end
                    obj.minRect = [x0, y0, x0+a-1, y0+a-1];
                case 'rectangle'
                    %create a rectangle mask
                    %4 elements: upper-left corner, h-length, v-length
                    x0 = maskParams(1);
                    y0 = maskParams(2);
                    a = maskParams(3);
                    b = maskParams(4);
                    for x = x0:x0+(a-1)
                        for y = y0:y0+(b-1)
                            obj.image(y, x) = 1;
                        end
                    end
                    obj.minRect = [x0, y0, x0+a-1, y0+b-1];
                case 'polygon'
                    %create an arbitrarily shaped mask
                    %number of elements depends on passed-in 'maskParams'
                    %every two numbers in 'maskParams' stands for (x, y)
                    [m, n] = size(maskParams);
                    vertices = zeros(1, m*n);
                    for i = 1:m
                        for j = 1:n
                            vertices((i-1)*n + j) = maskParams(i, j);
                        end
                    end
                    n = length(vertices);     %number of vertices
                    if n/2 ~= floor(n/2)
                        error('The number of parameters must be even.');
                    else
                        x = zeros(1, n/2+1);
                        y = zeros(1, n/2+1);
                        for i = 1:n/2
                            x(i) = vertices(2*i-1);
                            y(i) = vertices(2*i);
                        end
                        x(end) = x(1);
                        y(end) = y(1);
                        obj.image = poly2mask(x, y, rows, cols);
                        obj.params = vertices;
                        
                        %define the minRect
                        minx = min(x);
                        maxx = max(x);
                        miny = min(y);
                        maxy = max(y);
                        obj.minRect = [minx, miny, maxx, maxy];
                    end
                otherwise
                    error(['Mask shape can only take ''circle'', ''square'', ', ...
                        '''rectangle'', or ''polygon''']);
            end
        end
        
        function disp(obj)
            [rows, cols] = size(obj.image);
            if rows * cols < 100
                disp(obj.image);
            else
                disp('Mask image matrix is too large to display.');
            end
            disp(['Shape: ', obj.shape]);
            switch lower(obj.shape)
                case 'circle'
                    disp(['Center: ', num2str(obj.params(1)), ', ', ...
                        num2str(obj.params(2))]);
                    disp(['Radius: ', num2str(obj.params(3))]);
                case 'square'
                    disp(['Upper left corner: ', num2str(obj.params(1)), ...
                        ', ', num2str(obj.params(2))]);
                    disp(['Side length: ', num2str(obj.params(3))]);
                case 'rectangle'
                    disp(['Upper left corner: ', num2str(obj.params(1)), ...
                        ', ', num2str(obj.params(2))]);
                    disp(['Horizontal length: ', num2str(obj.params(3))]);
                    disp(['Vertical length: ', num2str(obj.params(4))]);
                case 'polygon'
                    for i = 1:2:length(obj.params)
                        if i == 1
                            disp(['Polygon vertices: ', num2str(obj.params(i)), ...
                                ', ', num2str(obj.params(i+1))]);
                        else
                            disp(['                  ', num2str(obj.params(i)), ...
                                ', ', num2str(obj.params(i+1))]);
                        end
                    end
            end
        end
        
        function maskedImage = apply(this, imageObj, method)
            if nargin == 2
                method = 'binary';
            end
            switch lower(method)
                case 'binary'
                    maskedImage = imageObj.image .* this.image;
                case 'smooth'
                    %apply mask using 'smooth' method
                otherwise
                    error('Apply method can only be ''binary'' or ''smooth''.');
            end
        end
        
        function this = setMaskImage(this, maskImage)
            %check if the new mask has the same size as the original mask
            [mNew, nNew] = size(maskImage);
            [mOri, nOri] = size(this.image);
            if ~(mNew == mOri && nNew == nOri)
                error('New mask must have the same dimension as the original.');
            else
                this.image = maskImage;
                this.params = [];
            end
        end
    end
end