function [km_ROI, klean_ROI] = coeffROI_extraction(thickness_ROI,klean_vect, km_vect, h_vect)
      sz = size(thickness_ROI);
      index = find(thickness_ROI ~= 0);
      klean_ROI = zeros(sz);
      km_ROI = zeros(sz);
      for i = index
         h_index = max(find(h_vect < thickness_ROI(i)));
         if  h_index == length(h_vect)
             h_index = h_index -1;
         end

         prop_h = (thickness_ROI(i) - h_vect(h_index)) ./ (h_vect(h_index+1)-h_vect(h_index));
         klean_ROI(i) = klean_vect(h_index) + prop_h* (klean_vect(h_index+1)-klean_vect(h_index));
         km_ROI(i) = km_vect(h_index) + prop_h* (km_vect(h_index+1)-km_vect(h_index));
      end