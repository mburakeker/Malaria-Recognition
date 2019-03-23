clear; close all; clc; 
imgFolder = fullfile(pwd,'\images');
dataset = imageSet(imgFolder);
methods(dataset);
togglefig('Malaria Images')
graphicObjects = gobjects(dataset.Count,1);

for ii = 1:dataset.Count
	graphicObjects(ii) =subplot(floor(sqrt(dataset.Count)),ceil(sqrt(dataset.Count)),ii);
	imshow(read(dataset,ii))
end
rand = 15;
set(graphicObjects(rand),'xcolor','r','ycolor','r','xtick',[],'ytick',[],'linewidth',2,'visible','on')
testData = getimage(graphicObjects(rand));
figure,subplot 131,imshow(testData);

grayscale = rgb2gray(testData);

[coords, rads] = imfindcircles(grayscale,[35 80], ...
	'Sensitivity',0.90, ...
	'EdgeThreshold',0.06, ...
	'Method','TwoStage', ...
	'ObjectPolarity','Dark');

subplot 132,imshow(testData)
viscircles(coords,rads,'edgecolor','b')
title(sprintf('%i Cells detected.',numel(rads)),'fontsize',14);

infectionThreshold = 25;
malaria = grayscale <= infectionThreshold;
showMaskAsOverlay(1,malaria,'r');
infected = false(numel(rads),1);

x = 1:size(grayscale,2);
y = 1:size(grayscale,1);
[xx,yy] = meshgrid(x,y);
subplot 133,imshow(testData)
malariaMask = false(size(grayscale));

for ii = 1:numel(rads)
	circleMask = hypot(xx - coords(ii,1), yy - coords(ii,2)) <= rads(ii);
	grayscaleCircles = grayscale;
	grayscaleCircles(~circleMask) = 0;
	malaria = grayscaleCircles > 0 & grayscaleCircles < infectionThreshold;
	malariaMask = malariaMask | malaria;
	infected(ii) = any(malaria(:));
end
showMaskAsOverlay(1,malariaMask,'r',[],false)
title('Infected Cells');


