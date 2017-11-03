function xyzimg= rgb2Xyz(rgbimg)

% RGB2Lab takes matrices corresponding to Red, Green, and Blue, and  
% transforms them into CIELab. 
R=rgbimg(:,:,1);
G=rgbimg(:,:,2);
B=rgbimg(:,:,3);
% quantize R, G, and B values to range of [0,1] if needed 
if ((max(max(R))> 1.0)|(max(max(G))> 1.0)|(max(max(B))> 1.0))  % max value in all features
%if (max(R)> 1.0)| (max(G)> 1.0)|(max(B)>1.0) % different max values in different columns
R = R/255;
G = G/255;
B = B/255;
end
[M, N] = size(R);
s = M*N; %pixel of R

% Set a threshold 
T = 0.008856;
RGB = [reshape(R,1,s); reshape(G,1,s); reshape(B,1,s)]; %size(RGB)=3*s
% RGB to XYZ 
MAT = [0.412453 0.357580 0.180423;0.212671 0.715160 0.072169;0.019334 0.119193 0.950227];
%[X]=[0.412453    0.357580    0.180423][R]
%[Y]=[0.212671    0.715160    0.072169][G]       formula: RGB 2 XYZ
%[Z]=[0.019334    0.119193    0.950227][B]
XYZ = MAT * RGB;
X = XYZ(1,:) / 0.950456;    % make the coefficient to 1 so that X is in the range of 0 to 255 (RGB[0 255])
Y = XYZ(2,:);      %sum[Y]=1
Z = XYZ(3,:) / 1.088754;

X = reshape(X, M, N);
Y = reshape(Y, M, N);
Z = reshape(Z, M, N);
xyzimg = cat(3,X,Y,Z);

end

