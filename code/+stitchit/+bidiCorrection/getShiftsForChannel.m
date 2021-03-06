function stats=getShiftForChannel(chan,everyNSections)
    % Get all shifts for a particular channel across all sections


    if nargin<2
        everyNSections=1;
    end

    section = handleSectionArg([]);
    section = section(section(:,2)==1,:);

    section = section(1:everyNSections:end,:);

    fprintf('Running over a total of %d sections\n', length(section))

    T=tic;
    parfor ii=1:length(section)
        tSection = section(ii,1);
        fprintf('Starting section %d\n',tSection)
        tmp=stitchit.bidiCorrection.getShiftForSection(tSection,chan);
        fprintf('Done section %d\n',tSection)

        if ~isempty(tmp)
            stats{ii}=tmp;
        end
    end

    fprintf('Finished processing channel %d in %0.1f seconds\n',chan,toc(T))
