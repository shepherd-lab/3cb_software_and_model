%hour
function result=hour;

time=clock;
result=sprintf('%d-%d-%d %dh%dmin',time(2),time(3),time(1),time(4),time(5));