function [y,feval] = findL0_BBs(Xph0_vect, Xim,xp,R0,tz,Xph_zcoord,s)         %rx0, ry0,rz0,tz0,
    %global num_bbs num_thickness
%options = optimset('Display','iter','TolFun',1e-8)
   %options = optimset('Display', 'on'); % Turn off Display
   [y,feval,exitflag,output] =  fminsearch(@projection, Xph0_vect,optimset('TolX',1e-3)) %, options
    %xp = [tx0, ty0,num_bbs,num_thickness]; fminsearch
        
    function L0 = projection(Xph0_vect) % Compute the polynomial.
         num_bbs = xp(3);
         num_thickness = xp(4);    
         tx0 = xp(1);
         ty0 = xp(2);
         
        % temp = Xph0_vect(2*num_bbs+4:end); 
        % Xph0_vect(2*num_bbs+4) = Xph_zcoord(1);
        % Xph0_vect(2*num_bbs+5:length(Xph0_vect)+1) =  temp;  
         
         temp = Xph0_vect(2*num_bbs+1:end); 
         Xph0_vect(2*num_bbs+1) = Xph_zcoord(1);
         Xph0_vect(2*num_bbs+2:length(Xph0_vect)+1) =  temp;
         
         temp = Xph0_vect(2*num_bbs+4:end); 
         Xph0_vect(2*num_bbs+4) = Xph_zcoord(2);
         Xph0_vect(2*num_bbs+5:length(Xph0_vect)+1) =  temp; 
         
         temp = Xph0_vect(2*num_bbs+9:end); 
         Xph0_vect(2*num_bbs+9) = Xph_zcoord(3);
               
         Xph2 = reshape(Xph0_vect(1:3*num_bbs), num_bbs,3);
         Xph =  repmat(Xph2, num_thickness, 1);
       for k = 1:num_thickness
          Xim_calc((k-1)*num_bbs+1:k*num_bbs,:) = bbProjector(Xph((k-1)*num_bbs+1:k*num_bbs,:),tx0,ty0,tz(k),R0,s); 
       end       
       Q = Xim(:,1:2) - Xim_calc(:,1:2);
       L0 = trace(Q*Q');  
    end
end
  

