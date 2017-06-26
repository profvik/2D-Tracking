%%Danny's newest code
%%modified  Jan 17, 2017
%this code tries to implement a 4 qud method to measure the angle
%consistently 
% Finds head and tail of an arbitrary microtubules
% Uses dsplacement data to figure out true head
% Tracks head of microtubules
% Prints "Party" at the end of program.
%% clean things
clear;
clc;
%% before you do anything extract boundaries
databdr = imread('H:\New Danny\20170113\Substack (1-600).tif',1);
uplimbdr = double(max(max(databdr)));
imbdr = uint8(double(databdr)/uplimbdr*255);
imeqbdr = imbdr; %histeq(imbdr);
%imshow(imeq);
[BWbdr xbd ybd] = roipoly(imeqbdr);

%% input some stuff
fini = 150;
fend = 250;
finres = zeros(fend,4);
sdrad = 10; %search radius for track
lowcut = 30; %dont find MT with fewer than these many pixels
highcut = 900; %dont find MT with more than these many pixels
diff = 1; %differnece between frames to track head
file = 'H:\Ross Lab\Paul\20161212_ch16_pRC114_prep20160905_2mMATP_1to2dil_2mMMag_150X_800frames_0dot1355spf ROI01 01 1.500 V.tif'; %name of file to be read
%n_im = 20; %number of images to analyse in file
res = [0 0 0 0];
head = [0 0 0];

