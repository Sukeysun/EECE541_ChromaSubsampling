%2017-10-12
clc
clear all
close all
%% Get user
userlist = [string('Sukey'),string('Yuki'),string('Ahmed'),string('Maurizio')];
for ii=1:length(userlist)
    disp([string(ii) + '   ' + userlist(ii)])
end
user = input('Who are you?  ');
%%
%% Set your CD here
dirlist = [string('E:\term1\EECE541\CIELAB downsampling Team\MATLAB'),...
    string(' '), ...    % Yuki: enter your directory here
    string(' '), ...    % Ahmed: enter your directory here
    string('C:\Users\mvonf\Documents\SCHOOL\UBC_Grad\UBC_Fall2017\EECE541\CIELAB_downsampling_Team\MATLAB\')];
cd([dirlist{user}]);

% add all folders that contain Matlab code
addpath('ProvidedCode')
addpath('trunk')
addpath('ProvidedCode\openEXR')
addpath('ProvidedCode\Display')
  

%%
filename=('Market3Clip4000r2_1920x1080p_50_hf_709_ct2020_444_00000.exr');
img=exrread(filename);
rgb = tonemap(img);

rgbPQ = SMPTE_ST_2084(img, true, 10000);    % this function works for inverse too, just set TRUE to FALSE

%% YCbCr
YCbCr = RGB2YCbCr(rgbPQ, true, 'BT.2020', true);
Y = YCbCr(:,:,1);
[ChromaA, ChromaB] = ChromaDownSampling(YCbCr, '420');
% [ChromaACfe, ChromaBCfe] = ChromaDownSampling(YCbCr, '420','MPEGFloatCfe'); %identical results
YCbCr420 = ChromaUpSampling( Y, ChromaA, ChromaB, '420');
rgb420 =  RGB2YCbCr(YCbCr420, false, 'BT.2020', true);
rgb444 =  RGB2YCbCr(YCbCr, false, 'BT.2020', true);

figure
imshow(rgb420)
title('420')
figure
imshow(rgb444)
title('444')

%% Lab
labimg=rgb2Lab(rgbPQ);

%% plot
figure
imshow(rgb);
title('exr ')
figure
imshow(rgbPQ)
title('after PQ ')
figure
imshow(labimg)
title('CIELAB')
figure
imshow(YCbCr)
title('YCbCr')

%% extract L, a, and b channels
L = labimg(:,:,1);
A = labimg(:,:,2);
B = labimg(:,:,3);

figure
subplot(311)
imshow(L)
title('L')
subplot(312)
imshow(A)
title('A')
subplot(313)
imshow(B)
title('B')
