%%this code calculates correlation function for danny
clear;
clc;
datatot = dlmread('motor40000.dat');
data(:,1) = datatot(:,7);
data(:,2) = datatot(:,8);
data(:,3) = datatot(:,2);
%% meat part
nmax = max(data(:,3));
delt = 900; %amount of time over which you want to check decay in correlation
endres = zeros(delt,2);
%figure;
%hold;
for pctr = 1:nmax
    disp(pctr);
    loc = find(data(:,3) == pctr);
    smdata = data(loc,1:2);
    %scatter(smdata(:,1),smdata(:,2));
    s = size(smdata); %check length of data
    for i = 1:delt %loop over times of interest
        %disp(i); %show something
        corr = 0; %set initial value to 0
        ctr = 1; %set this to 1: used later for averaging
        for j = 1:s(1)-i %loop over all particles
            vec1 = [smdata(j,1) smdata(j,2)]; %orientation in first frame
            vec2 = [smdata(j+i,1) smdata(j+i,2)]; %orientation after few steps
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
%plot(endres(:,1),endres(:,2)) %plot results
dlmwrite('corr40000.dat',endres);

%%this code calculates correlation function for danny
clear;
clc;
datatot = dlmread('motor120000.dat');
data(:,1) = datatot(:,7);
data(:,2) = datatot(:,8);
data(:,3) = datatot(:,2);
%% meat part
nmax = max(data(:,3));
delt = 900; %amount of time over which you want to check decay in correlation
endres = zeros(delt,2);
%figure;
%hold;
for pctr = 1:nmax
    disp(pctr);
    loc = find(data(:,3) == pctr);
    smdata = data(loc,1:2);
    %scatter(smdata(:,1),smdata(:,2));
    s = size(smdata); %check length of data
    for i = 1:delt %loop over times of interest
        %disp(i); %show something
        corr = 0; %set initial value to 0
        ctr = 1; %set this to 1: used later for averaging
        for j = 1:s(1)-i %loop over all particles
            vec1 = [smdata(j,1) smdata(j,2)]; %orientation in first frame
            vec2 = [smdata(j+i,1) smdata(j+i,2)]; %orientation after few steps
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
%plot(endres(:,1),endres(:,2)) %plot results
dlmwrite('corr120000.dat',endres);

%%this code calculates correlation function for danny
clear;
clc;
datatot = dlmread('motor240000.dat');
data(:,1) = datatot(:,7);
data(:,2) = datatot(:,8);
data(:,3) = datatot(:,2);
%% meat part
nmax = max(data(:,3));
delt = 900; %amount of time over which you want to check decay in correlation
endres = zeros(delt,2);
%figure;
%hold;
for pctr = 1:nmax
    disp(pctr);
    loc = find(data(:,3) == pctr);
    smdata = data(loc,1:2);
    %scatter(smdata(:,1),smdata(:,2));
    s = size(smdata); %check length of data
    for i = 1:delt %loop over times of interest
        %disp(i); %show something
        corr = 0; %set initial value to 0
        ctr = 1; %set this to 1: used later for averaging
        for j = 1:s(1)-i %loop over all particles
            vec1 = [smdata(j,1) smdata(j,2)]; %orientation in first frame
            vec2 = [smdata(j+i,1) smdata(j+i,2)]; %orientation after few steps
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
%plot(endres(:,1),endres(:,2)) %plot results
dlmwrite('corr240000.dat',endres);

%%this code calculates correlation function for danny
clear;
clc;
datatot = dlmread('motor400000.dat');
data(:,1) = datatot(:,7);
data(:,2) = datatot(:,8);
data(:,3) = datatot(:,2);
%% meat part
nmax = max(data(:,3));
delt = 900; %amount of time over which you want to check decay in correlation
endres = zeros(delt,2);
%figure;
%hold;
for pctr = 1:nmax
    disp(pctr);
    loc = find(data(:,3) == pctr);
    smdata = data(loc,1:2);
    %scatter(smdata(:,1),smdata(:,2));
    s = size(smdata); %check length of data
    for i = 1:delt %loop over times of interest
        %disp(i); %show something
        corr = 0; %set initial value to 0
        ctr = 1; %set this to 1: used later for averaging
        for j = 1:s(1)-i %loop over all particles
            vec1 = [smdata(j,1) smdata(j,2)]; %orientation in first frame
            vec2 = [smdata(j+i,1) smdata(j+i,2)]; %orientation after few steps
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
%plot(endres(:,1),endres(:,2)) %plot results
dlmwrite('corr400000.dat',endres);

%%this code calculates correlation function for danny
clear;
clc;
datatot = dlmread('motor1200000.dat');
data(:,1) = datatot(:,7);
data(:,2) = datatot(:,8);
data(:,3) = datatot(:,2);
%% meat part
nmax = max(data(:,3));
delt = 900; %amount of time over which you want to check decay in correlation
endres = zeros(delt,2);
%figure;
%hold;
for pctr = 1:nmax
    disp(pctr);
    loc = find(data(:,3) == pctr);
    smdata = data(loc,1:2);
    %scatter(smdata(:,1),smdata(:,2));
    s = size(smdata); %check length of data
    for i = 1:delt %loop over times of interest
        %disp(i); %show something
        corr = 0; %set initial value to 0
        ctr = 1; %set this to 1: used later for averaging
        for j = 1:s(1)-i %loop over all particles
            vec1 = [smdata(j,1) smdata(j,2)]; %orientation in first frame
            vec2 = [smdata(j+i,1) smdata(j+i,2)]; %orientation after few steps
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
%plot(endres(:,1),endres(:,2)) %plot results
dlmwrite('corr1200000.dat',endres);
%% only useful section
disp('as always...party');