function output = percent_fat()
    Rprot = 1.2906;
    Rwater = 1.3572;
    Rfat = 1.22;
    Rlean = 1.3392;%1.3618;
    
    percent_water = 0:0.05:1;
    percent_fat = 0:0.01:1;
    %percent_water = 0;
    count = 0;
    figure; grid on; hold on;
    for percent_fat = 0.0:0.1:1.0
        %for percent_water = 0:0.01:1
            count = count + 1;
            rst = percent_fat*Rfat + (1-percent_fat)*(1-percent_water)*Rprot + (1-percent_fat)*percent_water*Rwater;
            percent_fatDXA = (rst - Rlean)/(Rfat-Rlean);
            error(count,:) = (percent_fatDXA - percent_fat)*100;
            %plot(percent_water, error);hold on; %, '-*'
            a = 1;
        %end
    end
    plot(percent_water, error);
    legend('fat=0','fat=0.1', 'fat=0.2', 'fat=0.3', 'fat=0.4', 'fat=0.5', 'fat=0.6', 'fat=0.7', 'fat=0.8', 'fat=0.9','fat=1');
    a = 1;
    
