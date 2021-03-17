function R0 =  find_rotationamtrix(rx, ry, rz)
    Rx = [1, 0, 0;
     0, cos(rx/180*pi), sin(rx/180*pi);
     0, -sin(rx/180*pi), cos(rx/180*pi)];

  
    Ry = [cos(ry/180*pi), 0, -sin(ry/180*pi);
          0, 1, 0;
          sin(ry/180*pi), 0, cos(ry/180*pi)];

    Rz = [cos(rz/180*pi), sin(rz/180*pi),0;
          -sin(rz/180*pi), cos(rz/180*pi), 0;
          0, 0, 1];

    Rxyz = Rz * Ry * Rx;
    R0(1:3,1:3) = Rxyz;
    R0(4,1:4) = [ 0, 0, 0, 1];
    R0(1:4, 4) = [ 0; 0; 0; 1];