function xt_corr = nipple_removing(xt,yt)
            
%             figure;plot(xt,yt,'b-'); grid on;
            maxt = max(xt);
            ymax_index = find(xt==maxt);
            yc = yt(ymax_index);
            
            range_index = find(yt<yc+70 & yt>yc-70);
            minr = min(range_index);
            maxr = max(range_index);
            if minr<51
                minr=minr+50;
            end
            % bad work of nipple removal 
% % %             if maxr>(size(range_index)-50)
% % %                 maxr=maxr-50;
% % %             end
            % replaced by 
            if maxr>(size(yt)-50)
                maxr=maxr-50;
            end

            %FD 1/12/2012 Added to eliminate possible crash related to
            %indexing error
            yfit = yt([minr-50:minr,maxr:maxr+50]);
            xfit = xt([minr-50:minr,maxr:maxr+50]);
            yfit_all = yt(minr-50:maxr+50); 
            xfit_all = xt(minr-50:maxr+50); 
           
            results = polyfit(yfit, xfit,4);
            a1 = results(1);
            a2 = results(2);
            a3 = results(3);
            a4 = results(4);
            a5 = results(5);
                        
            xfitdata = a1*yfit_all.^4 + a2*yfit_all.^3 + a3*yfit_all.^2 + a4*yfit_all + a5;
            xfit_all = xt(minr-50:maxr+50); 
            xt(minr-10:maxr+10) = xfitdata(41:end-40); 
            xt_corr = xt(minr-50:maxr+50); 
           
%            figure; plot(yfit_all,xfit_all,'bo',yfit_all, xfitdata,'r-', yfit, xfit, 'r*');
            %figure; plot(yfit_all,xfit_all,'b-',yfit_all, xt_corr,'r-');
          
            xt_corr = xt';
           %  figure;
           % plot(yfit,xfit, yfit_init(range_small), fitdata);
           % figure;plot(xt', Outline.y,'-r');hold on;