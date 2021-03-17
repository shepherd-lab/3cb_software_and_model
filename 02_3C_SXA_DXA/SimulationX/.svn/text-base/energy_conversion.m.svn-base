function mu_aver = energy_conversion(en, mu, source_en, source_int)

mu_energy = en;
spectr_energy = source_en;
mu = mu;
source_intens = source_int;
len = length(source_intens);
for i= 1:len
     h_index = max(find(mu_energy <= spectr_energy(i)));
     if  h_index == length(mu_energy)
         h_index = h_index -1;
     end
          
     prop_en = (spectr_energy(i) - mu_energy(h_index)) ./ (mu_energy(h_index+1)-mu_energy(h_index));
     mu_corr(i) = mu(h_index) + prop_en* (mu(h_index+1)-mu(h_index));
     %km = km_vect(h_index) + prop_h* (km_vect(h_index+1)-km_vect(h_index));

end    
%figure; plot(mu_energy,mu,'-','Color',[0 0.33 0.8]);hold on;
%plot(spectr_energy,mu_corr,'-b');
 %mu_aver = sum(mu_corr'.*spectr_energy)/sum(spectr_energy);
 mu_aver = sum(mu_corr'.*source_intens)/sum(source_intens)
 enrgy_aver = sum(spectr_energy.*source_intens)/sum(source_intens)
a = 1;
