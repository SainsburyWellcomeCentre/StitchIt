function baseName=directoryBaseName(parameterFile)
% Get directory base name (i.e. the common stem of each section directory) from the acquisition parameter file
%
% function baseName=directoryBaseName(parameterFile)
%
%
% Purpose
% Data from each section are stored in a different directory. We need to know the 
% names of these directories to find the raw data. This function determines this.
%
% INPUTS
% parameterFile (optional) - the name of the file that contains the acquisition
%     parameters. e.g. this would be the "Mosaic" file for a TissueCyte system 
%     or a "recipe" file for a BakingTray system. If not supplied, StitchIt will
%     search for the file based on the system being used.
%
%
% OUTPUT
% baseName - string defining the data directory base name
%
%
% e.g.
% if the acquisition system is a TissueCyte, the Mosaic file might be 
% called "Mosaic_MV_140502_MV_18.txt". In this case, baseName will be "MV_140502_MV_18-"
% For a BakingTray system, baseName is obtained from fields in the recipe file.
%
%
% Rob Campbell - Basel 2014
% 
% Also see: getTiledAcquisitionParamFile

if nargin<1
    parameterFile=getTiledAcquisitionParamFile;
end


if isempty(parameterFile)
    error('Can not find a BakingTray recipe file in the current directory\n')
end

params = stitchit.yaml.ReadYaml(parameterFile);

baseName = [params.sample.ID,'-'];
