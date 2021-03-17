function [fname,ReturnCode]=EnterTheRepositionFileDlg(fname,RequestedAction)
%Lionel HERVE
%1-14-04
global file RepositionDlg Database Info

if ~exist('RequestedAction')
    RequestedAction='ROOT';
end
ReturnCode=0;
switch RequestedAction
    case 'ROOT'
        RepositionDlg.fname=fname;
        background=[0.1 0.1 0.4];
        foreground=[1 1 1];
        RepositionDlg.figure=figure;
        buttony=0.6;heightbox=0.1;
        DVDName=cell2mat(mxDatabase(Database.Name,['select location from reposition where acquisition_id=',num2str(Info.AcquisitionKey)]));
        set(RepositionDlg.figure,'units','normalized','position',[0.2 0.4 0.6 0.2],'NumberTitle','off','name','Reposition file selector','deletefcn','','color',background);
        uicontrol('style','text','string',['Select Repository drive for ',DVDName],'units','normalized','position',[0,1-heightbox,1,heightbox],'background',[1 0.6 0]);
        set(RepositionDlg.figure,'MenuBar','None');
        RepositionDlg.text=uicontrol('style','text','string',file.RepositoryDrive,'units','normalized','position',[0.2,buttony,0.55,heightbox]);
        uicontrol('style','pushbutton','string','>>','units','normalized','position',[0.95,buttony,0.05,heightbox],'callback','global RepositionDlg;EnterTheRepositionFileDlg(RepositionDlg.fname,''DIRECTORYDLG'');');
        buttony=0.05;
        uicontrol('style','pushbutton','string','Cancel','units','normalized','position',[0.75,buttony,0.1,2*heightbox],'callback','global RepositionDlg; RepositionDlg.ContinueFlag=true;RepositionDlg.Button=2;');
        RepositionDlg.ContinueFlag=false;
        RepositionDlg.Button=0;
        
        while (1)
            while ~RepositionDlg.ContinueFlag
                pause(0.2)
            end
            if RepositionDlg.Button==2
                close(RepositionDlg.figure);
                return;
            end
            fname=[file.RepositoryDrive,'\',funcEndFileName(fname)];
            s=dir (fname);
            if size(s,1)
                close(RepositionDlg.figure);
                ReturnCode=1;
                return;
            end
            RepositionDlg.ContinueFlag
        end
    case 'DIRECTORYDLG'
        if file.RepositoryDrive == 0
            file.RepositoryDrive='''';
        end;
        file.RepositoryDrive=uigetdir(file.RepositoryDrive,'Select the path for the repository drive');
        set(RepositionDlg.text,'string',file.RepositoryDrive);
        RepositionDlg.ContinueFlag=true;
end