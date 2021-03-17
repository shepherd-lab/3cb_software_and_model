function [a1, a2] = calc_3cb_coeff_cvx(A, t_water, t_lipid, t_protein)
%This function calculates the coefficients for 3CB.  It uses linear
%programming (convext optimization) with the CVX tool.



%Define other variables we'll need
t_total = t_water+t_protein+t_lipid;

%Assign the three thicknesses that will be optimized a number so that the
%third component can easily be changed.
% % % t_1 = t_protein;
% % % t_2 = t_lipid;
% % % t_3 = t_water;

t_1 = t_water;
t_2 = t_lipid;
t_3 = t_protein;

%Create weights to compensate for not normalizing the error
a = 1;

m = size(A,1);
n = size(A,2);
%{
cvx_begin
    variable t;

    minimize t
    subject to 
        x_1 >= A\t_1
        x_2 >= A\t_2
        t_3c = t_total - A*x_1 - A*x_2
        t_3c >= 0
        norm([A*x_1; A*x_2; t_3c] - [t_1; t_2; t_3]) <= t
cvx_end
%}
%
cvx_begin
    variable t;
    variable x_1(n);
    variable x_2(n);
    variable t_1c(m);
    variable t_2c(m);
    variable t_3c(m);

    minimize t
    subject to 
        t_1c == A*x_1
        t_2c == A*x_2
        t_3c == t_total - t_2c - t_1c
        t_1c >= 0
        t_2c >= 0
        t_3c >= 0
       % norm([t_1c - t_1; t_2c - t_2; a*(t_3c - t_3)]) <= t
        norm([t_1c - t_1; t_2c - t_2; (t_3c - t_3)]) <= t
cvx_end
%}

a1 = x_1;
a2 = x_2;

end