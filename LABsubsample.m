% LABsubsample.m
%
% Total workflow to create an image that is chroma subsampled in LAB color
% space.
% 
% Steps followed:
%   - Import image as .exr
%   - Perceptually quantize image via SMPTE 2084
%   - Convert image to Lab
%   - Quantize image to 10bits
%   - Apply chroma subsampling to 4:2:0 with a specific filter
%   ??? Save here or upsample first ???
%   - Upsample back to 4:4:4
%   - Save image as a .yuv using writeframeplanar
%   - Inverse everything, back to .exr
%
% Created: 24 October 2017

clc
clear all
close all

%% set directory based on user
setdir(4); 

%% import file
filename=('Market3Clip4000r2_1920x1080p_50_hf_709_ct2020_444_00000.exr');
img=exrread(filename);

%% apply PQ
rgbPQ = SMPTE_ST_2084(img, true, 10000);

%% convert to LAB
labimg=rgb2Lab(rgbPQ);
% labimg=rgb2lab(rgbPQ);

%% quantize lab into 0:1024
labq = ScaleImage2BitDepthLAB(labimg, true, false, 10, 'Lab');

%% extract L, a, and b channels
L = labq(:,:,1);
A = labq(:,:,2);
B = labq(:,:,3);

%% apply chroma downsampling
filter = 'MPEGCfE';
[Asampled, Bsampled] = ChromaDownSampling(labq,'420',filter); 
%% apply chroma upsampling
labimgcompressed = ChromaUpSampling(L, Asampled, Bsampled); 

%% save file in planar form
filename = ['Lab' filter '.yuv']; 
WriteFramePlanar(labimgcompressed(:,:,1), labimgcompressed(:,:,2), labimgcompressed(:,:,3), filename, 3,10);

%% convert back to r'g'b'
rgbPQcompressed = lab2rgb(labimgcompressed);
%% convert back to rgb
exr = SMPTE_ST_2084(rgbPQcompressed, false, 10000);

% remove imaginary pixels
numcomplex = size(find(imag(exr)~=0)); % these are caused by rgbPQcompressed values<0
disp('Number of imaginary pixel values in .exr file:')
disp(numcomplex)
exr(imag(exr) ~= 0) = 0; % eliminate imaginary pixels

%% save file
exrwrite(exr, 'test.exr');

%% open file to display
imgReopen=exrread('test.exr');
rgbPQReopen = SMPTE_ST_2084(img, true, 10000);
figure
imshow(rgbPQReopen)






