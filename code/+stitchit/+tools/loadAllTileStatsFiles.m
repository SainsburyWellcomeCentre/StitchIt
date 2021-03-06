function TILESTATS = loadAllTileStatsFiles(chan)

% Loads all tile stats files .mat files
%
%  function tileStats = loadAllTileStatsFiles(chan)
%
% Purpose
% Load all tileStats.mat files in the raw data directory and return as a structure
% 
% Inputs
% chan - channel to load. Default 2
%
% Outputs
% tileStats - vector all tileStats structures
%
%
% Rob Campbell - Basel 2016

if ~exist('chan', 'var') || isempty(chan)
    chan = 2;
end

%Load ini file variables
userConfig=readStitchItINI;

param=readMetaData2Stitchit;
baseName=directoryBaseName;

if ~exist(userConfig.subdir.rawDataDir,'dir')
    error('%s can not find raw data directory: .%s%s',mfilename,filesep,userConfig.subdir.rawDataDir)
end


%Loop through all raw data directories and load tileStats files
D=dir(fullfile(userConfig.subdir.rawDataDir, [baseName,'*']));

numMissingFiles=0;
TILESTATS=[];
fprintf('Loading tileStats.')
for ii=1:length(D)
    if mod(ii,5)==0, fprintf('.'), end

    fname = fullfile(userConfig.subdir.rawDataDir, userConfig.subdir.preProcessDir, ...
        D(ii).name,sprintf('tileStats_ch%.0f.mat', chan));
    if ~exist(fname,'file') %Skip this directory if no tileStats.mat file is present and increment counter
        numMissingFiles=numMissingFiles+1;
        continue
    end

    load(fname)
    TILESTATS = [TILESTATS,tileStats];

end
fprintf('\n')


%Issue a warning if none were loaded or some are missing
if numMissingFiles==length(D)
    fprintf('Found no tileStats.mat files\n')
    TILESTATS=[];
    return
elseif numMissingFiles>0
    fprintf('Failed to find %d/%d tileStats.mat files\n',numMissingFiles,length(D))
end