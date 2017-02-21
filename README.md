# Import AxoGraph X files into MATLAB

This MATLAB script is a modified version of the script provided with the data acquisition software [AxoGraph X](http://axograph.com/). It fixes a few problems with the original script.

## Example usage

```matlab
close all;
clear;

% Import an AxoGraph X chart
[data, hd] = importaxographx();
nChannels = hd.nDatCol-1;

% Plot all channels
figure('color', 'w');
for i = 1 : nChannels
    h(i) = subplot(nChannels, 1, i);
    plot(data(:,1), data(:,i+1));
    ylabel(hd.YCol(i+1).title);
end
xlabel(h(end),hd.YCol(1).title);

% Hide x-ticks for all but last plot
set(h, 'box', 'off');
set(h(1:end-1),'xcolor','w');
set(h(1:end-1),'xtick',[]);

% Link time axes for panning and zooming
linkaxes(h, 'x');
```
