%collapser for danny
%% this code creates a collapsed image for danny's experiments
clear;
clc;
% %% before you do anything extract boundaries
% databdr = imread('H:\New Danny\20170113\Substack (1-600).tif',1);
% uplimbdr = double(max(max(databdr)));
% imbdr = uint8(double(databdr)/uplimbdr*255);
% imeqbdr = imbdr; %histeq(imbdr);
% %imshow(imeq);
% [BWbdr xbd ybd] = roipoly(imeqbdr);
% emat = edge(BWbdr); %find edges from boundary
% se = strel('disk',3); %structural element of shape of disk
% dilim = imdilate(emat,se); %dilate edge image to get band
% locband = find(dilim == 1);
% newBW = uint8(BWbdr);
% %contim = zeros(512,512);
% %newBW(:,:) = 100;
% newBW(locband) = 5;
bdrdata = dlmread('bdr.dat');
xbd = bdrdata(:,1);
ybd = bdrdata(:,2);
%% now do something else
finim = uint8(zeros(512,512));
ini = 300;
fin = 500;
%n_file = 20; %number of files
filename = 'H:\New Danny\20170113\20170113_ch06_MyLOVChar_EX4R_1-4dilution_2mMATP_2mMMag_1mspf_600frames_150Xmag 05 - Copy.tif';
%xystep = 0.21; %micon/pix
%zstep = 0.41; %micron/frame
%str1 = 'H:\Ross Lab\San Diego\New data\ZSB\z-seriesbz';
%mat3d = zeros(512,512,n_file);
%matrec = zeros(512,512,n_file);
loc = [0 0 0];
for i = ini:fin
%for i = 1:n_file
    disp(i);
    %str2 = sprintf('%3.3d\n',i);
    %str3 = '.tif';
    %filename = strcat(str1,str2,str3);
    %data = imread(filename);
    data = uint8(sqrt(double(imread(filename,i))));
    bw = im2bw(data,0.05);
    filtim = uint8(medfilt2(bw,[2 2]));
    finim = max(finim,filtim);
end
imagesc(finim)
hold;
plot(xbd,ybd);