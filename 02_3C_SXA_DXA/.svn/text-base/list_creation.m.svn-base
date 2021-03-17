function [cc, mlo] = list_creation()
    clean_list = load('P:\Temp\good films\clean_list.txt');
    ln = size(clean_list(:,1))
    len = ln/4;
    cc = zeros(2 * len,1);
    mlo = zeros(2 * len,1);
    for i = 0:len-1
            cc(2*i+1) = clean_list(4*i+1); 
            cc(2*i+2) = clean_list(4*i+2); 
            mlo(2*i+1) = clean_list(4*i+3); 
            mlo(2*i+2) = clean_list(4*i+4); 
    end
    