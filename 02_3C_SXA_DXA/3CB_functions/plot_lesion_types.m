function plot_lesion_types()
 filename = '\\researchstg\aaData\Breast Studies\3C_data\RO1_3Cimages\UCSF\Results\Auto_3C_analysis_runs\Run2\RESULTS\run2_total_cut.xlsx'; 
 k= 10;
 findings = xlsread(filename);
 findings_inv = findings(findings(:,1)==1,:);
 findings_DCIS = findings(findings(:,1)==2,:);
 findings_FA = findings(findings(:,1)==3,:);
 findings_benign = findings(findings(:,1)==5,:);
 figure;plot(findings_inv(:,2),findings_inv(:,k),'r*'); hold on;
 plot(findings_DCIS(:,2),findings_DCIS(:,k),'b*'); hold on;
 plot(findings_FA(:,2),findings_FA(:,k),'g*'); hold on;
 plot(findings_benign(:,2),findings_benign(:,k),'y*'); grid on;
 a = 1;
 

end

