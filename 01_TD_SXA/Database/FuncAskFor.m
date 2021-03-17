% funcAskFor
% ask the questions for the entries
%author Lionel HERVE
%creation date 10-5-2003

function response=funcAskFor(msg,default_ans);
   % PROMPT FOR COL_OFFSET
    prompt = {msg};
    dlg_title = 'Question';
    num_lines = 1;
    response = inputdlg(prompt, dlg_title, num_lines, default_ans);
