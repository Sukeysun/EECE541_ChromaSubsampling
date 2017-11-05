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
% last updated: 31 Oct 2017

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
xyzimg = rgb2Xyz(rgbPQ, true);
labimg = xyz2lab_pq_8(xyzimg,true); % with this conversion, L:(0,1), a,b:(-0.5,0.5)

%% quantize lab into 0:1024
labq = QuantizeBT1361(labimg, true, 10, 'YCbCr');
labq = uint16(labq);

%% extract L, a, and b channels
L = labq(:,:,1);
A = labq(:,:,2);
B = labq(:,:,3);

%% apply chroma downsampling
filter = 'lanczos3';
[Asampled, Bsampled] = ChromaDownSampling(labq,'420',filter); 

%% save 4:2:0 file in planar form
filename = ['Lab420' filter '.yuv']; 
WriteFramePlanar(L, Asampled, Bsampled, filename, 3,10);

%% apply chroma upsampling
labimgcompressed = ChromaUpSampling(L, Asampled, Bsampled, '420',filter); 

%% convert back to r'g'b'
% rgbPQcompressed = lab2rgb(labimgcompressed);
xyzimgcompressed = xyz2lab_pq_8(labimgcompressed,false); 
rgbPQcompressed = rgb2Xyz(rgbPQ, false);



% 
% %% convert back to rgb
% exr = SMPTE_ST_2084(rgbPQcompressed, false, 10000);
% 
% % remove imaginary pixels
% numcomplex = size(find(imag(exr)~=0)); % these are caused by rgbPQcompressed values<0
% disp('Number of imaginary pixel values in .exr file:')
% disp(numcomplex)
% exr(imag(exr) ~= 0) = 0; % eliminate imaginary pixels
% 
% %% save file
% exrwrite(exr, 'test.exr');
% 
% %% open file to display
% imgReopen=exrread('test.exr');
% rgbPQReopen = SMPTE_ST_2084(img, true, 10000);
% figure
% imshow(rgbPQReopen)
