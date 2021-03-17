function addUCSFdatabase_batch( first, last ) %last were 165-180
for i = first:last
  if i ~= 70 
   add3C_UCSFDigiImages([i i]);
  else
      ;
  end
end

