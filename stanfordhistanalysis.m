%histogram analysis of new data
clear;
clc;
step = 10;
data = dlmread('C:\DannyData\DannyCode\Jan13Ch5VecBand.csv');
dataoff = data(:,1:2);
dataon = data(:,3:4);
%% cleaning section
offzero = find(dataoff(:,1) == 0);
onzero = find(dataon(:,1) == 0);
if isempty(offzero) ~= 1
    dataoff(offzero,:) = [];
end
if isempty(onzero) ~= 1
    dataon(onzero,:) = [];
end
%% loop part 1
s = size(dataoff);
ctr = 1;
for theta = -180:step:180
    disp(theta);
    resoff(ctr,1) = theta+5;
    resoff(ctr,2) = 0;
    resoff(ctr,3) = 0;
    datain = [0];
    for i = 1:s(1)
        if dataoff(i,1) >= theta && dataoff(i,1) < theta+step
            datain = cat(1,datain,[dataoff(i,2)]);
        end
    end
    disp(datain);
        datain(1) = [];
        if isempty(datain) ~= 1
            resoff(ctr,2) = mean(datain);
            resoff(ctr,3) = std(datain);
    end
    ctr = ctr + 1;
    clear datain;
end
resoff;

%% loop part 2
s = size(dataon);
ctr = 1;
for theta = -180:step:180
    disp(theta);
    reson(ctr,1) = theta+5;
    reson(ctr,2) = 0;
    reson(ctr,3) = 0;
    dataout = [0];
    for i = 1:s(1)
        if dataon(i,1) >= theta && dataon(i,1) < theta+step
            dataout = cat(1,dataout,[dataon(i,2)]);
        end
    end
    disp(dataout);
        dataout(1) = [];
        if isempty(dataout) ~= 1
            reson(ctr,2) = mean(dataout);
            reson(ctr,3) = std(dataout);
    end
    ctr = ctr + 1;
    clear dataout;
end
reson;