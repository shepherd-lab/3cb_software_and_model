function Y = Calibration_angleError(angle_all,thick_all)
Data=[...
4.9	     0.8	2
9.74	1.82	2
14.2	2.5	2
22.6	3.9	2
27.5	4.64	2
34.7	5.53	2
46.08	6.78	2
56.8	7.74	2
3.4	    1.1	4
5.3	     1.6	4
7.4	    2.45	4
13.2	3.96	4
15.4	4.65	4
18.2	5.57	4
22.4	6.79	4
27.3	7.75	4
3.5	    0.95	3
7.7	    1.91	3
10.7	2.55	3
15.3	3.8	3
19	4.58	3
23.3	5.25	3
30.5	6.38	3
35.1	7.15	3
2.5	1.06	6
3.4	1.52	6
5.4	2.36	6
8.2	3.8	6
10.5	4.5	6
13	5.42	6
16	6.67	6
18.1	7.56	6
];

H = Data(:,3);
An = Data(:,2);
B = Data(:,1);
len = size(Data,1);
one_vect = ones(len,1);
%A = zeros(len,6);
A=[one_vect, H, An, H.^2, An.^2, H.*An];
X=A\B
Result=A*X;
figure;plot(An,Result,'o');hold on;
plot(An,B,'rx');

%dev_thickness = (sum((Data(:,1)-Result(:,1)).^2)./size(Data,1)).^0.5
%dev_density = (sum((Data(:,2)-Result(:,2)).^2)./size(Data,1)).^0.5
%x = X;
%d = 1;
%dev = (sum((Data(:,2)-Result(:,2)).^2)./size(Data,1)).^0.5
;
 coeff = [
   13.9035
   -8.3748
    7.1420
    1.1422
    0.2298
   -1.1958
];
Y = coeff(1) + coeff(2)*thick_all + coeff(3)*angle_all + coeff(4)*thick_all.^2 + coeff(5)*angle_all.^2 + coeff(6)*thick_all.*angle_all;

