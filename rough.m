clear;
clc;

finres = zeros(512,512);
fini = 1;
fend = 50;
diff = 2;
file = 'E:\Bryant_Lab_Data\Good\20170113_ch05_MyLOVChar_EX4R_1-4dilution_2mMATP_2mMMag_1mspf_600frames_150Xmag 01.tif';
BWbdr = imread('BWbdr.tif');
newBW = imread('newBW.tif');
vec = dlmread('vertex.dat');
xbd = vec(:,1);
ybd = vec(:,2);

for i = fini:fend-diff
    disp(i); %show the frame it is workin on
    imini = imread(file,i); %read initial image
    locb = find(imini > 200);
    modimini = zeros(size(imini));
    modimini(locb) = 1;
    imfin = imread(file,i+diff); %read image after 'diff'
    locb = find(imfin > 200);
    modimfin = zeros(size(imfin));
    modimfin(locb) = 1;
    imdiff = modimfin - modimini;
    imagesc(imdiff);
    finloc = find(imdiff == 1);
    finres(finloc) = i-fini;
%     imdiff8 = uint8(sqrt(double(imdiff)));
%     gt8 = graythresh(imdiff8);
%     bw8 = im2bw(imdiff8,gt8);
%     f8 = bwareaopen(bw8,25,4);
%     imshow(f8);
    getframe();
    %waitforbuttonpress()
end
imagesc(finres);
hold;
plot(xbd,ybd)

%% this part made the heat map for danny
% clear;
% clc;
% data1 = dlmread('C:\DannyData\DannyCode\HeatMap\Danny0001.dat');
% data2 = dlmread('C:\DannyData\DannyCode\HeatMap\Danny0002.dat');
% data3 = dlmread('C:\DannyData\DannyCode\HeatMap\Danny0003.dat');
% data4 = dlmread('C:\DannyData\DannyCode\HeatMap\Danny0004.dat');
% data5 = dlmread('C:\DannyData\DannyCode\HeatMap\Danny0005.dat');
% data6 = dlmread('C:\DannyData\DannyCode\HeatMap\Danny0006.dat');
% for i = 1:64
%     for j = 1:64
%         c1 = 1;
%         if data1(i,j) > 0
%             c1 = c1+1;
%         end
%         if data2(i,j) > 0
%             c1 = c1+1;
%         end
%         if data3(i,j) > 0
%             c1 = c1+1;
%         end
%         if data4(i,j) > 0
%             c1 = c1+1;
%         end
%         if data5(i,j) > 0
%             c1 = c1+1;
%         end
%         if data6(i,j) > 0
%             c1 = c1+1;
%         end
%         res(i,j) = (data1(i,j)+data2(i,j)+data3(i,j)+data4(i,j)+data5(i,j)+data6(i,j))/c1;
%     end
% end
% imagesc(res);