function test_FilmResponse()
  
     Im = [ 7000, 10000, 15000, 20000, 25000, 30000, 35000, 40000, 45000, 50000, 55000, 60000];
    Im =  [5629 5807 6231 7229 9513 14412 23462 36162 48207 55952 59739 ...
                    61340 61975 62221 ];
     % Im = 1.0e+004 * Im      
      
      Correction.coef(1)=62372;
      Correction.coef(2)= 14.922;
      Correction.coef(3)= 5.1665;
      Correction.coef(4)=0.90103;
      Correction.coef(5)=5500;
     ValidityBegining=Correction.coef(5)+500;
     ValidityEnding=Correction.coef(1)-500;
     X=1:65536;
     %xlin = X;
     X(1:ValidityBegining)=ValidityBegining;X(ValidityEnding:end)=ValidityEnding;
    %figure;
     %plot(xlin, X);
     Y1=Correction.coef(2)+Correction.coef(3)*log(((X-Correction.coef(1))./(Correction.coef(5)-Correction.coef(1))).^(-1/Correction.coef(4))-1);
     [maxi_1,i0_1]=max(diff(X)./diff(Y1))   %compute the slope of the linear part
     CorrectedIm1=(Y1(Im+1)-Y1(i0_1))*maxi_1  + X(i0_1);  
          
     xX = X(i0_1)
     xm = maxi_1
     yY1 = Y1(i0_1-10000)
     mY1= max(max(Y1))
     %+1 is to prevent the have the zeros  
    % figure;
     %plot(X, Y1);
     %Correction.coef(3) = 3;
     CorrectedIm2=(Y1(Im+1)-Y1(i0_1+10000))*maxi_1 * 0.6 + X(i0_1); 
    % Y2=Correction.coef(2)+Correction.coef(3)*log(((X-Correction.coef(1))./(Correction.coef(5)-Correction.coef(1))).^(-1/Correction.coef(4))-1);
    % figure;
    % plot(X, Y2, X, Y1);
     %[maxi_2,i0_2]=max(diff(X)./diff(Y2))   %compute the slope of the linear part
     %CorrectedIm2=(Y2(Im+1)-Y2(i0_2))*maxi_2 + X(i0_2);  
     
     Implot = [Im' CorrectedIm1' CorrectedIm2']
     xim = (1:length(Im)) * 1;
     figure;
     plot(xim,Im,'-rd', xim, CorrectedIm1, '-bo', xim, CorrectedIm2, '-g*');
     grid on;
     
     Correction.coef(3) = 5.1665;
       xf = -20:5:60;
     Yf = Correction.coef(5) + (Correction.coef(1) - Correction.coef(5)) ./ (1 + exp( (-xf + Correction.coef(2)) ./ Correction.coef(3))).^Correction.coef(4);
     yf = Yf'
   %  figure;
   %  plot(xf, Yf);