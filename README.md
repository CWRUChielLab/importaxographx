# Import AxoGraph X files into MATLAB

This MATLAB script is a modified version of the script provided with the data
acquisition software [AxoGraph X](http://axograph.com/). It fixes a few
problems with the original script.

Additionally, a function for converting episodic data to continuous data is
provided.

## Example usage

```matlab
close all;
clear;

file = 'MyData.axgd';
nChannels = 4;

% Import an AxoGraph X chart
[data, hd] = importaxographx(file);

% Optionally convert the data from episodic format to continuous format
[data, hd] = episodic2continuous(data, hd, nChannels);

% Column 1 is time, and other columns are the channel data
timeTitle = hd.YCol(1).title;
channelTitles = convertCharsToStrings({hd.YCol(2:end).title});

% Plot all channels
figure('color', 'w');
for i = 1 : nChannels
    h(i) = subplot(nChannels, 1, i);
    plot(data(:,1), data(:,i+1));
    ylabel(channelTitles(i));
end
xlabel(h(end), timeTitle);

% Hide x-ticks for all but last plot
set(h, 'box', 'off');
set(h(1:end-1), 'xcolor', 'w');
set(h(1:end-1), 'xtick', []);

% Link time axes for panning and zooming
linkaxes(h, 'x');
```
