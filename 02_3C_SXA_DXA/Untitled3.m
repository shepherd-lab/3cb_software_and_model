uhcc21 = load('O:\SRL\aaStudies\Breast Studies\3CB R01\Analysis Code\Matlab\temporary_UCSF\comparison\UHCC\Thickness\21_LECCraw_Mat_v8.1.mat');
uhcc22 = load('O:\SRL\aaStudies\Breast Studies\3CB R01\Analysis Code\Matlab\temporary_UCSF\comparison\UHCC\Thickness\22_LECCraw_Mat_v8.1.mat');
uhcc23 = load('O:\SRL\aaStudies\Breast Studies\3CB R01\Analysis Code\Matlab\temporary_UCSF\comparison\UHCC\Thickness\23_LECCraw_Mat_v8.1.mat');
uhcc24 = load('O:\SRL\aaStudies\Breast Studies\3CB R01\Analysis Code\Matlab\temporary_UCSF\comparison\UHCC\Thickness\24_LECCraw_Mat_v8.1.mat');
uhcc25 = load('O:\SRL\aaStudies\Breast Studies\3CB R01\Analysis Code\Matlab\temporary_UCSF\comparison\UHCC\Thickness\25_LECCraw_Mat_v8.1.mat');
%%

    figure(1);
    imagesc(uhcc25.thickness_map,[0,8000]);
    title('uhcc thickness map patient: 25')
    colormap(gray)
    colorbar

    