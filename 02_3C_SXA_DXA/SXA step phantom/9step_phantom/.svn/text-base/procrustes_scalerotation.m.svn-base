function [R0,bscale] = procrustes_scalerotation(Xim,Xph)
    %revised from stat toolbox  
[n, m]   = size(Xim);
[ny, my] = size(Xph);

if ny ~= n
    error('stats:procrustes:InputSizeMismatch',...
          'X and Y must have the same number of rows (points).');
elseif my > m
    error('stats:procrustes:InputSizeMismatch',...
          'Y cannot have more columns (variables) than X.');
end

% center at the origin
mXim = mean(Xim,1);
mXph = mean(Xph,1);
Xim0 = Xim - repmat(mXim, n, 1);
Xph0 = Xph - repmat(mXph, n, 1);

ssqX = sum(Xim0.^2,1);
ssqY = sum(Xph0.^2,1);
constX = all(ssqX <= abs(eps(class(Xim))*n*mXim).^2);
constY = all(ssqY <= abs(eps(class(Xph))*n*mXph).^2);

if ~constX & ~constY
    % the "centered" Frobenius norm
    normX = sqrt(sum(ssqX)); % == sqrt(trace(X0*X0'))
    normY = sqrt(sum(ssqY)); % == sqrt(trace(Y0*Y0'))

    % scale to equal (unit) norm
    Xim0 = Xim0 / normX;
    Xph0 = Xph0 / normY;

    % make sure they're in the same dimension space
    if my < m
        Xph0 = [Xph0 zeros(n, m-my)];
    end

    % Do the computation of rotation matrix R
    %A =  Xph0 * Xim0';
    A =   Xim0*Xph0' ;
    [U, S, V] = svd(A);
    R = V * U';
    R0 = R(1:3,1:3);
    R0(4,1:4) = [ 0, 0, 0, 1];
    R0(1:4, 4) = [ 0; 0; 0; 1];
    trsqrtAA = sum(diag(S));
    bscale = trsqrtAA * normX / normY;
end
    %{
    % optimum (symmetric in X and Y) scaling of Y
    % == trace(sqrtm(A'*A))

    % the standardized distance between X and bYT+c
    d = 1 - trsqrtAA.^2;
    if nargout > 1
        Z = normX*trsqrtAA * Y0 * T + repmat(muX, n, 1);
    end
    if nargout > 2
        if my < m
            T = T(1:my,:);
        end
        b = trsqrtAA * normX / normY;
        transform = struct('T',T, 'b',b, 'c',repmat(muX - b*muY*T, n, 1));
    end

% the degenerate cases: X all the same, and Y all the same
elseif constX
    d = 0;
    Z = repmat(muX, n, 1);
    T = eye(my,m);
    transform = struct('T',T, 'b',0, 'c',Z);
else % ~constX & constY
    d = 1;
    Z = repmat(muX, n, 1);
    T = eye(my,m);
    transform = struct('T',T, 'b',0, 'c',Z);
end
%}