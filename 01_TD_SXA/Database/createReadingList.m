function [local_list,unanalyzed_acqs_path,unanalyzed_acqs_filename] = createReadingList(RequestedAction)

global Database Info

 [ret, comp_name] = system('hostname');
 if strcmp(comp_name(1:4),'Ming')
                        %start_dir = 'D:\aaDATA\Breast Studies\CPMC';
                        root_folder= 'D:\Working_Directory\Projects-Snap\aaSTUDIES\Breast Studies\BCSC\Analysis Code\Matlab\auto SQL\';
                        
                    else
                        root_folder= '\\ming\Working_Directory\Projects-Snap\aaSTUDIES\Breast Studies\BCSC\Analysis Code\Matlab\auto SQL\';
                    end
%root_folder='U:\jwang\My Documents\misc\auto SQL\';
if Info.Analysistype == 5
    bcp_fname32 = [root_folder,'bcp SQL querySXA.bat'];
    bcp_fname64 = [root_folder,'bcp SQL querySXA 64bit.bat'];
    dos_restart = [root_folder,'restartSXA.bat'];
elseif  Info.Analysistype == 12
    bcp_fname32 = [root_folder,'bcp SQL queryPC.bat'];
    bcp_fname64 = [root_folder,'bcp SQL queryPC 64bit.bat'];
    dos_restart = [root_folder,'restartPC.bat'];
else
    bcp_fname32 = [root_folder,'bcp SQL query.bat'];
    bcp_fname64 = [root_folder,'bcp SQL query 64bit.bat'];
    dos_restart = [root_folder,'restart.bat'];
end


bcp_fname32 = [root_folder,'bcp SQL query.bat'];
bcp_fname64 = [root_folder,'bcp SQL query 64bit.bat'];
dos_restart = [root_folder,'restart.bat'];
unanalyzed_acqs_path=root_folder;
str=computer;

switch RequestedAction
    case 'open'
        try
            %find out number of open sessions currently running auto SXA analysis
            SQLstatement = ['SELECT n from bot_open_sessions where now=1'];
            open_sessions = mxDatabase(Database.Name, SQLstatement);
            open_sessions = open_sessions{1};
            %             open_sessions=textread([root_folder,'open_sessions.txt']); 
            open_sessions=open_sessions+1;

            %check number of sessions to run, if over, close session
            SQLstatement = ['SELECT n from bot_sessions_to_run where now=1'];
            num_of_sessions_to_run = mxDatabase(Database.Name, SQLstatement);
            num_of_sessions_to_run = num_of_sessions_to_run{1};
            %             num_of_sessions_to_run=textread([root_folder,'num_of_sessions_to_run.txt']);
            if open_sessions > num_of_sessions_to_run
                exit;
            end

            %update open sessions file with one additional session
            SQLstatement = ['update bot_open_sessions set n=',num2str(open_sessions), ' where now=1'];
            mxDatabase(Database.Name, SQLstatement);
            %             open_sessions_file=fopen([root_folder,'open_sessions.txt'],'w');
            %             fprintf(open_sessions_file,num2str(open_sessions));
            %             fclose(open_sessions_file);

            %pull list of unanalyzed acquisitions (output from daily bcp query)
            unanalyzed_acqs_filename='unanalyzed_acqs.txt';
            unanalyzed_acqs_file=[root_folder,'unanalyzed_acqs.txt'];
            unanalyzed_acqs=textread(unanalyzed_acqs_file);
            len=length(unanalyzed_acqs);

            %create local acq_list to analyze
            local_list_len=floor(len/num_of_sessions_to_run);
            if open_sessions==1
                local_list=unanalyzed_acqs(1:local_list_len);
            else
                local_list=unanalyzed_acqs(((open_sessions-1)*local_list_len)+1:(open_sessions*local_list_len));
            end
        catch
            SQLstatement = ['update bot_open_sessions set n=0 where now=1'];
            mxDatabase(Database.Name, SQLstatement);
%             dos 'U:\jwang\My Documents\misc\auto SQL\zero sessions file.bat';
            if strcmp(str,'PCWIN64')
               dos(bcp_fname64);
              % dos 'U:\jwang\My Documents\misc\auto SQL\bcp SQL query 64bit.bat';
            else
                dos(bcp_fname32);
                %dos 'U:\jwang\My Documents\misc\auto SQL\bcp SQL query.bat';
            end
            pause(300);
            %dos 'U:\jwang\My Documents\misc\auto SQL\restart.bat';
            dos(dos_restart);
            exit;
        end

    case 'close'
        try
            %update open sessions file with one session closing
            SQLstatement = ['SELECT n from bot_open_sessions where now=1'];
            open_sessions = mxDatabase(Database.Name, SQLstatement);
            open_sessions = open_sessions{1};
            %             open_sessions=textread([root_folder,'open_sessions.txt']);
            open_sessions=num2str(open_sessions-1);
            SQLstatement = ['update bot_open_sessions set n=',num2str(open_sessions), ' where now=1'];
            mxDatabase(Database.Name, SQLstatement);
            %             open_sessions_file=fopen([root_folder,'open_sessions.txt'],'w');
            %             fprintf(open_sessions_file,num2str(open_sessions));
            %             fclose(open_sessions_file);
        catch
            SQLstatement = ['update bot_open_sessions set n=0 where now=1'];
            mxDatabase(Database.Name, SQLstatement);
            %             dos 'U:\jwang\My Documents\misc\auto SQL\zero sessions file.bat';
            if strcmp(str,'PCWIN64')
               % dos 'U:\jwang\My Documents\misc\auto SQL\bcp SQL query 64bit.bat';
               dos(bcp_fname64); 
            else
                %dos 'U:\jwang\My Documents\misc\auto SQL\bcp SQL query.bat';
                dos(bcp_fname32);
            end
            pause(300);
            dos(dos_restart);
            %dos 'U:\jwang\My Documents\misc\auto SQL\restart.bat';
            exit;
        end
end