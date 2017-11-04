function img= rgb2xyz(rgbimg, encode)

% if encode=1,rgb to xyz; if encode=0, xyz to rgb
% RGB2Lab takes matrices corresponding to Red, Green, and Blue, and  
% transforms them into CIELab. 
if encode
     R=rgbimg(:,:,1);
     G=rgbimg(:,:,2);
     B=rgbimg(:,:,3);
     if ((max(max(R))> 1.0)|(max(max(G))> 1.0)|(max(max(B))> 1.0))  % max value in all features
     %if (max(R)> 1.0)| (max(G)> 1.0)|(max(B)>1.0) % different max values in different columns
     R = R/255;
     G = G/255;
     B = B/255;
     end
     [M, N] = size(R);
     s = M*N; %pixel of R

% Set a threshold 
%T = 0.008856;
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
     img=cat(3,X,Y,Z);

else
     X=rgbimg(:,:,1);
     Y=rgbimg(:,:,2);
     Z=rgbimg(:,:,3);
     [M, N] = size(X);
     s=M*N;
     X = X * 0.950456;
     Z = Z * 1.088754;
     XYZ = [reshape(X,1,s); reshape(Y,1,s); reshape(Z,1,s)];
     MAT = [3.240479 -1.537150 -0.498535;-0.969256 1.875992 0.041556;0.055648 -0.204043 1.057311];
     RGB = MAT*XYZ;
     R = RGB(1,:);   
     G = RGB(2,:);      
     B = RGB(3,:);
     R = reshape(R, M, N);
     G = reshape(G, M, N);
     B = reshape(B, M, N);
     img=cat(3,R,G,B);
end