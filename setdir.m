function setdir(user)
% set the working directory based on user's folder setup
% user:
%   1 = Sukey
%   2 = Yuki
%   3 = Ahmed
%   4 = Maurizio


%% Poll for user if its not provided
if(~exist('user'))
    userlist = [string('Sukey'),string('Yuki'),string('Ahmed'),string('Maurizio')];
    for ii=1:length(userlist)
        disp([string(ii) + '   ' + userlist(ii)]) 
    end
    user = input('Who are you?  ');
end
%%
%% Set your CD here
dirlist = [string('E:\term1\EECE541\CIELAB downsampling Team\MATLAB'),...
    string(' '), ...    % Yuki: enter your directory here
    string(' '), ...    % Ahmed: enter your directory here
    string('C:\Users\mvonf\Documents\SCHOOL\UBC_Grad\UBC_Fall2017\EECE541\CIELAB_downsampling_Team\MATLAB\')];
cd([dirlist{user}]);

% add all folders that contain Matlab code
addpath('ProvidedCode')
addpath('trunk')
addpath('ProvidedCode\openEXR')
addpath('ProvidedCode\Display')