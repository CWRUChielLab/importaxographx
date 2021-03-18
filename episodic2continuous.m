% After importing data from an AxoGraph X file, this function can be used
% to convert the data from episodic format (many short columns with
% repeating names, one set of columns for each episode) to continuous
% format (one column per channel, with episodes concatenated one after
% another into longer columns). Performs some checks to make sure the data
% has the expected shape.

function [newData, newHd] = episodic2continuous(data, hd, nChannels)

    % Verify that the data column naming pattern is consistent with
    % episodic data (channel names should repeat every nChannels columns,
    % once for each episode)
    nDataColumns = width(data) - 1; % time is first column
    assert(mod(nDataColumns, nChannels) == 0, sprintf([ ...
        'The number of data columns (%d) is not divisible by the ' ...
        'specified number of channels (%d), as is expected for an ' ...
        'episodic data file. Is the number of channels set ' ...
        'correctly?'], nDataColumns, nChannels));
    nEpisodes = nDataColumns / nChannels;
    for i = 1:nChannels
        channelTitle = hd.YCol(i+1).title;
        for j = 1:nEpisodes
            columnTitle = hd.YCol((j-1)*nChannels+i+1).title;
            assert(strcmp(columnTitle, channelTitle), sprintf([ ...
                'Column titles do not repeat every %d columns, as is ' ...
                'expected for an episodic data file with %d channels. ' ...
                'Is the number of channels set correctly?'], nChannels, ...
                nChannels))
        end
    end

    % Perform concatenation of data columns
    newLength = length(data) * nEpisodes;
    newData = zeros(newLength, nChannels + 1);
    for i = 1:nChannels
        newData(:,i+1) = reshape(data(:, i+1:nChannels:end), 1, newLength);
    end

    % Fill first column with time values
    tStart = data(1, 1);
    samplingPeriod = data(2, 1) - data(1, 1);
    newData(:,1) = (0:newLength-1) * samplingPeriod + tStart;

    % Update header
    newHd = hd;
    newHd.nDatCol = nChannels + 1; % includes time column
    newHd.YCol = newHd.YCol(1:nChannels+1);
    for i = 1:nChannels + 1
        newHd.YCol(i).nPoints = newLength;
    end
