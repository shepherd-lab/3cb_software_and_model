  function medianfilter()
      %init_data = load('kir_pstTAllprmdata4b.txt');
      [init_data, first_line] = read_file('kir_pstTAllparam4b.txt');      
      xdata = init_data(:,1);
     % ydata = init_data(:,14);
      %plot(xdata,ydata, 'ob');
      xl = length(xdata)
      Plen = length(init_data(2,2:end);
      yl = xl;            %length(ydata)
     ydata_filtered = zeros(yl - 4,1:Plen;
      
    for j = 1:Plen
    %    ydata = zeros(yl - 4,1);
      ydata =  init_data(:,j);
      for i = 3:xl-2
          data_current = ydata(i-2:i+2);
          data_sort = sort(data_current);
         % ydata1(i-2) = (data_sort(2) + data_sort(3) + data_sort(4))/3;
          ydata2(i-2) = data_sort(3);
      end
      
       for i = 3:xl-6
        %  data_current1 = ydata1(i-1:i+1);
          data_current2 = ydata2(i-2:i+2);
         % data_sort = sort(data_current);
         % ydata1(i-1) = (data_current1(1) + data_current1(2) + data_current1(3))/3;
          ydata2(i-1) = (data_current2(1) + data_current2(2) + data_current2(3) + ...
                          data_current2(4) + data_current2(5))/5;
      end
      ys = size(ydata_filtered)
      sd = size(ydata2)
      ydata_filtered(:,j) =  ydata2';
      figure;
      plot(xdata(3:xl-2),ydata_filtered(:,j),'-bo',xdata,init_data(:,j), '-or' );
  end  
      ydata_filtered = [ydata_filtered, xdata(3:xl-2)];
     write_file('kir_pstTAllparam4bFlt.txt',ydata_filtered,first_line);
  % figure;
     % plot(xdata(3:xl-2),ydata1,'-ro');
     % figure;
     % plot(xdata(3:xl-2),ydata_filtered(:,14),'-bo',xdata,init_data(:,14), 'or' );