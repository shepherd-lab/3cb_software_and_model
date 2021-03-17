%%%
%%% PCA: Principal components analysis
%%%       
%%%   Hany Farid; Image Science Group; Dartmouth College
%%%   12.4.07
%%%

clear;

%%% DATA
n    = 500; % number of points
m    = 7;   % dimensionality of points
p    = 1;   % number of eigenvectors to retain
P    = randn( m, n ); % random points (each column of matrix is a point


%%% PCA
mu   = mean( P' );
P    = P - repmat( mu', 1, n ); % zero- mean

if( m <= n ) % compute eigenvectors directly
   C = P * P';
   [V,D] = eig( C );
   eigval = diag(D);
   [val,ind] = sort(eigval,1,'descend');
   ind = ind(1:p);
   eigval = eigval(ind);
   V = V(:,ind);
end

if( m > n ) % compute eigenvectors indirectly
   C = P' * P;
   [V,D] = eig( C );
   eigval = diag(D);
   [val,ind] = sort(eigval,1,'descend');
   ind = ind(1:p);
   eigval = eigval(ind);
   V = V(:,ind);
   V = P*V;
end

Q = (P' * V)'; % project onto eigenvectors

