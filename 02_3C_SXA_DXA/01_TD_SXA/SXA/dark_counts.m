function dark_counts()
 global fname
  Result.image=double(imread(fname));
  ReinitImage(Result.image,'OPTIMIZEHIST');