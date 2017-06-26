%% This code tracks MTs in danny's data
% This code is meant to analyze .tif stacks of gliding filament assays
% which have an optical interface in them in conjunction with optically
% switchable motors. It was developed by Vikrant Yadav from the University
% of Massachusetts, Amherst and was later edited by Daniel Todd fromt the
% University of Massachusetts, Amherst.
clear;
clc;
%% Inputs
lowcut = 10; %any MT with fewer than this number of pixels will not be tracked
highcut = 900; %any MT with more than this number of pixels will not be tracked
currentpath = pwd; % Sets Current working directory for us to pick from
cd('C:\DannyData\DannyCode'); 
% Gets you to pick .tif files to analyze
[file, path] = uigetfile({'*.tif'},'Light Interface Data to Load', 'MultiSelect','on');
ims = imfinfo(file) ;% Get information about the image
numOfFrames = length(ims); % Create variable the length of the .tiff stack
height = ims(1).Height; % Dimensions of the images
width = ims(1).Width;

%% create average image for substraction
avim = 500; %number of images to average over
bkg = zeros(height,width);
for i = 1:avim
    imtemp = imread(file,i); %read image
    bkg = bkg + double(imtemp); %add images
end
bkg = uint16(bkg/avim); %average image

%% Main Body
% Identifies Particle Positions over the .tiff stack
%figure;
finalres = [0 0 0];
for i = 1:length(ims) ; 
    disp(i) ; % shows you the loop number you are on
    im = imread(file,i);% Load the image stack 
    %im = im(:,:,1);
    %im = uint8(im/256);
    im = abs(im - bkg);
    level = graythresh(im); %find optimum threshold for binarizing
    bw1 = im2bw(im,level); %binarize image
    filt1 = medfilt2(bw1,[3 3]); %use median filter to remove salt and pepper noise
    cc = bwconncomp(filt1); %find connected component
    num_conn = cc.NumObjects; %find number of connected components detected%
    for ii = 1:num_conn %loop over all detected objects
        pixelnum = size(cc.PixelIdxList{ii}); %check number of pixels in this object
        if pixelnum(1) > lowcut && pixelnum(1) < highcut %check if it lies between our size range
            list = cc.PixelIdxList{ii}; %if yes find index of pixels that make this particular object
            [y , x] = ind2sub([512 512],list); %convert linear index to (x,y) positions
            res(ii,2) = round(mean(x)); % Takes average to find center of object
            res(ii,1) = round(mean(y)); % Rounds them to the nearest integer value
        end
    end
    res(:,3) = round(i); % Puts timestamp/Frame # on each location
    scatter(res(:,1),res(:,2));
    axis([0 512 0 512]);
    getframe;
    finalres = cat(1,finalres,res); % Stacks the variables on top of each other for each iteration of the loop
    clear res;
end
%if i<30
%    scatter(res(:,1),res(:,2));
%end
finalres(1,:) = []; % Gets rid of first column
str1 = file; %text part of file name
str3 = '.txt';    %extension of file
str2 = num2str(i,'%1.4i'); %converts n to a 4digit string
filename = strcat(str1,str2,str3); % Compiles a filename from several strings
dlmwrite(filename, finalres);    %data is array that you want to write

%% Track Particles
% Use the track function to track particles frame to frame
locx = find(finalres(:,1) == 0);
locy = find(finalres(:,2) == 0);
loc = intersect(locx,locy);
finalres(loc,:) = [];
param.mem = 0;
param.quiet = 1;
param.good = 50;
param.dim = 2;
ptkltrack = track(finalres,20,param); % Uses track function and ignores anything that moves over 20 pixels in a single frame

%% plot trajectories
n = max(ptkltrack(:,4));
figure;
hold;
axis([0 512 0 512]);
for i = 1:n
    loc = find(ptkltrack(:,4) == i);
    temp = ptkltrack(loc,:);
    scatter(temp(:,1),temp(:,2),[],temp(:,3));
end
%% You have finished tracking......PARTY :)