%% where is the head 
for i = fini:diff:fend
    disp(i); %show the frame it is workin on
    res1 = [0 0 0];
    res2 = [0 0 0];
    imini = imread(file,i); %read initial image
    imfin = imread(file,i+diff); %read image after 'diff' number of frames
    %imini(:,:,2:3) = []; %remove info about surface
    %imfin(:,:,2:3) = []; %remove info about surface
    if i == fini 
        maxchk = max(max(imini)); %find brightest point in first image
    end
    % random bright thing removal step
    bspotini = find(imini > maxchk*2);
    bspotfin = find(imfin > maxchk*2);
    if isempty(bspotini) == 0 %did you find a spot (1-no, 0-yes)
        imini(bspotini) = 0;
    elseif isempty(bspotfin) == 0 %did you find a spot (1-no, 0-yes)
        imfin(bspotfin) = 0;
    end
    
    %% convert images to 8 bit
    imini = uint8(sqrt(double(imini)));
    imini = imadjust(imini);
    imfin = uint8(sqrt(double(imfin)));
    imfin = imadjust(imfin);
    level = 0.52;%graythresh(imini); %find thresholding level
    bwini = im2bw(imini,level*1.0); %binarize image
    %level = graythresh(imfin);
    bwfin = im2bw(imfin,level*1.0);
    filtini = medfilt2(bwini,[3 3]); %median filter image to remove noise
    filtfin = medfilt2(bwfin,[3 3]);
    
    %find list of end points in initial image
    cc = bwconncomp(filtini); %find connected component
    num_conn = cc.NumObjects; %find number of connected components detected
    pctr = 2*num_conn;
    for ii = 1:num_conn %loop over all connected objects
        pixelnum = size(cc.PixelIdxList{ii}); %number of pixels in ii'th object
        if pixelnum(1) > lowcut && pixelnum(1) < highcut %check if object has right size
            list = cc.PixelIdxList{ii}; %find index of pixels
            [y x] = ind2sub([512 512],list); %change indices to coordinate data
            %section to detect ends
            % shift particle to positive quadrant
            xedge = min(x);
            yedge = min(y);
            x = x - xedge + 1;
            y = y - yedge + 1;
            %make a reconstructed binary image
            reconim = zeros(max(y),max(x));
            len = size(x);
            for ctr = 1:len(1)
                reconim(y(ctr),x(ctr)) = 1;
            end
            myfilt = fspecial('gaussian',2,2); %design a gaussian filter
            smoothim = imfilter(reconim,myfilt); %smooth image
            skelim = bwmorph(smoothim,'skel',Inf); %skeletonize
            endim = bwmorph(skelim,'endpoints'); %find endpoints
            [epy epx] = find(endim == 1); %extract endpoints
            np = size(epx); %number of endpoints detected
            ep(:,1) = epy; %put endpoints at one place
            ep(:,2) = epx;
            if np(1) >= 2
                cx = floor(max(x)/2); %x center of image
                cy = floor(max(y)/2); %y center of image
                %find distance of end points from center of image
                ep(:,3) = (ep(:,1)-cx).^2 + (ep(:,2)-cy).^2; %distance of points from center
                [epsort epi] = sort(ep(:,3),'descend'); %sort in order of descendin distance from center
                rec(1,1) = ep(epi(1),1); 
                rec(1,2) = ep(epi(1),2);
                rec(1,3) = 2*(ii-1)+1; %just an identifier for one head
                %find distance of head points from one point detected in
                %previous step
                ep(:,3) = (ep(:,1)-rec(1,1)).^2 + (ep(:,2)-rec(1,2)).^2; %distance of points from first point
                [epsort epi] = sort(ep(:,3),'descend'); %sort in order of descendin distance first head
                rec(2,1) = ep(epi(1),1);
                rec(2,2) = ep(epi(1),2);
                rec(2,3) = 2*(ii-1)+2; %just an identifier for another head
                %chnge location of particles
                rec(1,1) = rec(1,1) + yedge;
                rec(1,2) = rec(1,2) + xedge;
                rec(2,1) = rec(2,1) + yedge;
                rec(2,2) = rec(2,2) + xedge;
            end
            res1 = cat(1,res1,rec);
            clear ep;
        end
    end
    res1(:,4) = 1;
    res1(1,:) = [];
    
    %find list of end points in final image
    cc = bwconncomp(filtfin); %find connected component
    num_conn = cc.NumObjects; %find number of connected components detected
    for ii = 1:num_conn %loop over all connected objects
        pixelnum = size(cc.PixelIdxList{ii}); %number of pixels in ii'th object
        if pixelnum(1) > lowcut && pixelnum(1) < highcut %check if object has right size
            list = cc.PixelIdxList{ii}; %find index of pixels
            [y x] = ind2sub([512 512],list); %change indices to coordinate data
            %section to detect ends
            % shift particle to positive quadrant
            xedge = min(x);
            yedge = min(y);
            x = x - xedge + 1;
            y = y - yedge + 1;
            %make a reconstructed binary image
            reconim = zeros(max(y),max(x));
            len = size(x);
            for ctr = 1:len(1)
                reconim(y(ctr),x(ctr)) = 1;
            end
            myfilt = fspecial('gaussian',2,2); %design a gaussian filter
            smoothim = imfilter(reconim,myfilt); %smooth image
            skelim = bwmorph(smoothim,'skel',Inf); %skeletonize
            endim = bwmorph(skelim,'endpoints'); %find endpoints
            [epy epx] = find(endim == 1); %extract endpoints
            np = size(epx); %number of endpoints detected
            ep(:,1) = epy; %put endpoints at one place
            ep(:,2) = epx;
            if np(1) >= 2
                cx = floor(max(x)/2); %x center of image
                cy = floor(max(y)/2); %y center of image
                ep(:,3) = (ep(:,1)-cx).^2 + (ep(:,2)-cy).^2; %distance of points from center
                [epsort epi] = sort(ep(:,3),'descend'); %sort in order of descendin distance from center
                rec(1,1) = ep(epi(1),1); 
                rec(1,2) = ep(epi(1),2);
                rec(1,3) = 0; %just an identifier for one head
                ep(:,3) = (ep(:,1)-rec(1,1)).^2 + (ep(:,2)-rec(1,2)).^2; %distance of points from first point
                [epsort epi] = sort(ep(:,3),'descend'); %sort in order of descendin distance first head
                rec(2,1) = ep(epi(1),1);
                rec(2,2) = ep(epi(1),2);
                rec(2,3) = 0; %just an identifier for another head
                %chnge location of particles
                rec(1,1) = rec(1,1) + yedge;
                rec(1,2) = rec(1,2) + xedge;
                rec(2,1) = rec(2,1) + yedge;
                rec(2,2) = rec(2,2) + xedge;
            end
            res2 = cat(1,res2,rec);
            clear ep;
        end
    end
    res2(:,4) = 2;
    res2(1,:) = [];
    
    % now track where the particles are.
    res = cat(1,res1,res2);
    param.mem = 0;
    param.dim = 2;
    param.good = 1;
    param.quiet = 1;
    tr = track(res,sdrad,param);
    
    %from track data figure out where is the head
    for p = 1:pctr %number of positions to search (depends on how many particles were detected in first frame)
        ini = 2*(p-1)+1; %identifier of one end
        fin = 2*(p-1)+2; %identifier of other end
        inipos = find(tr(:,3) == ini); %position of first end
        finpos = find(tr(:,3) == fin); %position of other end
        if isempty(inipos) == 0 && isempty(finpos) == 0 %do i have this particle in first frame
            if tr(inipos+1,3) == 0 && tr(finpos+1,3) == 0 %do i have this particle in second frame
                disframe1 = (tr(inipos,1)-tr(finpos,1))^2 + (tr(inipos,2)-tr(finpos,2))^2; %distance between 2 ends in first frame
                disframe2 = (tr(inipos,1)-tr(finpos+1,1))^2 + (tr(inipos,2)-tr(finpos+1,2))^2; %distance between one end in first frame from one end in another
                if disframe1 > disframe2 %is distance decreasing
                    hd(1,1) = tr(inipos,1);
                    hd(1,2) = tr(inipos,2);
                elseif disframe1 < disframe2 %is distance increasing
                    hd(1,1) = tr(finpos,1);
                    hd(1,2) = tr(finpos,2);
                end
                hd(1,3) = i;
                head = cat(1,head,hd);
            end
        end
    end
