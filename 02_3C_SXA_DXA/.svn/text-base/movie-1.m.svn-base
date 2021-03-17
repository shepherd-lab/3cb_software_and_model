fig=figure;
set(fig,'DoubleBuffer','on');
haxes = axes;
set(haxes,'xlim',[-80 80],'ylim',[-80 80],...
       'NextPlot','replace','Visible','off')
%mov = avifile('mov_avi1')
%mov = avifile('mov_avi9')
% colorbar(haxes);

x = -pi:.2:pi;
radius = 0:length(x);
for k=1:length(x)
    colorbar('East');
    h = patch(sin(x)*radius(k),cos(x)*radius(k),...
                 [abs(cos(x(k))) 0 0]);
    set(h,'EraseMode','xor');
    F(k) = getframe(gca);
    title(gca,'test');
    %mov = addframe(mov,F);
end
title('test');
movie2avi(F,'mov_avi13','fps',5,'quality',100);
%mov = close(mov);
%movie2avi(mov,mov_avi3,'fps',value,'quality',50);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%movie2avi(mov,mov_avi1,'fps',value,'quality',50);
%{
Z = peaks; surf(Z); 
axis tight
set(gca,'nextplot','replacechildren');
% Record the movie
for j = 1:20 
    surf(sin(2*pi*j/20)*Z,Z)
    F(j) = getframe;
end
% Play the movie twenty times
movie(F,20) 
%}