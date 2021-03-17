function test_writefile()  
                    init = 69500;
                    acqs = (init+1:1:init+400);
                                
                    fid = fopen('P:\Temp\good films\list_me.txt','w+');
                    fprintf(fid,'%u \n',acqs);
                    fclose(fid);
                    acquisitionkeyList=textread('P:\Temp\good films\list_me.txt','%u');
                    a = acquisitionkeyList(1)