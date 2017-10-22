%% filterCompare
% compare different filters to be used in the chroma subsampling
% note: these filters are applied as convolutions. A visual aid to how
% these are applied can be found here: 
% http://www.songho.ca/dsp/convolution/convolution2d_example.html

setdir(4); % set directory

clc
close all
clear all

%% create "image" with data that we can actually visualize
testimage = 10*ones(720,1280);
testimage(:,1:2:end) = 2;

%% import a real image, convert to YCbCr, and extract the Y channel
realimage = imread('skiflip.jpg');

% convert to YCbCr if its not already
if(size(realimage,3)>1)
    YCbCr = RGB2YCbCr(realimage, true, 'BT.2020', true);
    YCbCr2 = rgb2ycbcr(realimage);

    Y = YCbCr(:,:,1);
else
    Y = realimage;
end

Y = double(uint32(Y));
Y = Y/max(max(Y));

%% create filters
H1 = [0 -1 0; -1 5 -1; 0 -1 0];
H1 = [0 1 0; 1 -4 1; 0 1 0];
H1 = [1 0 -1; 2 0 -2; 1 0 -1];

H1 = [1 6 1];

%bilinear?
H1 = 1/4*[0 1 0; 1 0 1; 0 1 0];

filteredtestim2 = imfilter(testimage, H1, 'replicate') ;
filteredtestim = imfilter(testimage, H1,'conv') ;
Yfilt = imfilter(Y, H1,'conv');
% Yfilt = Yfilt/max(max(Yfilt));

%% is bilinear done this way the same as if using imresize? Lets check...
Yresized = imresize(Y,0.5,'bilinear'); % use resize to subsample and filter at the same time
Yresized2 = Yfilt(:,1:2:end); % filter first, then downsample
Yresized2 = Yresized2(1:2:end,:);

disp('Filter:')
disp(H1)

disp('Original Test Image:')
disp(testimage(5:10,5:10))
disp('Filtered Test Image:')
disp(filteredtestim(5:10,5:10))
disp('Filtered Test Image2:')
disp(filteredtestim2(5:10,5:10))
disp('Original Real Image:')
disp(Y(5:10,5:10))
disp('Filtered Real Image:')
disp(Yfilt(5:10,5:10))


figure
imshow(Y)
title('Original')
figure
imshow(Yfilt)
title(['Filtered with [' num2str(H1) ']'])



