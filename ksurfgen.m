%%code to generate surface for Kaylee's simulation
clear;
clc;
rcyl = 20; %radius of cylinder in micron
amp = 3; %amplitude of undulation
n = 3; %number of rotations
ctr = 1; %ctr for making array
for theta = 0:.01:2*pi
    res(ctr,1) = (rcyl + amp*cos(2*n*theta))*cos(theta);
    res(ctr,2) = (rcyl + amp*cos(2*n*theta))*sin(theta);
    ctr = ctr+1;
end
dlmwrite('surf3d.txt',res,'delimiter',' ');
plot(res(:,1),res(:,2));