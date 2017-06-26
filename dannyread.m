%code to read text files generated from output of report

%% copy this portion to read file
% this code will only read files generated using 
% ./report fiber:ends > filename.txt
clear;
clc;
% Initialize variables.
filename = 'C:\DannyData\temp sim\final reports\motor4000000.txt'; %change file name
delimiter = ' ';
%% Read columns of data as strings:
formatSpec = '%s%s%s%s%s%s%s%s%s%s%s%s%s%[^\n\r]';
%% Open the text file.
fileID = fopen(filename,'r');
%% Read columns of data according to format string.
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true,  'ReturnOnError', false);
%% Close the text file.
fclose(fileID);
%% Convert the contents of columns containing numeric strings to numbers.
% Replace non-numeric strings with NaN.
raw = [dataArray{:,1:end-1}];
numericData = NaN(size(dataArray{1},1),size(dataArray,2));
for col=[1,2,3,4,5,6,7,8,9,10,11,12,13]
    % Converts strings in the input cell array to numbers. Replaced non-numeric
    % strings with NaN.
    rawData = dataArray{col};
    for row=1:size(rawData, 1);
        % Create a regular expression to detect and remove non-numeric prefixes and
        % suffixes.
        regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
        try
            result = regexp(rawData{row}, regexstr, 'names');
            numbers = result.numbers;
            
            % Detected commas in non-thousand locations.
            invalidThousandsSeparator = false;
            if any(numbers==',');
                thousandsRegExp = '^\d+?(\,\d{3})*\.{0,1}\d*$';
                if isempty(regexp(thousandsRegExp, ',', 'once'));
                    numbers = NaN;
                    invalidThousandsSeparator = true;
                end
            end
            % Convert numeric strings to numbers.
            if ~invalidThousandsSeparator;
                numbers = textscan(strrep(numbers, ',', ''), '%f');
                numericData(row, col) = numbers{1};
                raw{row, col} = numbers{1};
            end
        catch me
        end
    end
end
%% Replace non-numeric cells with NaN
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),raw); % Find non-numeric cells
raw(R) = {NaN}; % Replace non-numeric cells
%% Create output variable
fiber = cell2mat(raw);
%% Clear temporary variables
clearvars filename delimiter formatSpec fileID dataArray ans raw numericData col rawData row regexstr result numbers invalidThousandsSeparator thousandsRegExp me R;

% OK...this code will save the file in a matrix with NaN in place of
% text or special characters...numbers will stay numbers. Our next aim is
% to remove all the NaNs

nanrows = isnan(fiber(:,1));
loc = find(nanrows == 1);
fiber(loc,:) = [];
dlmwrite('motor4000000.dat',fiber);

% Now you can be happy. You have eliminated all the NaNs
%Words of wisdom
%second coloumn is particle id
%fifth and sixth coloumn is x,y position of minus end
%seventh and eighth coloumn is x,y orientation of minus end
%tenth and eleventh coloumn is x,y position of positive end
%twelth and thirteenth coloumn is x,y orientation of positive end

%Now i'll plot position and orientation of negative ends of 'i'th'
%microtubule

%% painting section
figure;
hold;
for i = 1:10
loci = find(fiber(:,2) == i);
x = fiber(loci,5);
y = fiber(loci,6);
vx = fiber(loci,7);
vy = fiber(loci,8);
quiver(x,y,vx,vy);
theta(i) = atan(vy(end)/vx(end))*180/pi;
end
theta = theta';