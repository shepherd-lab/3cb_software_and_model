function addUCSFdatabase_batch( first, last ) %last were 165-180
for i = first:last
 % if i ~= 70   %commented out to include patient in DB sypks 2018-01-07
                %unknown why patient 70 was excluded to begin with...
   add3C_UCSFDigiImages([i i]);
 % else
      ;
 % end
end


