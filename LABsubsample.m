% LABsubsample.m
%
% Total workflow to create an image that is chroma subsampled in LAB color
% space.
% 
% Steps followed:
%   - Import image as .exr
%   - Perceptually quantize image via SMPTE 2084
%   - Convert image to Lab
%   - Quantize image to 10bit integers
%   - Apply chroma subsampling to 4:2:0 with a specific filter
%   - Save compressed image as a planar .yuv file
%   - Upsample back to 4:4:4
%   - Inverse everything, back to .exr
%
% Created: 24 October 2017
% last updated: 21 November 2017
% 

clc
clear all
close all

%% set directory based on user
setdir(4); 

%% import file
filename=('Market3Clip4000r2_1920x1080p_50_hf_709_ct2020_444_00000.exr');
img=exrread(filename);
% imgsweatshirt = img(520:610,35:145,:);
% exrwritechannels('OriginalSweatshirt.exr', 'none', 'half', {'R', 'G', 'B'}, {imgsweatshirt(:,:,1),imgsweatshirt(:,:,2),imgsweatshirt(:,:,3)});
% imgpricetag = img(635:685,1090:1135,:);
% exrwritechannels('OriginalPricetag.exr', 'none', 'half', {'R', 'G', 'B'}, {imgpricetag(:,:,1),imgpricetag(:,:,2),imgpricetag(:,:,3)});

%% apply PQ
rgbPQ = SMPTE_ST_2084(img, true, 10000);

%% convert to LAB
xyzimg = rgb2Xyz(rgbPQ,true);
labimg = xyz2lab_pq_8(xyzimg,true); % with this conversion, L:(0,1), a,b:(-0.5,0.5)

%% quantize lab into 0:1024
labq = QuantizeBT1361(labimg, true, 10, 'YCbCr');
labq = uint16(labq);

%% apply chroma downsampling
filter = 'MPEGMvF07';
[Asampled, Bsampled] = ChromaDownSampling(labq,'420',filter); 

%% save 4:2:0 file in planar form
filename = ['Lab420' filter '.yuv']; 
WriteFramePlanar(labq(:,:,1), Asampled, Bsampled, filename, 3,10);

%% apply chroma upsampling
labimgcompressedq = ChromaUpSampling(labq(:,:,1), Asampled, Bsampled, '420',filter); 
% turn back to a decimal value
labimgcompressedq = single(labimgcompressedq);
%% inverse quantize back to decimal
labimgcompressed = QuantizeBT1361(labimgcompressedq, false, 10, 'YCbCr');
%% convert back to r'g'b'
% rgbPQcompressed = lab2rgb(labimgcompressed);
xyzimgcompressed = xyz2lab_pq_8(labimgcompressed,false); 
rgbPQcompressed = rgb2Xyz(xyzimgcompressed, false);
%% convert back to rgb
exrcompressed = SMPTE_ST_2084(rgbPQcompressed, false, 10000);

exrsweatshirt   = exrcompressed(520:610,35:145,:);
exrpricetag     = exrcompressed(635:685,1090:1135,:);
%%

figure
subplot(211)
imshow(rgbPQ)
title('Original')
ylim([635 685])
xlim([1090 1135])
subplot(212)
imshow(rgbPQcompressed);
title(['Compressed with ' filter])
ylim([635 685])
xlim([1090 1135])

figure
subplot(211)
imshow(rgbPQ)
title('Original')
ylim([520 610])
xlim([35 145])
subplot(212)
imshow(rgbPQcompressed);
ylim([520 610])
xlim([35 145])
title(['Compressed with ' filter])

%% remove imaginary pixels
numcomplex = size(find(imag(exrsweatshirt)~=0)); % these are caused by rgbPQcompressed values<0
disp('Number of imaginary pixel values in cropped .exr file:')
disp(numcomplex)
exrsweatshirt(imag(exrsweatshirt) ~= 0) = 0; % eliminate imaginary pixels

numcomplex = size(find(imag(exrpricetag)~=0)); % these are caused by rgbPQcompressed values<0
disp('Number of imaginary pixel values in cropped .exr file:')
disp(numcomplex)
exrpricetag(imag(exrpricetag) ~= 0) = 0; % eliminate imaginary pixels


numcomplex = size(find(imag(exrcompressed)~=0)); % these are caused by rgbPQcompressed values<0
disp('Number of imaginary pixel values in .exr file:')
disp(numcomplex)
exrcompressed(imag(exrcompressed) ~= 0) = 0; % eliminate imaginary pixels

%% save files
wd = cd;
cd([cd '\EXRs']);
filename3 = ['CIELAB420' filter 'Sweatshirt.exr'];
exrwritechannels(filename3, 'none', 'half', {'R', 'G', 'B'}, {exrsweatshirt(:,:,1),exrsweatshirt(:,:,2),exrsweatshirt(:,:,3)});

filename4 = ['CIELAB420' filter 'Pricetag.exr'];
exrwritechannels(filename4, 'none', 'half', {'R', 'G', 'B'}, {exrpricetag(:,:,1),exrpricetag(:,:,2),exrpricetag(:,:,3)});

filename5 = ['CIELAB420' filter '.exr'];
exrwritechannels(filename5, 'none', 'half', {'R', 'G', 'B'}, {exrcompressed(:,:,1),exrcompressed(:,:,2),exrcompressed(:,:,3)});
cd(wd);
%% open file to display
% imgReopen=exrread(filename3);
% rgbPQReopen = SMPTE_ST_2084(imgReopen, true, 10000);
% figure
% imshow(rgbPQReopen)
% title('Re-Open')
