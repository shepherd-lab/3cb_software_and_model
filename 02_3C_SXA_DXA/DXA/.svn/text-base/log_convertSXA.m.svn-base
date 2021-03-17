function I = log_convertSXA(image,mAs, kVp)
global Result
  voltages = [24, 25, 26,27, 28, 29, 30, 31, 32, 33,34, 39];
 
  max_counts = [6315.074, 7588.739, 9074.182 ,10504.13, 12415.06, 14237.83, 16142.65, 18685.01, 17046.57, 18920.65, 20879.08,33974.3];%40868.8 33974.3 3276 2000
  mmax = max_counts(find(voltages == kVp)); %9074.182 for 26 kVp
 
  I = -log(image*100/(mmax*mAs))* 10000;
