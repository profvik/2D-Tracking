%% Heat Map code
clear;
clc;
diff = 5;
res = [0 0 0];
data = xlsread('C:\DannyData\DannyCode\20150709_MyLOVCharEX_4R_50uMATP_ch2_run3_frames200-400.xlsx');
np = max(data(:,5));
for i = 1:np
    loc = find(data(:,5) == i);
    temp = data(loc,:);
    len = size(temp);
    if len(1) > diff
        for j = 1:len(1)-diff
            x = temp(j,1);
            y = temp(j,2);
            vx = temp(j+diff,1)-temp(j,1);
            vy = temp(j+diff,2)-temp(j,2);
            v = sqrt(vx^2+vy^2);
            list = [x y v];
            res = cat(1,res,list);
        end
    end
end
res(1,:) = [];
scatter3(res(:,1),res(:,2),res(:,3));