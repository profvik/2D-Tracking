%%continuation from rough 2
tempx = tempx - min(tempx) + 1;
tempy = tempy - min(tempy) + 1;
reconim = zeros(max(tempx),max(tempy));
len = size(tempx);
for i = 1:len(1)
    reconim(tempx(i),tempy(i)) = 1;
end
binrec = im2bw(reconim);
myfilt = fspecial('gaussian',10,2);
smoothrec = imfilter(binrec,myfilt);
%figure; imshow(smoothrec);
skelrec = bwmorph(smoothrec,'skel',Inf);
%figure; imshow(skelrec);
endrec = bwmorph(skelrec,'endpoints');
%figure; imshow(endrec);
[epx epy] = find(endrec == 1);
cx = floor(max(tempx)/2);
cy = floor(max(tempy)/2);
ep(:,1) = epx;
ep(:,2) = epy;
ep(:,3) = (ep(:,1)-cx).^2 + (ep(:,2)-cy).^2;
[ep2 epi] = sort(ep(:,3),'descend');
imshow(binrec);
hold;
scatter(ep(epi(1),2),ep(epi(1),1),'red');
scatter(ep(epi(2),2),ep(epi(2),1),'red');