end
head(1,:) = [];
disp('haha');
%% movie time
for ctr = fini:diff:fend
    im = imread(file,ctr);
    %im(:,:,2:3) = [];
    imagesc(im);
    hold on;
    loc = find(head(:,3) == ctr);
    scatter(head(loc,2),head(loc,1),'red');
    mov = getframe;
    imf = frame2im(mov);
    hold off;
    %imwrite(imf,'C:\DannyData\HeadTrack.tif');
     %imwrite(imf, 'myFile.TIFF', 'writemode', 'append')
end


%% section to track trajectories
    param.mem = 0;
    param.dim = 2;
    param.good = 2; %usually 10
    param.quiet = 1;
    traj = track(head,sdrad,param);
%     l1 = find(traj(:,1) < 1);
%     traj(l1,:) = [];
%     l1 = find(traj(:,1) > 512);
%     traj(l1,:) = [];
%     l1 = find(traj(:,2) < 1);
%     traj(l1,:) = [];
%     l1 = find(traj(:,2) > 512);
%     traj(l1,:) = [];
    npd = max(traj(:,4)); %number of particles detected
    disp('haha')


%% This section should measure displacement
npd = max(traj(:,4));
for ctr = 1:npd
    locnp = find(traj(:,4) == ctr);
    temptrack = traj(locnp,:);
    ini = min(temptrack(:,3));
    fin = max(temptrack(:,3));
    for chk = ini:fin-1
        d = sqrt((temptrack(chk-ini+1,1)-temptrack(chk-ini+2,1))^2+(temptrack(chk-ini+1,2)-temptrack(chk-ini+2,2))^2);
        finres(chk,1) = chk;
        finres(chk,2) = finres(chk,2)+d;
        finres(chk,3) = finres(chk,3)+1;
    end
end
finres(:,2) = finres(:,2)./finres(:,3);
plot(finres(:,1),finres(:,2))
%% random section
mov = 5
for x = fini+mov:fend-mov
    finres(x,4) = mean(finres(x-mov:x+mov,2));
end
plot(finres(:,1),finres(:,2))
hold on;
plot(finres(:,1),finres(:,4),'r');

lon = 200
loff = 400
finres(1:lon-1,5) = 0;
finres(lon:loff,5) = 6;
finres(loff+1,5) = 0;

plot(finres(:,1),finres(:,5),'black');

