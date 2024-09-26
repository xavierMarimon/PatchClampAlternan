function [voltage, current, time, sweepChange, sweepIndx]=loadascPatchClamp(filename)
%IMPORTFILE Import numeric data from a text file as a matrix.
%   data = loadascPatchClamp(FILENAME)
%   Reads data from text file FILENAME for the default selection.
%
%   data = loadascPatchClamp(FILENAME, STARTROW, ENDROW)
%   Reads data from rows STARTROW through ENDROW of text file FILENAME.
%
% Example:
%   data = loadascPatchClamp('HAM101028_28_U.asc', 1, 54091);

%% Initialize variables.
    startRow = 1;
    endRow = inf;

%% Read columns of data as text:
% For more information, see the TEXTSCAN documentation.
formatSpec = '%8s%18s%18s%18s%18s%18s%18s%18s%s%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to the format.
% This call is based on the structure of the file used to generate this code. If an error occurs for a different file, try regenerating the code from the Import Tool.
textscan(fileID, '%[^\n\r]', startRow(1)-1, 'WhiteSpace', '', 'ReturnOnError', false);
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', '', 'WhiteSpace', '', 'TextType', 'string', 'ReturnOnError', false, 'EndOfLine', '\r\n');
for block=2:length(startRow)
    frewind(fileID);
    textscan(fileID, '%[^\n\r]', startRow(block)-1, 'WhiteSpace', '', 'ReturnOnError', false);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', '', 'WhiteSpace', '', 'TextType', 'string', 'ReturnOnError', false, 'EndOfLine', '\r\n');
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

%% Close the text file.
fclose(fileID);

%% Convert the contents of columns containing numeric text to numbers.
% Replace non-numeric text with NaN.
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = mat2cell(dataArray{col}, ones(length(dataArray{col}), 1));
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));

for col=[1,2,3,4,5,6,7,8,9]
    % Converts text in the input cell array to numbers. Replaced non-numeric text with NaN.
    rawData = dataArray{col};
    for row=1:size(rawData, 1)
        % Create a regular expression to detect and remove non-numeric prefixes and suffixes.
        regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
        try
            result = regexp(rawData(row), regexstr, 'names');
            numbers = result.numbers;
            
            % Detected commas in non-thousand locations.
            invalidThousandsSeparator = false;
            if numbers.contains(',')
                thousandsRegExp = '^[-/+]*\d+?(\,\d{3})*\.{0,1}\d*$';
                if isempty(regexp(numbers, thousandsRegExp, 'once'))
                    numbers = NaN;
                    invalidThousandsSeparator = true;
                end
            end
            % Convert numeric text to numbers.
            if ~invalidThousandsSeparator
                numbers = textscan(char(strrep(numbers, ',', '')), '%f');
                numericData(row, col) = numbers{1};
                raw{row, col} = numbers{1};
            end
        catch
            raw{row, col} = rawData{row};
        end
    end
end


%% Replace non-numeric cells with NaN
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),raw); % Find non-numeric cells
raw(R) = {NaN}; % Replace non-numeric cells

%% Acces data
data = cell2mat(raw);
data(sum(isnan(data), 2) > 1, :) = [];

%% Create time vector
time_temp = data(1:end,1);
dt = time_temp(2)-time_temp(1);
time=dt*(1:length(time_temp));

%Find zeros
sweepChange=find(time_temp==0);

%Number of samples
N=length(time_temp);

%Number of sweeps
Nsweep=length(sweepChange);

%Initialize sweep index
sweepIndx=zeros(1, N);

%Loop over sweeps
for sweepCount=1:Nsweep
    
    %Find last sweep
    if sweepCount==Nsweep
       sweepIndx(sweepChange(sweepCount):N)=sweepCount;
    else
        %Replace by sweep current sweep counter
        sweepIndx(sweepChange(sweepCount):sweepChange(sweepCount+1)-1)=sweepCount;
    end  
end

%Acces current
current=data(1:end,3);

%Acces voltage
voltage=data(1:end,7);

%Convert to mV
voltage=voltage*1000;

%Convert to nA
current=current*10^9;

end
