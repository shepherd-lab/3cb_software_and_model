function [km, klean] = coeff_extraction(thickness,klean_vect, km_vect, h_vect)
     
    
         h_index = max(find(h_vect < thickness));
         if isempty(h_index)
             h_index = 1;
         end
         if  h_index == length(h_vect)
             h_index = h_index -1;
         end

         prop_h = (thickness - h_vect(h_index)) ./ (h_vect(h_index+1)-h_vect(h_index));
         klean = klean_vect(h_index) + prop_h* (klean_vect(h_index+1)-klean_vect(h_index));
         km = km_vect(h_index) + prop_h* (km_vect(h_index+1)-km_vect(h_index));
    