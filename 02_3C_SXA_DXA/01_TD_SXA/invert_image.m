function ima_out = invert_image(ima)
  
   % Create new figure
  figure(1)
  % Display ima
  imagesc(ima);
  axis image;
  colormap(gray);
  % Rescales ima between [0, 255]
  mini = min(min(ima));
  maxi = max(max(ima));
  ima_out = (ima-mini)/(maxi-mini)*8192;
  % Invert ima_out
  ima_out = 8192-ima_out;
  % Display result
  % Create new figure
  figure(2)
  imagesc(ima_out);
  axis image;
  colormap(gray);
  
