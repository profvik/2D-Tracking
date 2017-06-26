%testing something for trajectories code
ntest = 1;
testtrajloc = find(traj(:,4) == ntest);
traj(testtrajloc,1:2);
imshow(BWbdr);
hold;
scatter(traj(testtrajloc,1),traj(testtrajloc,2));
clear testtrajloc;
clear ntest;