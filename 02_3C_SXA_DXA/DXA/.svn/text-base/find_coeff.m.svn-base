function [y,feval] = find_coeff(x0, Data)         %rx0, ry0,rz0,tz0,
   %options = optimset('Display','iter','TolFun',1e-8)
   %options = optimset('Display', 'on'); % Turn off Display
    HE = Data(:,3)/1000;
    R =  Data(:,4); %R = LE/HE
    T =  Data(:,5); %T - total thickness in cm 
    tfat =  Data(:,1);
    twater = Data(:,2);
    
    %x = fminsearch(@(x) myfun(x,a),[0,1])
    
    [y,feval] = fminsearch(@fun_equation, x0); %, options
   % rx0 = x0(1);
   % ry0 = x0(2);
   % rz0 = x0(3);
   % tz0 = x0(4);
    
    function L0 = fun_equation(x)
        a = x(1:10);
        b = x(11:20);
        f1 = (a(1) + a(2)*HE  + a(3)*R + a(4)*T + a(5)*HE.^2 + a(6)*R.^2 + a(7)*T.^2)./(1 + a(8)*HE + a(9)*R + a(10)*T)-tfat;
        f2 = (b(1) + b(2)*HE  + b(3)*R + b(4)*T + b(5)*HE.^2 + b(6)*R.^2 + b(7)*T.^2)./(1 + b(8)*HE + b(9)*R + b(10)*T)-twater;
        L0 = trace(f1*f1') +  trace(f2*f2')
    end
   
 end