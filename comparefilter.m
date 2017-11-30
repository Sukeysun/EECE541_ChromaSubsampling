clc
clear all
load('a');
a=a*255;
H=[3,5,8,8,5,3]';
w=[1 6 1];
offset=log(sum(H))+log(sum(w));
shift=2^( offset-1);
f  = imfilter(a, w, 'replicate');
r  = imfilter(f, H, 'replicate') ;
%r  = (r + offset) / 2^shift;


H1= [0 4 4]';
w1 = [1 6 1];
offset=log(sum(H1))+log(sum(w1));
shift=2^( offset-1);
f1  = imfilter(a, w1, 'replicate');
r1  = imfilter(f1, H1, 'replicate') ;
%r  = (r + offset) / 2^shift;

H2 = [2 3 6 10 6 3 2]';
w2 = [2 3 6 10 6 3 2 ];
offset=log(sum(H2))+log(sum(w2));
shift=2^( offset-1);
f2  = imfilter(a, w2, 'replicate');
r2  = imfilter(f2, H2, 'replicate') ;
%r  = (r + offset) / 2^shift;


H3 = [0 5 6 3 2]';
w3=[1 6 1];
offset=log(sum(H3))+log(sum(w3));
shift=2^( offset-1);
f3  = imfilter(a, w3, 'replicate');
r3  = imfilter(f3, H3, 'replicate') ;
%r  = (r + offset) / 2^shift;


 r4 = imresize(a, 1, 'lanczos3', 'Antialiasing', true);
 

figure(1)
subplot(231)
imshow(a)
title('orginal')
subplot(232)
title('orginal')
imshow(r)
title('H=[3,5,8,8,5,3]^T,w=[1 6 1]')

subplot(233)
imshow(r1)
title('H=[0 4 4]^T,w=[1 6 1]')

subplot(234)
imshow(r2)
title('H=[2 3 6 10 6 3 2]^T,w=[2 3 6 10 6 3 2]')

subplot(235)
imshow(r3)
title('H=[0 5 6 3 2]^T,w=[1 6 1]')

subplot(236)
imshow(r4)
title('lanczos3')

