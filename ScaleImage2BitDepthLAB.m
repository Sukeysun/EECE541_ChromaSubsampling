function ImgOut = ScaleImage2BitDepth(ImgIn, Scale, BT1361, BitDepth, Representation)
%RGB2YCbCr - Scale an image to the targetted bit-depth
%
% Syntax:  ImgOut = ScaleImage2BitDepth(ImgIn, Scale, BT1361, BitDepth, Representation)
%
% Inputs:
%    -ImgIn: input image, if Encode = 1 : R'G'B' image, otherwise Y'CbCr
%    -Scale: scale to the bit-depth or inverse it
%    -BT1361: use the BT1361 quantization equations
%    -BitDepth: bit-depth considered
%    -Representation: RGB or YCbCr
%
% Outputs:
%    -ImgOut: output image, if Encode = 1: [0; +Inf], otherwise [0; 1]
%
% Example:
%    ImgOut = ScaleImage2BitDepth(ImgIn, true, true, 10, 'YCbCr')
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: ClipImage.m
%
% See also: 
% References:
%    -International Telecommunication Union, “Worldwide unified colorimetry
%    and related characteristics of future television and imaging systems,”
%    in Recommendation ITU-R BT.1361, 2002.
%
% Author: Ronan Boitard
% University of British Columbia, Vancouver, Canada
% email: rboitard.w@gmail.com
% Website: http://http://www.ece.ubc.ca/~rboitard/
% Created: 15-Mar-2012; Last revision: 26-Oct-2015

%---------------------------- BEGIN CODE ----------------------------------
if(~exist('Scale','var'))
    Scale = true;
end
if(~exist('BT1361','var'))
    BT1361 = false;
end
if(~exist('BitDepth','var'))
    BitDepth = 10;
end
if(~exist('Representation','var'))
    Representation = 'Lab';
end

if BT1361
    % Min and max value of the representation
    MaxValueY = (219*1  +  16)   * 2^(BitDepth-8);
    MinValueY = (219*0  +  16)   * 2^(BitDepth-8);
    MaxValueC = ( 224*0.5 + 128) * 2^(BitDepth-8);
    MinValueC = (-224*0.5 + 128) * 2^(BitDepth-8);
else
    % Min and max value of the representation
    MaxValueY = (255*1)   * 2^(BitDepth-8);
    MinValueY = (255*0)   * 2^(BitDepth-8);
    MaxValueC = (255*0.5  + 128) * 2^(BitDepth-8);
    MinValueC = (-255*0.5 + 128) * 2^(BitDepth-8);
end
    

if strcmp(Representation,'YCbCr')
    if Scale
        if BT1361
            % Scaling and quantization
            % Taken from ITU. (2002). RECOMMENDATION ITU-R BT.1361.
            ImgOut(:,:,1) = (219*ImgIn(:,:,1) +  16) * 2^(BitDepth-8); % Y
            ImgOut(:,:,2) = (224*ImgIn(:,:,2) + 128) * 2^(BitDepth-8); % Cb
            ImgOut(:,:,3) = (224*ImgIn(:,:,3) + 128) * 2^(BitDepth-8); % Cr
        else
            % Full dynamic scaling and quantization
            ImgOut(:,:,1) = (255*ImgIn(:,:,1)      ) * 2^(BitDepth-8); % Y
            ImgOut(:,:,2) = (255*ImgIn(:,:,2) + 128) * 2^(BitDepth-8); % Cb
            ImgOut(:,:,3) = (255*ImgIn(:,:,3) + 128) * 2^(BitDepth-8); % Cr
        end
        % Remove impossible value (when input values are outside the range
        ImgOut(:,:,1) = ClampImg(ImgOut(:,:,1), MinValueY, MaxValueY);
        ImgOut(:,:,2) = ClampImg(ImgOut(:,:,2), MinValueC, MaxValueC);
        ImgOut(:,:,3) = ClampImg(ImgOut(:,:,3), MinValueC, MaxValueC);
            
    else
        % remove over/underflow values, useful when compressed
        ImgIn(:,:,1)   = ClampImg(ImgIn(:,:,1)  , MinValueY, MaxValueY);
        ImgIn(:,:,2:3) = ClampImg(ImgIn(:,:,2:3), MinValueC, MaxValueC);
        
        if BT1361
            % Inverse quantization and scaling
            % Taken from ITU. (2002). RECOMMENDATION ITU-R BT.1361.
            ImgOut(:,:,1) = (ImgIn(:,:,1) / 2^(BitDepth-8) -  16) / 219;
            ImgOut(:,:,2) = (ImgIn(:,:,2) / 2^(BitDepth-8) - 128) / 224;
            ImgOut(:,:,3) = (ImgIn(:,:,3) / 2^(BitDepth-8) - 128) / 224;
        else
            % Full scaling and quantization
            ImgOut(:,:,1) = (ImgIn(:,:,1) / 2^(BitDepth-8)      ) / 255;
            ImgOut(:,:,2) = (ImgIn(:,:,2) / 2^(BitDepth-8) - 128) / 255;
            ImgOut(:,:,3) = (ImgIn(:,:,3) / 2^(BitDepth-8) - 128) / 255;
        end
    end
    
elseif strcmp(Representation,'RGB')
    if Scale
        if BT1361
            % Scaling and quantization
            % Taken from ITU. (2002). RECOMMENDATION ITU-R BT.1361.
            ImgOut = (219*ImgIn +  16) * 2^(BitDepth-8);
        else
            % Full dynamic scaling and quantization
            ImgOut = (255*ImgIn      ) * 2^(NbBits-8);
        end
        ImgOut = ClipImage(ImgOut, MinValueY, MaxValueY);
    else
        % remove over/underflow values, useful when compressed
        ImgIn   = ClipImage(ImgIn, MinValueY, MaxValueY);
        if BT1361
            % Inverse quantization and scaling
            % Taken from ITU. (2002). RECOMMENDATION ITU-R BT.1361.
            ImgOut = (ImgIn / 2^(BitDepth-8) -  16) / 219;
        else
            ImgOut = (ImgIn / 2^(NbBits-8)        ) / 255;
        end
    end
elseif strcmp(Representation,'Lab')
    % Lab: scale linearly
    ImgOut(:,:,1) = ImgIn(:,:,1)/100*2^BitDepth;    % L [0, 100]
    ImgOut(:,:,2) = (ImgIn(:,:,2) + 86.185)/184.439*2^BitDepth; % a [-86.185, 98.254]
    ImgOut(:,:,3) = (ImgIn(:,:,3) + 107.863)/202.345*2^BitDepth; % b [-107.863, 94.482]
        
        

end
end