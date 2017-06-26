%% This code tracks MTs in danny's data
clear;
clc;
%% Inputs
lowcut = 10; %any MT with fewer than this number of pixels will not be tracked
highcut = 900; %any MT with more than this number of pixels will not be tracked
im = imread('C:\DannyData\20150722_MyLOVCharEX_4R_50uMATP_ch3_run6_RGBOverlay.tif',50'); %read this image

%% split image into red and green channels
im1 = im(:,:,1);
im2 = im(:,:,2);

%% Main body
level = graythresh(im1); %find optimum threshold for binarizing
bw1 = im2bw(im1,level); %binarize image
filt1 = medfilt2(bw1,[3 3]); %use median filter to remove salt and pepper noise
cc = bwconncomp(filt1); %find connected component
num_conn = cc.NumObjects; %find number of connected components detected
imshow(im); % show image
hold; %hold image for overlaying detected objects later
for i = 1:num_conn %loop over all detected objects
    pixelnum = size(cc.PixelIdxList{i}); %check number of pixels in this object
    if pixelnum(1) > lowcut && pixelnum(1) < highcut %check if it lies between our size range
        list = cc.PixelIdxList{i}; %if yes find index of pixels that make this particular object
        [y x] = ind2sub([512 512],list); %convert linear index to (x,y) positions
        scatter(x,y,'.'); %plot this on top of original image
    end
end
%% You have finished tracking......PARTY :)