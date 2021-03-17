function sxa_acq_extraction()
  global database fname Info BreastMask ROI
    Database.Name = 'mammo_CPMC';
    [FileName,PathName] = uigetfile('\\researchstg\aaData\Breast Studies\Masking\txt_excels\*.txt','Select the acquisition list txt-file ');
    acqs_filename = [PathName,FileName];     %'\'
    FileName_list =  FileName;
    acqs_filename = [PathName,'\',FileName];
    ACQIDList = textread(acqs_filename,'%u');
    sz1 = size(ACQIDList);
    len = sz1(1);
    dir_towrite = '\\researchstg\aaData\Breast Studies\Masking\Masking_diag_last\CPMC\';
    dir_towrite_pres = '\\researchstg\aaData\Breast Studies\Masking\Masking_diag_last\CPMC\Presentation';
     key = 0;
     count = 0;
     count2=0;
    for index=1:len
          try
           
    Info.AcquisitionKey = ACQIDList(index) 
       SQLStatement = ['SELECT *  FROM [mammo_CPMC].[dbo].[DICOMinfo], [mammo_CPMC].[dbo].[acquisition]  where DICOMinfo.DICOM_ID = acquisition.DICOM_ID and acquisition_id = ',num2str(ACQIDList(index))];    
       a1=mxDatabase(Database.Name,SQLStatement)
      mag_factor = cell2mat(a1(57));
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
        if  ~(~isempty(strfind(lower(filename),'39kv')) | ~isempty(strfind(filename,'water')) | ~isempty(strfind(filename,'lipid')) | ~isempty(strfind(filename,'protein')) | ~isempty(strfind(filename,'CP'))) & ~isempty(strfind(filename,'png'))
            full_filename = [pathstr,'\',filename];
%             funcOpenImage(full_filename,1);
%             PhantomDetection;
            if mag_factor == 1
            ROIDetection('ROOT');
            SkinDetection('FROMGUI');
         else
             sz = size(Image.image);
             BreastMask = ones(sz);
             ROI.ymin = 0;
             ROI.xmin = 0;
           
         end

%             Periphery_calculation; 
            tophatFiltered = TOPHAT();
            image_pres = deflip_image(tophatFiltered);
            pres_filename = [pathstr,'\',name,'_pres',ext]; 
            imwrite(uint16(image_pres),pres_filename,'PNG');
%             copyfile(pres_filename,annot_masing_dir);
            a = 1;
        end
    %%%%%%%%%%%%%%% end %%%%%%%%%%%%%%%%%%%%%
    
    [pathstr,name,ext] = fileparts(fname); 
   if Info.ViewId  == 2
         view_str = 'RCC';
    elseif Info.ViewId  == 3
         view_str = 'LCC';
    elseif Info.ViewId  == 4
         view_str = 'RML0';
    elseif Info.ViewId  == 5
         view_str = 'LMLO';
    end
         
    copyfile(fname,dir_towrite);  
    fname_old = [dir_towrite,name,ext];
    fname_new = [dir_towrite,strtrim(Info.patient_id),'_',strtrim(Info.date_acq),view_str,ext];
    copyfile([fname(1:end-7),'.mat'],dir_towrite);
    movefile( fname_old, fname_new);
    fname_oldm = [dir_towrite,name(1:end-3),'.mat'];
    fname_newm = [dir_towrite,strtrim(Info.patient_id),'_',strtrim(Info.date_acq),view_str,'.mat'];
    movefile( fname_oldm, fname_newm);
    load(fname_newm);
    info_dicom_blinded.AccessionNumber = key;
    save(fname_newm);
    
    [pathstr,name,ext] = fileparts(pres_filename); 
    copyfile(pres_filename,dir_towrite_pres);  
    fname_old = [dir_towrite_pres,'\',name,ext];
    fname_new = [dir_towrite_pres,'\',strtrim(Info.patient_id),'_',strtrim(Info.date_acq),view_str,'_pres',ext];
    copyfile([pres_filename(1:end-12),'.mat'],dir_towrite_pres);
    movefile( fname_old, fname_new);
    fname_oldm = [dir_towrite_pres,'\',name(1:end-8),'.mat'];
    fname_newm = [dir_towrite_pres,'\',strtrim(Info.patient_id),'_',strtrim(Info.date_acq),view_str,'_pres','.mat'];
    movefile( fname_oldm, fname_newm);
    load(fname_newm);
    info_dicom_blinded.AccessionNumber = key;
    save(fname_newm);
    
    count = count + 1
        catch
           key = [key; Info.AcquisitionKey];
           count2 = count2 + 1
        end
    a =1
    end
    a = 1;
    
    
    
    
