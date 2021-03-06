function writeCombCorCoefs(imStack,thisDirName,combCorChans)
    % Inputs
    % imStack - A cell array of image stacks. The rows are channels and the
    %           columns are optical sections.
    % thisDirName - a string defining the directory where we will save these data
    


    %fprintf('Calculating phase correction\n')
    userConfig=readStitchItINI;
    nBands = userConfig.analyse.nbands;

    for thisLayer=1:size(imStack,2)
        %Build image array for comb correction by averaging all data arrays across the requested channels
        thisLayerData = imStack(combCorChans,thisLayer);
        combCorData = cat(4,thisLayerData{:});
        combCorData = mean(combCorData,4);

        fname=fullfile(thisDirName,sprintf('phaseStats_%02d.mat',thisLayer)); %save file name
        fprintf('Calculating phase correction coefs for %s\n',fname)

        phaseShifts = calcPhaseDelayShifts(combCorData,nBands);
        save(fname,'phaseShifts');
    end

