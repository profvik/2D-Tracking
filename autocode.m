clear;
clc;
angle = 45;
n = 10; %number of fibers
l = 8; %length of microtubules
theta = angle*pi/180;

fileid = fopen('dannycode45.txt','w');
fprintf(fileid, '%% A gliding assay, with stripes of two motors of opposite directionality\r\n');
fprintf(fileid, '%% run in 2D %% Edited by Danny Todd 6/15/15\r\n');
fprintf(fileid, 'set simul glide_stripe.cym\r\n');
fprintf(fileid, '{\r\n');
fprintf(fileid, '    time_step = 0.5\r\n');
fprintf(fileid, '    viscosity = 0.5\r\n');
fprintf(fileid, '    display = { window_size=2000,2000 }\r\n');
fprintf(fileid, '}\r\n');

fprintf(fileid, 'set space cell\r\n');
fprintf(fileid, '{\r\n');
fprintf(fileid, '    geometry = ( periodic 25 25 ) %% Sets dimesnsion in micrometers\r\n');
fprintf(fileid, '}\r\n');

fprintf(fileid, 'new space cell\r\n');

fprintf(fileid, 'set fiber microtubule\r\n');
fprintf(fileid, '{\r\n');
fprintf(fileid, '    % Taxol-stabilized microtubule are more flexible\r\n');
fprintf(fileid, '    % Taxol-stabilized are ~10 units here\r\n');
fprintf(fileid, '    % Found established rigidity of taxol stabalized MT and Actin\r\n');
fprintf(fileid, '    % filaments at\r\n');
fprintf(fileid, '    % http://jcb.rupress.org/content/120/4/923.full.pdf\r\n');
fprintf(fileid, '    rigidity = 1.5\r\n');
fprintf(fileid, '    segmentation = 0.5\r\n');
fprintf(fileid, '    display = { line_width=6; visible=1 }\r\n');
fprintf(fileid, '}\r\n');

fprintf(fileid, 'set hand kinesin\r\n');
fprintf(fileid, '{\r\n');
fprintf(fileid, '    binding_rate = 5\r\n');
fprintf(fileid, '    binding_range = 0.01\r\n');
fprintf(fileid, '    unbinding_rate = 0.3\r\n');
fprintf(fileid, '    unbinding_force = 6\r\n');
fprintf(fileid, '    activity = move\r\n');
fprintf(fileid, '    max_speed = 1.20 %% Speed in micrometers\r\n');
fprintf(fileid, '    stall_force = 6\r\n');
fprintf(fileid, '    display = { color=red; size=8; visible=0 } \r\n');
fprintf(fileid, '    % visibility is 0 for not showing in simulations\r\n');
fprintf(fileid, '}\r\n');

fprintf(fileid, 'set hand dynein\r\n');
fprintf(fileid, '{\r\n');
fprintf(fileid, '    binding_rate = 5\r\n');
fprintf(fileid, '    binding_range = 0.01\r\n');
fprintf(fileid, '    unbinding_rate = 0.3\r\n');
fprintf(fileid, '    unbinding_force = 6\r\n');
fprintf(fileid, '    activity = move\r\n')'
fprintf(fileid, '    max_speed = 1.00 %% Speed in micrometers\r\n');
fprintf(fileid, '    stall_force = 6\r\n');
fprintf(fileid, '    display = { color=blue; size=8; visible=1 }\r\n');
fprintf(fileid, '}\r\n');

fprintf(fileid, 'set single gKinesin\r\n');
fprintf(fileid, '{\r\n');
fprintf(fileid, '    hand = kinesin\r\n');
fprintf(fileid, '    stiffness = 50\r\n');
fprintf(fileid, '    activity = fixed\r\n');
fprintf(fileid, '}\r\n');

fprintf(fileid, 'set single gDynein\r\n');
fprintf(fileid, '{\r\n');
fprintf(fileid, '    hand = dynein\r\n');
fprintf(fileid, '    stiffness = 50\r\n');
fprintf(fileid, '    activity = fixed\r\n');
fprintf(fileid, '}\r\n');

for i = 1:n
    fprintf(fileid, 'new fiber microtubule\r\n');
    fprintf(fileid, '{\r\n');
    fprintf(fileid, '    length = %f %% Micrometers\r\n',l);
    x = 4*cos(theta);
    y = i + 4*sin(theta);
    u1 = cos(theta);
    u2 = sin(theta);
    fprintf(fileid, '    position = (%f %f 0)\r\n',x,y);
    fprintf(fileid, '    orientation = (%f %f 0)\r\n',u1,u2);
    fprintf(fileid, '}\r\n');
end

fprintf(fileid, 'new 25000 single gKinesin ( stripe  0  25  )\r\n');
fprintf(fileid, 'new 25000 single gDynein  ( stripe  -25  0 )\r\n');

fprintf(fileid, 'set simul:display gliding\r\n');
fprintf(fileid, '{\r\n');
fprintf(fileid, '    label = (Motor stripes -)\r\n');
fprintf(fileid, '    delay = 10\r\n');
fprintf(fileid, '    tiled = 1, 1\r\n');
fprintf(fileid, '    style = 2\r\n');
fprintf(fileid, '}\r\n');

fprintf(fileid, 'run 10 simul *\r\n');
fprintf(fileid, '{\r\n');
fprintf(fileid, '    nb_frames = 10\r\n');
fprintf(fileid, '}\r\n');