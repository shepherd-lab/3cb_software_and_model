function plane_coef = plane_fittting(XYZ_trans)
    X = XYZ_trans(:,1);
    Y = XYZ_trans(:,2);
    Z = XYZ_trans(:,3);
    A=[ X Y ones(size(X))];
    plane_coef=A\Z;