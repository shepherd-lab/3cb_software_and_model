function output = merit(Phantom,xf,yf)
output=0; 
for index=1:size(Phantom,2)
    output=output+(Phantom(index).mx-xf(index))^2+(Phantom(index).my-yf(index))^2;
end

output;