afft=fftshift(abs(fft2(a)));
load('a');
a=a*255;
H=[3,5,8,8,5,3]';
w=[1 6 1];
offset=log(sum(H))+log(sum(w));
shift=2^( offset-1);
f  = imfilter(a, w, 'replicate');
r  = imfilter(f, H, 'replicate') ;
%r  = (r + offset) / 2^shift;
rfft=fftshift(abs(fft2(r)));

H1= [0 4 4]';
w1 = [1 6 1];
offset=log(sum(H1))+log(sum(w1));
shift=2^( offset-1);
f1  = imfilter(a, w1, 'replicate');
r1  = imfilter(f1, H1, 'replicate') ;
%r  = (r + offset) / 2^shift;
rfft1=fftshift(abs(fft2(r1)));

H2 = [2 3 6 10 6 3 2]';
w2 = [2 3 6 10 6 3 2 ];
offset=log(sum(H2))+log(sum(w2));
shift=2^( offset-1);
f2  = imfilter(a, w2, 'replicate');
r2  = imfilter(f2, H2, 'replicate') ;
%r  = (r + offset) / 2^shift;
rfft2=fftshift(abs(fft2(r2)));

H3 = [0 5 6 3 2]';
w3=[1 6 1];
offset=log(sum(H3))+log(sum(w3));
shift=2^( offset-1);
f3  = imfilter(a, w3, 'replicate');
r3  = imfilter(f3, H3, 'replicate') ;
%r  = (r + offset) / 2^shift;
rfft3=fftshift(abs(fft2(r3)));


 r4 = imresize(a, 1, 'lanczos3', 'Antialiasing', true);
 rfft4=fftshift(abs(fft2(r4)));
 

figure(1)
subplot(231)
mesh(afft)
title('orginal')
subplot(232)
title('orginal')
mesh(rfft)
title('H=[3,5,8,8,5,3]^T,w=[1 6 1]')

subplot(233)
mesh(rfft1)
title('H=[0 4 4]^T,w=[1 6 1]')

subplot(234)
mesh(rfft2)
title('H=[2 3 6 10 6 3 2]^T,w=[2 3 6 10 6 3 2]')

subplot(235)
mesh(rfft3)
title('H=[0 5 6 3 2]^T,w=[1 6 1]')

subplot(236)
mesh(rfft4)
title('lanczos3')
