function test_FilmResponse2()
  
     Im = [ 7000, 10000, 15000, 20000, 25000, 30000, 35000, 40000, 45000, 50000, 55000, 60000];
    Im =  [5629 5807 6231 7229 9513 14412 23462 36162 48207 55952 59739 ...
                    61340 61975 62221 ];
     % Im = 1.0e+004 * Im      
      
      Correction.coef(1)=62372;
      Correction.coef(2)= 14.922;
      Correction.coef(3)= 5.1665;
      Correction.coef(4)=0.90103;
      Correction.coef(5)=5500;
     ValidityBegining1=Correction.coef(5)+500;
     ValidityEnding1=Correction.coef(1)-500;
     X1=1:65536;
     %xlin = X;
     X1(1:ValidityBegining1)=ValidityBegining1;X1(ValidityEnding1:end)=ValidityEnding1;
         
    %figure;
     %plot(xlin, X);
     Y1=Correction.coef(2)+Correction.coef(3)*log(((X1-Correction.coef(1))./(Correction.coef(5)-Correction.coef(1))).^(-1/Correction.coef(4))-1);
     [maxi_1,i0_1]=max(diff(X1)./diff(Y1))   %compute the slope of the linear part
     CorrectedIm1=(Y1(Im+1)-Y1(i0_1))*maxi_1  + X1(i0_1);  
    
      Correction.coef(3) = 2.81;
     Y3=Correction.coef(2)+Correction.coef(3)*log(((X1-Correction.coef(1))./(Correction.coef(5)-Correction.coef(1))).^(-1/Correction.coef(4))-1);
     [maxi_3,i0_3]=max(diff(X1)./diff(Y3))   %compute the slope of the linear part
     CorrectedIm3=(Y1(Im+1)-Y1(i0_3))*maxi_3  + X1(i0_1);  
      %   xf = -20:5:60;
    % Yf = Correction.coef(5) + (Correction.coef(1) - Correction.coef(5)) ./ (1 + exp( (-xf + Correction.coef(2)) ./ Correction.coef(3))).^Correction.coef(4);
    % yf = Yf'
     
     
     
            Correction.coef(1)=61622;
            Correction.coef(2)=18.84;
            Correction.coef(3)=2.8145;
            Correction.coef(4)=0.34672;
            Correction.coef(5)=10000;
            ValidityBegining2=Correction.coef(5)+500;
            ValidityEnding2=Correction.coef(1)-500;
            X2=1:65536;
     %xlin = X;
     X2(1:ValidityBegining2)=ValidityBegining2;X2(ValidityEnding2:end)=ValidityEnding2;
            
      Y2=Correction.coef(2)+Correction.coef(3)*log(((X2-Correction.coef(1))./(Correction.coef(5)-Correction.coef(1))).^(-1/Correction.coef(4))-1);
     [maxi_2,i0_2]=max(diff(X2)./diff(Y2))   %compute the slope of the linear part
     CorrectedIm2=(Y2(Im+1)-Y2(i0_2))*maxi_2  + X2(i0_2);  
     
     Implot = [Im' CorrectedIm1' CorrectedIm2']
     xim = (1:length(Im)) * 1;
     figure;
     plot( xim, CorrectedIm1, '-bo', xim, CorrectedIm2, '-g*',xim, CorrectedIm3, '-r*'); %xim,Im,'-rd',
     grid on;
     legend('init_image',  'CPMC_image','Parnas_image');
     
     
     
   