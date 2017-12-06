% videoSubSampleLAB
clc
clear all
close all

setdir(4); %% set directory based on user

nbFrameCount = 10; % number frames to subsample
fileFolder = [cd '\VideoFrames\Market3Clip4000r2_1920x1080p_50_hf_709_ct2020_444\'];
dirOutput = dir(fullfile(fileFolder,'*.exr'));
fileNames = {dirOutput.name}';

File = 'Market_1920x1080p_50_hf_709_ct2020_LABsubsampled_420_';


% filterlist = [string('MPEGMvF06')],string('MPEGSukey04'),...
%     string('MPEGMvF07'),string('MPEGSukey06'),string('MPEGYuki05'),...
%     string('lanczos3'),string('MPEGCfE'),string('MPEGSuperAnchor')];

% filterlist = [string('MPEGYukiB05'), string('NearestNeighbor'), string('MPEGMvF03')];
filterlist = [string('MPEGYukiB05'), string('MPEGMvFB03')];

numfilters = length(filterlist);

for nbFilter = 1:numfilters
    filter = filterlist(nbFilter)


    filename = ['CIELAB_' char(filter) '_' num2str(nbFrameCount) 'frames' '.yuv']; 

    for nbFrame =1: nbFrameCount
        nbFrame
        ImgIn = exrread(strcat(fileFolder,fileNames{nbFrame}));    
        rgbPQ = SMPTE_ST_2084(ImgIn, true, 10000); % apply PQ
        xyzimg = rgb2Xyz(rgbPQ,true); % convert to LAB via XYZ
        labimg = xyz2lab_pq_8(xyzimg,true); % with this conversion, L:(0,1), a,b:(-0.5,0.5)
        labq = QuantizeBT1361(labimg, true, 10, 'YCbCr'); % quantize lab into 0:1024
        labq = uint16(labq);

        [Asampled, Bsampled] = ChromaDownSampling(labq,'420',filter); % subsample with 'filter'

        wd = cd;
        cd([cd '\VideoFrames\compressed\Market_1920x1080p_50_hf_709_ct2020_LABsubsampled_420']);
        WriteFramePlanar(labq(:,:,1), Asampled, Bsampled, filename, 2,10);
        cd(wd)
    end

end

