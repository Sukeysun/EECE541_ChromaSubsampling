function [ChromaA, ChromaB] = ChromaDownSamplingLAB(Img, Sampling, Filter)
%
% Syntax:  ChromaDownsampling(Img, Sampling, FilterSampling)
%
% Inputs:
%    -Img: Image to add to the file in LAB format
%    -Sampling: chroma sampling 
%    -Filter: filter used for sampling
%
% Outputs:
%    -ChromaA: first chroma channel
%    -ChromaB: second chroma channel
%
% Example:
%    [ChromaA, ChromaB] = ChromaDownSampling(Img, '420', 'MPEG_CfE')
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: 
% Author: Ronan Boitard
% University of British Columbia, Vancouver, Canada
% email: rboitard.w@gmail.com
% Website: http://http://www.ece.ubc.ca/~rboitard/
% Created: 28-Oct-2015; Last revision: 2-Nov-2015
% Modified: 24-Oct-2017 by Maurizio von Flotow for LAB color space

%---------------------------- BEGIN CODE ----------------------------------
if(~exist('Sampling'))
    Sampling = '420';
end
if(~exist('Filter'))
    Filter = 'lanczos3';
end

if strcmp(Sampling, '420')
    % write U component, downsample and reshaped
    if strcmp(Filter,'lanczos3')
        ChromaA = imresize(Img(:,:,2), 0.5, 'lanczos3', 'Antialiasing', true);
        ChromaB = imresize(Img(:,:,3), 0.5, 'lanczos3', 'Antialiasing', true);
    elseif strfind( Filter, 'MPEG')
        % see CfE section B.1.5.5
        % A. Luthra, E. Francois, and W. Husak, “Call for
        % Evidence (CfE) for HDR and WCG Video Coding,” in ISO/IEC
        % JTC1/SC29/WG11 MPEG2014/N15083, 2015.
        % Several version exist
        % -Mpeg_CfE: original version implemented in HDR tools
        % -Mpeg_CfE_Float: shifting is replaced by division and rounding, no quantization
        % -Mpeg_SuperAnchor: change of phase for the vertical filter, adding luma correstion through closedLoop iteration
        % -Mpeg_SuperAnchor_Float: shifting is replaced by division and rounding, no quantization, phase is 0 no 0.5
        W_Filter = [1 6 1];
        if strfind( Filter, 'CfE')
            H_Filter = [0 4 4]';
        else % New anchor generation with change of phase
            H_Filter = [1 6 1]';
        end
        offset   = 32;
        shift    = 6;
        for Chroma = 2 : 3
            if strfind( Filter, 'Float')
                s  = double(Img(:,:,Chroma)); % input chroma
            else % quantization before chroma subsampling
                s  = double(uint32(Img(:,:,Chroma))); % input chroma
            end
            
            % Horizontal downsampling - associated with width
            f  = imfilter(s, W_Filter, 'replicate');
            f  = f(:,1:2:end);
            % Vertical downsampling - associated with height
            r  = imfilter(f, H_Filter, 'replicate') ;
            r  = r(1:2:end, :);
            
            if strfind( Filter, 'Float')
                r  = (r + offset) / 2^shift;
            else
                % Shift instead of division
                r  = double(bitshift(uint32(r + offset), -shift));
            end
            if Chroma == 2
                ChromaA = r;
            else
                ChromaB = r;
            end
        end
    end
    elseif strcmp(Sampling, '422')
        ChromaA = Img(:, 1 : 2 : end, 2); % 4:2:2
        ChromaB = Img(:, 1 : 2 : end, 3); % 4:2:2
    elseif strcmp(Sampling, '444')
        ChromaA = Img(:, :, 2); % 4:4:4
        ChromaB = Img(:, :, 3); % 4:4:4
    else
    disp('Wrong Value for chroma sampling: 0 (4:2:0), 2 (4:2:2) or 4 (4:4:4)');
    throw(err);
end
end
%--------------------------- END OF CODE ----------------------------------
% Header generated using two templates:
% - 4908-m-file-header-template
% - 27865-creating-function-files-with-a-header-template

