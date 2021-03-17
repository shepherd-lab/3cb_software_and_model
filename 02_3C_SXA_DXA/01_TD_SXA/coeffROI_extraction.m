function [km_ROI, klean_ROI] = coeffROI_extraction(thickness_ROI2,klean_vect, km_vect, h_vect)
      sz = size(thickness_ROI2);
      index = find(thickness_ROI2 ~= 0);
      thickness_ROI = reshape(thickness_ROI2,sz(1)*sz(2), 1);
      klean_ROI = zeros(sz);
      km_ROI = zeros(sz);
      for i = 1:length(index)    % index
         cur_thick =  thickness_ROI(index(i));
         h_index = max(find(h_vect < cur_thick));
         if  h_index == length(h_vect)
             h_index = h_index -1;
         end

         prop_h = (thickness_ROI(i) - h_vect(h_index)) ./ (h_vect(h_index+1)-h_vect(h_index));
         klean_vect(i) = klean_vect(h_index) + prop_h* (klean_vect(h_index+1)-klean_vect(h_index));
         km_vect(i) = km_vect(h_index) + prop_h* (km_vect(h_index+1)-km_vect(h_index));
      end
      km_ROI = reshape(km_vect, sz);
      klean_ROI = reshape(klean_vect, sz);
      
      