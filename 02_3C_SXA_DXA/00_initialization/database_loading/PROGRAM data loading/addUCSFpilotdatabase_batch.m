function addUCSFpilotdatabase_batch( first, last ) %last were 165-180
for i = first:last
  if i ~= 70 
   add3C_UCSFpilotDigiImages([i i]);
  else
      ;
  end
end