% %% section for finding position of trajectories
% str = size(traj);
% for i = 1:str(1)
%     traj(i,5) = BWbdr(traj(i,1),traj(i,2));%BWbdr(traj(i,2),abs(512-traj(i,1)+1));
% end
% disp('haha2');
%     
% %% section to plot trajectories
%      figure;
%      hold;
%      %this portion plots particle that do cross interface
%     for z = 1:npd
%         locz = find(traj(:,4) == z);
%         locbdr = traj(locz,5);
%         maxbd = max(locbdr);
%         minbd = min(locbdr);
%         if isempty(locbdr) ~= 1
%         if maxbd ~= minbd && locbdr(1) == 1
%             disp(z)
%         scatter(traj(locz,1),traj(locz,2));
%         end
%         end
%     end
%     %this portion plots particle that don't cross interface
%     for z = 1:npd
%         locz = find(traj(:,4) == z);
%         locbdr = traj(locz,5);
%         maxbd = max(locbdr);
%         minbd = min(locbdr);
%         %if isempty(locbdr) ~= 1
%         if maxbd == minbd %&& locbdr(1) == 0
%         %    disp(z)
%         plot(traj(locz,1),traj(locz,2));
%         end
%         %end
%     end
%      plot(ybd,xbd);
%     
%     
% % %% one small section to test a trajectory
% % clear tempdat;
% % clear uv;
% % clear o;
% % figure;
% % hold;
% % z = 160;%loop over number of particles
% % locz = find(traj(:,4) == z); %find zth particle in all frames
% % tempdat = traj(locz,:); %get trajectory of zth particle
% % npid = size(tempdat); %find length of trajectory
% % for pctr = 1:npid(1)-1 %loop over all locations in trajectory
% % x1 = tempdat(pctr,1); %extract initial x
% % y1 = tempdat(pctr,2); %extract initial y
% % x2 = tempdat(pctr+1,1); %extract next x
% % y2 = tempdat(pctr+1,2); %extract next y
% % xlen = x2-x1;
% % ylen = y2-y1;
% %     if xlen >= 0 && ylen >= 0       %1st quadrant test                                            % 1st quadrant
% %         theta = atan(ylen/xlen);
% %     elseif xlen <= 0 && ylen >= 0       %2nd quadrant test                                        % 2nd quadrant
% %         theta = pi + atan(ylen/xlen);
% %     elseif xlen <= 0 && ylen <= 0       %3rd quadrant test                                        % 3rd quadrant
% %         theta = pi + atan(ylen/xlen);
% %     elseif xlen >= 0 && ylen <= 0       %4th quadrant test                                        % 4th quadrant
% %         theta = 2*pi + atan(ylen/xlen);
% %     end
% % angdat = theta;
% % o(pctr) = angdat;
% % %angdat = atan((y2-y1)/(x2-x1)); %orientation after every 5 frame data
% % % chkang = isnan(angdat); %chk there is no division by 0
% % %     if chkang  ~= 1
% % %         o(pctr) = angdat; %get orientation series
% % %     elseif chkang == 1 && ylen > 0
% % %         o(pctr) = pi/2; %o(pctr-1); %get orientation series
% % %     elseif chkang == 1 && ylen < 0
% % %         o(pctr) = -pi/2; %o(pctr-1); %get orientation series
% % %     end
% %     uv(pctr,1) = cos(o(pctr));
% %     uv(pctr,2) = sin(o(pctr));
% % end
% % scatter(tempdat(1:end-1,1),tempdat(1:end-1,2));
% % quiver(tempdat(1:end-1,1),tempdat(1:end-1,2),uv(:,1),uv(:,2),0.25);
% % plot(ybd,xbd);
% 
%  %% velocity distribution section
%     v(1,1) = [0];
%     for z = 1:npd
%         %disp(z)
%         locz = find(traj(:,4) == z);
%         tempdat = traj(locz,:);
%         locino = find(tempdat(:,5) == 0); %this portion removes particle
%         tempdat(locino,:) = [];
%         npid = size(tempdat);
%         xstd = std(tempdat(:,1));
%         ystd = std(tempdat(:,2));
%         totstd(z) = sqrt(xstd^2+ystd^2);
%         if npid(1) > 1 && totstd(z) >= 10
%         for pctr = 1:npid-1
%             x1 = tempdat(pctr,1);
%             y1 = tempdat(pctr,2);
%             x2 = tempdat(pctr+1,1);
%             y2 = tempdat(pctr+1,2);
%             diffn = tempdat(pctr+1,3) - tempdat(pctr,3); %difference in frame number
%             r(pctr) = (sqrt((x2-x1)^2+(y2-y1)^2))/diffn; %distance travelled every 5 frame data
%         end
%         r = r';
%         v = cat(1,v,r);
%         clear r;
%         clear tempdat;
%         elseif npid(1) <= 1
%             disp(z);
%         end
%     end
%     bin = -30:2:30;
%     [vhist vbin] = hist(v,bin);
%     figure;
%     plot(vbin,vhist);
%     f = fit(vbin.',vhist.','gauss1');
%     disp(f.b1);
%     disp(f.c1);
% %     clear v;
% %     clear vbin;
% %     clear vhist;
%  %% orientation correlation section
% %     v = [0];
% %     figure;
% %     hold;
% %     clc;
% %     for z = 1:8;%1:npd %loop over number of particles
% %         locz = find(traj(:,4) == z); %find zth particle in all frames
% %         tempdat = traj(locz,:); %get trajectory of zth particle
% %         npid = size(tempdat); %find length of trajectory
% %         for pctr = 1:npid(1)-1 %loop over all locations in trajectory
% %             x1 = tempdat(pctr,1); %extract initial x
% %             y1 = tempdat(pctr,2); %extract initial y
% %             x2 = tempdat(pctr+1,1); %extract next x
% %             y2 = tempdat(pctr+1,2); %extract next y
% %             xlen = x2-x1;
% %             ylen = y2-y1;
% %                 if xlen >= 0 && ylen >= 0       %1st quadrant test                                            % 1st quadrant
% %                         theta = atan(ylen/xlen);
% %                 elseif xlen <= 0 && ylen >= 0       %2nd quadrant test                                        % 2nd quadrant
% %                         theta = pi + atan(ylen/xlen);
% %                 elseif xlen <= 0 && ylen <= 0       %3rd quadrant test                                        % 3rd quadrant
% %                         theta = pi + atan(ylen/xlen);
% %                 elseif xlen >= 0 && ylen <= 0       %4th quadrant test                                        % 4th quadrant
% %                         theta = 2*pi + atan(ylen/xlen);
% %                 end
% %         angdat = theta;
% %             %angdat = atan((y2-y1)/(x2-x1)); %orientation after every 5 frame data
% %             chkang = isnan(angdat); %chk there is no division by 0
% %             if chkang  ~= 1
% %                 o(pctr) = angdat; %get orientation series
% %             elseif chkang == 1
% %                 o(pctr) = pi/2; %o(pctr-1); %get orientation series
% %             end
% %         end
% %         for d = 0:npid(1)-2 %loop over all distances
% %             oc = 0; %orientation correlation tracker
% %             for avt = 1:npid(1)-d-1 %loop over all possible terms
% %                 uv1 = [cos(o(avt)) sin(o(avt))]; %first unit vector
% %                 uv2 = [cos(o(avt+d)) sin(o(avt+d))]; %next unit vector
% %                 oc = oc + dot(uv1,uv2); %update orientation
% %             end
% %             oc = oc/(npid(1)-d-1); %average oc
% %             scatter(d*diff,oc,[],z); %plot oc
% %         end
% %     end
% 
% %% section to calculate normals
% %output of this section is a variable called normdat and it has info of
% %normals
% nver = size(xbd); %find number of vertices in polygon
% for i = 1:nver-1
%     slp = (ybd(i+1)-ybd(i))/(xbd(i+1)-xbd(i)); %slope
%     norm1 = -1/slp;
%     xmv = (xbd(i+1)+xbd(i))/2;
%     ymv = (ybd(i+1)+ybd(i))/2; %locations of center of vertices
%     constl = (slp*ymv+xmv)/slp; %constant of line
%     xn = uint16(xmv+2); %an arbit x location 10 pixel away
%     yn = uint16(norm1*xn+constl); %corresponding y point
%     if xn > 512 || xn < 1 || yn > 512 || yn < 1 || BWbdr(xn,yn) == 0
%         normdat(i,1) = xmv;
%         normdat(i,2) = ymv;
%         normdat(i,3) = cos(atan(norm1)+pi);
%         normdat(i,4) = sin(atan(norm1)+pi);
%     else
%         normdat(i,1) = xmv;
%         normdat(i,2) = ymv;
%         normdat(i,3) = cos(atan(norm1));
%         normdat(i,4) = sin(atan(norm1));
%     end
% end
% figure;
% plot(xbd,ybd);
% hold;
% quiver(normdat(1:3,1),normdat(1:3,2),normdat(1:3,3),normdat(1:3,4));
% 
% %% section to calculate change in angle of incidence
%      figure;
%      hold;
%      ctr = 1;
%      %this portion plots particle that do cross interface
%     for z = 1:npd
%         locz = find(traj(:,4) == z); %find i'th particle detected
%         locbdr = traj(locz,5); %track which region it was in
%         maxbd = max(locbdr); %find if it was ever inside
%         minbd = min(locbdr); %find if it was ever outside
%         if isempty(locbdr) ~= 1
%         if maxbd ~= minbd && locbdr(1) == 1 %test that it crossed region and started inside
%             %disp(z);
%             loc_crs = min(find(locbdr == 0)); %first instance of crossing
%             chklen = 10; %number of frames over which a track is detected
%             if loc_crs > chklen
%                 %disp('accept');
%                 entrydatax = traj(locz(loc_crs-chklen+1):locz(loc_crs-1),2);
%                 entrydatay = traj(locz(loc_crs-chklen+1):locz(loc_crs-1),1);
%             elseif loc_crs >= 3 && loc_crs <= 10
%                 entrydatax = traj(locz(1):locz(loc_crs-1),2);
%                 entrydatay = traj(locz(1):locz(loc_crs-1),1);
%             else
%                 entrydatax = [];
%                 entrydatay = [];
%             end
%             loctot = size(locbdr); %total length of trajectory
%             remlen = loctot(1)-loc_crs;
%             if remlen > chklen
%                 exitdatax = traj(locz(loc_crs):locz(loc_crs+chklen-1),2);
%                 exitdatay = traj(locz(loc_crs):locz(loc_crs+chklen-1),1);
%             elseif remlen >= 3 && remlen <= 10
%                 exitdatax = traj(locz(loc_crs):locz(end),2);
%                 exitdatay = traj(locz(loc_crs):locz(end),1);
%             else
%                 exitdatax = [];
%                 exitdatay = [];
%             end
%             if ~isempty(entrydatax) && ~isempty(exitdatax)
%             fitin = polyfit(entrydatax,entrydatay,1); %fit entry data with line
%             fitex = polyfit(exitdatax,exitdatay,1); %fit exit data with line
%             lfangin = atan(fitin(1));
%             lfangex = atan(fitex(1));
%             %this portion should check the location of angle of incidence
%             boxnum = 0;
%             for i = 1:3
%                 xrc = traj(locz(loc_crs),2); %x position of region change
%                 yrc = traj(locz(loc_crs),1); %y position of region change
%                 xbig = max(xbd(i),xbd(i+1));
%                 xsml = min(xbd(i),xbd(i+1));
%                 ybig = max(ybd(i),ybd(i+1));
%                 ysml = min(ybd(i),ybd(i+1));
%                 if xrc >= xsml && xrc <= xbig && yrc >= ysml && yrc <= ybig
%                     boxnum = i;
%                     %disp(boxnum);
%                 end
%             end
%             if boxnum ~= 0
%                 %disp(z);
%                 vecnorm = [normdat(boxnum,3) normdat(boxnum,4)];
%                 vectan = [normdat(boxnum,4) -1*normdat(boxnum,3)];
%                 vecinlf = [cos(lfangin) sin(lfangin)];
%                 vecexlf = [cos(lfangex) sin(lfangex)];
%                 thin = acos(dot(vecnorm,vecinlf)); %entry angle from normal
%                 thou = acos(dot(vecnorm,vecexlf)); %exit angle from normal
%                 thintan = acos(dot(vectan,vecinlf)); %entry angle from tangent
%                 thoutan = acos(dot(vectan,vecexlf)); %exit angle from tangent
%                 if thintan < pi/2
%                     angres(ctr,1) = -min(thin,pi-thin)*180/pi;
%                 elseif thintan > pi/2
%                     angres(ctr,1) = min(thin,pi-thin)*180/pi;
%                 end
%                 if thoutan < pi/2
%                     angres(ctr,2) = -min(thou,pi-thou)*180/pi;
%                 elseif thoutan > pi/2
%                     angres(ctr,2) = min(thou,pi-thou)*180/pi;
%                 end
%                 %angres(ctr,1) = min(thin,pi-thin)*180/pi;
%                 %angres(ctr,2) = min(thou,pi-thou)*180/pi;
%                 ctr = ctr + 1;
%                 scatter(entrydatax,entrydatay);
%                 scatter(exitdatax,exitdatay);
%                 quiver(entrydatax(1),entrydatay(1),vecinlf(1),vecinlf(2),100);
%                 quiver(exitdatax(1),exitdatay(1),vecexlf(1),vecexlf(2),100);
%                 plot(xbd,ybd)
%                 clear entrydatax;
%                 clear entrydatay;
%                 clear exitdatax;
%                 clear exitdatay;
%             end
%             end
%         end
%         end
%     end
%     figure;
% scatter(angres(:,1),angres(:,2)); 
% 
% %% display party
% disp('PARTY.....');