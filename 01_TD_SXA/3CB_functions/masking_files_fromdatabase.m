function sxa_acq_extraction()
  global database fname Info Image BreastMask ROI
    Database.Name = 'mammo_CPMC';
    [FileName,PathName] = uigetfile('\\researchstg\aaData\Breast Studies\Masking\txt_excels\*.txt','Select the acquisition list txt-file ');
    acqs_filename = [PathName,FileName];     %'\'
    FileName_list =  FileName;
    acqs_filename = [PathName,'\',FileName];
    ACQIDList = textread(acqs_filename,'%u');
    sz1 = size(ACQIDList);
    len = sz1(1);
%     dir_towrite = '\\researchstg\aaData\Breast Studies\Masking\PrelimAnalysis\Interval\';
    dir_towrite = [uigetdir('\\researchstg\aaData\Breast Studies\Masking\PrelimAnalysis\'),'\'];
    key = 0;
     count = 0;
     count2=0;
    for index=1:len
          try
           
    Info.AcquisitionKey = ACQIDList(index) 
%     Info.AcquisitionKey =  1000500227;
% %       SQLStatement = ['SELECT *  FROM [mammo_CPMC].[dbo].[DICOMinfo], [mammo_CPMC].[dbo].[acquisition]  where DICOMinfo.DICOM_ID = acquisition.DICOM_ID and acquisition_id = ',num2str(ACQIDList(index))];    
% %        a1=mxDatabase(Database.Name,SQLStatement)
%       mag_factor = cell2mat(a1(57));

     key = Info.AcquisitionKey
    
    RetrieveInDatabase('ACQUISITION');   
    [pathstr,name,ext] = fileparts(fname);
    filename = [name,ext];
    %%%%%%%%%%%%%% conversion %%%%%%%%%%%%%%%
     h1 = findobj('tag','hInit')
         if ~isempty(h1)
             for k = 1:length(h1)
                 delete(h1(k));
             end
         end
        
        h2 = findobj('tag','h_slope')
         if ~isempty(h2)
             for n = 1:length(h2)
                 delete(h2(n));
             end
         end
    %%%%%%%%%%%%%%% end %%%%%%%%%%%%%%%%%%%%%
 
         
    copyfile(fname,dir_towrite);  
    fname_old = [dir_towrite,name,ext];
    fname_new = [dir_towrite,num2str(key),ext];
    copyfile([fname(1:end-7),'.mat'],dir_towrite);
    movefile( fname_old, fname_new);
    fname_oldm = [dir_towrite,name(1:end-3),'.mat'];
    fname_newm = [dir_towrite,num2str(key),'.mat'];
    movefile( fname_oldm, fname_newm);
    load(fname_newm);
    info_dicom_blinded.AccessionNumber = key;
%     save(fname_newm);
     save(fname_newm,'info_dicom_blinded');
    
      
    count = count + 1
        catch
           key = [key; Info.AcquisitionKey];
           count2 = count2 + 1
        end
    end
    a= 1;
    
   
    
    
    
