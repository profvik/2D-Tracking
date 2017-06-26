%% MT break code
clear;
clc;
xsize = 100;
ysize = 100;
lattice = zeros(xsize,ysize);
mtrow = uint16(xsize/2);
mtcolini = uint16(ysize/4);
mtcolfin = uint16(ysize*3/4);
lattice(mtrow,mtcolini:mtcolfin) = 1;
conc = 0.1; %number between 0 to 1
procut = 0.1;
nkat = uint16(xsize*ysize*conc);
katloc = zeros(nkat,2);
for i = 1:nkat
    katloc(i,1) = uint16(rand()*xsize);
    katloc(i,2) = uint16(rand()*ysize);
end
%lattice(katloc(:,1),katloc(:,2)) = 2;

%% update and severe step
file1 = 'MTsevere';
file3 = '.tif';
ctr = 1;
l = 100;
while l > 0
    % update step
    %disp(n);  
    l = sum(lattice(xsize/2,:));
    res(ctr,1) = ctr-1;
    res(ctr,2) = l/51;
    imagesc(lattice);
    colormap cool;
    %scatter(katloc(:,1),katloc(:,2));
    axis([1 100 1 100]);
    %subplot(1,2,2), plot(res(:,1),res(:,2));
    %mov(ctr) = getframe();
    if mod(ctr,20) == 1
        file2 = num2str(ctr,'% 1.4i');
        filename = strcat(file1,file2,file3);
        imwrite(lattice,filename);
    end
    for i = 1:nkat
        chk = uint8(rand()*4);
        if chk == 1 && katloc(i,1) < 100
            katloc(i,1) = katloc(i,1)+1;
        elseif chk == 1 && katloc(i,1) == 100
            katloc(i,1) = 1;
        elseif chk == 2 && katloc(i,2) > 1
            katloc(i,2) = katloc(i,2)-1;
        elseif chk == 2 && katloc(i,2) == 1
            katloc(i,2) = 100;
        elseif chk == 3 && katloc(i,1) > 1
            katloc(i,1) = katloc(i,1)-1;
        elseif chk == 3 && katloc(i,1) == 1
            katloc(i,1) = 100;
        elseif chk == 4 && katloc(i,2) < 100
            katloc(i,2) = katloc(i,2)+1;
        elseif chk == 4 && katloc(i,2) == 100
            katloc(i,2) = 1;
        end
    end
    % severing step
    loc = find(katloc(:,1) == mtrow & katloc(:,2) >= mtcolini & katloc(:,2) <= mtcolfin);
    len = size(loc);
    testempt = isempty(len);
    if testempt ~= 1
        for i = 1:len(1)
            xloc = katloc(loc(i),1);
            yloc = katloc(loc(i),2);
            if lattice(xloc,yloc) == 1
                sevprob = rand();
                if sevprob < procut
                    lattice(xloc,yloc) = 0;
                end
            end
        end
    end
    ctr = ctr+1;
end
%res(:,2) = res(:,2)/res(1,2);
%plot(res(:,1),res(:,2));