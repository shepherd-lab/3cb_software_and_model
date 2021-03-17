function test_file()
      
      ab = [ 1 0 1 3 ];
      %fid = fopen(['P:\Temp\ThresholdAnalysis\thresholdanalysis',num2str(1000),'.txt'],'a+');
      
     % fwrite(fid,a,'real*8');  
      save(['P:\Temp\ThresholdAnalysis\thresholdanalysis',num2str(1000),'.txt'],'ab','-ascii', '-append');  
      %fclose(fid);