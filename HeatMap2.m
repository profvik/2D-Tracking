%% Heat Map code
clear;
clc;
diff = 10; %difference between number of images to calculate speed
square = 8; %size of square to coarese grain image
sz = 512; %size of image
ng = uint8(sz/square); %number of grids into which image should be sampled
res = zeros(ng,ng); %matrix to store final image
ctr = ones(ng,ng); %matrix to store how many time a particle was detected in a grid
data = xlsread('C:\DannyData\DannyCode\20150709_MyLOVCharEX_4R_50uMATP_ch2_run3_frames200-400.xlsx'); %read data file
np = max(data(:,5)); %find number of particles in data
for i = 1:np
    disp(i); 
    loc = find(data(:,5) == i); %find track of i'th particle
    temp = data(loc,:);
    len = size(temp); %number of frames in which i'th partile was seen
    if len(1) > diff
        for j = 1:len(1)-diff
            xpos = uint8(temp(j,1)/square)+1; %change pixel position to grid location
            ypos = uint8(temp(j,2)/square)+1; %change pixel location to grid location
            vx = temp(j+diff,1) - temp(j,1); %x speed
            vy = temp(j+diff,2) - temp(j,2); %yspeed
            v = sqrt(vx^2+vy^2); % net speed
            res(ypos,xpos) = res(ypos,xpos) + v; %update heat map
            ctr(ypos,xpos) = ctr(ypos,xpos) + 1; %update counter
        end
    end
end
for i = 1:ng
    for j = 1:ng
        res(i,j) = res(i,j)/ctr(i,j); %average by counter number to find average speed in a grid
    end
end
res(:,:) = res(:,:)./max(max(res))*2; %scale speed from 0 to 2
imagesc(res);
dlmwrite('Danny001.dat',res); %write data to danny00n.dat