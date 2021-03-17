function [X, XFat, d, dFat] = findcorrcoeffs(Vfat, V80,Vphd,D)
     x1 = Vfat * (D - 80);
     x2 = - D * V80;
     A = [x1 x2];
     b = - Vphd * 80;
     X = A \ b;
     %Y = [1.03;	1.34];
    % Y3 = [0.9547;	1.1708];

     d = (Vphd - Vfat*X(1)) / (V80 * X(2) - Vfat * X(1)) * 80;
   %  d1 = (Vphd - Vfat*Y(1)) / (V80 * Y(2) - Vfat * Y(1)) * 80;
     %d3 = (Vphd - Vfat*Y3(1)) / (V80 * Y3(2) - Vfat * Y3(1)) * 80;
     yd = -A * X / 80;
     sd = sqrt(sum((D - d).^2) / 7)
   %  sd1 = sqrt(sum((D - d1).^2) / 7)
    % sd3 = sqrt(sum((D - d3).^2) / 7)
     kfat = X(1);
     klean = X(2);

     x1Fat = (D - 80);
     x2Fat = - D * V80;
     AFat = [x1Fat x2Fat];
     bFat = - Vphd * 80;
     XFat = AFat \ bFat;
     %Y = [1.03;	1.34];
    % Y3 = [0.9547;	1.1708];

     dFat = (Vphd - XFat(1)) / (V80 * X(2) - XFat(1)) * 80;
   %  d1 = (Vphd - Vfat*Y(1)) / (V80 * Y(2) - Vfat * Y(1)) * 80;
     %d3 = (Vphd - Vfat*Y3(1)) / (V80 * Y3(2) - Vfat * Y3(1)) * 80;
     ydFat = -AFat * XFat / 80;
     sdFat = sqrt(sum((D - dFat).^2) / 7)
   %  sd1 = sqrt(sum((D - d1).^2) / 7)
    % sd3 = sqrt(sum((D - d3).^2) / 7)
     VfatFat = XFat(1);
     kleanFat = XFat(2);
