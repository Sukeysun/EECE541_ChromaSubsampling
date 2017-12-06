% videoUpSampleLAB.m
% --
% import 4:2:0 .yuv frames, upsample to 4:4:4, convert to RGB, then save as
% a .exr for later analyzing in HDRTools

clc
clear all
close all

setdir(4); %% set directory based on user

% filterlist = [string('MPEGMvF06'),string('MPEGSukey04'),...
%     string('MPEGMvF07'),string('MPEGSukey06'),string('MPEGYuki05'),...
%     string('lanczos3'),string('MPEGCfE'),string('MPEGSuperAnchor')];

filterlist = [string('MPEGYuki0505'), string('NearestNeighbor'), string('MPEGMvF03')];


nbFrameCount = 10; % number frames in each video

for nbFilter = 1:length(filterlist)
    filter = char(filterlist(nbFilter))
    
    fileFolder = ['C:\Users\mvonf\Documents\SCHOOL\UBC_Grad\UBC_Fall2017\EECE541\CIELAB_downsampling_Team\HM-16.16\bin\vc2015\x64\Release\EECE541files\RECfiles\' filter '\'];
    dirOutput = dir(fullfile(fileFolder,'*.yuv'));
    fileNames = {dirOutput.name}';

    % make a new directory for this specific filter
    grandparentdir = [cd '\VideoFrames\compressed\Market_1920x1080p_50_hf_709_ct2020_LABsubsampled_444'];
    success1 = mkdir(grandparentdir,['\' filter]);

    for nbFile = 1:length(fileNames)    % go through all .yuv files in the directory
        fileNames(nbFile)

        % extract filter and QP from file name
        temp = char(fileNames(nbFile));
        file = temp(5:end-4);
%         filter = file(1:strfind(file,'_')-1);
        QP = file(end-1:end);

        % make new directory to save frames into
        parentdir = [grandparentdir '\' filter];
        success2 = mkdir(parentdir,['\' file]);

        for nbFrame =1: nbFrameCount % go through each frame in this video file
            nbFrame
            % import next frame, convert back to decimal, inverse quantize
            labimgcompressedq = ReadYUVFrame(strcat(fileFolder,fileNames{nbFile}), '420', 10, 1920, 1080, nbFrame, filter);
            labimgcompressedq = single(labimgcompressedq);
            labimgcompressed = QuantizeBT1361(labimgcompressedq, false, 10, 'YCbCr');
            % convert back to rgb
            xyzimgcompressed = xyz2lab_pq_8(labimgcompressed,false); 
            rgbPQcompressed = rgb2Xyz(xyzimgcompressed, false);
            exrcompressed = SMPTE_ST_2084(rgbPQcompressed, false, 10000);

            % remove imaginary pixels
            numcomplex = size(find(imag(exrcompressed)~=0)); % these are caused by rgbPQcompressed values<0
    %         disp('Number of imaginary pixel values in .exr file:')
    %         disp(numcomplex)
            exrcompressed(imag(exrcompressed) ~= 0) = 0; % eliminate imaginary pixels


            % save to correct directory
            wd = cd;
            if(success2)
                cd([parentdir '\' file]);
            else
                error('mkdir() error!');
            end
            filename = [file '_' num2str(nbFrame,'%05.f') '.exr'];
            exrwritechannels(filename, 'none', 'half', {'R', 'G', 'B'}, {exrcompressed(:,:,1),exrcompressed(:,:,2),exrcompressed(:,:,3)});
            cd(wd);
        end
    end
end


