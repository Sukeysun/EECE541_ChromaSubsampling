%2017-10-12
filename=('E:\term1\EECE541\CIELAB downsampling Team\Market3Clip4000r2_1920x1080p_50_hf_709_ct2020_444_00000.exr');
img=exrread(filename);
rgb = tonemap(img);
figure(1)
subplot(2,2,1)
imshow(rgb);
title('exr ')
y = SMPTE_ST_2084(img, true, 10000);
size(y);
subplot(2,2,2)
imshow(y)
title('after PQ ')
labimg=rgb2Lab(y);
subplot(2,2,3)
imshow(labimg)
title('2Lab ')
