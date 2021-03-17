function h_center = thickness_calculation(R,ry,tz,r_corr,S,tx)
    hph = tz-h_corr;
    ry = ry*pi/180;
    R = R*0.014; %if it is not in cm
    H = (2*S*hph + tx*tan(ry)*2*S - R*tan(ry)*S + hph*tan(ry)*R)/(2*S - tan(ry)*R);
