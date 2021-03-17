function table2excell(trainingFeatures,labels, xlsx_file, num)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
for i=1:num
    var_names{1,i} = ['ft_',num2str(i)];
end  
% var_names{1,num+1} = 'fracture_label'; 
ft = trainingFeatures';
T = array2table(ft);
T.Fracture_labels = labels; 
% T.Properties.VariableNames = var_names;
    writetable(T,xlsx_file)

end

