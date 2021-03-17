clear all
close all
clc

%% load in images

%   UHCC path
%uhcc = 'O:\SRL\aaStudies\Breast Studies\3CB R01\Analysis Code\Matlab\temporary_UCSF\comparison\UHCC';

%   UCSF path
%ucsf = 'O:\SRL\aaStudies\Breast Studies\3CB R01\Analysis Code\Matlab\temporary_UCSF\comparison\UCSF';
ucsf = 'O:\SRL\aaStudies\Breast Studies\3CB R01\Analysis Code\Matlab\temporary_UCSF\comparison\UCSF\Thickness';

%uhccList = dir([uhcc,'\*.mat']);
ucsfList = dir([ucsf,'\*.mat']);

%   order the list
% [uhccName, reindexUHCC] = sort( str2double( regexp( {uhccList.name}, '\d\d\d\d\d', 'match', 'once' )));
% uhccList = uhccList(reindexUHCC);

[ucsfName, reindexUCSF] = sort( str2double( regexp( {ucsfList.name}, '\d\d\d\d\d', 'match', 'once' )));
ucsfList = ucsfList(reindexUCSF);

% for ii = 1:length({uhccList.name})
%     structUHCC(ii) = load([uhcc,'\',uhccList(ii).name]);
%     disp([uhcc,'\',uhccList(ii).name])
% end

for jj = 1:length({ucsfList.name})
    structUCSF(jj) = load([ucsf,'\',ucsfList(jj).name]);
    disp([ucsf,'\',ucsfList(jj).name])
end

%% diff between UCSF and UHCC

for kk = 1:size(structUCSF,2)
    structDiff(kk).LEPres = structUHCC(kk).maps.LEPres - structUCSF(kk).maps.LEPres;
    structDiff(kk).lipid = structUHCC(kk).maps.lipid - structUCSF(kk).maps.lipid;
    structDiff(kk).water = structUHCC(kk).maps.water - structUCSF(kk).maps.water;
    structDiff(kk).protein = structUHCC(kk).maps.protein - structUCSF(kk).maps.protein;
end

%% Show thickness_maps

for qq = 1:size(structUCSF,2)
    figure(qq)
    imagesc(structUCSF(qq).thickness_map,[0,12000])
    title(['UCSF patient 2',num2str(qq),' thickness map v8.1'])
    colormap(gray)
    colorbar
end

%% Show difference images

for bb = 1:size(structDiff,2)
    figure(15+bb)
    subplot(221)
    imagesc(structDiff(bb).LEPres,colorBound(structDiff(bb).LEPres))
    title('LEPres')
    colormap(gray)
    colorbar
    subplot(222)
    
    imagesc(structDiff(bb).water,colorBound(structDiff(bb).water))
    title('Water')
    colormap(gray)
    colorbar
    subplot(223)
    
    imagesc(structDiff(bb).lipid,colorBound(structDiff(bb).lipid))
    title('Lipid')
    colormap(gray)
    colorbar
    subplot(224)
    
    imagesc(structDiff(bb).protein,colorBound(structDiff(bb).protein))
    title('Protein')
    colormap(gray)
    colorbar
    p = mtit(['3CB Diff 3C0',num2str(ucsfName(bb))]);
end

%% UCSF Show all images for a given patient

for qq = 1:size(structUCSF,2)
    figure(qq)
    subplot(221)
    imagesc(structUCSF(qq).maps.LEPres,[min(min(structUCSF(qq).maps.LEPres)),max(max(structUCSF(qq).maps.LEPres))])
    title('LEPres')
    colormap(gray)
    colorbar
    subplot(222)
    
    imagesc(structUCSF(qq).maps.water,[min(min(structUCSF(qq).maps.water)),max(max(structUCSF(qq).maps.water))])
    title('Water')
    colormap(gray)
    colorbar
    subplot(223)
    
    imagesc(structUCSF(qq).maps.lipid,[min(min(structUCSF(qq).maps.lipid)),max(max(structUCSF(qq).maps.lipid))])
    title('Lipid')
    colormap(gray)
    colorbar
    subplot(224)
    
    imagesc(structUCSF(qq).maps.protein,[min(min(structUCSF(qq).maps.protein)),max(max(structUCSF(qq).maps.protein))])
    title('Protein')
    colormap(gray)
    colorbar
    p = mtit(['UCSF 3C0',num2str(ucsfName(qq))]);
end

%% UHCC Show all images for a given patient

for ww = 1:size(structUHCC,2)
    figure(ww)
    subplot(221)
    imagesc(structUHCC(ww).maps.LEPres,[min(min(structUHCC(ww).maps.LEPres)),max(max(structUHCC(ww).maps.LEPres))])
    title('LEPres')
    colormap(gray)
    colorbar
    subplot(222)
    
    imagesc(structUHCC(ww).maps.water,[min(min(structUHCC(ww).maps.water)),max(max(structUHCC(ww).maps.water))])
    title('Water')
    colormap(gray)
    colorbar
    subplot(223)
    
    imagesc(structUHCC(ww).maps.lipid,[min(min(structUHCC(ww).maps.lipid)),max(max(structUHCC(ww).maps.lipid))])
    title('Lipid')
    colormap(gray)
    colorbar
    subplot(224)
    
    imagesc(structUHCC(ww).maps.protein,[min(min(structUHCC(ww).maps.protein)),max(max(structUHCC(ww).maps.protein))])
    title('Protein')
    colormap(gray)
    colorbar
    p = mtit(['UHCC 3C0',num2str(ucsfName(ww))]);
end

%% plot the images and things done with the images

% % % % plot the absolute thickness difference
% % % for dd = 1:size(structDiff,2)
% % %     figure(dd);
% % %     subplot(211)
% % %     imagesc(structDiff(dd).thickness,[min(min(structDiff(dd).thickness)) max(max(structDiff(dd).thickness))]);
% % %  %   imagesc(structDiff(dd).thickness,[-2000 4000]);
% % %     colormap(gray)
% % %     title(['This is a Thickness Diff plot of ',num2str(dd)])
% % %     colorbar
% % %     subplot(212)
% % %     imagesc(abs(structDiff(dd).thickness),[min(min(abs(structDiff(dd).thickness))) max(max(abs(structDiff(dd).thickness)))]);
% % %  %   imagesc(structDiff(dd).thickness,[-2000 4000]);
% % %     colormap(gray)
% % %     title(['This is an Absolute Thickness Diff plot of ',num2str(dd)])
% % %     colorbar
% % % end
% % %
% % % % plot the abosolute density difference
% % % for kk = 1:size(structDiff,2)
% % %     figure(5+kk);
% % %     subplot(211)
% % %     imagesc(structDiff(kk).density,[min(min(structDiff(kk).density)) max(max(structDiff(kk).density))]);
% % %  %   imagesc(structDiff(dd).thickness,[-2000 4000]);
% % %     colormap(gray)
% % %     title(['This is a Density Diff plot of ',num2str(kk)])
% % %     colorbar
% % %     subplot(212)
% % %     imagesc(abs(structDiff(kk).density),[min(min(abs(structDiff(kk).density))) max(max(abs(structDiff(kk).density)))]);
% % %  %   imagesc(structDiff(dd).thickness,[-2000 4000]);
% % %     colormap(gray)
% % %     title(['This is an Absolute Density Diff plot of ',num2str(kk)])
% % %     colorbar
% % % end
% % %
% % %



%%
% % for gg = 1:size(structUCSF,2)
% %     figure(10+gg);
% %     subplot(211)
% % %    imagesc(structUCSF(gg).thickness_map,[min(min(structUCSF(gg).thickness_map)),max(max(structUCSF(gg).thickness_map))]);
% %     imagesc(structUCSF(gg).thickness_map,[0,6000]);
% %     colormap(gray)
% %     title(['This is a plot of UCSF',num2str(gg)])
% %     colorbar
% %     subplot(212)
% %     imagesc(structUHCC(gg).thickness_map,[0,6000]);
% %     colormap(gray)
% %     title(['This is a plot of UHCC',num2str(gg)])
% %     colorbar
% % end
% %
% %


% % for pp = 1:size(structUHCC,2)
% %     figure(5+pp);
% %     imagesc(structUHCC(pp).thickness_map);
% %     colormap(gray)
% %     title(['This is a plot of UHCC',num2str(pp)])
% % end


