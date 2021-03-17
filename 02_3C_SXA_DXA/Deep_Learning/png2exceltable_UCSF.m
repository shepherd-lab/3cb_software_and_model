function dream_python_pngcreationUCSF()
global Image Info

input_dir = '\\researchstg\aaData9\Breast_Studies\DREAM\Our_presentation_dicoms\UCSF_dream_png\trainingData_png';

 dcm_files = dir(input_dir);
 len = length(dcm_files);
 %results = zeros(2,len-2);
 results = cell(len-2,2);
 cancer = 0;
 for i = 3:len
    results{i-2,1} = dcm_files(i).name;
    results{i-2,2} = cancer;    
    a= 1;
 end
  Excel('INIT');
  Excel('TRANSFERT',results);
a = 1;
end