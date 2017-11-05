% YCbCrsubsample.m
% Subsample the content in the YCbCr colorpsace, for reference
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
%% convert to YCbCr
YCbCr = RGB2YCbCr(rgbPQ,true,'BT.2020',false);
%% quantize to 10 bits
YCbCrq = QuantizeBT1361(YCbCr, true, 10, 'YCbCr');
YCbCrq = uint16(YCbCrq);
% save 4:4:4 10-bit image as .yuv
WriteFramePlanar(YCbCrq(:,:,1), YCbCrq(:,:,2), YCbCrq(:,:,3), 'YCbCr_444.yuv', 3,10);
%% Chroma Downsample to 4:2:0 using specificed filter
filter = 'lanczos3';
[Cbsampled, Crsampled] = ChromaDownSampling(YCbCrq,'420',filter); 
%% Save 4:2:0 10-bit image as .yuv
filename2 = ['YCbCr420' filter '.yuv']; 
WriteFramePlanar(YCbCrq(:,:,1), Cbsampled, Crsampled, filename2, 3,10);
%% apply chroma upsampling
ycbcrimgcompressedq = ChromaUpSampling(YCbCrq(:,:,1), Cbsampled, Crsampled, '420',filter);
% turn back to a decimal value
ycbcrimgcompressedq = single(ycbcrimgcompressedq);
%% inverse quantize back to decimal
ycbcrimgcompressed = QuantizeBT1361(ycbcrimgcompressedq, false, 10, 'YCbCr');
%% convert back to r'g'b'
rgbPQcompressed = RGB2YCbCr(ycbcrimgcompressed,false,'BT.2020',false); % i think there's an error in this function somehow
%% convert back to rgb
exrcompressed = SMPTE_ST_2084(rgbPQcompressed, false, 10000);
%% see image
figure
imshow(rgbPQcompressed);
