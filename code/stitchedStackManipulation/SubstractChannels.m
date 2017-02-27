function SubstractChannels(stitchedDir,channels, offset,range,overwrite,destDir)
% SubstractChannels(stitchedDir,channels, offset,range,overwrite,destDir)
%
% INPUTS 
% stitchedDir - string, path of data folder
% channels	- [channel A, channel B, channel C];
% offset	- a scalar, add offset to the final channel, optional, by default 400.
% range		- the range of sections to be processed, optional, by defalt empty
%			- 1) a vector of length two [physical section, optical section]. Stitches one plane only
%			- 2) matrix defining the first and last planes to stitch: [physSec1,optSec1; physSecN,optSecN]. 
%			- 3) if empty, attempt to stitch from all available data directories. default. 
% overwrite	- 1, overwrite; 0, not. Optional, default 0.
% destDir	- string, path of target folder, optional, by defaul destDir = stitchedDir	
%
% make a new channel called '5' under the stitchedDir
%       ch5 = chA - ChB + offset;
%
% eg. SubstractChannels('stitchedImages_100',[2,1],200);
%     ch5 = ch2-ch1+200;
%
% Yunyun 2016-01-31, Basel


%Check channels are there

if nargin<6
    destDir=stitchedDir;
end
if nargin<5
    overwrite=0;
end
if nargin<4
    range=[];
end
if nargin<3
   offset=400; 
end

stitchedDirA=[stitchedDir filesep num2str(channels(1))];
stitchedDirB=[stitchedDir filesep num2str(channels(2))];


if ~isequal(exist(stitchedDirA),7)
    error('Channel A folder no found')
end

if ~isequal(exist(stitchedDirB),7)
    error('Channel B folder no found')
end


%list the tiffs in the two channel 
tifsA = dir([stitchedDirA,filesep,'*.tif']);
tifsB = dir([stitchedDirB,filesep,'*.tif']);


if isempty(tifsA) | isempty(tifsB)  | isempty(tifsB)
	error('No tiffs found in %s',stitchedDir); %update error

end

if isempty(range)
	%check that the are same length
	if length(tifsA)==length(tifsB)
	    fprintf('Found %d images\n',length(tifsA))
	else
    	error('file number is not equal in channel A, B')
	end

	for i=1:length(tifsA)
	   name{i}= tifsA(i).name;
	end

else
	if size(range,1)<=2 
		section=handleSectionArg(range);
	else
		error('input argument error: range ')
	end

	for i=1:size(section,1)
		name{i}=sprintf('section_%03d_%02d.tif',section(i,1),section(i,2));

	end

end



%make a target directory to keep them in
targetDir=[destDir filesep '5'];
mkdir(targetDir)

parfor ii=1:length(name)
    
    if exist(fullfile(targetDir,name{ii}), 'file')==2 & overwrite ==0 
        disp([ targetDir filesep name{ii} ' exists, SKIPPING'] )
    else
	%load tifA(ii)
    imA=stitchit.tools.openTiff([stitchedDirA filesep name{ii}]);
    imB=stitchit.tools.openTiff([stitchedDirB filesep name{ii}]);

    %average
    mu = imA;
    mu = imA-imB + offset;

    % write the average image
    imwrite(mu,[targetDir,filesep,name{ii}],'Compression','none');
    	disp([name{ii} ' processed'])
    end
end

%Make a file that says what the average was
fid = fopen([targetDir,filesep,'Info.txt'],'w');
try
fid = fopen([targetDir,filesep,'Info.txt'],'w');
fprintf(fid,'Ch05 = Ch%02d - Ch%02d + %d',channels(1),channels(2),offset);
catch
end
fclose(fid);

