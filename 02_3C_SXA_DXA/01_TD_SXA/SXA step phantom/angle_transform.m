function  [ph_rx, ph_ry, ph_rz] = angle_transform(rx0, ry0, rz0)
    R0dir = rotation_matrix(rx0, ry0, rz0); 
    R0inv = R0dir';
    ph_rx = asin(-R0inv(3,2)/sqrt(1 - R0inv(3,1)^2))*180/pi;
    ph_ry = asin(R0inv(3,1))*180/pi;
    ph_rz = asin(-R0inv(2,1)/sqrt(1 - R0inv(3,1)^2))*180/pi;