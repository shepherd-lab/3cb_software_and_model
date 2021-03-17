%AutomaticSXAAnalysis
%Do the SXA analysis Sequence
%Lionel HERVE
%6-17-04

function AutomaticSXAAnalysis()
global ctrl Image Error ReportText AutomaticAnalysis Database Info Recognition Correction Analysis QA Threshold Site ROI 

global flag%tic

flag.Selenia_image = true;
%acquisitionkeyList=textread('P:\Temp\good films\z2_new9.txt','%u'); 
acquisitionkeyList=textread('P:\Temp\good films\z2_test.txt','%u'); 
len = length(acquisitionkeyList)

%count = 0;

 SQLstatement=['delete from qa_code_results WHERE acquisition_id = ',num2str(Info.AcquisitionKey), ' AND QA_Code >= ''45''  AND QA_Code <= ''46'''];
 mxDatabase(Database.Name,SQLstatement);

for i = 1:len
     Info.AcquisitionKey = acquisitionkeyList(i);
      Analysis.Step = 0;
     RetrieveInDatabase('ACQUISITION');
   
    AutomaticAnalysis.Step=0;
    %{
    if size(Image.OriginalImage,1)>1800   %detect small / big paddle
        top=DetectImageEdge(Image.OriginalImage,'TOP');
        imagemenu('CutTopWithParam',top);
        bottom=DetectImageEdge(Image.OriginalImage,'BOTTOM');
        imagemenu('CutBottomWithParam',bottom);
        right=DetectImageEdge(Image.OriginalImage,'RIGHT');
        imagemenu('CutRightWithParam',right);
        left=DetectImageEdge(Image.OriginalImage,'LEFT');
        imagemenu('CutLeftWithParam',left);
        Error.BIGPADDLE=true;
    end
        %set(ctrl.Cor,'value',true);
        imagemenu('AutomaticCrop');
     %}
    %{
    if Info.ViewId==2
        imagemenu('flipV');
    elseif Info.ViewId==3
        imagemenu('flipH');
    elseif Info.ViewId==4
        imagemenu('flipV');
    elseif Info.ViewId==5
        imagemenu('flipH');
    end
     %}
  %% phantom detection
    AutomaticAnalysis.Step=2;
    database_name = 'mammo_CPMC';
       
    type = phantom_typedigital; %(Image.OriginalImage)
    a = 1;
    
   %delete qa=45 and qa=46 from database
   SQLstatement=['delete from qa_code_results WHERE acquisition_id = ',num2str(Info.AcquisitionKey), ' AND QA_Code >= ''45''  AND QA_Code <= ''46'''];
   mxDatabase(Database.Name,SQLstatement);
  
     
    if strcmp(type, 'NO') 
      QAcodeNumber = 45; 
      addoneqacode_inDatabase(database_name,QAcodeNumber, Info.AcquisitionKey);
    elseif strcmp(type, 'BAD')
      QAcodeNumber = 46;     
      addoneqacode_inDatabase(database_name,QAcodeNumber, Info.AcquisitionKey); 
      QAcodeNumber = 45;
      addoneqacode_inDatabase(database_name,QAcodeNumber, Info.AcquisitionKey)
    end
   %}
end   
  