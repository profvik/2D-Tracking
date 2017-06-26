%This script extracts the region of light and write it into a file
%clear;
%clc;
data = imread('H:\Ross Lab\Danny Data\20150708_Field_Stop_Position_150x.tif',1);
uplim = double(max(max(data)));
im = uint8(double(data)/uplim*255);
imeq = histeq(im);
%imshow(imeq);
[BW xi yi] = roipoly(imeq);