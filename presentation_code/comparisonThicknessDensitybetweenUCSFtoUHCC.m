clear all 
close all
clc

%% load in images

%   UHCC path
uhcc = 'O:\SRL\aaStudies\Breast Studies\3CB R01\Analysis Code\Matlab\temporary_UCSF\comparison\UHCC\Thickness2';

%   UCSF path
ucsf = 'O:\SRL\aaStudies\Breast Studies\3CB R01\Analysis Code\Matlab\temporary_UCSF\comparison\UCSF\Thickness';

uhccList = dir([uhcc,'\*.mat']);
ucsfList = dir([ucsf,'\*.mat']);

%   order the list
[~, reindexUHCC] = sort( str2double( regexp( {uhccList.name}, '\d\d\d\d\d', 'match', 'once' )));
 uhccList = uhccList(reindexUHCC);
 
[~, reindexUCSF] = sort( str2double( regexp( {ucsfList.name}, '\d\d\d\d\d', 'match', 'once' )));
 ucsfList = ucsfList(reindexUCSF);
 
for ii = 1:length({uhccList.name})
     structUHCC(ii) = load([uhcc,'\',uhccList(ii).name]);
     disp([uhcc,'\',uhccList(ii).name])
end

for jj = 1:length({ucsfList.name})
     structUCSF(jj) = load([ucsf,'\',ucsfList(jj).name]);
     disp([ucsf,'\',ucsfList(jj).name])
end


%% Calculate Thickness value (avg over breast)

for pp = 1:length({uhccList.name})
    avgThicknessUHCC(pp) = sum(structUHCC(pp).thickness_map(structUHCC(pp).thickness_map~=0))/sum(sum(structUHCC(pp).thickness_map~=0));
end

for zz = 1:length({ucsfList.name})
    avgThicknessUCSF(zz) = sum(structUCSF(zz).thickness_map(structUCSF(zz).thickness_map~=0))/sum(sum(structUCSF(zz).thickness_map~=0));
end

%% Add average
newThickness = structUHCC;

saveNames = {'21_LECCraw_Mat_v8.2','22_LECCraw_Mat_v8.2','23_LECCraw_Mat_v8.2','24_LECCraw_Mat_v8.2','25_LECCraw_Mat_v8.2'};

for ik = 1:length({uhccList.name})
     newThickness(ik).thickness_map(newThickness(ik).thickness_map~=0) = newThickness(ik).thickness_map(newThickness(ik).thickness_map~=0)+1300;
     thisName = [uhcc,'\',char(saveNames{ik}),'.mat'];
     thisMat = newThickness(ik);
     save(thisName,'-struct','thisMat')
end

%%
figure(20)
stem(avgThicknessUCSF,avgThicknessUHCC)


%% do things with images

for kk = 1:size(structUCSF,2)
    structDiff(kk).thickness = structUHCC(kk).thickness_map - structUCSF(kk).thickness_map;
    structDiff(kk).density = structUHCC(kk).density_map - structUCSF(kk).density_map;
end





%% plot the images and things done with the images

% plot the absolute thickness difference
for dd = 1:size(structDiff,2)
    figure(dd);
    subplot(211)
    imagesc(structDiff(dd).thickness,[min(min(structDiff(dd).thickness)) max(max(structDiff(dd).thickness))]);
 %   imagesc(structDiff(dd).thickness,[-2000 4000]);
    colormap(gray)
    title(['This is a Thickness Diff plot of ',num2str(dd)])
    colorbar
    subplot(212)
    imagesc(abs(structDiff(dd).thickness),[min(min(abs(structDiff(dd).thickness))) max(max(abs(structDiff(dd).thickness)))]);
 %   imagesc(structDiff(dd).thickness,[-2000 4000]);
    colormap(gray)
    title(['This is an Absolute Thickness Diff plot of ',num2str(dd)])
    colorbar
end

% plot the abosolute density difference
for kk = 1:size(structDiff,2)
    figure(5+kk);
    subplot(211)
    imagesc(structDiff(kk).density,[min(min(structDiff(kk).density)) max(max(structDiff(kk).density))]);
 %   imagesc(structDiff(dd).thickness,[-2000 4000]);
    colormap(gray)
    title(['This is a Density Diff plot of ',num2str(kk)])
    colorbar
    subplot(212)
    imagesc(abs(structDiff(kk).density),[min(min(abs(structDiff(kk).density))) max(max(abs(structDiff(kk).density)))]);
 %   imagesc(structDiff(dd).thickness,[-2000 4000]);
    colormap(gray)
    title(['This is an Absolute Density Diff plot of ',num2str(kk)])
    colorbar
end





%%
for gg = 1:size(structUCSF,2)
    figure(10+gg);
    subplot(211)
%    imagesc(structUCSF(gg).thickness_map,[min(min(structUCSF(gg).thickness_map)),max(max(structUCSF(gg).thickness_map))]);
    imagesc(structUCSF(gg).thickness_map,[0,8000]);
    colormap(gray)
    title(['This is a plot of UCSF',num2str(gg)])
    colorbar
    subplot(212)
    imagesc(structUHCC(gg).thickness_map,[0,8000]);
    colormap(gray)
    title(['This is a plot of UHCC',num2str(gg)])
    colorbar
end




% % for pp = 1:size(structUHCC,2)
% %     figure(5+pp);
% %     imagesc(structUHCC(pp).thickness_map);
% %     colormap(gray)
% %     title(['This is a plot of UHCC',num2str(pp)])
% % end


