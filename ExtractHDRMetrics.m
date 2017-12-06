% ExtractHDRMetrics.m
% Extracts the line of averaged metrics from an HDRMetrics file.
% Set to loop over a batch of filters and QP values.
clc
clear all
close all

setdir(4); %% set directory based on user

scene       = char('Market');
filedirbaseMetrics = char('C:\Users\mvonf\Documents\SCHOOL\UBC_Grad\UBC_Fall2017\EECE541\CIELAB_downsampling_Team\HDRTools16\HDRTools-master-fa1e8ed7695e084a2cfb5319318b51ea671e69ba\bin\EECE541files\HDRMetricResults\');
filedirbaseHM = char('C:\Users\mvonf\Documents\SCHOOL\UBC_Grad\UBC_Fall2017\EECE541\CIELAB_downsampling_Team\HM-16.16\bin\vc2015\x64\Release\EECE541files\CompressionResults\');
datanames = ["tPSNR-X", "tPSNR-Y","tPSNR-Z","tPSNR-XYZ","tOSNR-XYZ",...
        "PSNR_DE100","PSNR_MD0100","PSNR_L0100","Time"];

% filter(1).name = char('MPEGMvF07');
% filter(2).name = char('lanczos3');
% filter(3).name = char('MPEGCfE');
% filter(4).name = char('MPEGSukey04');
% filter(5).name = char('MPEGSukey06');
% filter(6).name = char('MPEGYuki05');
% filter(7).name = char('MPEGSuperAnchor');
% filter(8).name = char('MPEGMvF06');

filterlist = [string('MPEGMvF06'), string('MPEGMvF07'),string('MPEGSukey06'),...
    string('MPEGYuki05'), string('lanczos3'),string('MPEGCfE'),string('MPEGSuperAnchor'),...
    string('MPEGYuki0505'),  string('MPEGMvF03')]; 
%string('NearestNeighbor'),string('MPEGSukey04')
numfilters = length(filterlist);

for kk=1:numfilters
    filter(kk).name = char(filterlist(kk));
    filter(kk).QP(1).QPval = 22;
    filter(kk).QP(2).QPval = 29;
    filter(kk).QP(3).QPval = 32;
    filter(kk).QP(4).QPval = 34;
end

for filtnum = 1:numfilters
    for QPnum = 1:length(filter(filtnum).QP)
        filedirMetrics  = [filedirbaseMetrics filter(filtnum).name];
        FileNameMetrics = [filedirMetrics '\HDRMetrics_' scene '_' filter(filtnum).name '_QP' num2str(filter(filtnum).QP(QPnum).QPval) '.txt'];

        filedirHM       = [filedirbaseHM filter(filtnum).name];
        FileNameHM      = [filedirHM '\CompressionLog_' scene '_' filter(filtnum).name '_QP' num2str(filter(filtnum).QP(QPnum).QPval) '.txt'];

        % Extract Metrics from HDRMetrics file:
        Key      = 'D_Avg';
%        % Import text file and select lines starting with the Key string:
        Str     = fileread(FileNameMetrics);
        CStr    = strsplit(Str, '\n');
        Match   = strncmp(CStr, Key, length(Key));
        CStr    = CStr(Match);
        temp    = char(CStr);
        dataChar = temp(10:end);

        findzero = strfind(dataChar,' ');
        filter(filtnum).QP(QPnum).data = str2num(char(strsplit(dataChar)));
       
        % Extract Bitrate from HM files:
        Key2      = 'Bytes written to file:';
        % Import text file and select lines starting with the Key string:
        Str2     = fileread(FileNameHM);
        CStr2    = strsplit(Str2, '\n');
        Match2   = strncmp(CStr2, Key2, length(Key2));
        CStr2    = CStr2(Match2);
        Start   = cell2mat(strfind(CStr2,'('))+1;
        
        temp2    = char(CStr2);
        dataChar2 = temp2(Start:end-7);
        filter(filtnum).QP(QPnum).bitrate = str2num(dataChar2);
    end
end

figure
% combine data for plotting
for filtnum = 1:numfilters
    filter(filtnum).QPvec = [filter(filtnum).QP(1).QPval, filter(filtnum).QP(2).QPval,...
        filter(filtnum).QP(3).QPval, filter(filtnum).QP(4).QPval];
    filter(filtnum).bitratevec = [filter(filtnum).QP(1).bitrate, filter(filtnum).QP(2).bitrate,...
        filter(filtnum).QP(3).bitrate, filter(filtnum).QP(4).bitrate];
    filter(filtnum).deltaEvec = [filter(filtnum).QP(1).data(6), filter(filtnum).QP(2).data(6),...
        filter(filtnum).QP(3).data(6), filter(filtnum).QP(4).data(6)];

legend(filter(filtnum).name)
if(strcmp(filter(filtnum).name,'MPEGMvF03') | strcmp(filter(filtnum).name,'MPEGYuki0505'))
    plot(filter(filtnum).bitratevec, filter(filtnum).deltaEvec,'--')
else
    plot(filter(filtnum).bitratevec, filter(filtnum).deltaEvec)
end
hold on

end
 Legend=cell(numfilters,1)
 for filtnum=1:numfilters
   Legend{filtnum}=filter(filtnum).name;
 end
 legend(Legend)
title('Filter Comparison')
ylabel('PSNR deltaE')
xlabel('Bitrate (kbit/s)')
ylim([30.28 30.7])
xlim([0.2 1.8e4])
legend(Legend)
grid




% findnum = strfind(dataChar,

% % Create new file and write matching lines:
% fid = fopen(NewFile, 'w');
% if fid == -1
%   error('Cannot create new file: %s', NewFile);
% end
% fprintf(fid, '%s\n', dataStr{:});
% fclose(fid);
