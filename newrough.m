%rough document for danny's code
clear;
clc;
lowcut = 10;
highcut = 900;
im = imread('C:\DannyData\20150722_MyLOVCharEX_4R_50uMATP_ch3_run6_RGBOverlay.tif',1);
im1(:,:) = im(:,:,1);
level = graythresh(im1);
bw = im2bw(im1,level);
figure; imshow(bw);
filtim = medfilt2(bw,[3 3]);
figure; imshow(filtim);
cc = bwconncomp(filtim); %find connected component
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
 figure; imshow(filtim);
 hold;
 scatter(res(:,2),res(:,1));
 
 %% choose a number
 i = 22;
 tmplist = cc.PixelIdxList{i};
 [tempy , tempx] = ind2sub([512 512], tmplist);
  %ptemp = polyfit(tempx, tempy, 2);
 %fitx = min(tempx):max(tempx);
 %fity = ptemp(1)*fitx.^2+ptemp(2)*fitx+ptemp(3);
 %scatter(tempx,tempy);
 %hold;
 %plot(fitx,fity);