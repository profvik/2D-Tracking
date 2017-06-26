%% anglecorr2....this code measures angle by checking difference in positions
%this code calculates correlation function for danny
clear;
clc;
step = 10; %step for measuring angle
datatot = dlmread('motor400000.dat');
data(:,1) = datatot(:,5);
data(:,2) = datatot(:,6);
data(:,3) = datatot(:,2);
%% meat part
nmax = max(data(:,3));
delt = 900; %amount of time over which you want to check decay in correlation
endres = zeros(delt,2);
figure;
hold;
for pctr = 1:nmax
    disp(pctr);
    loc = find(data(:,3) == pctr);
    smdata = data(loc,1:2);
    %scatter(smdata(:,1),smdata(:,2));
    d = size(smdata); %check length of data
    for k = 1:d(1)-step
        thdata(k,1) = atan((smdata(k+step,2)-smdata(k,2))/(smdata(k+step,1)-smdata(k,1)));
    end
    s = size(thdata);
    for i = 1:delt %loop over times of interest
        %disp(i); %show something
        corr = 0; %set initial value to 0
        ctr = 1; %set this to 1: used later for averaging
        for j = 1:step:s(1)-i %loop over all particles
            
            vec1 = [cos(thdata(j,1)) sin(thdata(j,1))]; %orientation in first frame
            vec2 = [cos(thdata(j+i,1)) sin(thdata(j+i,1))]; %orientation after few steps
            corr = corr + dot(vec1,vec2); %update total correlation
            ctr = ctr + 1; %update ctr
        end
        finres(i,1) = i;
        finres(i,2) = corr/ctr; %take average
    end
    endres(:,1) = finres(:,1);
    endres(:,2) = endres(:,2)+finres(:,2);
end
endres(:,2) = endres(:,2)/10;
endres(:,1) = endres(:,1)*0.02;
plot(endres(:,1),endres(:,2)) %plot results
dlmwrite('corr400000.dat',endres);
%% only useful section
disp('as always...party');