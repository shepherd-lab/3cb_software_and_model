function ellipse_testfit()
%minimize || f(a,x,y) ||_2
% a

%where f = (( x-a(1) ).^2)/a(2).^2 + (( y-a(3) ).^2)/a(4).^2 - 1 . 
%In other words, you are minimizing the sum of the squares of the residuals:

%min (sum ( f .* f ) )
% a

%a0 = [10 10 10 10];
%f = @(a) ((x-a(1)).^2)/a(2).^2 + ((y-a(3)).^2)/a(4).^2 -1;
%options = optimset('Display','iter');
%af = lsqnonlin(f, a0, [], [], options);

%Since you have variables in the denominator and numerator, 
%they can shrink and grow together and you could obtain very large or very small coefficients. 
%To avoid this, fix a(1) and a(2) (providing the center of the ellipse) to be the average of the data x and y.
%Then, vary the other two parameters:

t = (0:pi/20:1.5*pi)';
x = 5 + 4*cos(t) + rand(size(t));
y = 8 + 2*sin(t) + rand(size(t));

a0 = [10 10];
options = optimset('Display','iter');
c = [mean(x) mean(y)];
f = @(a) norm(((x-c(1)).^2)/a(1).^2 + ((y-c(2)).^2)/a(2).^2 -1);
af = fminsearch(f, a0, options);
%f = @(a) ((x-c(1)).^2)/a(1).^2 + ((y-c(2)).^2)/a(2).^2 -1;
%af = lsqnonlin(f, a0, [], [], options);
figure;
plot(x,y,'*'), hold on
plot(c(1), c(2), 'r*')
t=0:pi/10:2*pi;
plot(c(1) + af(1)*cos(t), c(2) + af(2)*sin(t), 'r');

%If you do not have the Optimization Toolbox, you can also use the FMINSEARCH function to solve this problem. 
%FMINSEARCH is not specialized like LSQNONLIN to handle the least squares problem, 
%but the objective function can be modified to account for this. 
%For FMINSEARCH, the sum of squares evaluation must be performed within the objective funtion.
%f = @(a) norm(((x-c(1)).^2)/a(1).^2 + ((y-c(2)).^2)/a(2).^2 -1);
%af = fminsearch(f, a0, options);
