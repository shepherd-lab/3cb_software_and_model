function test_mucoeff()
%water/wax = 20/20 

A = [8527.78	4984	8761.715576;
4294.03	2746	4197.358916
        1	1	1];
 B = [31905;
     15939.49;
    4.443];

X = A\B

%%

A = [8527.78	4984	8950.608108;
     4294.03	2746	4300;
        1	1	1];
    
 B = [29672.94;15352.86; 4.296];

X = A\B
X1 = lsqnonneg(A,B)
X2 = lsqr(A,B,1e-6, 100)
%%
A = [8527.78	4984	8528.040541;
     4294.03	2746	4020.540541;
        1	1	1];
    
 B = [28285.71;14675.1; 3.948];

X = A\B

%%
%breast
A = [8527.78	4984	8528.040541;
4294.03	2746	4020.540541;
        1	1	1];
 B = [24244;
     12172;
    4.3317];

X = A\B
X1 = lsqnonneg(A,B)
X2 = lsqr(A,B,1e-6, 100)


%%
% % % A = [8787 4948	8752;
% % % 3906 2766 4190;
% % %         1	1	1];
 
 A = [9800  5100 8400;3906  2766    4190;1	1	1];   
 R = A(1,:)./A(2,:)
 B = [24244;
     12172;
    4.1];

X = A\B
% %  X1 = lsqnonneg(A,B)
% %  X2 = lsqr(A,B,1e-6, 100)
%%
A = [9800  5100 8400;3906  2766    4190;1	1	1];   
 R = A(1,:)./A(2,:)
 B = [32179;
     17439;
    4.5];

X = A\B