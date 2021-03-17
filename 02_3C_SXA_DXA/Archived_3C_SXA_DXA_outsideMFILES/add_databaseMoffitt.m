function add_databaseUCSF(limits )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

for i = limits(1):limits(2)
    add3C_MoffittDigiImages([i i])  
end

