% function  BD=BlockComputeBDDXA()

Image.material=imread('try.png');

            %% save the blocks for BD and T:
             maxBD=double(max(max(Image.material(400:1900,20:1500))));
            blockBD=double(Image.material);
            blockBD = flipdim(max(blockBD,0),1);
            blockBD = flipdim(blockBD,2); % double flip to get the right orientation
            blockBD = uint16(blockBD);
%             blockBD = uint16(blockBD*65535/100);
            filename=sprintf('sheet1.tif',k,i,j);
            filename=[ 'Y:\Breast Studies\Tlsty_P01_data\p148al1_TT002R\try\' filename];
            imwrite(blockBD,filename,'tif');

      