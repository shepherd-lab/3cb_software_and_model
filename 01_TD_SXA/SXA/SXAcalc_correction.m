function corr_density = SXAcalc_correction(H,dh,D)
global X
  % X = [5.774806548; -3.026451704; -95.17907999; 0.029381358; 0.306035637; 17.21085162; 4.87E-06; 13.46493086; -0.00503972; -0.224510578];
  X = [5.7748; -3.0265; -95.17908; 0.0294; 0.306; 17.2109; 4.87E-06; 13.4649; -0.0050; -0.2245];
            %  +   H    +   dh    +   D  +   H.^2 + dh.^2  +  D.^2   + H.*dh  +  H.*D  +  dh.*D;
   coeff = X;
   corr_density =  coeff(1) + coeff(2)*H + coeff(3)*dh +  coeff(4)*D  + coeff(5)*H.^2 + coeff(6)*dh.^2 + coeff(7)*D.^2 + coeff(8)*H.*dh + coeff(9)*H.*D + coeff(10)*dh.*D;
   corr_density = corr_density; %*0.83;
   a =1;