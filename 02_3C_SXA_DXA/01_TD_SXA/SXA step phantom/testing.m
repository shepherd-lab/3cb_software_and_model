filename='P:\Vidar Images\test\bbs10.tif';

Mammo=imread(filename);
figure;imagesc(Mammo);colormap(gray);

hold on;
plot([1 1400],[10 3000])